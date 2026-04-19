import SwiftUI

struct FileListView: View {
    let files: [FileItem]
    let onRemove: (UUID) -> Void
    let onReveal: (FileItem) -> Void

    private let sizeFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Files")
                    .font(.headline)
                Spacer()
                Text("\(files.count) item(s)")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }

            List(files) { file in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(file.fileName)
                            .font(.body.weight(.medium))
                        Spacer()
                        Text(file.status.label)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(statusColor(file.status).opacity(0.15))
                            .foregroundStyle(statusColor(file.status))
                            .clipShape(Capsule())
                    }

                    Text(file.originalPath)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)

                    HStack(spacing: 12) {
                        Text(sizeFormatter.string(fromByteCount: file.fileSize))
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if let errorMessage = file.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }

                        Spacer()

                        if file.status == .done {
                            Button("Reveal in Finder") {
                                onReveal(file)
                            }
                            .buttonStyle(.link)
                        }

                        Button(role: .destructive) {
                            onRemove(file.id)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .padding(.vertical, 4)
            }
            .frame(minHeight: 180)
        }
    }

    private func statusColor(_ status: FileProcessingStatus) -> Color {
        switch status {
        case .pending: return .secondary
        case .processing: return .blue
        case .done: return .green
        case .failed: return .red
        }
    }
}
