

import 'package:agni_chit_saving/routes/app_export.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? secondActionButtonCallback;
  final IconData? secondActionButtonIcon;
  const CommonAppBar({
    super.key,
    required this.title,
    this.secondActionButtonCallback,
    this.secondActionButtonIcon,
  });


  @override
  _CommonAppBarState createState() => _CommonAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CommonAppBarState extends State<CommonAppBar> {
  String? selectedCompanyId;
  List<String> companyIds = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title, style: commonTextStyleLarge(),),
      actions: [
        if (widget.secondActionButtonIcon != null && widget.secondActionButtonCallback != null)
          IconButton(
            onPressed: widget.secondActionButtonCallback,
            icon: Icon(widget.secondActionButtonIcon),
          ),
      ],
      backgroundColor: AppColors.CommonColor,
      iconTheme: IconThemeData(color: AppColors.Textstylecolor),
    );
  }



}
