import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettings
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(settings.text(.settings))
                .font(.title3.weight(.semibold))

            GroupBox {
                VStack(spacing: 12) {
                    HStack {
                        HStack(spacing: 6) {
                            Text(settings.text(.language))
                            HelpHintView(message: settings.text(.helpLanguage))
                        }
                        Spacer()
                        Picker(settings.text(.language), selection: $settings.language) {
                            Text(settings.text(.english)).tag(AppLanguage.english)
                            Text(settings.text(.simplifiedChinese)).tag(AppLanguage.simplifiedChinese)
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .frame(width: AppUI.pickerWidth)
                    }

                    HStack {
                        HStack(spacing: 6) {
                            Text(settings.text(.fontSize))
                            HelpHintView(message: settings.text(.helpFontSize))
                        }
                        Spacer()
                        Picker(settings.text(.fontSize), selection: $settings.fontSize) {
                            Text(settings.text(.small)).tag(AppFontSize.small)
                            Text(settings.text(.medium)).tag(AppFontSize.medium)
                            Text(settings.text(.large)).tag(AppFontSize.large)
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .frame(width: AppUI.pickerWidth)
                    }

                    HStack {
                        HStack(spacing: 6) {
                            Text(settings.text(.themeColor))
                            HelpHintView(message: settings.text(.helpTheme))
                        }
                        Spacer()
                        Picker(settings.text(.themeColor), selection: $settings.theme) {
                            Text(settings.text(.lightTheme)).tag(AppThemeColor.light)
                            Text(settings.text(.darkTheme)).tag(AppThemeColor.dark)
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .frame(width: AppUI.pickerWidth)
                    }
                }
                .padding(.top, 4)
            }

            HStack {
                Spacer()
                Button(settings.text(.close)) {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(width: 500)
    }
}
