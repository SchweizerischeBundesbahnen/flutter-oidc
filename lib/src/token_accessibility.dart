/// The accessibility of stored tokens (iOS only).
///
/// See:
/// - https://developer.apple.com/documentation/security/restricting-keychain-item-accessibility
/// - https://developer.apple.com/documentation/security/item-attribute-keys-and-values?language=objc#Accessibility-Values
enum TokenAccessibility {
  /// Tokens are only accessible when the device is unlocked. A device without
  /// a passcode is considered to always be unlocked. This is the default
  /// accessibility when you don’t otherwise specify a setting.
  whenUnlocked,

  /// Tokens are only accessible when the device is unlocked. A device without
  /// a passcode is considered to always be unlocked.
  ///
  /// Token with this accessibility do not migrate to a new device. Thus, after
  /// restoring from a backup of a different device, these tokens will not be
  /// present.
  whenUnlockedThisDeviceOnly,

  /// This condition becomes true once the user unlocks the device for the
  /// first time after a restart, or if the device does not have a passcode.
  /// It remains true until the device restarts again. Use this level of
  /// accessibility when your app needs to access the tokens while running in
  /// the background.
  afterFirstUnlock,

  /// This condition becomes true once the user unlocks the device for the
  /// first time after a restart, or if the device does not have a passcode.
  /// It remains true until the device restarts again. Use this level of
  /// accessibility when your app needs to access the tokens while running in
  /// the background.
  ///
  /// Token with this accessibility do not migrate to a new device. Thus, after
  /// restoring from a backup of a different device, these tokens will not be
  /// present.
  afterFirstUnlockThisDeviceOnly,
}
