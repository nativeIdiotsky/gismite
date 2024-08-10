import 'package:flutter/material.dart';
import 'package:gismite/pages/map_page.dart';
import 'msginfo.dart';

class MsgInboxAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        children: [
          buildAlertTile(
              context: context,
              icon: Icons.notifications,
              message: 'Water level sudden change.',
              backgroundColor: Colors.blue,
              navToWaterLvlAndGIS: true),
          buildAlertTile(
            context: context,
            icon: Icons.warning,
            message: 'Critical water level in Jade Valley river.',
            backgroundColor: Colors.red,
            navigateToMsgInfo: true,
          ),
          buildAlertTile(
              context: context,
              icon: Icons.notifications,
              message: 'Water level sudden change.',
              backgroundColor: Colors.blue,
              navToWaterLvlAndGIS: true),
          buildAlertTile(
            context: context,
            icon: Icons.warning,
            message: 'Maximum water level in Jade Valley river.',
            backgroundColor: Colors.orange,
            navigateToMsgInfo: true,
          ),
          buildAlertTile(
              context: context,
              icon: Icons.notifications,
              message: 'Water level sudden change.',
              backgroundColor: Colors.blue,
              navToWaterLvlAndGIS: true),
          buildAlertTile(
            context: context,
            icon: Icons.warning,
            message: 'Above normal water level in Jade Valley river.',
            backgroundColor: Colors.yellow,
            navigateToMsgInfo: true,
          ),
          buildAlertTile(
            context: context,
            icon: Icons.notifications,
            message: 'Water level sudden change.',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget buildAlertTile({
    required BuildContext context,
    required IconData icon,
    required String message,
    required Color backgroundColor,
    bool navigateToMsgInfo = false,
    bool navToWaterLvlAndGIS = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (navigateToMsgInfo) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MessageInfo()),
          );
        } else if (navToWaterLvlAndGIS) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapPage()),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black26),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
