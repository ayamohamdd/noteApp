import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/data_provider/local/sqldb.dart';
import 'package:notes_app/modules/notes.dart';

class AddNote extends StatefulWidget {
  bool? flag;
  final note;
  final title;
  //final color;
  int id;
  AddNote({
    super.key,
    required this.id,
    required this.title,
    required this.note,
   // required this.color,
    required this.flag});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  SqlDB sqlDb = SqlDB();

  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController note = TextEditingController();

  TextEditingController title = TextEditingController();

  TextEditingController color = TextEditingController();

  var flag;
  @override
  void initState() {
    note.text = widget.note;
    title.text = widget.title;
    //color.text = widget.color;
    flag = widget.flag;
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: flag? Text('Edit Note'):Text('Add Note'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Title Text
                  const Text(
                      "Title",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  // Title TextFormField
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: title,
                        decoration: const InputDecoration(
                          hintText: "Title",
                          border: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  // Note Text
                  const Text(
                    "Note",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  // Note TextFormField
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.0,
                          color: Colors.grey
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        controller: note,
                        decoration: const InputDecoration(
                            hintText: "Note",
                            border: InputBorder.none,
                          //contentPadding: EdgeInsets.symmetric(vertical: 80.0)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  // Color Text
                  // const Text(
                  //   "Color",
                  //   style: TextStyle(
                  //       fontSize: 20.0,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.blue
                  //   ),
                  // ),
                  // const SizedBox(height: 10.0,),
                  // // Color TextFormField
                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //         width: 1.0,
                  //         color: Colors.grey
                  //     ),
                  //     borderRadius: BorderRadius.circular(15.0),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: TextFormField(
                  //       controller: color,
                  //       decoration: const InputDecoration(
                  //           hintText: "Color",
                  //           border: InputBorder.none
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 80.0,),
                  // Add Note || Edit Note Btn
                  Container(
                    width: 200.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                        width: 1.0
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () async{
                        int response = flag ?
                       //  await sqlDb.updateData('''
                       //  UPDATE "notes" SET "note" = "${note.text}",
                       //  "title" = "${title.text}" ,"color" = "${color.text}"
                       //  WHERE "id"= ${widget.id}
                       // '''):
                        // Shortcut Update
                        await sqlDb.update("notes",
                            {
                              "title" : title.text,
                              "note" : note.text,
                              //"color" : color.text
                            },
                          "id = ${widget.id}"
                        ) :
                        // await sqlDb.insertData('''
                        // INSERT INTO 'notes' ("title","note","color")
                        // VALUES  ("${title.text}","${note.text}","${color.text}")
                        // ''');
                        // Shortcut Insert
                        await sqlDb.insert("notes", {
                          "title" : title.text,
                          "note" : note.text,
                          //"color" : color.text
                        });
                        if(response>0){
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context)=>NotesApp()),
                                  (route) => false);
                        }
                      },
                      child: flag? const Text("Edit Note",style: TextStyle(color: Colors.white)):const Text("Add Note",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
