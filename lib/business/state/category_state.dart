import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {}

class CategoryReadyState extends CategoryState {
  final List<Object> all;
  CategoryReadyState.ready({required this.all});
  @override
  List<Object?> get props => [all];
}
