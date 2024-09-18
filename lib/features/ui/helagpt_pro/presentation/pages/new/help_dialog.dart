import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text('හෙළ GPT - උපදෙස්', style: TextStyle(fontSize: 18)),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'හෙළ GPT භාවිතා කරන ආකාරය:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '1. කුමක්ද හෙළ GPT කියන්නෙ?\n'
                'හෙළ GPT යනු විශේෂිත භාෂාවකින් (සිංහලෙන්) පදනම්ව ඇති මැෂින් ලර්නින්‍‌ග් මොඩෙලයක් වෙයි. ඔබට ඔබේ ප්‍රශ්න සහ ඉල්ලීම්, එමෙන්ම ඕනෑම තොරතුරක් මෙහි ලබා දිය හැක.\n\n'
                '2. මෙය කෙසේ භාවිතා කළ හැකිද?\n'
                'හෙළ GPT සෘජු ලෙස කථා කිරීම, ප්‍රශ්න කිරීමට, සහ උපදෙස් ලබා ගැනීමට භාවිතා කළ හැක. ඔබට පණිවිඩයක් යවන්න, සටහන් සකස් කිරීමට, සහ විවිධ වැඩ කටයුතු කරන්න පුළුවන්.\n\n'
                '3. මට කිසිවක් අසන්න පුළුවන්ද?\n'
                'ඔව් ඔබට ඕනෑම දෙයක් මෙයින් දැනගන්න පුලුවන්. අවශ්‍යයි නම් ඔබට ගැටළු සහ ප්‍රශ්න ‍යවන්න පුලුවන්. (පෞද්ගලික තොරතුරු හැර)\n'
                '4. කතාබහ පිටපත් කරන්නේ කෙසේද?\n'
                'අදාල message එක touch කරගෙන සිටීමෙන් ඔබට අවශ්‍ය කොටස පිටපත් කල හැකිය.',

                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    },
  );
}
