import 'package:agni_chit_saving/routes/app_export.dart';
class CommonContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double borderRadius;
  final EdgeInsets padding;

  const CommonContainer({
    Key? key,
    required this.child,
    this.color,
    this.borderRadius = 15.0,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color ?? AppColors.CommonColor,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
