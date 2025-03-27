import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signuppage.dart';
import 'homepage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  FocusNode fn1=FocusNode();
  FocusNode fn2=FocusNode();
  bool see=true;
  Future<void> loginUser() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim() ,
          password: passwordController.text.trim()
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Homepage();}));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Log in done!!!")));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User don't exist")));
    }
  }
  @override
  void dispose() {
    fn1.dispose();
    fn2.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                Text("Log In",style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                )),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  focusNode: fn1,
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
                  focusNode: fn2,
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
                  await loginUser();
                },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        minimumSize: Size(double.infinity , 50 )
                    ),
                    child: Text("Log In",style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.primary))
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have a account?"),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Signuppage();}));
                    }, child: Text("Sign Up",style: TextStyle(color: Colors.blue)))
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
