import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  bool isFav=false;
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  FocusNode titleFocusNode=FocusNode();
  FocusNode descriptionFocusNode=FocusNode();
  Future<void> addNotes() async{
    await FirebaseFirestore.instance.collection("notes").add({
      "id":FirebaseAuth.instance.currentUser!.uid,
      "title":titleController.text.trim(),
      "description":descriptionController.text.trim(),
      "isFav":"no"
    });
  }
  Future<void> addToFav() async{
    await FirebaseFirestore.instance.collection("notes").add({
      "id":FirebaseAuth.instance.currentUser!.uid,
      "title":titleController.text.trim(),
      "description":descriptionController.text.trim(),
      "isFav":isFav,
    });
  }
  @override
  void dispose() {
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Theme.of(context).colorScheme.tertiary,
        )),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async{
            setState(() {
              isFav=!isFav;
            });
            await addToFav();
            titleFocusNode.unfocus();
            descriptionFocusNode.unfocus();}, icon: Icon(Icons.favorite,color:isFav?Colors.red:Colors.grey)),
          IconButton(onPressed: () async{
            await addNotes();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to notes")));
            titleFocusNode.unfocus();
            descriptionFocusNode.unfocus();}, icon: Icon(Icons.add))
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
}