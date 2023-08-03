import 'dart:async';

import 'package:flutter_social_firebase/src/features/theme/data/datasources/theme_local_datasource.dart';

import 'package:flutter_social_firebase/src/features/theme/domain/entities/custom_theme.dart';
import 'package:flutter_social_firebase/src/features/theme/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDatasource localDatasource;

  final _controller = StreamController<CustomTheme>();

  static const _kThemePersistenceKey = '__theme_persistence_key__';
  ThemeRepositoryImpl({required this.localDatasource}) {
    _init();
  }
  @override
  Stream<CustomTheme> get currentThemeStream async* {
    yield* _controller.stream;
  }

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Future<void> saveTheme(CustomTheme theme) async {
    _controller.add(theme); //lo metto in stream
    localDatasource.setValue(_kThemePersistenceKey, theme.name);
  }

  void _init() {
    final themeString = localDatasource.getValue(_kThemePersistenceKey);
    if (themeString != null) {
      if (themeString == CustomTheme.light.name) {
        _controller.add(CustomTheme.light);
      } else {
        _controller.add(CustomTheme.dark);
      }
    } else {
      //esco di default con light
      _controller.add(CustomTheme.light);
    }
  }
}
