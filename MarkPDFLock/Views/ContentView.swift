import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var settings = AppSettings()
    @State private var isShowingSettings = false

    private let pageMaxWidth: CGFloat = 1200
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    var body: some View {
        ZStack {
            settings.theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 8) {
                    header

                    card {
                        DropZoneView(
                            settings: settings,
                            onDropFiles: { urls in
                                viewModel.addFiles(from: urls)
                            },
                            onAddFiles: viewModel.choosePDFFiles,
                            onAddFolder: viewModel.choosePDFFolder
                        )
                    }

                    HStack(alignment: .top, spacing: 8) {
                        card {
                            PasswordSectionView(
                                settings: settings,
                                userPassword: $viewModel.options.userPassword,
                                ownerPassword: $viewModel.options.ownerPassword,
                                showPassword: $viewModel.showPassword
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .top)

                        card {
                            PermissionSectionView(
                                settings: settings,
                                printPermission: $viewModel.options.printPermission,
                                copyAllowed: $viewModel.options.copyAllowed,
                                modifyPermission: $viewModel.options.modifyPermission
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                    }

                    card {
                        ExportControlsView(
                            settings: settings,
                            exportFolderURL: viewModel.exportFolderURL,
                            overwriteExisting: $viewModel.options.overwriteExisting,
                            openFolderWhenFinished: $viewModel.options.openFolderWhenFinished,
                            onChooseFolder: viewModel.chooseExportFolder,
                            onClearList: viewModel.clearList
                        )
                    }

                    card {
                        FileListView(
                            settings: settings,
                            files: viewModel.files,
                            isProcessing: viewModel.isProcessing,
                            onRemove: viewModel.removeFile(id:),
                            onRemoveCompleted: viewModel.removeCompletedFiles,
                            onReveal: viewModel.revealInFinder
                        )
                    }

                    card {
                        ProgressSectionView(
                            settings: settings,
                            progress: viewModel.progress,
                            completedCount: viewModel.completedCount,
                            totalCount: viewModel.files.count,
                            globalMessage: viewModel.globalMessage,
                            summaryText: viewModel.summaryText
                        )
                    }
                }
                .frame(maxWidth: pageMaxWidth)
                .padding(12)
            }
        }
        .textSelection(.enabled)
        .dynamicTypeSize(settings.fontSize.dynamicTypeSize)
        .controlSize(settings.fontSize.controlSize)
        .tint(settings.theme.tint)
        .preferredColorScheme(settings.theme.colorScheme)
        .frame(minWidth: 960, minHeight: 760)
        .animation(.easeInOut(duration: 0.15), value: settings.theme)
        .sheet(isPresented: $isShowingSettings) {
            SettingsView(settings: settings)
                .preferredColorScheme(settings.theme.colorScheme)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(settings.text(.appTitle))
                        .font(.title2.weight(.bold))
                    Text("v\(appVersion)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    HelpHintView(message: settings.text(.helpAppOverview), scrollable: true)
                }
                Text(settings.text(.dragDropSubtitle))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 10) {
                Button {
                    viewModel.startEncryption()
                } label: {
                    Label(viewModel.isProcessing ? settings.text(.encrypting) : settings.text(.startEncryption), systemImage: "bolt.fill")
                        .font(.headline)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .foregroundStyle(.white)
                        .frame(minWidth: 170)
                }
                .disabled(!viewModel.canStartEncryption)
                .buttonStyle(.plain)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(viewModel.canStartEncryption ? Color.green : Color.gray)
                )
                .opacity(viewModel.isProcessing ? 0.9 : 1)
                .keyboardShortcut(.defaultAction)

                Button {
                    isShowingSettings = true
                } label: {
                    Label(settings.text(.settings), systemImage: "slider.horizontal.3")
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(settings.theme.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(settings.theme.border, lineWidth: 1)
            )
    }
}

#Preview {
    ContentView()
}
