import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:step/palette.dart';
import 'package:step/services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final data = await getNotifications();
    setState(() {
      notifications = data['notifications'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await readNotification(); // call read() function here
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          elevation: 0,
          foregroundColor: Palette.kToDark,
        ),
        body: RefreshIndicator(
          onRefresh: _loadNotifications,
          child: notifications.isEmpty
              ? ListView(
                  // Use ListView here to ensure scrolling
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No notifications',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    final notification = notifications[index];
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Container(
                          width: 40, // Adjust size as needed
                          height: 40,
                          decoration: BoxDecoration(
                            color: Palette
                                .kToDark, // Change background color as needed
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 24, // Adjust to fit nicely within the circle
                          ),
                        ),

                        title: Text(
                          notification['data']['type'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['data']['title']?.replaceAll(
                                RegExp('<p>|</p>|<br>'),
                                '',
                              ),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Due on ${DateFormat.yMMMMd().format(DateTime.parse(notification['data']['due_date']))}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
