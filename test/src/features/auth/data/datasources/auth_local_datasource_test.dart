import 'package:flutter_social_firebase/src/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthLocalDatasource authLocalDatasource;
  setUp(() {
    authLocalDatasource = AuthLocalDatasource();
  });
  group('AuthLocalDatasource', () {
    group('Write', () {
//testo che se scrivo dentro un certo valore allora quando leggo lo devo trovare
      test('should write a non-null value to the data source', () {
        const key = "test_key";
        const value = "test_value";
        //chiamo il metodo che sto testando
        authLocalDatasource.write(key: key, value: value);
        //verifico che abbia scritto
        expect(authLocalDatasource.read(key: key), equals(value));
      });
      test('should write a null value to the data source', () {
        const key = "test_key";
        const value = null;
        //chiamo il metodo che sto testando
        authLocalDatasource.write(key: key, value: value);
        //verifico che abbia scritto
        expect(authLocalDatasource.read(key: key), isNull);
      });
      //testo che SOVRASCRIVA
      test('should overwrite a value in the data source', () {
        const key = "test_key";
        const initialValue = "InitialValue";
        const newValue = "new_value";

        //metto dentro il primo valore iniziale
        authLocalDatasource.write(key: key, value: initialValue);
        //ora con stessa chiave ci metto il nuovo valore
        authLocalDatasource.write(key: key, value: newValue);
        //verifico
        expect(authLocalDatasource.read(key: key), newValue);
      });
    });
    group('Read', () {
      test('should READ a value FROM the data source', () {
        const key = "test_key";

        const value = "test_value";

        //metto dentro valore
        authLocalDatasource.write(key: key, value: value);
        //chiamo il metodo
        final result = authLocalDatasource.read(key: key);
        //verifico
        expect(result, equals(value));
      });
      test('should return null if no value is found for the key', () {
        const key = 'non_existing_key';
        final result = authLocalDatasource.read(key: key);
        expect(result, isNull);
      });
      test('should return null if value is  not of type T', () {
        const key = 'test_key';
        const value = 123;
        authLocalDatasource.write<int>(key: key, value: value);
        //in datasource CI HO MESSO IO UN NUMERO
        //ora chiamo il metodo READ aspettandomi una stringa
        final result = authLocalDatasource.read<String>(key: key);
        //verifico sia null
        expect(result, isNull);
      });
    });
  });
}
