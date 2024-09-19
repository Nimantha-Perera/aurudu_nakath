import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'හෙළ GPT - උපදෙස්',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color.fromARGB(221, 122, 122, 122),
                ),
              ),
              SizedBox(height: 10),
              _buildHelpItem(
                context,
                '1. කුමක්ද හෙළ GPT කියන්නේ?',
                'හෙළ GPT යනු විශේෂිත භාෂාවකින් (සිංහලෙන්) පදනම්ව ඇති මැෂින් ලර්නින්‍‌ග් මොඩෙලයක් වෙයි. '
                'ඔබට ඔබේ ප්‍රශ්න සහ ඉල්ලීම්, එමෙන්ම ඕනෑම තොරතුරක් මෙහි ලබා දිය හැක.',
              ),
              _buildHelpItem(
                context,
                '2. මෙය කෙසේ භාවිතා කළ හැකිද?',
                'හෙළ GPT සෘජු ලෙස කථා කිරීම, ප්‍රශ්න කිරීමට, සහ උපදෙස් ලබා ගැනීමට භාවිතා කළ හැක. '
                'ඔබට පණිවිඩයක් යවන්න, සටහන් සකස් කිරීමට, සහ විවිධ වැඩ කටයුතු කරන්න පුළුවන්.',
              ),
              _buildHelpItem(
                context,
                '3. මට කිසිවක් අසන්න පුළුවන්ද?',
                'ඔව් ඔබට ඕනෑම දෙයක් මෙයින් දැනගන්න පුළුවන්. '
                'අවශ්‍යයි නම් ඔබට ගැටළු සහ ප්‍රශ්න ‍යවන්න පුළුවන්. (පෞද්ගලික තොරතුරු හැර)',
              ),
              _buildHelpItem(
                context,
                '4. කතාබහ පිටපත් කරන්නේ කෙසේද?',
                'අදාල පණිවිඩය touch කරගෙන සිටීමෙන් ඔබට අවශ්‍ය කොටස පිටපත් කල හැකිය.',
              ),
              _buildHelpItem(
                context,
                '5. හෙළ GPT මගින් ලබාදෙන ප්‍රතිචාර',
                'හෙළ GPT මඟින් ලබාදෙන සමහර ප්‍රතිචාර 100% ක් නිවැරදි නොවිය හැකිය. '
                'එවැනි ප්‍රතිචාර පිලිබඳව අපව දැනුවත් කරන්න.',
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildHelpItem(BuildContext context, String title, String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: const Color.fromARGB(255, 163, 163, 163)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color.fromARGB(221, 145, 145, 145),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: const Color.fromARGB(137, 165, 165, 165),
          ),
        ),
      ],
    ),
  );
}
