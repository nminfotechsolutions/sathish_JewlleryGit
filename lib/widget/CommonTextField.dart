import 'package:agni_chit_saving/routes/app_export.dart';

class CommonDialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final Function()? onTap;
  final bool readOnly; // New parameter to make the text field readonly

  const CommonDialogTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.labelStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
    ),
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.left,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: textStyle,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
      ),
      keyboardType: keyboardType,
      textAlign: textAlign,
      onTap: onTap,
      readOnly: readOnly,
    );
  }
}
