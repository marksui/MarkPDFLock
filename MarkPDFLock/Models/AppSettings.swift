import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english
    case simplifiedChinese

    var id: String { rawValue }
}

enum AppFontSize: String, CaseIterable, Identifiable {
    case small
    case medium
    case large

    var id: String { rawValue }

    var dynamicTypeSize: DynamicTypeSize {
        switch self {
        case .small: return .xSmall
        case .medium: return .medium
        case .large: return .xxxLarge
        }
    }

    var controlSize: ControlSize {
        switch self {
        case .small: return .small
        case .medium: return .regular
        case .large: return .large
        }
    }
}

enum AppThemeColor: String, CaseIterable, Identifiable {
    case light
    case dark

    var id: String { rawValue }

    var tint: Color {
        switch self {
        case .light: return .black
        case .dark: return .white
        }
    }

    var background: Color {
        switch self {
        case .light: return .white
        case .dark: return .black
        }
    }

    var cardBackground: Color {
        switch self {
        case .light: return Color(red: 0.96, green: 0.96, blue: 0.96)
        case .dark: return Color(red: 0.10, green: 0.10, blue: 0.10)
        }
    }

    var border: Color {
        switch self {
        case .light: return Color.black.opacity(0.15)
        case .dark: return Color.white.opacity(0.2)
        }
    }

    var colorScheme: ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum AppUI {
    static let pickerWidth: CGFloat = 220
}

enum AppTextKey: String {
    case appTitle
    case settings
    case language
    case fontSize
    case themeColor
    case close
    case english
    case simplifiedChinese
    case small
    case medium
    case large
    case lightTheme
    case darkTheme
    case dragDropTitle
    case dragDropSubtitle
    case files
    case items
    case addFiles
    case addFolder
    case removeCompleted
    case revealInFinder
    case cancel
    case passwordSettings
    case openPasswordRequired
    case openPasswordPlaceholder
    case ownerPasswordOptional
    case ownerPasswordPlaceholder
    case ownerPasswordHint
    case showPassword
    case permissionSettings
    case allowPrinting
    case allowCopying
    case allowModifying
    case yes
    case no
    case lowResolutionOnly
    case none
    case assembly
    case full
    case export
    case noFolderSelected
    case chooseFolder
    case overwriteExisting
    case openFolderWhenFinished
    case clearList
    case progress
    case processedCount
    case startEncryption
    case encrypting
    case onlyPDFSupported
    case outputFileExists
    case encryptionCompletedWithFailures
    case encryptionCompletedSuccessfully
    case passwordCannotBeEmpty
    case permissionDenied
    case pathNotFound
    case unknownError
    case statusPending
    case statusProcessing
    case statusDone
    case statusFailed
    case summaryFormat
    case helpOpenPassword
    case helpOwnerPassword
    case helpShowPassword
    case helpAllowPrinting
    case helpAllowCopying
    case helpAllowModifying
    case helpChooseFolder
    case helpOverwriteExisting
    case helpOpenFolderWhenFinished
    case helpLanguage
    case helpFontSize
    case helpTheme
    case modifyNoneDescription
    case modifyAssemblyDescription
    case modifyFullDescription
    case helpAppOverview
}

enum AppText {
    static func localized(_ key: AppTextKey, language: AppLanguage = AppSettings.currentLanguage()) -> String {
        switch language {
        case .english:
            return english[key] ?? key.rawValue
        case .simplifiedChinese:
            return simplifiedChinese[key] ?? key.rawValue
        }
    }

