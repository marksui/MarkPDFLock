import AppKit
import Foundation
import UniformTypeIdentifiers

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
        return String(format: AppText.localized(.summaryFormat), files.count, done, failed)
    }

    func addFiles(from urls: [URL]) {
        let pdfs = urls.filter { $0.pathExtension.lowercased() == "pdf" }
        guard !pdfs.isEmpty else {
            globalMessage = AppText.localized(.onlyPDFSupported)
            return
        }

        let existing = Set(files.map(\.url))
        let newItems = pdfs
            .filter { !existing.contains($0) }
            .map(FileItem.init)
        files.append(contentsOf: newItems)
    }

    func removeFile(id: UUID) {
        guard !isProcessing else { return }
        files.removeAll { $0.id == id }
    }

    func clearList() {
        guard !isProcessing else { return }
        files.removeAll()
        progress = 0
        completedCount = 0
        globalMessage = nil
    }

    func removeCompletedFiles() {
        guard !isProcessing else { return }
        files.removeAll { $0.status == .done }
    }

    func choosePDFFiles() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [.pdf]
        panel.prompt = "Select"

        if panel.runModal() == .OK {
            addFiles(from: panel.urls)
        }
    }

    func choosePDFFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Select"

        guard panel.runModal() == .OK, let folderURL = panel.url else {
            return
        }

        let urls = (try? FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)) ?? []
        addFiles(from: urls)
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
                            files[index].errorMessage = AppText.localized(.outputFileExists)
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
                ? AppText.localized(.encryptionCompletedWithFailures)
                : AppText.localized(.encryptionCompletedSuccessfully)

            if options.openFolderWhenFinished {
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
            return AppText.localized(.passwordCannotBeEmpty)
        }
        if lowered.contains("permission denied") {
            return AppText.localized(.permissionDenied)
        }
        if lowered.contains("no such file") {
            return AppText.localized(.pathNotFound)
        }
        return errorText.isEmpty ? AppText.localized(.unknownError) : errorText
    }
}
