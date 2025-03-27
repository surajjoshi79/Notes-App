import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagesProvider extends ChangeNotifier{
  Uint8List? image;
  void addImage(Uint8List img){
    image=img;
    notifyListeners();
  }
  showImage(){
    return image;
  }
}