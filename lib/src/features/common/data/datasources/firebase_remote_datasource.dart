// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;

import 'package:flutter_social_firebase/src/features/common/data/datasources/remote_datasource.dart';
import 'package:flutter_social_firebase/src/services/service_locator.dart';

class RemoteDataSourceCloudFirestore implements RemoteDataSource {
  final cloud_firestore.FirebaseFirestore _firestore;
  RemoteDataSourceCloudFirestore({cloud_firestore.FirebaseFirestore? firestore})
      : _firestore = firestore ??
            sl<
                cloud_firestore
                    .FirebaseFirestore>(); //se non la passo la inietto
  @override
  Future<String> addDocument(
      {required String collectionPath,
      required Map<String, dynamic> data}) async {
    cloud_firestore.DocumentReference<Map<String, dynamic>> ref;
    ref = await _firestore
        .collection(collectionPath)
        .add(data); //riferimento al doc appena aggiunto (i data)
    return ref.id; //id del doc appena giunto su firestore
  }

  @override
  Future<List<T>> getCollection<T>(
      {required String collectionPath,
      required ObjectMapper<T> objectMapper}) async {
    cloud_firestore.Query<Map<String, dynamic>>
        query; //ogg con il risultato iterrog la collection
    query = _firestore.collection(collectionPath);
    final snapshot = await query.get(); //interroga e dà uno snapshot
    final result = snapshot.docs //tutti i documenti
        .map((doc) => objectMapper(doc.data(), id: doc.id)) // li mappo in ogg
        .where((element) => element != null) //tengo i non null
        .toList();
    return result;
  }

  @override
  Future<T?> getDocument<T>(
      {required String collectionPath,
      required String documentId,
      required ObjectMapper<T> objectMapper}) async {
    cloud_firestore.DocumentReference<Map<String, dynamic>>
        query; //'stavolta è un docRef NON una Query (per le collez)
    query = _firestore.collection(collectionPath).doc(documentId);
    final snapshot = await query.get();
    final result = objectMapper(snapshot.data(),
        id: snapshot.id); //è lo stesso di documentId?
    return result;
  }

  @override
  Stream<T?> streamDocument<T>(
      {required String collectionPath,
      required String documentId,
      required ObjectMapper<T> objectMapper}) {
    cloud_firestore.DocumentReference<Map<String, dynamic>> ref;
    ref = _firestore.collection(collectionPath).doc(documentId);
    final snapshot = ref.snapshots(); //a diff di get() return uno Stream
    final results = snapshot.map((doc) {
      if (doc.data() != null) {
        return objectMapper(doc.data(), id: doc.id);
      } else {
        return null;
      }
    }); //rimappo Stream di Map<String,dynamic> in Stream di T
    return results;
  }

  @override
  Future<void> updateDocument(
      {required String collectionPath,
      required String documentId,
      required Map<String, dynamic> data}) async {
    cloud_firestore.DocumentReference<Map<String, dynamic>> ref;
    ref = _firestore.collection(collectionPath).doc(documentId); //ref al doc
    await ref.update(data);
  }

  @override
  Stream<List<T>> streamCollection<T>({
    required String collectionPath,
    required ObjectMapper<T> objectMapper,
    String? field,
    isEqualToValue,
    arrayContainsValue,
  }) {
    cloud_firestore.Query<Map<String, dynamic>> query;
    query = _firestore.collection(collectionPath);

    if (field != null) {
      query = query.where(
        field,
        isEqualTo: isEqualToValue,
        arrayContains: arrayContainsValue,
      );
    }

    final snapshots = query.snapshots();
    final results = snapshots.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return <T>[];
      } else {
        return snapshot.docs
            .map((doc) => objectMapper(doc.data(), id: doc.id))
            .toList();
      }
    });
    return results;
  }
}
