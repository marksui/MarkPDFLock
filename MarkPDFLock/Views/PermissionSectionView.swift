import SwiftUI

struct PermissionSectionView: View {
    @ObservedObject var settings: AppSettings
    @Binding var printPermission: PrintPermission
    @Binding var copyAllowed: Bool
    @Binding var modifyPermission: ModifyPermission

    var body: some View {
        GroupBox(label: Text(settings.text(.permissionSettings))) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack(spacing: 6) {
                        Text(settings.text(.allowPrinting))
                        HelpHintView(message: settings.text(.helpAllowPrinting))
                    }
                    Spacer()
                    Menu {
                        ForEach(PrintPermission.allCases) { option in
                            Button(printPermissionLabel(option)) {
                                printPermission = option
                            }
                        }
                    } label: {
                        menuLabel(printPermissionLabel(printPermission))
                    }
                }

                HStack {
                    HStack(spacing: 6) {
                        Text(settings.text(.allowCopying))
                        HelpHintView(message: settings.text(.helpAllowCopying))
                    }
                    Spacer()
                    Menu {
                        Button(settings.text(.yes)) {
                            copyAllowed = true
                        }
                        Button(settings.text(.no)) {
                            copyAllowed = false
                        }
                    } label: {
                        menuLabel(copyAllowed ? settings.text(.yes) : settings.text(.no))
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        HStack(spacing: 6) {
                            Text(settings.text(.allowModifying))
                            HelpHintView(message: settings.text(.helpAllowModifying))
                        }
                        Spacer()
                        Menu {
                            ForEach(ModifyPermission.allCases) { option in
                                Button(modifyPermissionLabel(option)) {
                                    modifyPermission = option
                                }
                            }
                        } label: {
                            menuLabel(modifyPermissionLabel(modifyPermission))
                        }
                    }

                    Text(modifyPermissionDescription(modifyPermission))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 4)
        }
    }

    private func menuLabel(_ text: String) -> some View {
        HStack(spacing: 8) {
            Text(text)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: 0)
            Image(systemName: "chevron.up.chevron.down")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(width: AppUI.pickerWidth, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.secondary.opacity(0.12))
        )
    }

    private func printPermissionLabel(_ permission: PrintPermission) -> String {
        switch permission {
        case .full: return settings.text(.yes)
        case .none: return settings.text(.no)
        case .lowResolution: return settings.text(.lowResolutionOnly)
        }
    }

    private func modifyPermissionLabel(_ permission: ModifyPermission) -> String {
        switch permission {
        case .none: return settings.text(.none)
        case .assembly: return settings.text(.assembly)
        case .full: return settings.text(.full)
        }
    }

    private func modifyPermissionDescription(_ permission: ModifyPermission) -> String {
        switch permission {
        case .none: return settings.text(.modifyNoneDescription)
        case .assembly: return settings.text(.modifyAssemblyDescription)
        case .full: return settings.text(.modifyFullDescription)
        }
    }
}
