# Changelog

## 1.4.6

- Restore consistency between the repository and the npm package. The 1.4.5 npm package included README and podspec changes from local SPM work that were absent from its recorded Git commit. This release uses the CocoaPods-only setup on master; the `$RNStreetViewUseSPMGoogleMaps` flag is not supported. Apps using that flag should remove it and install GoogleMaps through CocoaPods.
- Fix the podspec source tag to match the repository's unprefixed version tags (for example, `1.4.6`).
- Retain the native resource cleanup fixes introduced in 1.4.5.

## 1.4.5

- Release Android Street View resources and clear listeners on unmount.
- Improve iOS Street View cleanup on removal to avoid crashes from in-flight GoogleMaps requests.
