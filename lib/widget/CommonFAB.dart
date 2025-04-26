import 'package:agni_chit_saving/routes/app_export.dart';

class CommonFAB extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const CommonFAB({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 5,
      focusColor: AppColors.ButtonColorYes,
      onPressed: onPressed,
      label: Text(label),
      icon: Container(
        decoration: BoxDecoration(
          color: AppColors.Textstylecolor,
          borderRadius: BorderRadius.circular(50.0)
        ),
          child: Icon(icon,color: AppColors.CommonBlack)),
    );
  }
}
