import 'package:aurudu_nakath/features/ui/litha/domain/entities/aurudu_nakath_data.dart';
import 'package:aurudu_nakath/features/ui/litha/domain/usecase/get_aurudu_nakath_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



part 'aurudu_nakath_event.dart';


class AuruduNakathBloc extends Bloc<AuruduNakathEvent, AuruduNakathState> {
  final GetAuruduNakathData getAuruduNakathData;

  AuruduNakathBloc({required this.getAuruduNakathData}) : super(AuruduNakathInitial()) {
    on<LoadAuruduNakathData>((event, emit) async {
      emit(AuruduNakathLoading());
      try {
        final auruduNakathData = await getAuruduNakathData();
        emit(AuruduNakathLoaded(auruduNakathData));
      } catch (e) {
        emit(AuruduNakathError(e.toString()));
      }
    });
  }
}