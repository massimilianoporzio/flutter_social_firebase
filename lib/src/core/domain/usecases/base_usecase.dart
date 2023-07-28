import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

abstract class Params extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoParams extends Params {}
