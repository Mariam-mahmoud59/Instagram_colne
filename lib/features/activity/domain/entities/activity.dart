class Activity {
  final String avatar;
  final String username;
  final String action;
  final String time;
  final String? thumbnail;
  final String? button;
  final bool reply;
  final String section;

  Activity({
    required this.avatar,
    required this.username,
    required this.action,
    required this.time,
    this.thumbnail,
    this.button,
    this.reply = false,
    required this.section,
  });
}
