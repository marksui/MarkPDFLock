import Foundation

enum FileProcessingStatus: String, Codable, CaseIterable {
    case pending
    case processing
    case done
    case failed

    var label: String {
        rawValue.capitalized
    }
}

struct FileItem: Identifiable, Hashable {
    let id: UUID
    let url: URL
    let fileName: String
    let originalPath: String
    let fileSize: Int64
    var status: FileProcessingStatus
    var outputURL: URL?
    var errorMessage: String?

    init(url: URL) {
        self.id = UUID()
        self.url = url
        self.fileName = url.lastPathComponent
        self.originalPath = url.path
        self.fileSize = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize).map(Int64.init) ?? 0
        self.status = .pending
        self.outputURL = nil
        self.errorMessage = nil
    }
}
