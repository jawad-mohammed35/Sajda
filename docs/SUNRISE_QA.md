# Sunrise fork implementation and QA

Validated on November 15, 2026 with Xcode 27.2 (27B52), on Apple Silicon.

## Implementation

- `PrayerTimeViewModel.sunriseTime` is an informational value outside `todayTimes`. Adhan's existing `PrayerTimes.sunrise` supplies calculated schedules without changing the five corrected prayer times.
- The timetable uses the existing prayer row, typography, column measurements, glass appearance and clock formatter. Sunrise is between Fajr and Dhuhr (before Dhuha when Sunnah prayers are enabled), without highlighting or an adhan control.
- Imported PDF/CSV calendars already have the shape `[fajr, sunrise, dhuhr, asr, maghrib, isha]`; Sunrise comes directly from that second field in the existing Mac-timezone convention. Invalid/missing Sunrise is omitted. If a custom date is uncovered, the five-prayer fallback is preserved, but no Sunrise is synthesized. CSV/PDF importers continue rejecting incomplete layouts rather than inferring missing columns.
- All nine existing Sunrise translations are reused. The manual fork-release link has translations in all nine languages.
- Sunrise is excluded from audio lookup and notification filtering as an additional safeguard. Countdown, completion/highlight selection, prayer correction settings and Sunnah behavior continue using the existing prayer dictionary.

## Additional fixes

1. Replace the missing `../MacControlCenterUI` local dependency with the public package pinned to 2.7.5. Commit the Swift package lockfile for reproducibility. No new library was introduced.
2. Validate imported clock fields before constructing dates, preventing values such as `25:99` from rolling into another day.
3. Use calendar-day arithmetic for the previous/next custom timetable day, preserving day selection over daylight-saving transitions.
4. Refresh coordinate schedules at midnight in the selected location's timezone, and recalculate on system timezone changes.

## Independent distribution

- Bundle ID: `com.jawadmohammed35.SajdaSunrise`; app version 4.6.5, build 50.
- Remove the upstream Sparkle feed and public key; prevent Sparkle initialization and disable automatic update controls. Manual checks open this fork's releases page.
- Clear the upstream development team from the project. No signing identity, private key or Apple credential is used.
- `scripts/release-unsigned.sh` builds a universal Release app and packages only the app, original MIT license, testing-build notice and Applications shortcut.
- The retained upstream signed-release script is guarded against use from this fork.
- The MIT license and original author/contributor acknowledgements are preserved.

## Commands

```sh
xcodebuild -resolvePackageDependencies -project Sajda.xcodeproj -scheme Sajda \
  -derivedDataPath build/DerivedData -clonedSourcePackagesDirPath build/SourcePackages

xcodebuild -project Sajda.xcodeproj -scheme Sajda -configuration Debug \
  -derivedDataPath build/DerivedData -clonedSourcePackagesDirPath build/SourcePackages \
  -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO build

xcodebuild -project Sajda.xcodeproj -scheme Sajda -configuration Debug \
  -derivedDataPath build/DerivedData -clonedSourcePackagesDirPath build/SourcePackages \
  -destination 'platform=macOS' -only-testing:SajdaTests CODE_SIGNING_ALLOWED=NO test

# XCUITest needs a locally signed runner. '-' is an ad-hoc signature, not
# Developer ID signing. This changes no macOS security settings.
xcodebuild -project Sajda.xcodeproj -scheme Sajda -configuration Debug \
  -derivedDataPath build/UITestDerivedData -clonedSourcePackagesDirPath build/SourcePackages \
  -destination 'platform=macOS' -only-testing:SajdaUITests \
  CODE_SIGNING_ALLOWED=YES CODE_SIGN_IDENTITY=- DEVELOPMENT_TEAM= CODE_SIGN_STYLE=Manual test

bash scripts/release-unsigned.sh
```

## Results and limitations

- Dependency resolution and Debug compilation succeeded.
- Unit tests: 56 passed, 0 failed. Coverage includes New York, London, Jakarta and Tokyo across five dates (including DST boundaries), equality with Adhan's Sunrise and all five unchanged prayer times, selected-location midnight, imported Sunrise, invalid/uncovered custom data, row ordering, 12/24-hour formatting, translations, audio and notification exclusion, plus the existing regression suite.
- The focused Sunrise UI test passed: real manual-location onboarding, Sunrise between Fajr and Dhuhr, all five prayer names visible, and exactly five adhan controls. Its screenshot was visually reviewed: the Sunrise clock aligns with the prayer clocks and has no mute ring.
- Full UI suite: 20 test executions passed, 0 failed (the timetable test, launch performance test and 18 launch-configuration executions).
- Universal Release compilation succeeded for arm64 and x86_64. The DMG was verified with `hdiutil verify`; read-only inspection checked the bundle ID/build, absent upstream updater configuration, preserved MIT license and equality of packaged/extracted executable bytes with the local Release build.
- The Release app launched and accepted a manual New York location. UI tests use local ad-hoc signing; the distributed testing app is not Developer ID signed or notarized.
- Initial unsigned XCUITest runner launch failed with signal kill before connecting. An early synthetic dictionary launch fixture also failed to provide a usable location; the final UI test uses the real onboarding flow. These were test setup failures, not hidden passes.
- Existing SwiftUI `onChange`/other SDK deprecation warnings and the benign AppIntents metadata warning remain. No unrelated warning cleanup was attempted.
- No physical Intel execution, macOS 14 hardware run, real wall-clock Sunrise/audio wait, sleep/wake hardware test, or exhaustive visual review of all languages, RTL and accessibility presets was performed. Architecture slices and shared formatting/localization paths were checked; that does not replace those hardware/visual checks.
- Downloads may be blocked by Gatekeeper. No security protection was disabled or quarantine removed. Build from source or wait for an independently signed/notarized release if blocked.

## Modified files

- `.gitignore`, `README.md`
- `Sajda.xcodeproj/project.pbxproj`
- `Sajda.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`
- `Sajda/PrayerTimeViewModel.swift`, `MainView.swift`, `NotificationManager.swift`, `SajdaControlCenterMenu.swift`
- `Sajda/Info.plist`, `UpdateChecker.swift`, `AboutView.swift`, `SettingsView.swift`, `OnboardingView.swift`
- `Sajda/{en,ar,id,es,fr,de,ja,ko,zh-Hans}.lproj/Localizable.strings`
- `SajdaTests/SajdaTests.swift`, `SajdaUITests/SajdaUITests.swift`
- `docs/RELEASE.md`, `docs/SUNRISE_QA.md`
- `scripts/release.sh`, `scripts/release-unsigned.sh`
