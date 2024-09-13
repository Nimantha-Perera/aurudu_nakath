part of 'aurudu_nakath_bloc.dart';

abstract class AuruduNakathEvent {}

class LoadAuruduNakathData extends AuruduNakathEvent {}

// lib/presentation/bloc/aurudu_nakath_state.dart


abstract class AuruduNakathState {}

class AuruduNakathInitial extends AuruduNakathState {}

class AuruduNakathLoading extends AuruduNakathState {}

class AuruduNakathLoaded extends AuruduNakathState {
  final AuruduNakathData data;

  AuruduNakathLoaded(this.data);
}

class AuruduNakathError extends AuruduNakathState {
  final String message;

  AuruduNakathError(this.message);
}