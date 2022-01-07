import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {}

class AppStarted extends AppEvent {
  @override
  List<Object?> get props => [];
}
