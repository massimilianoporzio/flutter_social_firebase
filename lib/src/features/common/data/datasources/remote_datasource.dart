//mapper tra un mappa string,dynamic a uno specifico oggetto (o lista di oggetti)
typedef ObjectMapper<T> = T Function(Map<String, dynamic>? data, {String? id});

//interfaccia per un generico "remote" non necessariamente firebase
abstract class RemoteDataSource {
  //agg un doc a una collezione
  Future<String> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  });
  //Aggiorna un doc dentro un collezione
  Future<void> updateDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  });
  //ritorna una collezione di doc usando il mapper
  Future<List<T>> getCollection<T>({
    required String collectionPath,
    required ObjectMapper<T> objectMapper,
  });
  //ritorna una documento che sta dentro una collezione usando il mapper
  //(ritorna anche null se non trova il doc)
  Future<T?> getDocument<T>({
    required String collectionPath,
    required String documentId,
    required ObjectMapper<T> objectMapper,
  });
  //ritorna uno STREAM di documenti di modo da stare in ascolto per quando
  //un doc viene aggiornato (o cancellato e quindi anche null)
  Stream<T?> streamDocument<T>({
    required String collectionPath,
    required String documentId,
    required ObjectMapper<T> objectMapper,
  });
  //ritorna uno STREAM di una collezioni di modo da stare in ascolto per quando
  //una collezione cambia (agg/rimuovi/modifica documento)
  Stream<List<T>> streamCollection<T>({
    required String collectionPath,
    required ObjectMapper<T> objectMapper,
    String field, //per fare una query su un campo
    dynamic isEqualToValue, //uguale a un certo valore
    dynamic arrayContainsValue, //o se un array contiene un certo valore
  });
}
