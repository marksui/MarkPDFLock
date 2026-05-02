# MarkPDFLock

Version: `v1.0.0`

[![DMG downloads](https://img.shields.io/github/downloads/marksui/MarkPDFLock/v1.0.0/MarkPDFLock-v1.0.0.dmg?label=DMG%20downloads)](https://github.com/marksui/MarkPDFLock/releases/download/v1.0.0/MarkPDFLock-v1.0.0.dmg)

MarkPDFLock is a small macOS app for protecting PDF files with passwords. Add one PDF or a whole batch, choose the permissions you want, and export encrypted copies without changing your original files.

Everything runs on your Mac. MarkPDFLock does not upload your PDFs, does not require an account, and does not include analytics.

## Download

Download the current release:

[Download MarkPDFLock-v1.0.0.dmg](https://github.com/marksui/MarkPDFLock/releases/download/v1.0.0/MarkPDFLock-v1.0.0.dmg)

## Install

1. Download the DMG.
2. Open `MarkPDFLock-v1.0.0.dmg`.
3. Drag `MarkPDFLock.app` into the Applications folder.
4. Open MarkPDFLock from Applications.

If macOS shows a warning when opening the app, right-click MarkPDFLock and choose Open.

## What It Does

- Encrypts PDF files with password protection
- Supports batch processing for multiple PDFs
- Lets you choose an open password and optional owner password
- Controls whether recipients can print, copy, or modify the PDF
- Saves encrypted copies to the folder you choose
- Can overwrite existing encrypted files when you enable it
- Can open the export folder after the job finishes
- Shows per-file progress, success, and failure messages
- Keeps the original PDFs untouched

## Getting Started

1. Open MarkPDFLock.
2. Drag PDF files into the drop area, or click Add Files.
3. Enter the open password recipients will use to open the encrypted PDF.
4. Optional: enter an owner password if you want a separate password for permission control.
5. Choose printing, copying, and modifying permissions.
6. Choose an export folder.
7. Click Start Encryption.

Encrypted files are saved as new PDFs. By default, output names use `_encrypted`, such as `Contract_encrypted.pdf`.

## Passwords and Permissions

The open password is required. Anyone who opens the encrypted PDF will need this password.

The owner password is optional. It controls permission settings such as printing, copying, and modifying. If you leave it blank, MarkPDFLock safely uses the open password for owner permissions too.

PDF permissions depend on the PDF reader. Most modern readers follow them, but they are not a replacement for sharing files carefully.

## Privacy and Security

- Your PDFs stay on your Mac.
- Passwords are used locally during encryption.
- MarkPDFLock does not send files or passwords over the network.
- The app creates encrypted copies and does not edit your source PDFs.
- You are responsible for storing passwords safely. If you forget a PDF password, MarkPDFLock cannot recover it.

## Requirements

- macOS 11.5 or newer
- PDF files
- A MarkPDFLock build that includes `qpdf`, or a local `qpdf` installation

If MarkPDFLock says `qpdf` is missing, install it with Homebrew:

```bash
brew install qpdf
```

Then reopen MarkPDFLock and try again.

## Troubleshooting

**The app says only PDF files are supported.**
Make sure every file you added ends in `.pdf`.

**The output file already exists.**
Turn on Overwrite existing encrypted files, choose another export folder, or rename the existing file.

**Encryption failed for one file.**
Check that the PDF is not damaged, locked by another app, or stored somewhere MarkPDFLock cannot read.

**The encrypted PDF does not allow the action I expected.**
Review the printing, copying, and modifying settings, then export a new encrypted copy.

## Source

MarkPDFLock is open source: [github.com/marksui/MarkPDFLock](https://github.com/marksui/MarkPDFLock).
