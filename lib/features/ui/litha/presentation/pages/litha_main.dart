import 'package:aurudu_nakath/features/ui/litha/data/modal/events_all.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/bloc/aurudu_nakath_bloc.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/pages/widget/calendar_widget.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/pages/widget/kona_masa_widget.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/pages/widget/maru_sitina_disawa_widget.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/pages/widget/rashi_aya_waya.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/pages/widget/sunan_agawatima_widget.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/pages/widget/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LithaMainScreen extends StatefulWidget {
  @override
  _LithaMainScreenState createState() => _LithaMainScreenState();
}

class _LithaMainScreenState extends State<LithaMainScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch the event to load data
    context.read<AuruduNakathBloc>().add(LoadAuruduNakathData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2024 ලිත',style: GoogleFonts.notoSerifSinhala(fontSize: 14.0, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: BlocBuilder<AuruduNakathBloc, AuruduNakathState>(
        builder: (context, state) {
          if (state is AuruduNakathLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AuruduNakathLoaded) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  TimeNow(),
                  
                  CalendarWidget(
                    events: sampleEvents,
                  ),

                  RashiAyaWayaScreen(rashi_aya_waya: state.data.rashi_aya_waya),
                  MaruSitinaDisawaWidget(
                      maruSitinaDisawa: state.data.maruSitinaDisawa),
                  KonaMasaWidget(konaMasa: state.data.konaMasa),
                  SunanAgawatimaWidget(
                      sunanAgawatima: state.data.sunanAgawatima),
                ],
              ),
            );
          } else if (state is AuruduNakathError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
