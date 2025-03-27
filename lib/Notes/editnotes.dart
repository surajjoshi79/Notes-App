import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Editnotes extends StatefulWidget {
  String id="";
  Editnotes({super.key, required this.id});

  @override
  State<Editnotes> createState() => _EditnotesState(id: id);
}

class _EditnotesState extends State<Editnotes> {
  String id="";
  _EditnotesState({required this.id});
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  FocusNode titleFocusNode=FocusNode();
  FocusNode descriptionFocusNode=FocusNode();
  final CollectionReference notes=FirebaseFirestore.instance.collection("notes");
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: notes.doc(id).get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Scaffold(
                appBar: AppBar(
                  title: Text("Edit Notes",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.tertiary,
                  )),
                  centerTitle: true,
                  actions: [
                    IconButton(onPressed: () async{
                      notes.doc(id).update({
                        'title':titleController.text.trim(),
                        'description':descriptionController.text.trim(),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Edit done")));
                      titleFocusNode.unfocus();
                      descriptionFocusNode.unfocus();}, icon: Icon(Icons.done))
                  ],
                ),
              body:Center(child: SpinKitDancingSquare(color: Theme.of(context).colorScheme.secondary))
            );
          }
          if(snapshot.hasData) {
            titleController.text = snapshot.data!['title'];
            descriptionController.text = snapshot.data!['description'];
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Edit Notes",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.tertiary,
              )),
              centerTitle: true,
              actions: [
                IconButton(onPressed: () async{
                  notes.doc(id).update({
                    'title':titleController.text.trim(),
                    'description':descriptionController.text.trim(),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Edit done")));
                  titleFocusNode.unfocus();
                  descriptionFocusNode.unfocus();}, icon: Icon(Icons.done))
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: titleController,
                    focusNode: titleFocusNode,
                    decoration:InputDecoration(
                      label: Text("Title"),
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary
                          )
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: Theme.of(context).colorScheme.tertiary,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 40,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,right: 10,bottom: 5),
                    child: TextField(
                      controller: descriptionController,
                      focusNode: descriptionFocusNode,
                      decoration:InputDecoration(
                        label: Text("Description"),
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary
                            )
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      cursorColor: Theme.of(context).colorScheme.tertiary,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}
