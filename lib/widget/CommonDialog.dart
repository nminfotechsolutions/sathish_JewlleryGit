

import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/widget/RoundedElevatedButton.dart';

class CommonDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required VoidCallback onYes,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Are you sure?'),
          actions: <Widget>[
           RoundedElevatedButton(text: "Cancel",onPressed: (){Navigator.pop(context);}),
           RoundedElevatedButton(text: "Yes",onPressed: (){
             Navigator.of(context).pop();
             onYes();
           }),
          ],
        );
      },
    );
  }
}
