import 'dart:convert';
import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/utils/commonUtils.dart';
import 'package:agni_chit_saving/widget/CommonSharedPrefrences.dart';

class MdlProfileScreen {
  final String USERNAME;
  final String MOBILENO;
  final String EMAIL;
  final String PASS;
  final String CONPASS;
  final String USERID;
  final String ACTIVE;
  final String Imgpath;
  final String ADD1;
  final String ADD2;
  final String ADD3;
  final String NOM_NAME;
  final String NOM_MOBNO;
  final String AADHARNO;
  final String PANNO;

  MdlProfileScreen({
    required this.USERNAME,
    required this.MOBILENO,
    required this.EMAIL,
    required this.PASS,
    required this.CONPASS,
    required this.USERID,
    required this.ACTIVE,
    required this.Imgpath,
    required this.ADD1,
    required this.ADD2,
    required this.ADD3,
    required this.NOM_NAME,
    required this.NOM_MOBNO,
    required this.AADHARNO,
    required this.PANNO,
  });

  factory MdlProfileScreen.fromjson(Map<String, dynamic> json) {
    return MdlProfileScreen(
      USERNAME: json['USERNAME'] ?? '',
      MOBILENO: json['MOBILENO'] ?? '',
      EMAIL: json['EMAIL'] ?? '',
      PASS: json['PASS'] ?? '',
      CONPASS: json['CONPASS'] ?? '',
      USERID: json['USERID'] ?? '',
      ACTIVE: json['ACTIVE'] ?? '',
      Imgpath: json['Imgpath'] ?? '',
      ADD1: json['ADD1'] ?? '',
      ADD2: json['ADD2'] ?? '',
      ADD3: json['ADD3'] ?? '',
      NOM_NAME: json['NOM_NAME'] ?? '',
      NOM_MOBNO: json['NOM_MOBNO'] ?? '',
      AADHARNO: json['AADHARNO'] ?? '',
      PANNO: json['PANNO'] ?? '',
    );
  }

  static late Future<List<MdlProfileScreen>> futureMdlProfileScreen;
  static List<MdlProfileScreen> allMdlProfileScreen = [];
  static List<MdlProfileScreen> filteredMdlProfileScreen = [];

  static Future<List<MdlProfileScreen>> fecthProfileScreenquerry() async {
    final SqlConnectionService sqlService = SqlConnectionService();
    try {
      String? userid = SharedPreferencesHelper.getString("USERID");
      /*Fluttertoast.showToast(msg: "${userid}");*/
      String querry = """
     select 
    convert(varchar(255), USERNAME) as USERNAME,
    convert(varchar(255), MOBILENO) as MOBILENO,
    convert(varchar(255), EMAIL) as EMAIL,
    convert(varchar(255), PASS) as PASS,
    convert(varchar(255), CONPASS) as CONPASS,
    convert(varchar(255), USERID) as USERID,
    convert(varchar(255), ACTIVE) as ACTIVE,
    convert(varchar(255), Imgpath) as Imgpath,
    convert(varchar(255), ADD1) as ADD1,
    convert(varchar(255), ADD2) as ADD2,
    convert(varchar(255), ADD3) as ADD3,
    convert(varchar(255), NOM_NAME) as NOM_NAME,
    convert(varchar(255), NOM_MOBNO) as NOM_MOBNO,
    convert(varchar(255), AADHARNO) as AADHARNO,
    convert(varchar(255), PANNO) as PANNO
      from USERMASTER where userid='$userid' """;

      dynamic results = await sqlService.fetchData(querry);
      /*commonUtils.log.i('Query: $querry');*/

      if (results != null) {
        List<Map<String, dynamic>> jsonResult = [];

        if (results is List<dynamic>) {
          jsonResult = results.cast<Map<String, dynamic>>();
        } else if (results is String) {
          jsonResult = jsonDecode(results).cast<Map<String, dynamic>>();
        }

        List<MdlProfileScreen> Ratemaster =
            jsonResult.map((data) => MdlProfileScreen.fromjson(data)).toList();
        commonUtils.log.i('Number of records fetched: ${Ratemaster.length}');

        return Ratemaster;
      } else {
        return [];
      }
    } catch (e) {
      commonUtils.log.e("Error: $e");
      return [];
    }
  }

  static Future<void> updateDataFromServer(
      List<MdlProfileScreen> ProfileScreenList) async {
    final SqlConnectionService sqlService = SqlConnectionService();
    String? username = SharedPreferencesHelper.getString("username");
    for (var itemData in ProfileScreenList) {
      String USERNAME = itemData.USERNAME;
      String MOBILENO = itemData.MOBILENO;
      String EMAIL = itemData.EMAIL;
      String PASS = itemData.PASS;
      String CONPASS = itemData.CONPASS;
      String USERID = itemData.USERID;
      String ACTIVE = itemData.ACTIVE;
      String Imgpath = itemData.Imgpath;
      String ADD1 = itemData.ADD1;
      String ADD2 = itemData.ADD2;
      String ADD3 = itemData.ADD3;
      String NOM_NAME = itemData.NOM_NAME;
      String NOM_MOBNO = itemData.NOM_MOBNO;
      String AADHARNO = itemData.AADHARNO;
      String PANNO = itemData.PANNO;

      String query = '''
  UPDATE USERMASTER SET  USERNAME = '$USERNAME', MOBILENO = '$MOBILENO', EMAIL = '$EMAIL', PASS = '$PASS'
  , CONPASS = '$CONPASS', USERID = '$USERID', ACTIVE = '$ACTIVE',    Imgpath = '$Imgpath',    ADD1 = '$ADD1'
  , ADD2 = '$ADD2', ADD3 = '$ADD3', NOM_NAME = '$NOM_NAME', NOM_MOBNO = '$NOM_MOBNO', AADHARNO = '$AADHARNO'
  , PANNO = '$PANNO' WHERE   USERID=$USERID;
''';

      String? result = await sqlService.writeData(query);
      if (result != null) {
        commonUtils.log.i('Data insert successfully in server: $result');
      } else {
        commonUtils.log
            .e('Failed to insert data for item with id ${itemData.USERID}');
      }
    }
  }
}
