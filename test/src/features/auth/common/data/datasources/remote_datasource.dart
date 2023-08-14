//GENERIC MAPPER
//parte da una mappa ed eventualemte un ID (singolo doc)
//e restituisce l'OGGETTO
typedef ObjectMapper<T> = T Function(Map<String, dynamic>? data, {String? id});

abstract class RemoteDataSource {
  //INSERT
  Future<String> addDocument({
    required String collectionPath, //sotto quale label metto i dati
    required Map<String, dynamic> data, //i dati
  });
  Future<void> updateDocument({
    required String collectionPath,
    required String documentId, //l'id del documento che voglio agg
    required Map<String, dynamic> data,
  });
  //ottengo la lista di ogg passando la label sotto cui sono salvati
  //E la funzione che me li mappa
  Future<List<T>> getCollection<T>({
    required String collectionPath,
    required ObjectMapper<T> objectMapper,
  });
  //OTTENGO l'OGGETTO dando la collection , l'id dell'oggetto
  //E come mapparlo da una generica mappa all'oggeto richiesto
  Future<T?> getDocument<T>({
    required String collectionPath,
    required String documentId,
    required ObjectMapper<T> objectMapper,
  });
  //OTTENGO UNO STREAM CHE POSSO ASCOLTARE e ogni volta che QUEL
  //DOCUMENTO cambia ricevo il nuovo valore sullo stream
  Stream<T?> streamDocument<T>({
    required String collectionPath,
    required String documentId,
    required ObjectMapper<T> objectMapper,
  });
  //Ottengo uno STREAM di oggetti di una collezione e ogni volta che QUELLA
  //Collezione cambia ricevo la nuova lista di oggetti sullo stream
  Stream<List<T>> streamCollection<T>({
    required String collectionPath,
    required ObjectMapper<T> objectMapper,
    required String field, //per fare query e ascoltare
    dynamic isEqualToValue, //per fare query
    dynamic arrayContainsValue, // per fare query
  });
}
