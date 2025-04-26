import 'package:image_picker/image_picker.dart';
import 'package:agni_chit_saving/routes/app_export.dart';

picker(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? _file = await imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  commonUtils.log.i('No Image Selected');
}
