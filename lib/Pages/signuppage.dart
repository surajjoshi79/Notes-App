import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Pages/loginpage.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  TextEditingController fullNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  FocusNode fn1=FocusNode();
  FocusNode fn2=FocusNode();
  FocusNode fn3=FocusNode();
  bool see=true;
  Future<void> addUser() async{
    UserCredential userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim() ,
        password: passwordController.text.trim()
    );
    await FirebaseFirestore.instance.collection('profile').doc(userCredential.user!.uid).set({
      'id':FirebaseAuth.instance.currentUser!.uid,
      'name':fullNameController.text.trim(),
      'email':emailController.text.trim(),
      'password':passwordController.text.trim()
    });
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fn1.dispose();
    fn2.dispose();
    fullNameController.dispose();
    fn3.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          body:Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign Up",style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                )),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  focusNode: fn1,
                  controller: fullNameController,
                  decoration: InputDecoration(
                      hintText: "Full Name",
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
                      prefixIcon: Icon(Icons.person)
                  ),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  cursorColor: Theme.of(context).colorScheme.tertiary,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  focusNode: fn2,
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
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
                    prefixIcon: Icon(Icons.email),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  cursorColor: Theme.of(context).colorScheme.tertiary,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  focusNode: fn3,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
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
                ElevatedButton(onPressed: () async{
                  fn1.unfocus();
                  fn2.unfocus();
                  fn3.unfocus();
                  await addUser();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign up done!!!")));
                },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        minimumSize: Size(double.infinity , 50 )
                    ),
                    child: Text("Sign Up",style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.primary))
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have a account?"),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Loginpage();}));
                    }, child: Text("Login",style: TextStyle(color: Colors.blue)))
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
