# MarkPDFLock

MarkPDFLock is a **local-only macOS SwiftUI utility** for encrypting one or more PDF files with password protection using **qpdf + AES-256**.

- No cloud upload
- No account/login
- No analytics
- No network calls

## Features

- Drag and drop one or multiple PDFs.
- File queue with:
  - file name
  - original path
  - file size
  - status (`pending`, `processing`, `done`, `failed`)
- Password settings:
  - required open password
  - optional owner password
  - show/hide password
- Permission settings:
  - Printing: yes / no / low-resolution only
  - Copying: yes / no
  - Modifying: none / assembly / full
- Select export folder.
- Batch encryption with progress bar.
- Per-file success/failure handling.
- Reveal exported file in Finder.
- Clear queue.
- Overwrite toggle for existing output files.
- Auto-open export folder when finished.

## Project structure

```text
MarkPDFLock/
├── MarkPDFLock.xcodeproj
├── MarkPDFLock
│   ├── MarkPDFLockApp.swift
│   ├── Models
│   │   ├── EncryptionOptions.swift
│   │   └── FileItem.swift
│   ├── Services
│   │   └── QPDFRunner.swift
│   ├── ViewModels
│   │   └── MainViewModel.swift
│   ├── Views
│   │   ├── ContentView.swift
│   │   ├── DropZoneView.swift
│   │   ├── ExportControlsView.swift
│   │   ├── FileListView.swift
│   │   ├── PasswordSectionView.swift
│   │   ├── PermissionSectionView.swift
│   │   └── ProgressSectionView.swift
│   └── Utilities
└── README.md
```

## Build & run

1. Open `MarkPDFLock.xcodeproj` in Xcode (macOS).
2. Set your own bundle identifier/team in target signing settings.
3. Build and run the `MarkPDFLock` target.

## qpdf integration

### Option A: Bundle qpdf inside app (recommended)

1. Build or obtain a trusted `qpdf` executable for macOS.
2. In Xcode, add a folder reference named `qpdf` under app resources.
3. Place binary at:

```text
MarkPDFLock/qpdf/qpdf
```

4. Ensure the binary has execute permissions:

```bash
chmod +x MarkPDFLock/qpdf/qpdf
```

The app resolves qpdf in this order:
1. Bundled resource: `qpdf/qpdf`
2. Bundled root resource: `qpdf`
3. System locations:
   - `/opt/homebrew/bin/qpdf`
   - `/usr/local/bin/qpdf`
   - `/usr/bin/qpdf`

### Option B: Use system-installed qpdf

Install qpdf locally and ensure one of the system paths above exists.

## Example qpdf command

The app builds a command equivalent to:

```bash
qpdf --encrypt "<user_password>" "<owner_password_or_user_password>" 256 \
  --use-aes=y \
  --print=<full|none|low> \
  --modify=<none|assembly|all> \
  --extract=<y|n> \
  -- "<input.pdf>" "<output_encrypted.pdf>"
```

Output naming:
- default: `originalname_encrypted.pdf`
- if duplicate and overwrite is off: `originalname_encrypted_1.pdf`, etc.

## Security notes

- Encryption mode is locked to **256-bit AES** (`--use-aes=y` + `256`).
- Weak encryption modes are not used.
- If owner password is blank, MarkPDFLock safely falls back to the open password (avoids empty-owner defaults).
- All processing is performed locally on device.
- No password values are sent over network.

## Error handling included

- Missing qpdf binary
- Invalid/non-PDF input
- Empty required password
- Export path issues
- Duplicate output conflicts
- Permission denied read/write failures

All surfaced as plain English messages in the UI per file and in batch summary.

## Optional app icon concept

A simple line icon:
- PDF document shape + padlock overlay
- monochrome for template compatibility
- accent blue lock for app icon variant
