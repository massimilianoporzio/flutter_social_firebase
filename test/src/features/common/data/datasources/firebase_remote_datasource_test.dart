import 'package:flutter_social_firebase/src/features/common/data/datasources/firebase_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:mockito/mockito.dart';

import 'firebase_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<cloud_firestore.FirebaseFirestore>(),
  MockSpec<cloud_firestore.CollectionReference>(),
  MockSpec<cloud_firestore.DocumentReference>(),
  MockSpec<cloud_firestore.DocumentSnapshot>(),
  MockSpec<cloud_firestore.Query>(),
  MockSpec<cloud_firestore.QuerySnapshot>(),
])
@GenerateMocks([], customMocks: [
  MockSpec<cloud_firestore.QueryDocumentSnapshot<Map<String, dynamic>>>(
    as: #MockQueryDocumentSnapshot,
  )
])
void main() {
  late RemoteDataSourceCloudFirestore remoteDataSource;
  late cloud_firestore.FirebaseFirestore mockFirestore;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    remoteDataSource = RemoteDataSourceCloudFirestore(firestore: mockFirestore);
  });
  test('getCollection returns a list of data list when collection is not empty',
      () async {
    const collectionPath = 'collectionPath';
    // Mock the collection method to return a dummy collection
    final collection = MockCollectionReference<Map<String, dynamic>>();
    when(mockFirestore.collection(collectionPath)).thenReturn(collection);

    // Mock the get method to return a dummy snapshot
    final snapshot = MockQuerySnapshot<Map<String, dynamic>>();
    when(collection.get()).thenAnswer((_) async => snapshot);

    // Create a list of mock document snapshots
    int numberOfDocuments = 2;
    List<MockQueryDocumentSnapshot> docs =
        List.generate(numberOfDocuments, (_) => MockQueryDocumentSnapshot());

    when(snapshot.docs).thenReturn(docs);

    // Generate data and id for each document
    List<Map<String, dynamic>> dataList = [];
    for (var i = 0; i < numberOfDocuments; i++) {
      final data = {'key': 'value$i'};
      dataList.add(data);
      when(docs[i].data()).thenReturn(data);
      when(docs[i].id).thenReturn(i.toString());
    }

    // Call the method to test
    final result = await remoteDataSource.getCollection<Map<String, dynamic>>(
      collectionPath: collectionPath,
      objectMapper: (data, {id}) => data!,
    );

    // Verify the result
    expect(
        result,
        equals([
          {'key': 'value0'},
          {'key': 'value1'}
        ]));
  });

  test('getDocument ...', () async {
    const collectionPath = 'collectionPath';
    const documentId = 'documentId';

    // Mock the collection method to return a dummy collection
    final collection = MockCollectionReference<Map<String, dynamic>>();
    when(mockFirestore.collection(collectionPath)).thenReturn(collection);

    // Mock the doc method to return a dummy document
    final document = MockDocumentReference<Map<String, dynamic>>();
    when(collection.doc(documentId)).thenReturn(document);

    // Mock the get method to return a dummy document snapshot
    final snapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    when(document.get()).thenAnswer((_) async => snapshot);

    // Mock the data method to return a dummy map
    final data = {'key': 'value'};
    when(snapshot.data()).thenReturn(data);

    // Mock the id property to return a dummy id
    when(snapshot.id).thenReturn(documentId);

    // Call the method to test
    final result = await remoteDataSource.getDocument<Map<String, dynamic>>(
      collectionPath: collectionPath,
      documentId: documentId,
      objectMapper: (data, {id}) => data!,
    );

    // Verify the result
    expect(result, equals({'key': 'value'}));
  });
}
