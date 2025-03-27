import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'lockedpage.dart';

class Verficationpage extends StatefulWidget {
  const Verficationpage({super.key});

  @override
  State<Verficationpage> createState() => _VerficationpageState();
}

class _VerficationpageState extends State<Verficationpage> {
  TextEditingController passwordController=TextEditingController();
  FocusNode fn=FocusNode();
  bool see=true;
  @override
  void dispose() {
    fn.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('profile').where('id',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (context, snapshot) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(child: Image.asset("assets/padlock.png"),radius: 35,),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  focusNode: fn,
                  decoration: InputDecoration(
                    hintText: "Enter Your Password",
                    hintStyle: TextStyle(
                        fontSize: 16
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1.5
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1.5
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        see=!see;
                      });
                    }, icon: see?Icon(Icons.visibility):Icon(Icons.visibility_off)),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  obscureText: see,
                  cursorColor: Theme.of(context).colorScheme.tertiary,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: () {
                  fn.unfocus();
                  if(passwordController.text.trim()==snapshot.data!.docs[0]['password']){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Lockedpage();}));
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wrong password")));
                  }
                },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        minimumSize: Size(double.infinity , 50 )
                    ),
                    child: Text("Enter",style: TextStyle(fontSize: 16))
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
