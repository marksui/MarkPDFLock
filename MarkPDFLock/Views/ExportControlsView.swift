import SwiftUI

struct ExportControlsView: View {
    @ObservedObject var settings: AppSettings
    let exportFolderURL: URL?
    @Binding var overwriteExisting: Bool
    @Binding var openFolderWhenFinished: Bool
    let onChooseFolder: () -> Void
    let onClearList: () -> Void

    var body: some View {
        GroupBox(settings.text(.export)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(exportFolderURL?.path ?? settings.text(.noFolderSelected))
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .foregroundStyle(exportFolderURL == nil ? .secondary : .primary)
                    Spacer()
                    Button(settings.text(.chooseFolder), action: onChooseFolder)
                    HelpHintView(message: settings.text(.helpChooseFolder))
                }

                HStack(spacing: 6) {
                    Toggle(settings.text(.overwriteExisting), isOn: $overwriteExisting)
                    HelpHintView(message: settings.text(.helpOverwriteExisting))
                }

                HStack(spacing: 6) {
                    Toggle(settings.text(.openFolderWhenFinished), isOn: $openFolderWhenFinished)
                    HelpHintView(message: settings.text(.helpOpenFolderWhenFinished))
                }

                HStack {
                    Spacer()
                    Button(settings.text(.clearList), role: .destructive, action: onClearList)
                }
            }
            .padding(.top, 4)
        }
    }
}
