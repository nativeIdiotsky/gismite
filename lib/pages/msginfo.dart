import 'package:flutter/material.dart';
import 'package:gismite/pages/msginboxalerts.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageInfo extends StatelessWidget {
  const MessageInfo({super.key});

  void _dialEmergencyNumber() async {
    const emergencyNumber = 'tel:911';
    if (await canLaunch(emergencyNumber)) {
      await launch(emergencyNumber);
    } else {
      throw 'Could not launch $emergencyNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Info'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MsgInboxAlerts(),
                ));*/
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Please evacuate as soon as possible to the nearest highland evacuation center!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              color: Colors.grey.shade300, // Placeholder for the image
              child: Center(
                child: Text('Image Placeholder'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  Text(
                    'FLOOD RESCUE SERVICE',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call, color: Colors.red),
                      SizedBox(width: 5),
                      Text(
                        'Phone: (082) 295 2387 Or Call: 911',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Spacer(),
            GestureDetector(
              onTap: _dialEmergencyNumber,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.red,
                child: Icon(Icons.phone, size: 40, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
