import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/utils.dart';
import 'package:provider/provider.dart';
import '../Provider/imageprovider.dart';
import 'favoritepage.dart';
import 'homepage.dart';
import 'verficationpage.dart';
import 'themepage.dart';
import 'signuppage.dart';

class Deletepage extends StatefulWidget {
  const Deletepage({super.key});

  @override
  State<Deletepage> createState() => _DeletepageState();
}

class _DeletepageState extends State<Deletepage> {
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('delete').where('id',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Scaffold(
              appBar: AppBar(
                title: Text("Notes",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.tertiary,
                )),
              ),
              body: Center(child:CircularProgressIndicator.adaptive())
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Bin",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.tertiary,
            )),
          ),
          body: snapshot.data!.docs.isEmpty?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset("assets/recycle_bin.png"),
              ),
              SizedBox(
                height: 10,
              ),
              Center(child: Text("Nothing to show",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))),
              SizedBox(
                height: 10,
              ),
            ],
          ):
          Container(
            padding: EdgeInsets.only(top:8),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5,right: 5),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              title: Text(snapshot.data!.docs[index]["title"].toString(),style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                              subtitle: Text(snapshot.data!.docs[index]["description"].toString(),style: TextStyle(
                                  fontSize: 15
                              )),
                              trailing: IconButton(onPressed: (){
                                showDialog(context: context, builder: (context){
                                  return AlertDialog.adaptive(
                                    title: Text("Delete"),
                                    content: Text("Are you sure?"),
                                    actions: [
                                      TextButton(onPressed: (){
                                        Navigator.of(context).pop();
                                      }, child: Text("No",style: TextStyle(color: Colors.green))),
                                      TextButton(onPressed: (){
                                        FirebaseFirestore.instance.collection('delete').doc(snapshot.data!.docs[index].id).delete();
                                        Navigator.of(context).pop();
                                      }, child: Text("Yes",style: TextStyle(color: Colors.red)))
                                    ],
                                  );
                                });
                              }, icon: Icon(Icons.delete,color: Colors.red)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
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
    );
  }
}