    private static let english: [AppTextKey: String] = [
        .appTitle: "MarkPDFLock",
        .settings: "Settings",
        .language: "Language",
        .fontSize: "Font Size",
        .themeColor: "Theme",
        .close: "Close",
        .english: "English",
        .simplifiedChinese: "Simplified Chinese",
        .small: "Small",
        .medium: "Medium",
        .large: "Large",
        .lightTheme: "White Background / Black Text",
        .darkTheme: "Black Background / White Text",
        .dragDropTitle: "Drag and drop PDF files here",
        .dragDropSubtitle: "Drop one or multiple PDFs",
        .files: "Files",
        .items: "item(s)",
        .addFiles: "Add Files",
        .addFolder: "Add Folder",
        .removeCompleted: "Remove Completed",
        .revealInFinder: "Reveal in Finder",
        .cancel: "Cancel",
        .passwordSettings: "Password Settings",
        .openPasswordRequired: "Open password (required)",
        .openPasswordPlaceholder: "Enter open password",
        .ownerPasswordOptional: "Owner password (optional)",
        .ownerPasswordPlaceholder: "Optional owner password",
        .ownerPasswordHint: "If empty, owner password will safely default to open password.",
        .showPassword: "Show password",
        .permissionSettings: "Permission Settings",
        .allowPrinting: "Allow printing",
        .allowCopying: "Allow copying",
        .allowModifying: "Allow modifying",
        .yes: "Yes",
        .no: "No",
        .lowResolutionOnly: "Low-resolution only",
        .none: "None",
        .assembly: "Assembly",
        .full: "Full",
        .export: "Export",
        .noFolderSelected: "No folder selected",
        .chooseFolder: "Choose Folder",
        .overwriteExisting: "Overwrite existing encrypted files",
        .openFolderWhenFinished: "Open export folder when finished",
        .clearList: "Clear List",
        .progress: "Progress",
        .processedCount: "Processed %d of %d",
        .startEncryption: "Start Encryption",
        .encrypting: "Encrypting...",
        .onlyPDFSupported: "Only PDF files are supported.",
        .outputFileExists: "Output file already exists. Enable overwrite or rename the file.",
        .encryptionCompletedWithFailures: "Encryption completed with some failures.",
        .encryptionCompletedSuccessfully: "Encryption completed successfully.",
        .passwordCannotBeEmpty: "Password cannot be empty.",
        .permissionDenied: "Permission denied while reading or writing files.",
        .pathNotFound: "Input or output path was not found.",
        .unknownError: "An unknown error occurred.",
        .statusPending: "Pending",
        .statusProcessing: "Processing",
        .statusDone: "Done",
        .statusFailed: "Failed",
        .summaryFormat: "Total: %d • Succeeded: %d • Failed: %d",
        .helpOpenPassword: "This password is required to open the encrypted PDF.",
        .helpOwnerPassword: "Controls permission settings. If empty, it defaults to the open password.",
        .helpShowPassword: "Temporarily show password text for easier checking.",
        .helpAllowPrinting: "Set whether recipients can print and at what quality.",
        .helpAllowCopying: "Set whether text and content can be copied from the PDF.",
        .helpAllowModifying: "Set how much editing is allowed after encryption.",
        .helpChooseFolder: "Choose where encrypted PDFs will be saved.",
        .helpOverwriteExisting: "If enabled, existing files with the same name will be replaced.",
        .helpOpenFolderWhenFinished: "Automatically opens the export folder after processing.",
        .helpLanguage: "Switch the app language for all labels and messages.",
        .helpFontSize: "Adjust overall text and control size.",
        .helpTheme: "Choose white background with black text, or black background with white text.",
        .modifyNoneDescription: "No editing allowed after encryption.",
        .modifyAssemblyDescription: "Only document assembly is allowed (for example rotating or merging pages).",
        .modifyFullDescription: "All modification actions are allowed.",
        .helpAppOverview: "About this app:\nMarkPDFLock is a lightweight desktop tool for batch PDF protection.\n\nHow encryption works:\nIt uses qpdf to apply 256-bit AES encryption and PDF permission rules (print/copy/modify), then writes a new encrypted PDF file without altering your source file.\n\nCreator background:\nThis project was created as a practical workflow tool for fast, repeatable document protection.\n\nAbout the author:\nAn independent builder focused on making clean, practical desktop tools."
    ]

