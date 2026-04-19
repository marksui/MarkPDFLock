import SwiftUI

struct HelpHintView: View {
    let message: String
    var scrollable: Bool = false
    @State private var isPresented = false

    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            Image(systemName: "questionmark.circle")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .help(message)
        .accessibilityLabel(message)
        .popover(isPresented: $isPresented, arrowEdge: .top) {
            if scrollable {
                ScrollView {
                    Text(message)
                        .font(.body)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                }
                .frame(minWidth: 420, idealWidth: 460, maxWidth: 520, minHeight: 220, idealHeight: 280, maxHeight: 360)
            } else {
                Text(message)
                    .font(.body)
                    .textSelection(.enabled)
                    .padding(12)
                    .frame(maxWidth: 280, alignment: .leading)
            }
        }
    }
}
