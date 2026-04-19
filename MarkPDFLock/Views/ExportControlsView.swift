import SwiftUI

struct ExportControlsView: View {
    let exportFolderURL: URL?
    @Binding var overwriteExisting: Bool
    @Binding var openFolderWhenFinished: Bool
    let onChooseFolder: () -> Void
    let onClearList: () -> Void

    var body: some View {
        GroupBox("Export") {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(exportFolderURL?.path ?? "No folder selected")
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .foregroundStyle(exportFolderURL == nil ? .secondary : .primary)
                    Spacer()
                    Button("Choose Folder", action: onChooseFolder)
                }

                Toggle("Overwrite existing encrypted files", isOn: $overwriteExisting)
                Toggle("Open export folder when finished", isOn: $openFolderWhenFinished)

                HStack {
                    Spacer()
                    Button("Clear List", role: .destructive, action: onClearList)
                }
            }
            .padding(.top, 4)
        }
    }
}
