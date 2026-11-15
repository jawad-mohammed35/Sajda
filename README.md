# Sajda

A prayer times app for macOS that lives in the menu bar.

<img src="https://github.com/user-attachments/assets/6e8bd922-a446-4b33-a184-e5e89493a4b1" alt="Sajda App Screenshot">

> The interface now uses Liquid Glass: a glass panel, a frosted interior, and native glass controls that fit in with the latest macOS.

[![Latest Release](https://img.shields.io/github/v/release/jawad-mohammed35/Sajda)](https://github.com/jawad-mohammed35/Sajda/releases)
[![macOS Sonoma 14.0+](https://img.shields.io/badge/macOS-Sonoma%2014.0%2B-blue)](https://github.com/jawad-mohammed35/Sajda/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## About This Fork

This repository is a modified fork of [Sajda](https://github.com/ikoshura/Sajda), the open-source macOS prayer time application originally developed by ikoshura. All credit for the original application goes to its creator and contributors; this fork is independent and is not officially maintained or endorsed by them.

The main modification is **Sunrise in the daily timetable**, between Fajr and Dhuhr. It uses Adhan's Sunrise for calculated schedules and the imported Sunrise/Shuruk value for custom PDF/CSV schedules. Missing or invalid imported Sunrise values are omitted, never estimated. If a custom file does not cover a date, the existing calculated fallback for the five prayers remains available, while Sunrise stays hidden. Sunrise is informational only: it has no adhan, notification, mute control, next-prayer highlight, or countdown.

This fork uses a separate bundle identifier (`com.jawadmohammed35.SajdaSunrise`), so it has its own settings and notification permissions. Automatic updates are disabled until the fork has an independent signed feed. Manual update checks open this fork's releases page.

## Features

- Shows the next prayer in the menu bar as an icon, a countdown, or the exact time.
- Turns red a set amount of time before prayer. You choose how early.
- Detects your location automatically, or lets you pick any city.
- Supports several calculation methods, and custom timetables imported from a PDF or CSV.
- Works offline for prayer time calculation. No accounts or tracking.
- Available in English, Indonesian, Arabic, Spanish, French, German, Japanese, Korean, and Simplified Chinese.

## Installation

Requires macOS Sonoma 14.0 or later (Apple Silicon or Intel).

### Fork testing builds

Download a package from [this fork's releases](https://github.com/jawad-mohammed35/Sajda/releases). Check its release notes for the signing status. Unsigned testing builds are **not Developer ID signed or Apple notarized** and may be blocked by Gatekeeper when downloaded. Do not disable Gatekeeper or remove quarantine; build locally using the instructions below, or wait for a signed release if macOS refuses to open the download.

The following Homebrew instructions install the original application, without this fork's Sunrise change.

### Upstream Homebrew

```bash
brew install --cask ikoshura/sajda/sajda
```

### Upstream DMG

Download the original `.dmg` from the [upstream Releases page](https://github.com/ikoshura/Sajda/releases), open it, and drag Sajda to your Applications folder.

### Upstream first launch

The upstream application is signed with a Developer ID certificate and notarized by Apple, so it opens normally — no Gatekeeper workaround, no quarantine removal. Quit Sajda and reopen it, and updates install themselves in the background (verified with an EdDSA signature before anything is replaced, via [Sparkle](https://sparkle-project.org)).

## Build from source

Requires macOS Sonoma 14.0+ and Xcode with the macOS SDK.

```bash
xcodebuild \
  -project Sajda.xcodeproj \
  -scheme Sajda \
  -configuration Debug \
  -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO \
  build

open build/DerivedData/Build/Products/Debug/Sajda.app
```

For signing and notarization, see [docs/RELEASE.md](docs/RELEASE.md). Implementation details, validation results, limitations and modified files are recorded in [docs/SUNRISE_QA.md](docs/SUNRISE_QA.md).

## Contributing

Pull requests are welcome. For bigger changes, please open an issue first.

## Contributors

- [@ikoshura](https://github.com/ikoshura)
- [@omar-hanafy](https://github.com/omar-hanafy)
- [@novan](https://github.com/novan)
- [@maddada](https://github.com/maddada)
- [@sabuz796](https://github.com/sabuz796)

[![Contributors](https://contrib.rocks/image?repo=ikoshura/Sajda)](https://github.com/ikoshura/Sajda/graphs/contributors)

Thanks also to [@iMacLion](https://github.com/iMacLion) for testing releases and giving detailed feedback.

## Privacy

- No accounts, analytics, or tracking. The app has no servers and collects nothing.
- Location is used only to calculate prayer times, and stays on your device.
- Prayer times are calculated offline with the Adhan library.
- City search sends only the text you type to [OpenStreetMap Nominatim](https://wiki.openstreetmap.org/wiki/Nominatim). Requests identify as `Sajda/1.0`.
- Timezone detection uses Apple's standard reverse geocoding.
- Settings are stored locally on your Mac.

## Acknowledgements

- [Adhan](https://github.com/batoulapps/Adhan): prayer time calculation (MIT)
- [ColorSelector](https://github.com/jaywcjlove/ColorSelector): highlight colour picker (MIT)
- [FluidMenuBarExtra](https://github.com/lfroms/fluid-menu-bar-extra): resizing menu bar window (MIT, vendored in `Sajda/FluidMenuBar/`)
- [MacControlCenterUI](https://github.com/orchetect/MacControlCenterUI): Control Center style menu and controls (MIT; pulls in [MenuBarExtraAccess](https://github.com/orchetect/MenuBarExtraAccess), also MIT)
- [NavigationStack](https://github.com/indieSoftware/NavigationStack): view navigation (MIT)
- [Sparkle](https://sparkle-project.org): signed, notarized in-app updates (MIT)
- Adhan audio: bundled recordings from [adhan.notifications](https://archive.org/details/adhan.notifications) and [adhan.recordings.from.doha.qatar](https://archive.org/details/adhan.recordings.from.doha.qatar), both Public Domain Mark 1.0
- City search: [OpenStreetMap Nominatim](https://wiki.openstreetmap.org/wiki/Nominatim); results © OpenStreetMap contributors (ODbL). Timezone detection uses Apple's reverse geocoding
- Artwork: menu-bar mosque glyph and app icon use [Mosque by Nawicon](https://thenounproject.com/icon/mosque-3364513/) from Noun Project (CC BY 3.0, via [@sabuz796](https://github.com/sabuz796) in [PR #17](https://github.com/ikoshura/Sajda/pull/17)). No bundled fonts — system fonts only

## License

MIT. See [LICENSE](LICENSE).
