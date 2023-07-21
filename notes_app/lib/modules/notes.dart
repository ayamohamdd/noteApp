import 'package:flutter/material.dart';
import 'package:notes_app/data_provider/local/sqldb.dart';
import 'package:notes_app/modules/note.dart';

class NotesApp extends StatefulWidget {
  const NotesApp({Key? key}) : super(key: key);
  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  bool flag = true;
  bool isLoading = true;
  SqlDB sqlDb = SqlDB();
  List notes = [];

  readData() async{
   //List<Map> response = await sqlDb.readData("SELECT * FROM notes");
    // Shortcut
    List<Map> response = await sqlDb.read("notes");
   notes.addAll(response);
   isLoading = false;
   setState(() {});
  }

  @override
  void initState() {
    readData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes App"),
        elevation: 0,
      ),
      body: isLoading?
          const Center(child: CircularProgressIndicator())
      : Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
             ListView.separated(
                  itemCount: notes.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context,index) => buildNoteModel(notes[index]),
                  separatorBuilder: (context,index)=>const SizedBox(height: 20.0,),
             ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>AddNote(
                flag: false,
                note: "",
                title: "",
               // color: "",
                id: 0,)));
        },
        child: const Icon(Icons.add),
      ),

    );
  }
  Widget buildNoteModel(Map notes){
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async{
        // int response = await sqlDb.deleteData('''DELETE FROM "notes" WHERE id =${notes["id"]} ''');

        // Shortcut
        int response = await sqlDb.myDelete("notes",
        "id = ${notes["id"]}"
        );
        print(response);
      },
      background: Container(
        color: Colors.redAccent,
        child: const Center(
          child: Text(
            "Delete Note 😒",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration:  BoxDecoration(
            color: const Color(0xffd8e6f6),
            border: Border.all(color: Colors.transparent,width: 1.0),
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
                      SizedBox(height: 10.0,),
                      Text(
                          notes["note"],
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),),
                      SizedBox(height: 8.0,),
                      // Text(notes["color"],
                      //   style: const TextStyle(
                      //     fontSize: 16.0,
                      //   ),
                      // ),

                    ],
                  ),
                ),
                // Edit
                IconButton(
                    onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>AddNote(
                        flag: true,
                      note: notes["note"],
                      title: notes["title"],
                      //color: notes["color"],
                      id:notes["id"],)));},
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


