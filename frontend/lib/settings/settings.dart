import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool eventsNotification = false;
  bool newsNotification = false;
  int remindersFrequency = 0 ; // 0 represents "Never"
  bool chatNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications settings'),
      ),
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 290.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListView(
              children: [
                SizedBox(height: 20),
                Center(
                  child: ListTile(
                    leading: Image.asset('images/eventC.png',  width: 40, height: 30,),
                    title: Text(
                      'Events',
                      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 89, 87, 87)),
                    ),
                    trailing: Switch(
                      value: eventsNotification,
                      onChanged: (value) {
                        setState(() {
                          eventsNotification = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(),
                Center(
                  child: ListTile(
                    leading: Image.asset('images/notification.png',  width: 40, height: 30,),
                    title: Text(
                      'News ',
                      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 89, 87, 87)),
                    ),
                    trailing: Switch(
                      value: newsNotification,
                      onChanged: (value) {
                        setState(() {
                          newsNotification = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(),
                Center(
                  child: ListTile(
                    leading: Image.asset('images/alarm-clock.png',  width: 40, height: 30,),
                    title: Text(
                      'Reminders Frequency',
                      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 89, 87, 87)),
                    ),
                    subtitle: Text(
                      _getFrequencyText(),
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showFrequencyDialog();
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '      Professional Users',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
          Container(
          width: double.infinity,
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: ListTile(
              leading: Image.asset('images/chat.png', width: 40, height: 30),
              title: Text(
                'Chat ',                
                style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 89, 87, 87)),
              ),
              trailing: Switch(
                value: chatNotification,
                onChanged: (value) {
                  setState(() {
                    chatNotification = value;
                  });
                },
              ),
            ),
          ),
        ),
          
        ],
      ),
    );
  }

  String _getFrequencyText() {
    if (remindersFrequency == 0) {
      return 'Never';
    } else {
      return remindersFrequency.toString();
    }
  }

  void _showFrequencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Frequency'),
          backgroundColor: Color.fromARGB(255, 240, 240, 240), // Set the background color to grey
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: const Color.fromARGB(255, 190, 190, 190)), // Set the border color to grey
      ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<int>(
                title: Text('Never'),
                value: 0,
                groupValue: remindersFrequency,
                onChanged: (int? value) {
                  setState(() {
                    remindersFrequency = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<int>(
                title: Text('1 per day'),
                value: 1,
                groupValue: remindersFrequency,
                onChanged: (int? value) {
                  setState(() {
                    remindersFrequency = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<int>(
                title: Text('2 per day'),
                value: 2,
                groupValue: remindersFrequency,
                onChanged: (int? value) {
                  setState(() {
                    remindersFrequency = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<int>(
                title: Text('3 per day'),
                value: 3,
                groupValue: remindersFrequency,
                onChanged: (int? value) {
                  setState(() {
                    remindersFrequency = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<int>(
                title: Text('4 per day'),
                value: 4,
                groupValue: remindersFrequency,
                onChanged: (int? value) {
                  setState(() {
                    remindersFrequency = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}