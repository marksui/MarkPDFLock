import SwiftUI

struct HelpHintView: View {
    let message: String
    var scrollable: Bool = false
    @State private var isPresented = false

    private var shouldScroll: Bool {
        scrollable || message.count > 120
    }

    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            Image(systemName: "questionmark.circle")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .buttonStyle(.plain)
        .help(message)
        .accessibilityLabel(message)
        .popover(isPresented: $isPresented, arrowEdge: .top) {
            if shouldScroll {
                ScrollView {
                    Text(message)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                }
                .frame(minWidth: 380, idealWidth: 440, maxWidth: 520, minHeight: 180, idealHeight: 240, maxHeight: 340)
            } else {
                Text(message)
                    .font(.body)
                    .padding(12)
                    .frame(minWidth: 280, idealWidth: 320, maxWidth: 400, alignment: .leading)
            }
        }
    }
}
