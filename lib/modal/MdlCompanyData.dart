import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/routes/app_export.dart';

class MdlCompanyData {
  final String companyid;
  final String companyname;
  final String address1;
  final String address2;
  final String phone;
  final String gstno;
  final String voucherno;
  final String branchid;
  final String rno;
  final String shortname;
  final String yr;
  final String regno;
  final String remid;
  final String razor_key;

  MdlCompanyData({
    required this.companyid,
    required this.companyname,
    required this.address1,
    required this.address2,
    required this.phone,
    required this.gstno,
    required this.voucherno,
    required this.branchid,
    required this.rno,
    required this.shortname,
    required this.yr,
    required this.regno,
    required this.remid,
    required this.razor_key,
  });

  factory MdlCompanyData.fromjson(Map<String, dynamic> json) {
    return MdlCompanyData(
      companyid: json['COMPANYID'] ?? '',
      companyname: json['COMPANYNAME'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      phone: json['phone'] ?? '',
      gstno: json['gstno'] ?? '',
      voucherno: json['voucherno'] ?? '',
      branchid: json['branchid'] ?? '',
      rno: json['rno'] ?? '',
      shortname: json['shortname'] ?? '',
      yr: json['yr'] ?? '',
      regno: json['regno'] ?? '',
      remid: json['remid'] ?? '',
      razor_key: json['razor_key'] ?? '',
    );
  }

  static Future<List<MdlCompanyData>> fecthdatafromQuery() async {
    final SqlConnectionService sqlService = SqlConnectionService();
    try {
      String querry = """
    
SELECT 
    CONVERT(VARCHAR(255), COMPANYID) AS COMPANYID,
    CONVERT(VARCHAR(255), COMPANYNAME) AS COMPANYNAME,
    CONVERT(VARCHAR(255), ADDRESS1) AS ADDRESS1,
    CONVERT(VARCHAR(255), ADDRESS2) AS ADDRESS2,
    CONVERT(VARCHAR(255), PHONE) AS PHONE,
    CONVERT(VARCHAR(255), GSTNO) AS GSTNO,
    CONVERT(VARCHAR(255), VOUCHERNO) AS VOUCHERNO,
    CONVERT(VARCHAR(255), BRANCHID) AS BRANCHID,
    CONVERT(VARCHAR(255), RNO) AS RNO,
    CONVERT(VARCHAR(255), SHORTNAME) AS SHORTNAME,
    CONVERT(VARCHAR(255), YR) AS YR,
    CONVERT(VARCHAR(255), REGNO) AS REGNO,
    CONVERT(VARCHAR(255), REMID) AS REMID,
    CONVERT(VARCHAR(255), razor_key) AS razor_key
FROM 
    COMPANY;

      """;

      dynamic results = await sqlService.fetchData(querry);
      commonUtils.log.i('Query: $querry');

      if (results != null) {
        List<Map<String, dynamic>> jsonResult = [];

        if (results is List<dynamic>) {
          jsonResult = results.cast<Map<String, dynamic>>();
        } else if (results is String) {
          jsonResult = jsonDecode(results).cast<Map<String, dynamic>>();
        }

        List<MdlCompanyData> rateMaster =
            jsonResult.map((data) => MdlCompanyData.fromjson(data)).toList();
        commonUtils.log.i('Number of records fetched: ${rateMaster.length}');

        return rateMaster;
      } else {
        return [];
      }
    } catch (e) {
      commonUtils.log.i('Error in rateMaster: $e');
      return [];
    }
  }
}
