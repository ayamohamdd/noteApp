import 'package:flutter/material.dart';
import 'package:notes_app/data_provider/local/sqflite.dart';

import 'note.dart';

class NoteApp extends StatefulWidget {
  const NoteApp({Key? key}) : super(key: key);

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  Sqflite sqlDb = Sqflite();
  List notesList = [];
  bool isLoading = true;
  myReadData() async {
    List<Map> response = await sqlDb.readData('SELECT * FROM note');
    notesList.addAll(response);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    myReadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note App"),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemBuilder: (context, index) => buildNoteModel(notesList[index]),
              separatorBuilder: (context, index) => const SizedBox(
                height: 15.0,
              ),
              itemCount: notesList.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddNote(
                      isEditing: false,
                      title: "",
                      description: "",
                      color: "",
                      id: 0)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildNoteModel(Map notes) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async {
        int response = await sqlDb
            .deleteData('''DELETE FROM 'note' WHERE id =${notes["id"]}''');
        print(response);
      },
      background: Container(
        color: Colors.redAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Delete Note ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffd8e6f6),
            border: Border.all(color: Colors.transparent, width: 1.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notes["title"],
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        notes["description"],
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        notes["color"],
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNote(
                                isEditing: true,
                                title: notes["title"],
                                description: notes["description"],
                                color: notes["color"],
                                id: notes["id"])));
                  },
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
