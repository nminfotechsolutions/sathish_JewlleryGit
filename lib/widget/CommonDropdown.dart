import 'package:agni_chit_saving/routes/app_export.dart';
class CommoDropDown extends StatefulWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CommoDropDown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  _CommoDropDownState createState() => _CommoDropDownState();
}

class _CommoDropDownState extends State<CommoDropDown> {
  late String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: AppColors.CommonColor),
          ),
          child: Stack(
            children: [
              DropdownButton<String>(
                value: _selectedItem,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                  widget.onChanged(newValue);
                },
                icon: SizedBox.shrink(),
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(),
                items: widget.items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),
              Positioned(
                right: 8,
                top: 12,
                child: Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
