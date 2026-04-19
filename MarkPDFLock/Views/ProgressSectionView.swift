import SwiftUI

struct ProgressSectionView: View {
    let progress: Double
    let completedCount: Int
    let totalCount: Int
    let globalMessage: String?
    let summaryText: String

    var body: some View {
        GroupBox("Progress") {
            VStack(alignment: .leading, spacing: 10) {
                ProgressView(value: progress)
                    .progressViewStyle(.linear)

                Text("Processed \(completedCount) of \(totalCount)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(summaryText)
                    .font(.subheadline)

                if let globalMessage {
                    Text(globalMessage)
                        .foregroundStyle(globalMessage.contains("fail") ? .orange : .green)
                }
            }
            .padding(.top, 4)
        }
    }
}
