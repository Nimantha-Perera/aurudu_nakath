import 'package:aurudu_nakath/features/ui/lagna_palapala/data/repositories/lagna_palapala_repository.dart';
import 'package:aurudu_nakath/features/ui/lagna_palapala/domain/lagna_palapala_model.dart';
import 'package:aurudu_nakath/features/ui/lagna_palapala/presentation/bloc/lagna_palapala_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
class LagnaPalapala extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LagnaPalapalaCubit(LagnaPalapalaRepository())..fetchLagnaPalapala(),
      child: WillPopScope(
        onWillPop: () async {
          // Handle back button logic here
          return true; // Return true to allow the back navigation
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text('ලග්න පලාඵල', style: GoogleFonts.notoSerifSinhala(fontSize: 14)),
          ),
          body: BlocBuilder<LagnaPalapalaCubit, List<LagnaPalapalaModel>>(
            builder: (context, lagnaPalapalaList) {
              if (lagnaPalapalaList.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: lagnaPalapalaList.length,
                itemBuilder: (context, index) {
                  final item = lagnaPalapalaList[index];
                  final hexColor = item.color.startsWith("#") ? item.color.substring(1) : item.color;
                  final colorValue = int.parse('FF' + hexColor, radix: 16);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black38,
                                backgroundImage: NetworkImage(item.imageUrl),
                              ),
                              title: Text(
                                item.name,
                                style: GoogleFonts.notoSerifSinhala(fontSize: 14, color: Colors.white),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'අය ${item.aya} ',
                                    style: GoogleFonts.notoSerifSinhala(fontSize: 12, color: Colors.white70),
                                  ),
                                  Text(
                                    'වැය ${item.waya} ',
                                    style: GoogleFonts.notoSerifSinhala(fontSize: 12, color: Colors.white70),
                                  ),
                                  Text(
                                    'වර්ණය ',
                                    style: GoogleFonts.notoSerifSinhala(fontSize: 12, color: Colors.white70),
                                  ),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(colorValue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListTile(
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 30, bottom: 30),
                              child: Text(
                                item.message,
                                style: GoogleFonts.notoSerifSinhala(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
