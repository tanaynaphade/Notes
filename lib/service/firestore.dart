import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  //get collection
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('Notes');

  //create
  Future<void> addNotes(String note){
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  //read
  Stream<QuerySnapshot> getnotes(){
    final noteStream = notes.orderBy('timestamp',descending: true).snapshots();
    return noteStream;
  }

  //update
  Future<void> updateNotes(String new_note,String docID){
    return notes.doc(docID).update({
      'note': new_note,
      'timestamp': Timestamp.now(),
    });
  }

  //delete
  Future<void> deleteNotes(String docID){
    return notes.doc(docID).delete();
  }
}
