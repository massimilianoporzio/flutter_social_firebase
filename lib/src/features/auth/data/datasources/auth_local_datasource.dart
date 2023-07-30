// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthLocalDatasource {
  //tiene una mappa chiave valore
  final Map<String, Object?> authLocalDatasource;
  //quando costruisco la local data source inizializzo con mappa vuota
  AuthLocalDatasource() : authLocalDatasource = <String, Object?>{};

  //metodo per scrivere dentro la mappa
  void write<T extends Object?>({required String key, T? value}) {
    authLocalDatasource[key] = value;
  }

  T? read<T extends Object?>({required String key}) {
    final value = authLocalDatasource[key];
    if (value is T) return value;
    return null;
  }
}
