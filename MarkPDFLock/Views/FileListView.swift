import SwiftUI

struct FileListView: View {
    @ObservedObject var settings: AppSettings
    let files: [FileItem]
    let isProcessing: Bool
    let onRemove: (UUID) -> Void
    let onRemoveCompleted: () -> Void
    let onReveal: (FileItem) -> Void

    private let sizeFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(settings.text(.files))
                    .font(.headline)
                Spacer()
                if files.contains(where: { $0.status == .done }) {
                    Button(settings.text(.removeCompleted), action: onRemoveCompleted)
                        .buttonStyle(.bordered)
                        .disabled(isProcessing)
                }
                Text("\(files.count) \(settings.text(.items))")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }

            List(files) { file in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(file.fileName)
                            .font(.body.weight(.medium))
                        Spacer()
                        Text(statusLabel(file.status))
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
                            Button(settings.text(.revealInFinder)) {
                                onReveal(file)
                            }
                            .buttonStyle(.link)
                        }

                        Button {
                            onRemove(file.id)
                        } label: {
                            Label(settings.text(.cancel), systemImage: "xmark.circle")
                        }
                        .buttonStyle(.borderless)
                        .disabled(isProcessing)
                    }
                }
                .padding(.vertical, 4)
            }
            .frame(minHeight: 220)
            .scrollContentBackground(.hidden)
        }
    }

    private func statusColor(_ status: FileProcessingStatus) -> Color {
        switch status {
        case .pending: return .secondary
        case .processing: return settings.theme.tint
        case .done: return .green
        case .failed: return .red
        }
    }

    private func statusLabel(_ status: FileProcessingStatus) -> String {
        switch status {
        case .pending: return settings.text(.statusPending)
        case .processing: return settings.text(.statusProcessing)
        case .done: return settings.text(.statusDone)
        case .failed: return settings.text(.statusFailed)
        }
    }
}
