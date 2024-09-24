import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: _buildContent(context),
                ),
              ],
            ),
          ),
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
  );
}

Widget _buildHeader(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'හෙළ GPT - උපදෙස්',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 121, 121, 121),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close,
              color: const Color.fromARGB(255, 124, 124, 124)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

Widget _buildContent(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16),
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(20),
    ),
    child: ListView(
      children: [
        _buildHelpItem(
          context,
          '1. කුමක්ද හෙළ GPT PRO කියන්නේ?',
          'හෙළ GPT යනු විශේෂිත භාෂාවකින් (සිංහලෙන්) පදනම්ව ඇති මැෂින් ලර්නින්‍‌ග් මොඩෙලයක් වෙයි. '
              'ඔබට ඔබේ ප්‍රශ්න සහ ඉල්ලීම්, එමෙන්ම ඕනෑම තොරතුරක් මෙහි ලබා දිය හැක.',
          Icons.lightbulb_outline,
        ),
        _buildHelpItem(
          context,
          '2. මෙය කෙසේ භාවිතා කළ හැකිද?',
          'හෙළ GPT PRO වැඩු දියුනු කල අකෘතියෙන් සෘජු ලෙස කථා කිරීම, ප්‍රශ්න කිරීමට, සහ උපදෙස් ලබා ගැනීමට භාවිතා කළ හැක. '
              'ඔබට පණිවිඩයක් යවන්න, සටහන් සකස් කිරීමට, සහ විවිධ වැඩ කටයුතු කරන්න පුළුවන්.',
          Icons.chat_bubble_outline,
        ),
        _buildHelpItem(
          context,
          '3. ජායාරූප භාවිතයෙන් ප්‍රශ්න අහන්නෙ කොහොමද?',
          'ඔබගේ අවශ්‍ය ජායාරූපය උඩුගත කිරීමෙන් අනතුරුව අකුරු ඇතුලත් කිරීමේ තීරුවේ ඔබට ජායාරූප මගින් දැන ගැනීමට අවශ්‍ය දේ ලියන්න. ජායාරූපය කෙලින්ම ඔබට Chat එකේ දැකිය නොහැක නමුත් ඔබ ඇතුලත් කල දේ අනුව ප්‍රතිචාරය ලබාදේ (අවවාදයයි. අසභ්‍ය සහ යම් කෙනෙකුට අපහාසයක් වන ජායාරූප, පෞද්ගලික දත්ත ඇතුලත් ජායාරූප ඇතුලත් කිරීමෙන් වලකින්න.)',
          Icons.chat_bubble_outline,
        ),
        _buildHelpItem(
          context,
          '4. මට කිසිවක් අසන්න පුළුවන්ද?',
          'ඔව් ඔබට ඕනෑම දෙයක් මෙයින් දැනගන්න පුළුවන්. '
              'අවශ්‍යයි නම් ඔබට ගැටළු සහ ප්‍රශ්න ‍යවන්න පුළුවන්. (පෞද්ගලික තොරතුරු හැර)',
          Icons.question_answer,
        ),
        _buildHelpItem(
          context,
          '5. කතාබහ පිටපත් කරන්නේ කෙසේද?',
          'අදාල පණිවිඩය touch කරගෙන සිටීමෙන් ඔබට අවශ්‍ය කොටස පිටපත් කල හැකිය.',
          Icons.content_copy,
        ),
        _buildHelpItem(
          context,
          '6. හෙළ GPT මගින් ලබාදෙන ප්‍රතිචාර',
          'හෙළ GPT මඟින් ලබාදෙන සමහර ප්‍රතිචාර 100% ක් නිවැරදි නොවිය හැකිය. '
              'එවැනි ප්‍රතිචාර පිලිබඳව අපව දැනුවත් කරන්න.',
          Icons.info_outline,
        ),
      ],
    ),
  );
}

Widget _buildHelpItem(
    BuildContext context, String title, String content, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 223, 219, 31),
                ),
              ),
            ),
            Icon(icon, color: Color.fromARGB(255, 223, 219, 31), size: 28),
          ],
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}
