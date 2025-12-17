part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<WeatherData> weatherHistory;
  final List<DayData> dayHistory;
  final List<String> calculationsHistory;

  const HistoryLoaded({
    required this.weatherHistory,
    required this.dayHistory,
    required this.calculationsHistory,
  });

  @override
  List<Object> get props => [weatherHistory, dayHistory, calculationsHistory];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}