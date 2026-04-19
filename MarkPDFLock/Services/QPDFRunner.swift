import Foundation

struct QPDFExecutionResult {
    let success: Bool
    let stderr: String
    let stdout: String
}

enum QPDFRunnerError: LocalizedError {
    case binaryNotFound
    case invalidInputFile

    var errorDescription: String? {
        switch self {
        case .binaryNotFound:
            return "qpdf binary was not found. Add a bundled qpdf executable to Resources/qpdf/qpdf or install qpdf on your Mac."
        case .invalidInputFile:
            return "The selected file is not a valid PDF."
        }
    }
}

final class QPDFRunner {
    private let fileManager = FileManager.default

    func encrypt(inputURL: URL, outputURL: URL, options: EncryptionOptions) async throws -> QPDFExecutionResult {
        guard inputURL.pathExtension.lowercased() == "pdf" else {
            throw QPDFRunnerError.invalidInputFile
        }

        guard let qpdfPath = resolveQPDFPath() else {
            throw QPDFRunnerError.binaryNotFound
        }

        let ownerPassword = options.ownerPassword.isEmpty ? options.userPassword : options.ownerPassword

        let args = [
            "--encrypt", options.userPassword, ownerPassword, "256",
            "--use-aes=y",
            "--print=", options.printPermission.qpdfValue,
            "--modify=", options.modifyPermission.qpdfValue,
            "--extract=", options.copyAllowed ? "y" : "n",
            "--", inputURL.path, outputURL.path
        ]

        let compactArgs = normalizeArgs(args)
        return try await execute(binaryPath: qpdfPath, args: compactArgs)
    }

    private func normalizeArgs(_ args: [String]) -> [String] {
        var normalized: [String] = []
        var index = 0
        while index < args.count {
            let current = args[index]
            if ["--print=", "--modify=", "--extract="].contains(current), index + 1 < args.count {
                normalized.append(current + args[index + 1])
                index += 2
            } else {
                normalized.append(current)
                index += 1
            }
        }
        return normalized
    }

    private func execute(binaryPath: String, args: [String]) async throws -> QPDFExecutionResult {
        try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            let stdoutPipe = Pipe()
            let stderrPipe = Pipe()

            process.executableURL = URL(fileURLWithPath: binaryPath)
            process.arguments = args
            process.standardOutput = stdoutPipe
            process.standardError = stderrPipe

            process.terminationHandler = { proc in
                let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
                let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
                let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
                let stderr = String(data: stderrData, encoding: .utf8) ?? ""
                continuation.resume(returning: QPDFExecutionResult(
                    success: proc.terminationStatus == 0,
                    stderr: stderr.trimmingCharacters(in: .whitespacesAndNewlines),
                    stdout: stdout.trimmingCharacters(in: .whitespacesAndNewlines)
                ))
            }

            do {
                try process.run()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private func resolveQPDFPath() -> String? {
        let bundledCandidates = [
            Bundle.main.path(forResource: "qpdf", ofType: nil, inDirectory: "qpdf"),
            Bundle.main.path(forResource: "qpdf", ofType: nil)
        ].compactMap { $0 }

        for path in bundledCandidates where fileManager.isExecutableFile(atPath: path) {
            return path
        }

        let systemCandidates = [
            "/opt/homebrew/bin/qpdf",
            "/usr/local/bin/qpdf",
            "/usr/bin/qpdf"
        ]

        return systemCandidates.first(where: { fileManager.isExecutableFile(atPath: $0) })
    }
}
