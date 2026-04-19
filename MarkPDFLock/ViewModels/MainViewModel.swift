import AppKit
import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    @Published var files: [FileItem] = []
    @Published var options = EncryptionOptions()
    @Published var exportFolderURL: URL?
    @Published var isProcessing = false
    @Published var showPassword = false
    @Published var progress: Double = 0
    @Published var completedCount = 0
    @Published var globalMessage: String?

    private let qpdfRunner: QPDFRunner

    init(qpdfRunner: QPDFRunner = QPDFRunner()) {
        self.qpdfRunner = qpdfRunner
    }

    var canStartEncryption: Bool {
        !files.isEmpty && !options.userPassword.isEmpty && exportFolderURL != nil && !isProcessing
    }

    var summaryText: String {
        let done = files.filter { $0.status == .done }.count
        let failed = files.filter { $0.status == .failed }.count
        return "Total: \(files.count) • Succeeded: \(done) • Failed: \(failed)"
    }

    func addFiles(from urls: [URL]) {
        let pdfs = urls.filter { $0.pathExtension.lowercased() == "pdf" }
        guard !pdfs.isEmpty else {
            globalMessage = "Only PDF files are supported."
            return
        }

        let existing = Set(files.map(\.url))
        let newItems = pdfs
            .filter { !existing.contains($0) }
            .map(FileItem.init)
        files.append(contentsOf: newItems)
    }

    func removeFile(id: UUID) {
        files.removeAll { $0.id == id }
    }

    func clearList() {
        files.removeAll()
        progress = 0
        completedCount = 0
        globalMessage = nil
    }

    func chooseExportFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Select"

        if panel.runModal() == .OK {
            exportFolderURL = panel.url
        }
    }

    func startEncryption() {
        guard canStartEncryption, let exportFolderURL else { return }

        isProcessing = true
        globalMessage = nil
        progress = 0
        completedCount = 0

        for index in files.indices {
            files[index].status = .pending
            files[index].outputURL = nil
            files[index].errorMessage = nil
        }

        Task {
            for index in files.indices {
                files[index].status = .processing
                let sourceURL = files[index].url
                let outputURL = nextOutputURL(for: sourceURL, exportFolder: exportFolderURL)

                do {
                    if FileManager.default.fileExists(atPath: outputURL.path) {
                        if options.overwriteExisting {
                            try FileManager.default.removeItem(at: outputURL)
                        } else {
                            files[index].status = .failed
                            files[index].errorMessage = "Output file already exists. Enable overwrite or rename the file."
                            advanceProgress()
                            continue
                        }
                    }

                    let result = try await qpdfRunner.encrypt(inputURL: sourceURL, outputURL: outputURL, options: options)
                    if result.success {
                        files[index].status = .done
                        files[index].outputURL = outputURL
                    } else {
                        files[index].status = .failed
                        files[index].errorMessage = prettify(errorText: result.stderr)
                    }
                } catch {
                    files[index].status = .failed
                    files[index].errorMessage = prettify(errorText: error.localizedDescription)
                }

                advanceProgress()
            }

            isProcessing = false
            globalMessage = files.contains(where: { $0.status == .failed })
                ? "Encryption completed with some failures."
                : "Encryption completed successfully."

            if options.openFolderWhenFinished, let exportFolderURL {
                NSWorkspace.shared.open(exportFolderURL)
            }
        }
    }

    func revealInFinder(_ file: FileItem) {
        guard let outputURL = file.outputURL else { return }
        NSWorkspace.shared.activateFileViewerSelecting([outputURL])
    }

    private func advanceProgress() {
        completedCount += 1
        progress = files.isEmpty ? 0 : Double(completedCount) / Double(files.count)
    }

    private func nextOutputURL(for inputURL: URL, exportFolder: URL) -> URL {
        let base = inputURL.deletingPathExtension().lastPathComponent + "_encrypted"
        var candidate = exportFolder.appendingPathComponent(base).appendingPathExtension("pdf")

        guard !options.overwriteExisting else {
            return candidate
        }

        var counter = 1
        while FileManager.default.fileExists(atPath: candidate.path) {
            candidate = exportFolder.appendingPathComponent("\(base)_\(counter)").appendingPathExtension("pdf")
            counter += 1
        }
        return candidate
    }

    private func prettify(errorText: String) -> String {
        let lowered = errorText.lowercased()
        if lowered.contains("password") && lowered.contains("empty") {
            return "Password cannot be empty."
        }
        if lowered.contains("permission denied") {
            return "Permission denied while reading or writing files."
        }
        if lowered.contains("no such file") {
            return "Input or output path was not found."
        }
        return errorText.isEmpty ? "An unknown error occurred." : errorText
    }
}
