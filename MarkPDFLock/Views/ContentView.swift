import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        VStack(spacing: 12) {
            DropZoneView { urls in
                viewModel.addFiles(from: urls)
            }

            FileListView(
                files: viewModel.files,
                onRemove: viewModel.removeFile(id:),
                onReveal: viewModel.revealInFinder
            )

            HStack(alignment: .top, spacing: 12) {
                PasswordSectionView(
                    userPassword: $viewModel.options.userPassword,
                    ownerPassword: $viewModel.options.ownerPassword,
                    showPassword: $viewModel.showPassword
                )

                PermissionSectionView(
                    printPermission: $viewModel.options.printPermission,
                    copyAllowed: $viewModel.options.copyAllowed,
                    modifyPermission: $viewModel.options.modifyPermission
                )
            }

            ExportControlsView(
                exportFolderURL: viewModel.exportFolderURL,
                overwriteExisting: $viewModel.options.overwriteExisting,
                openFolderWhenFinished: $viewModel.options.openFolderWhenFinished,
                onChooseFolder: viewModel.chooseExportFolder,
                onClearList: viewModel.clearList
            )

            ProgressSectionView(
                progress: viewModel.progress,
                completedCount: viewModel.completedCount,
                totalCount: viewModel.files.count,
                globalMessage: viewModel.globalMessage,
                summaryText: viewModel.summaryText
            )

            HStack {
                Spacer()
                Button(viewModel.isProcessing ? "Encrypting..." : "Start Encryption") {
                    viewModel.startEncryption()
                }
                .disabled(!viewModel.canStartEncryption)
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(16)
        .frame(minWidth: 900, minHeight: 760)
    }
}

#Preview {
    ContentView()
}
