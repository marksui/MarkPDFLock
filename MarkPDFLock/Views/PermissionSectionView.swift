import SwiftUI

struct PermissionSectionView: View {
    @Binding var printPermission: PrintPermission
    @Binding var copyAllowed: Bool
    @Binding var modifyPermission: ModifyPermission

    var body: some View {
        GroupBox("Permission Settings") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Allow printing")
                    Spacer()
                    Picker("Allow printing", selection: $printPermission) {
                        ForEach(PrintPermission.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 170)
                }

                HStack {
                    Text("Allow copying")
                    Spacer()
                    Picker("Allow copying", selection: $copyAllowed) {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                    }
                    .labelsHidden()
                    .frame(width: 170)
                }

                HStack {
                    Text("Allow modifying")
                    Spacer()
                    Picker("Allow modifying", selection: $modifyPermission) {
                        ForEach(ModifyPermission.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 170)
                }
            }
            .padding(.top, 4)
        }
    }
}
