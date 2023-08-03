import 'package:flutter/material.dart';
import 'package:flutter_social_firebase/src/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_local_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final mockPrefs = MockSharedPreferences();
  late ThemeLocalDatasource localDatasource;
  late ThemeLocalDatasource mocklocalDatasource;

  setUp(() {
    localDatasource = ThemeLocalDatasource(prefs: prefs);
    mocklocalDatasource = ThemeLocalDatasource(prefs: mockPrefs);
  });
  group('ThemeLocalDatasource', () {
    group('Write', () {
      test('should throw an expetion if sharedPrefs cannot write', () async {
        when(mockPrefs.setString(any, any))
            .thenAnswer((_) => Future.value(false));
        const key = "test_key";
        const value = "test_value";
        expect(() => mocklocalDatasource.setValue(key, value), throwsException);
      });

      test('should  write a non-null value to the data source', () {
        const key = "test_key";
        const value = "test_value";
        // when(prefs.setString(any, any)).thenAnswer((_) => Future.value(true));
        // when(prefs.getString(any)).thenReturn(value);
        localDatasource.setValue(key, value);
        expect(localDatasource.getValue(key), equals(value));
      });
      test('should  over-write a non-null value to the data source', () {
        const key = "test_key";
        const initialValue = "test_value";
        const newValue = "newValue";
        localDatasource.setValue(key, initialValue);
        localDatasource.setValue(key, newValue);
        expect(localDatasource.getValue(key), equals(newValue));
      });
    });
    group('Read', () {
      test('should READ a value FROM the data source', () {
        const key = "test_key";

        const value = "test_value";

        //metto dentro valore
        localDatasource.setValue(key, value);
        //chiamo il metodo
        final result = localDatasource.getValue(key);
        //verifico
        expect(result, equals(value));
      });
      test('should return null if no value is found for the key', () {
        const key = 'non_existing_key';
        final result = localDatasource.getValue(key);
        expect(result, isNull);
      });
    });
  });
}
