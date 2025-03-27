import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/Provider/imageprovider.dart';
import 'package:notes_app/utils.dart';
import 'signuppage.dart';
import 'package:notes_app/Theme/theme.dart';
import 'verficationpage.dart';
import 'package:provider/provider.dart';
import 'deletepage.dart';
import 'favoritepage.dart';
import 'homepage.dart';
import 'package:notes_app/Provider/themeprovider.dart';

class Themepage extends StatefulWidget {
  const Themepage({super.key});

  @override
  State<Themepage> createState() => _ThemepageState();
}

class _ThemepageState extends State<Themepage> {
  List<Map<String,dynamic>> themes=[{"name":"Light Theme","theme":lightModeSimple},
    {"name":"Dark Theme","theme":darkModeSimple},
    {"name":"Light Theme(Pink Accent)","theme":lightModePink},
    {"name":"Dark Theme(Pink Accent)","theme":darkModePink},
    {"name":"Light Theme(Yellow Accent)","theme":lightModeYellow},
    {"name":"Dark Theme(Yellow Accent)","theme":darkModeYellow},
    {"name":"Light Theme(Green Accent)","theme":lightModeGreen},
    {"name":"Dark Theme(Green Accent)","theme":darkModeGreen},
    {"name":"Dark Theme(Grey)","theme":darkMode}];
  void showLoaderForFixedTime(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SpinKitPouringHourGlass(color: Theme.of(context).colorScheme.secondary),
        );
      },
    );
    await Future.delayed(Duration(seconds: 10));
    Navigator.of(context).pop();
  }
  void selectImage() async{
    Uint8List img=await pickImage(ImageSource.gallery);
    Provider.of<ImagesProvider>(context,listen: false).addImage(img);
    showLoaderForFixedTime(context);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Themes",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Theme.of(context).colorScheme.tertiary,
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount:themes.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  Provider.of<ThemeProvider>(context,listen: false).addTheme(index);
                },
                child: Card(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(themes[index]["name"].toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      trailing: Provider.of<ThemeProvider>(context).getTheme()==themes[index]['theme']?Icon(Icons.check_rounded):Icon(Icons.circle_outlined),
                    ),
                  ),
                ),
              );
            }),
      ),
      drawer: FutureBuilder(
          future: FirebaseFirestore.instance.collection('profile').where('id',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return NavigationDrawer(backgroundColor: Theme.of(context).appBarTheme.backgroundColor,children: [
                SizedBox(
                    height:200,
                    child: Center(child: SpinKitWave(color: Theme.of(context).colorScheme.secondary,size: 25))
                ),
                Divider(
                  thickness: 1.5,
                  color: Theme.of(context).colorScheme.primary,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return Homepage();
                    })
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.home ,color: Colors.black,),
                    title: Text("Home",style: TextStyle(fontSize: 18,color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return Deletepage();
                    })
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.black),
                    title: Text("Deleted",style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return Favoritepage();
                    })
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.favorite, color: Colors.black),
                    title: Text("Favorite",style: TextStyle(fontSize: 18,color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return Verficationpage();
                    })
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.lock, color: Colors.black),
                    title: Text("Hidden",style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return Themepage();
                    })
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.color_lens, color: Colors.black),
                    title: Text("Theme",style: TextStyle(fontSize: 18,color: Colors.black)),
                  ),
                )
              ]);
            }
            return NavigationDrawer(backgroundColor: Theme.of(context).appBarTheme.backgroundColor,children: [
              SizedBox(
                height:200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: Provider.of<ImagesProvider>(context).showImage()!=null?
                        CircleAvatar(radius: 40,backgroundImage: MemoryImage(Provider.of<ImagesProvider>(context).showImage())):
                        CircleAvatar(radius: 40,child: Image.asset("assets/user.png"))
                    ),
                    SizedBox(height: 8),
                    Text(snapshot.data!.docs[0]['name'],style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    )),
                    SizedBox(height: 8),
                    Text(snapshot.data!.docs[0]['email'],style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    )),
                    TextButton(onPressed: (){
                      showDialog(context: context, builder: (context){
                        return AlertDialog.adaptive(
                          title: Text("Sign Out"),
                          content: Text("Are you sure?"),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: Text("No",style: TextStyle(color: Colors.green))),
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Signuppage();}));
                            }, child: Text("Yes",style: TextStyle(color: Colors.red)))
                          ],
                        );
                      });
                    }, child: Text("Sign Out",style: TextStyle(fontSize: 16,color:Colors.black)))
                  ],
                ),
              ),
              Divider(
                thickness: 1.5,
                color: Theme.of(context).colorScheme.primary,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                    return Homepage();
                  })
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.home ,color: Colors.black,),
                  title: Text("Home",style: TextStyle(fontSize: 18,color: Colors.black)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return Deletepage();
                  })
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.black),
                  title: Text("Deleted",style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return Favoritepage();
                  })
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.favorite, color: Colors.black),
                  title: Text("Favorite",style: TextStyle(fontSize: 18,color: Colors.black)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return Verficationpage();
                  })
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.lock, color: Colors.black),
                  title: Text("Hidden",style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return Themepage();
                  })
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.color_lens, color: Colors.black),
                  title: Text("Theme",style: TextStyle(fontSize: 18,color: Colors.black)),
                ),
              )
            ]);
          }
      ),
    );
  }
}