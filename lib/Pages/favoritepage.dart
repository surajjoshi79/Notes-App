import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/Pages/deletepage.dart';
import 'package:notes_app/Notes/editnotes.dart';
import 'package:notes_app/Provider/imageprovider.dart';
import 'package:notes_app/utils.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'verficationpage.dart';
import 'themepage.dart';
import 'signuppage.dart';

class Favoritepage extends StatefulWidget {
  const Favoritepage({super.key});

  @override
  State<Favoritepage> createState() => _FavoritepageState();
}

class _FavoritepageState extends State<Favoritepage> {

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
      stream: FirebaseFirestore.instance.collection("notes").where("isFav",isEqualTo: true).where('id',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Scaffold(
            appBar: AppBar(
              title: Text("Favorite",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.tertiary,
              )),
            ),
            body: Center(child: CircularProgressIndicator.adaptive())
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Favorite",style: TextStyle(
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
                child: Image.asset("assets/empty_folder.png"),
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
                  child: sharedPrefs.pref.getBool("isGrid")??false?
                  MasonryGridView.builder(
                    gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return Editnotes(id: snapshot.data!.docs[index].id);
                          }));
                        },
                        onLongPress: () async{
                          await FirebaseFirestore.instance.collection("notes").add({
                            'id':FirebaseAuth.instance.currentUser!.uid,
                            'title':snapshot.data!.docs[index]['title'],
                            'description':snapshot.data!.docs[index]['description'],
                            'isFav':true,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to favorite")));
                        },
                        child: Dismissible(
                          key:Key(snapshot.data!.docs[index]['title']),
                          onDismissed: (direction){
                            if(direction==DismissDirection.endToStart){
                              FirebaseFirestore.instance.collection('delete').add({
                                'id':FirebaseAuth.instance.currentUser!.uid,
                                'title':snapshot.data!.docs[index]['title'],
                                'description':snapshot.data!.docs[index]['description'],
                              });
                              FirebaseFirestore.instance.collection('notes').doc(snapshot.data!.docs[index].id).delete();
                            }
                            else{
                              FirebaseFirestore.instance.collection('hidden').add({
                                'id':FirebaseAuth.instance.currentUser!.uid,
                                'title':snapshot.data!.docs[index]['title'],
                                'description':snapshot.data!.docs[index]['description'],
                              });
                              FirebaseFirestore.instance.collection('notes').doc(snapshot.data!.docs[index].id).delete();
                            }
                          },
                          background: Container(
                              padding:EdgeInsets.only(left:8),
                              color: Colors.green,
                              child: Row(
                                children: [
                                  Icon(Icons.lock),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Swipe to hide",style: TextStyle(fontSize: 16))
                                ],
                              )
                          ),
                          secondaryBackground: Container(
                              padding:EdgeInsets.only(right:8),
                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Swipe to delete",style: TextStyle(fontSize: 16)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.delete)
                                ],
                              )
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 5,right: 5,bottom: 5),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              title: Text(snapshot.data!.docs[index]['title'],style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                              subtitle: Text(snapshot.data!.docs[index]['description'].toString().length>150?
                              snapshot.data!.docs[index]['description'].toString().substring(0,150)+".........":
                              snapshot.data!.docs[index]['description'].toString(),style: TextStyle(
                                  fontSize: 15
                              )),
                            ),
                          ),
                        ),
                      );
                    },
                  ):ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return Editnotes(id: snapshot.data!.docs[index].id);
                          }));
                        },
                        child: Column(
                          children: [
                            Dismissible(
                              key:Key(snapshot.data!.docs[index]['title']),
                              onDismissed: (direction){
                                if(direction==DismissDirection.endToStart){
                                  FirebaseFirestore.instance.collection('delete').add({
                                    'id':FirebaseAuth.instance.currentUser!.uid,
                                    'title':snapshot.data!.docs[index]['title'],
                                    'description':snapshot.data!.docs[index]['description'],
                                  });
                                  FirebaseFirestore.instance.collection('notes').doc(snapshot.data!.docs[index].id).delete();
                                }
                                else{
                                  FirebaseFirestore.instance.collection('hidden').add({
                                    'id':FirebaseAuth.instance.currentUser!.uid,
                                    'title':snapshot.data!.docs[index]['title'],
                                    'description':snapshot.data!.docs[index]['description'],
                                  });
                                  FirebaseFirestore.instance.collection('notes').doc(snapshot.data!.docs[index].id).delete();
                                }
                              },
                              background: Container(
                                  color: Colors.green,
                                  child: Row(
                                    children: [
                                      Icon(Icons.lock),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Swipe to hide",style: TextStyle(fontSize: 16))
                                    ],
                                  )),
                              secondaryBackground: Container(
                                  color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Swipe to delete",style: TextStyle(fontSize: 16)),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(Icons.delete),
                                    ],
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5,right: 5),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  title: Text(snapshot.data!.docs[index]["title"],style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                                  subtitle: Text(snapshot.data!.docs[index]['description'].toString().length>400?
                                  snapshot.data!.docs[index]['description'].toString().substring(0,400):
                                  snapshot.data!.docs[index]['description'].toString(),style: TextStyle(
                                      fontSize: 15
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
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
