import SwiftUI

struct ProgressSectionView: View {
    @ObservedObject var settings: AppSettings
    let progress: Double
    let completedCount: Int
    let totalCount: Int
    let globalMessage: String?
    let summaryText: String

    var body: some View {
        GroupBox(settings.text(.progress)) {
            VStack(alignment: .leading, spacing: 10) {
                ProgressView(value: progress)
                    .progressViewStyle(.linear)

                Text(settings.text(.processedCount, completedCount, totalCount))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(summaryText)
                    .font(.subheadline)

                if let globalMessage {
                    Text(globalMessage)
                        .foregroundStyle(globalMessage == settings.text(.encryptionCompletedWithFailures) ? .orange : .green)
                }
            }
            .padding(.top, 4)
        }
    }
}
