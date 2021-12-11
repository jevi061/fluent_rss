class ChannelStatus {
  String channelLink;
  int lastCheck;
  int unreadCount;
  int totalCount;
  ChannelStatus(
      {required this.channelLink,
      required this.lastCheck,
      required this.unreadCount,
      required this.totalCount});

  Map<String, dynamic> toMap() {
    return {
      'channelLink': channelLink,
      'lastCheck': lastCheck,
      'unreadCount': unreadCount,
      'totalCount': totalCount
    };
  }

  ChannelStatus.fromMap(Map<String, dynamic> data)
      : channelLink = data['channelLink'],
        lastCheck = data['lastCheck'],
        unreadCount = data['unreadCount'],
        totalCount = data['totalCount'];
}