    private static let simplifiedChinese: [AppTextKey: String] = [
        .appTitle: "MarkPDFLock",
        .settings: "设置",
        .language: "语言",
        .fontSize: "字体大小",
        .themeColor: "主题",
        .close: "关闭",
        .english: "英文",
        .simplifiedChinese: "简体中文",
        .small: "小",
        .medium: "中",
        .large: "大",
        .lightTheme: "白底黑字",
        .darkTheme: "黑底白字",
        .dragDropTitle: "拖放 PDF 文件到这里",
        .dragDropSubtitle: "支持一次拖入一个或多个 PDF",
        .files: "文件列表",
        .items: "个文件",
        .addFiles: "添加文件",
        .addFolder: "添加文件夹",
        .removeCompleted: "移除已完成",
        .revealInFinder: "在访达中显示",
        .cancel: "取消",
        .passwordSettings: "密码设置",
        .openPasswordRequired: "打开密码（必填）",
        .openPasswordPlaceholder: "请输入打开密码",
        .ownerPasswordOptional: "所有者密码（可选）",
        .ownerPasswordPlaceholder: "可选的所有者密码",
        .ownerPasswordHint: "如果留空，将自动安全地使用打开密码。",
        .showPassword: "显示密码",
        .permissionSettings: "权限设置",
        .allowPrinting: "允许打印",
        .allowCopying: "允许复制",
        .allowModifying: "允许修改",
        .yes: "是",
        .no: "否",
        .lowResolutionOnly: "仅低分辨率",
        .none: "不允许",
        .assembly: "仅文档装配",
        .full: "完全允许",
        .export: "导出",
        .noFolderSelected: "未选择文件夹",
        .chooseFolder: "选择文件夹",
        .overwriteExisting: "覆盖已存在的加密文件",
        .openFolderWhenFinished: "完成后打开导出文件夹",
        .clearList: "清空列表",
        .progress: "进度",
        .processedCount: "已处理 %d / %d",
        .startEncryption: "开始加密",
        .encrypting: "正在加密...",
        .onlyPDFSupported: "仅支持 PDF 文件。",
        .outputFileExists: "输出文件已存在。请开启覆盖或重命名文件。",
        .encryptionCompletedWithFailures: "加密完成，但有部分失败。",
        .encryptionCompletedSuccessfully: "加密已全部完成。",
        .passwordCannotBeEmpty: "密码不能为空。",
        .permissionDenied: "读取或写入文件时权限不足。",
        .pathNotFound: "未找到输入或输出路径。",
        .unknownError: "发生未知错误。",
        .statusPending: "待处理",
        .statusProcessing: "处理中",
        .statusDone: "完成",
        .statusFailed: "失败",
        .summaryFormat: "总计: %d • 成功: %d • 失败: %d",
        .helpOpenPassword: "这是打开加密 PDF 必需的密码。",
        .helpOwnerPassword: "用于控制权限设置；留空时会默认使用打开密码。",
        .helpShowPassword: "临时明文显示密码，便于核对输入。",
        .helpAllowPrinting: "设置接收者是否能打印，以及打印质量。",
        .helpAllowCopying: "设置是否允许从 PDF 复制文本和内容。",
        .helpAllowModifying: "设置加密后允许的编辑范围。",
        .helpChooseFolder: "选择加密后的 PDF 保存位置。",
        .helpOverwriteExisting: "开启后，同名文件会被直接覆盖。",
        .helpOpenFolderWhenFinished: "处理完成后自动打开导出文件夹。",
        .helpLanguage: "切换应用语言，影响所有标签和提示信息。",
        .helpFontSize: "调整全局文字与控件尺寸。",
        .helpTheme: "选择白底黑字或黑底白字主题。",
        .modifyNoneDescription: "加密后不允许任何编辑操作。",
        .modifyAssemblyDescription: "仅允许文档装配（例如旋转或合并页面）。",
        .modifyFullDescription: "允许所有修改操作。",
        .helpAppOverview: "软件介绍：\nMarkPDFLock 是一个轻量级桌面工具，用于批量给 PDF 加密。\n\n如何实现加密：\n它调用 qpdf，对 PDF 应用 256-bit AES 加密和权限规则（打印/复制/修改），输出新的加密文件，不会改动原文件。\n\n创作背景：\n这个项目源于日常文档处理需求，希望用最少步骤完成稳定、可重复的加密流程。\n\n个人介绍：\n作者是专注实用工具的独立开发者，偏好简洁、稳定、可维护的产品设计。"
    ]
}

final class AppSettings: ObservableObject {
    static let languageDefaultsKey = "ui.language"
    private static let fontSizeDefaultsKey = "ui.fontSize"
    private static let themeDefaultsKey = "ui.theme"

    @Published var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: Self.languageDefaultsKey)
        }
    }

    @Published var fontSize: AppFontSize {
        didSet {
            UserDefaults.standard.set(fontSize.rawValue, forKey: Self.fontSizeDefaultsKey)
        }
    }

    @Published var theme: AppThemeColor {
        didSet {
            UserDefaults.standard.set(theme.rawValue, forKey: Self.themeDefaultsKey)
        }
    }

    init() {
        let defaults = UserDefaults.standard
        language = AppLanguage(rawValue: defaults.string(forKey: Self.languageDefaultsKey) ?? "") ?? .english
        fontSize = AppFontSize(rawValue: defaults.string(forKey: Self.fontSizeDefaultsKey) ?? "") ?? .medium
        theme = AppThemeColor(rawValue: defaults.string(forKey: Self.themeDefaultsKey) ?? "") ?? .light
    }

    static func currentLanguage() -> AppLanguage {
        let raw = UserDefaults.standard.string(forKey: languageDefaultsKey) ?? ""
        return AppLanguage(rawValue: raw) ?? .english
    }

    func text(_ key: AppTextKey) -> String {
        AppText.localized(key, language: language)
    }

    func text(_ key: AppTextKey, _ value1: Int, _ value2: Int) -> String {
        String(format: text(key), value1, value2)
    }

    func text(_ key: AppTextKey, _ value1: Int, _ value2: Int, _ value3: Int) -> String {
        String(format: text(key), value1, value2, value3)
    }
}
