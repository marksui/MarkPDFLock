import SwiftUI

struct PasswordSectionView: View {
    @ObservedObject var settings: AppSettings
    @Binding var userPassword: String
    @Binding var ownerPassword: String
    @Binding var showPassword: Bool

    var body: some View {
        GroupBox(settings.text(.passwordSettings)) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(settings.text(.openPasswordRequired))
                            .font(.subheadline)
                        HelpHintView(message: settings.text(.helpOpenPassword), scrollable: true)
                    }
                    if showPassword {
                        TextField(settings.text(.openPasswordPlaceholder), text: $userPassword)
                    } else {
                        SecureField(settings.text(.openPasswordPlaceholder), text: $userPassword)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(settings.text(.ownerPasswordOptional))
                            .font(.subheadline)
                        HelpHintView(message: settings.text(.helpOwnerPassword), scrollable: true)
                    }
                    if showPassword {
                        TextField(settings.text(.ownerPasswordPlaceholder), text: $ownerPassword)
                    } else {
                        SecureField(settings.text(.ownerPasswordPlaceholder), text: $ownerPassword)
                    }
                    Text(settings.text(.ownerPasswordHint))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 6) {
                    Toggle(settings.text(.showPassword), isOn: $showPassword)
                    HelpHintView(message: settings.text(.helpShowPassword), scrollable: true)
                }
            }
            .padding(.top, 4)
        }
    }
}
