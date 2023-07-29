import 'package:loggy/loggy.dart';

mixin UsecaseLoggy implements LoggyType {
  @override
  Loggy<UsecaseLoggy> get loggy =>
      Loggy<UsecaseLoggy>('Usecase Loggy - $runtimeType');
}
