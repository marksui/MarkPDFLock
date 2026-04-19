import SwiftUI

struct PasswordSectionView: View {
    @Binding var userPassword: String
    @Binding var ownerPassword: String
    @Binding var showPassword: Bool

    var body: some View {
        GroupBox("Password Settings") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Open password (required)")
                        .font(.subheadline)
                    if showPassword {
                        TextField("Enter open password", text: $userPassword)
                    } else {
                        SecureField("Enter open password", text: $userPassword)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Owner password (optional)")
                        .font(.subheadline)
                    if showPassword {
                        TextField("Optional owner password", text: $ownerPassword)
                    } else {
                        SecureField("Optional owner password", text: $ownerPassword)
                    }
                    Text("If empty, owner password will safely default to open password.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Toggle("Show password", isOn: $showPassword)
            }
            .padding(.top, 4)
        }
    }
}
