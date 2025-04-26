import 'package:agni_chit_saving/modal/Mdl_DummyApi.dart';
import 'package:agni_chit_saving/modal/Mdl_DummyApiServices.dart';
import 'package:agni_chit_saving/routes/app_export.dart';

class rewards extends StatefulWidget {
  const rewards({super.key});

  @override
  State<rewards> createState() => _rewardsState();
}

class _rewardsState extends State<rewards> {
  MdlDummyapiservices api = MdlDummyapiservices();
  MdlDummyapi? dummydata;

  @override
  void initState() {
    Loaddata();
  }

  Future<void> Loaddata() async {
    MdlDummyapi? data = await api.fetchData();
    setState(() {
      dummydata = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.construction_sharp, size: 50),
            SizedBox(
              height: 10,
            ),
            Text(
              "Coming Soon${dummydata?.tittle}",
              style: commonTextStyleLarge(color: AppColors.CommonColor),
            ),
          ],
        ),
      ),
    );
  }
}
