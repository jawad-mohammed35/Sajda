#!/usr/bin/env bash
# Independent fork: development/testing only; no Developer ID or notarization.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
VERSION="${1:-4.6.5-sunrise.1}"
case "$VERSION" in *[!0-9A-Za-z.-]*|'') echo 'Invalid version' >&2; exit 1;; esac
APP="build/ReleaseDerivedData/Build/Products/Release/Sajda.app"
STAGE="$(mktemp -d "$ROOT/build/unsigned-stage.XXXXXX")"
trap 'rm -rf "$STAGE"' EXIT
xcodebuild -project Sajda.xcodeproj -scheme Sajda -configuration Release \
  -derivedDataPath build/ReleaseDerivedData \
  -clonedSourcePackagesDirPath build/SourcePackages \
  ARCHS='arm64 x86_64' ONLY_ACTIVE_ARCH=NO CODE_SIGNING_ALLOWED=NO build
# Refuse to package an upstream-identified or updater-enabled application.
/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP/Contents/Info.plist" \
  | /usr/bin/grep -qx 'com.jawadmohammed35.SajdaSunrise'
if /usr/libexec/PlistBuddy -c 'Print :SUFeedURL' "$APP/Contents/Info.plist" >/dev/null 2>&1; then
  echo 'Refusing to package an application with an update feed' >&2; exit 1
fi
ARCHITECTURES="$(lipo -archs "$APP/Contents/MacOS/Sajda")"
for architecture in arm64 x86_64; do
  case " $ARCHITECTURES " in
    *" $architecture "*) ;;
    *) echo "Missing architecture: $architecture" >&2; exit 1 ;;
  esac
done
ditto "$APP" "$STAGE/Sajda.app"
cp LICENSE "$STAGE/LICENSE.txt"
cat > "$STAGE/READ-ME.txt" <<'TXT'
Sajda Sunrise — independent fork of https://github.com/ikoshura/Sajda
UNSIGNED DEVELOPMENT/TESTING BUILD — NOT APPLE NOTARIZED.
Sunrise is informational only. Automatic updates are disabled.
Downloaded builds may be blocked by Gatekeeper. Do not disable Gatekeeper or
remove quarantine. Build from source or wait for a signed release if blocked.
Source and build instructions: https://github.com/jawad-mohammed35/Sajda
TXT
ln -s /Applications "$STAGE/Applications"
DMG="build/Sajda-${VERSION}-unsigned.dmg"
hdiutil create -volname 'Sajda Sunrise (Unsigned)' -srcfolder "$STAGE" -ov -format UDZO "$DMG"
hdiutil verify "$DMG"
shasum -a 256 "$DMG"
