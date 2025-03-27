import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

pickImage(ImageSource source) async{
  final ImagePicker imagePicker=ImagePicker();
  XFile? image=await imagePicker.pickImage(source: source);
  if(image != null){
    return image.readAsBytes();
  }
}

class SharedPrefs {
  late final SharedPreferences pref;
  Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }
}

final sharedPrefs =SharedPrefs();