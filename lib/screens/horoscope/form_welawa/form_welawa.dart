import 'package:flutter/material.dart';

class Form_Welaawa extends StatefulWidget {
  const Form_Welaawa({Key? key}) : super(key: key);

  @override
  State<Form_Welaawa> createState() => _Form_WelaawaState();
}

class _Form_WelaawaState extends State<Form_Welaawa> {
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isMale = false;
  bool isFemale = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welaawa Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'සම්පූර්ණ නම',
                    icon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'උපත් දිස්ත්‍රික්කය',
                    icon: Icon(Icons.location_on),
                  ),
                ),
                
                SizedBox(height: 16.0),
                ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text('Preferred Time'),
                  subtitle: Text('${selectedTime.format(context)}'),
                  onTap: () => _selectTime(context),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isMale,
                      onChanged: (value) {
                        setState(() {
                          isMale = value ?? false;
                          if (isMale) {
                            isFemale = false;
                          }
                        });
                      },
                      checkColor: Colors.blue,
                    ),
                    Text('Male'),
                    SizedBox(width: 16.0),
                    Checkbox(
                      value: isFemale,
                      onChanged: (value) {
                        setState(() {
                          isFemale = value ?? false;
                          if (isFemale) {
                            isMale = false;
                          }
                        });
                      },
                      checkColor: Colors.blue,
                    ),
                    Text('Female'),
                  ],
                ),
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity, // Set the desired width
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle form submission
                      // You can use the selectedTime variable here
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Form_Welaawa(),
  ));
}
