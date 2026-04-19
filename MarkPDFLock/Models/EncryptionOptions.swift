import Foundation

enum PrintPermission: String, CaseIterable, Identifiable {
    case full
    case none
    case lowResolution

    var id: String { rawValue }

    var label: String {
        switch self {
        case .full: return "Yes"
        case .none: return "No"
        case .lowResolution: return "Low-resolution only"
        }
    }

    var qpdfValue: String {
        switch self {
        case .full: return "full"
        case .none: return "none"
        case .lowResolution: return "low"
        }
    }
}

enum ModifyPermission: String, CaseIterable, Identifiable {
    case none
    case assembly
    case full

    var id: String { rawValue }

    var label: String {
        switch self {
        case .none: return "None"
        case .assembly: return "Assembly"
        case .full: return "Full"
        }
    }

    var qpdfValue: String {
        switch self {
        case .none: return "none"
        case .assembly: return "assembly"
        case .full: return "all"
        }
    }
}

struct EncryptionOptions {
    var userPassword: String = ""
    var ownerPassword: String = ""
    var printPermission: PrintPermission = .full
    var copyAllowed: Bool = true
    var modifyPermission: ModifyPermission = .none
    var overwriteExisting: Bool = false
    var openFolderWhenFinished: Bool = false
}
