import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'service/firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController textctrl = TextEditingController();
  final FirestoreServices firestoreServices = FirestoreServices();

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: TextField(
          controller: textctrl,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreServices.addNotes(textctrl.text);
              } else {
                firestoreServices.updateNotes(textctrl.text, docID);
              }
              textctrl.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Notes',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openNoteBox();
        },
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreServices.getnotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List noteslist = snapshot.data!.docs;
            return ListView.builder(
                itemCount: noteslist.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = noteslist[index];
                  String docID = doc.id;

                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  String noteText = data['note'];

                  return ListTile(
                    shape: CircleBorder(),
                    hoverColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        openNoteBox(docID: docID);
                      },
                    ),
                    title: Text(
                      noteText,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        firestoreServices.deleteNotes(docID);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  );
                });
          } else {
            return Text('NO NOTES!!!!!!');
          }
        },
      ),
    );
  }
}
