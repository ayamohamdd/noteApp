import 'package:flutter/material.dart';
import '../data_provider/local/sqflite.dart';
import 'note_app.dart';

class AddNote extends StatefulWidget {
  final bool isEditing;
  final String title;
  final String description;
  final String color;
  final int id;
  const AddNote(
      {super.key,
      required this.isEditing,
      required this.title,
      required this.description,
      required this.color,
      required this.id});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  Sqflite sqlDb = Sqflite();
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController description = TextEditingController();

  TextEditingController title = TextEditingController();

  TextEditingController color = TextEditingController();
  var isEditing = false;
  int? id;
  @override
  void initState() {
    title.text = widget.title;
    description.text = widget.description;
    color.text = widget.color;
    id = widget.id;
    isEditing = widget.isEditing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Note' : "Add Note"),
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
                          color: Colors.blue),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
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
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Title must not be null";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Title",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // Note Text
                    const Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    // Note TextFormField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: description,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Description must not be null";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Description",
                            border: InputBorder.none,
                            //contentPadding: EdgeInsets.symmetric(vertical: 80.0)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    //Color Text
                    const Text(
                      "Color",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    // Color TextFormField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: color,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "color must not be null";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: "Color", border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    // Add Note || Edit Note Btn
                    Container(
                      width: 200.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 1.0),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            int response = isEditing
                                ? await sqlDb.updateData('''
                            UPDATE "note" SET "title" = "${title.text}",
                            "description" = "${description.text}",
                            "color" = "${color.text}"
                            WHERE id = "$id"
                          ''')
                                : await sqlDb.insertData('''
                           INSERT INTO 'note'("title","description","color")
                           VALUES("${title.text}","${description.text}","${color.text}")
                          ''');

                            print(response);
                            if (response > 0) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const NoteApp()),
                                  (route) => false);
                            }
                          }
                        },
                        child: Text(
                          isEditing ? "Edit Note" : "Add Note",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
