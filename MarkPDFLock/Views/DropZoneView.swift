import SwiftUI
import UniformTypeIdentifiers

struct DropZoneView: View {
    @ObservedObject var settings: AppSettings
    let onDropFiles: ([URL]) -> Void
    let onAddFiles: () -> Void
    let onAddFolder: () -> Void
    @State private var isTargeted = false

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 28, weight: .medium))
            Text(settings.text(.dragDropTitle))
                .font(.headline)
            Text(settings.text(.dragDropSubtitle))
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: 8) {
                Button(settings.text(.addFiles), action: onAddFiles)
                    .buttonStyle(.bordered)
                Button(settings.text(.addFolder), action: onAddFolder)
                    .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 128)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isTargeted ? settings.theme.tint : Color.secondary.opacity(0.35), style: StrokeStyle(lineWidth: 2, dash: [7]))
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.secondary.opacity(0.08)))
        )
        .onDrop(of: [UTType.fileURL.identifier], isTargeted: $isTargeted, perform: handleDrop(providers:))
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        let group = DispatchGroup()
        let lock = NSLock()
        var urls: [URL] = []

        for provider in providers where provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
            group.enter()
            provider.loadDataRepresentation(forTypeIdentifier: UTType.fileURL.identifier) { data, _ in
                defer { group.leave() }
                guard let data, let url = URL(dataRepresentation: data, relativeTo: nil) else {
                    return
                }
                lock.lock()
                urls.append(url)
                lock.unlock()
            }
        }

        group.notify(queue: .main) {
            if !urls.isEmpty {
                onDropFiles(urls)
            }
        }

        return true
    }
}
