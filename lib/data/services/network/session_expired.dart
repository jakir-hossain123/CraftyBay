class SessionExpired {
  SessionExpired._();

  static Future<void> Function()? onExpired;

  static Future<void> notify() async {
    await onExpired?.call();
  }
}
