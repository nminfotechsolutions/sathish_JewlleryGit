import 'dart:convert';
import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/routes/app_export.dart';

class MdlMysavingsScheme {
  String NAME;
  String SCHCODE;
  String SCHEMETYPE;
  String REGNO;
  String ACCNO;
  String BRANCHID;
  String CHITID;
  String SCHEMEID;
  String METID;
  String NOINS;
  String GROUPCODE;
  String SCHNAME;
  String SCHCODE1;
  String SCHAMT;
  String INSTALLMENT;
  String PAIDINS;
  String TOTALWGT;
  String PAID;
  String BALANCE;
  String USERID;
  String MATURITY_DATE;
  String STATUS;
  String SCHEMENO;
  String RATE;

  MdlMysavingsScheme({
    required this.NAME,
    required this.SCHCODE,
    required this.SCHEMETYPE,
    required this.REGNO,
    required this.ACCNO,
    required this.BRANCHID,
    required this.CHITID,
    required this.SCHEMEID,
    required this.METID,
    required this.NOINS,
    required this.GROUPCODE,
    required this.SCHNAME,
    required this.SCHCODE1,
    required this.SCHAMT,
    required this.INSTALLMENT,
    required this.PAIDINS,
    required this.TOTALWGT,
    required this.PAID,
    required this.BALANCE,
    required this.USERID,
    required this.MATURITY_DATE,
    required this.STATUS,
    required this.SCHEMENO,
    required this.RATE,
  });

  Map<String, dynamic> toJson() {
    return {
      'NAME': NAME,
      'SCHCODE': SCHCODE,
      'SCHEMETYPE': SCHEMETYPE,
      'REGNO': REGNO,
      'ACCNO': ACCNO,
      'BRANCHID': BRANCHID,
      'CHITID': CHITID,
      'SCHEMEID': SCHEMEID,
      'METID': METID,
      'NOINS': NOINS,
      'GROUPCODE': GROUPCODE,
      'SCHNAME': SCHNAME,
      'SCHCODE1': SCHCODE1,
      'SCHAMT': SCHAMT,
      'RATE': RATE,
      'INSTALLMENT': INSTALLMENT,
      'PAIDINS': PAIDINS,
      'TOTALWGT': TOTALWGT,
      'PAID': PAID,
      'BALANCE': BALANCE,
      'USERID': USERID,
      'MATURITY_DATE': MATURITY_DATE,
      'STATUS': STATUS,
      'SCHEMENO': SCHEMENO,
    };
  }

  factory MdlMysavingsScheme.fromjson(Map<String, dynamic> json) {
    return MdlMysavingsScheme(
      NAME: json['NAME'] ?? '',
      SCHCODE: json['SCHCODE'] ?? '',
      SCHEMETYPE: json['SCHEMETYPE'] ?? '',
      REGNO: json['REGNO'] ?? '',
      ACCNO: json['ACCNO'] ?? '',
      BRANCHID: json['BRANCHID'] ?? '',
      CHITID: json['CHITID'] ?? '',
      SCHEMEID: json['SCHEMEID'] ?? '',
      METID: json['METID'] ?? '',
      NOINS: json['NOINS'] ?? '',
      GROUPCODE: json['GROUPCODE'] ?? '',
      SCHNAME: json['SCHNAME'] ?? '',
      SCHCODE1: json['SCHCODE1'] ?? '',
      SCHAMT: json['SCHAMT'] ?? '',
      INSTALLMENT: json['INSTALLMENT'] ?? '',
      PAIDINS: json['PAIDINS'] ?? '',
      TOTALWGT: json['TOTALWGT'] ?? '',
      PAID: json['PAID'] ?? '',
      BALANCE: json['BALANCE'] ?? '',
      RATE: json['RATE'] ?? '',
      USERID: json['USERID'] ?? '',
      MATURITY_DATE: json['MATURITY_DATE'] ?? '',
      SCHEMENO: json['SCHEMENO'] ?? '',
      STATUS: json['STATUS'] ?? '',
    );
  }

  static List<MdlMysavingsScheme> allNewSchemeData = [];
  static List<MdlMysavingsScheme> filteredMdlNewScheme = [];

  static Future<List<MdlMysavingsScheme>> fetchDataFromSavings() async {
    final SqlConnectionService service = SqlConnectionService();

    try {
      String? userid = SharedPreferencesHelper.getString("USERID");
      String query = """

 

SELECT 
    CONVERT(VARCHAR(200), NAME) AS NAME,
    CONVERT(VARCHAR(200), MNTHSCHEME.SCHCODE) AS SCHCODE,
    CONVERT(VARCHAR(200), SCHEME.SCHEMETYPE) AS SCHEMETYPE,
    CONVERT(VARCHAR(200), MNTHSCHEME.REGNO) AS REGNO,
    CONVERT(VARCHAR(200), MNTHSCHEME.ACCNO) AS ACCNO,
    CONVERT(VARCHAR(200), MNTHSCHEME.BRANCHID) AS BRANCHID,
    CONVERT(VARCHAR(200), MNTHSCHEME.CHITID) AS CHITID,
    CONVERT(VARCHAR(200), MNTHSCHEME.SCHEMEID) AS SCHEMEID,
    CONVERT(VARCHAR(200), CHITAMOUNT.METID) AS METID,
    CONVERT(VARCHAR(200), CHITAMOUNT.NOINS) AS NOINS,
    CONVERT(VARCHAR(200), CHITAMOUNT.GROUPCODE) AS GROUPCODE,
    CONVERT(VARCHAR(200), NEWSCHEME.SCHNAME) AS SCHNAME,
    CONVERT(VARCHAR(200), NEWSCHEME.SCHCODE) AS SCHCODE1,
    CONVERT(VARCHAR(200), NEWSCHEME.SCHAMT) AS SCHAMT,
    CONVERT(VARCHAR(200), NOINS) AS INSTALLMENT,
    CONVERT(VARCHAR(200), COUNT(MNTHSCHEME.ACCNO)) AS PAIDINS,
    CONVERT(VARCHAR(200), ISNULL(SUM(MnthScheme.PGRSWT), 0)) AS TOTALWGT,
    CONVERT(VARCHAR(200), ISNULL(SUM(MnthScheme.Cash), 0) + ISNULL(SUM(MnthScheme.Card), 0) + ISNULL(SUM(MnthScheme.Cheque), 0) + ISNULL(SUM(MnthScheme.MobTran), 0)) AS PAID,
    CONVERT(VARCHAR(200), (chitamount.noins * chitamount.amount) - (ISNULL(SUM(MnthScheme.Cash), 0) + ISNULL(SUM(MnthScheme.Card), 0) + ISNULL(SUM(MnthScheme.Cheque), 0) + ISNULL(SUM(MnthScheme.MobTran), 0))) AS BALANCE,
    CONVERT(VARCHAR(200), MNTHSCHEME.USERID) AS USERID,
   CASE WHEN INS_TYPE!='DAILY' THEN CONVERT(VARCHAR(200), DATEADD(MONTH, CONVERT(INT, CHITAMOUNT.NOINS), JID)) ELSE  CONVERT(VARCHAR(200), DATEADD(DAY, CONVERT(INT, CHITAMOUNT.NOINS), JID))  END  AS MATURITY_DATE,
        
    CONVERT(VARCHAR(200), CASE WHEN NEWSCHEME.BILLDATE IS NOT NULL THEN 'BILLED' ELSE 'ACTIVE' END) AS STATUS
FROM 
    MnthScheme
INNER JOIN 
    ChitAmount ON MnthScheme.CHITID = ChitAmount.CHITID
INNER JOIN 
    NEWSCHEME ON NEWSCHEME.ACCNO = MNTHSCHEME.ACCNO
INNER JOIN 
    SCHEME ON SCHEME.SCHEMENO = MNTHSCHEME.SCHCODE
WHERE 
    MNTHSCHEME.USERID = '$userid' 
    AND MNTHSCHEME.CANCEL <> 'Y'
    AND NEWSCHEME.CANCEL <> 'Y'
GROUP BY 
    CHITAMOUNT.NOINS, 
    CHITAMOUNT.AMOUNT, 
    CHITAMOUNT.METID, 
    CHITAMOUNT.GROUPCODE, 
    MNTHSCHEME.ACCNO, 
    MNTHSCHEME.branchId, 
    MNTHSCHEME.chitId, 
    MNTHSCHEME.schemeId, 
    NEWSCHEME.SCHCODE, 
    NEWSCHEME.SCHNAME, 
    NEWSCHEME.SCHAMT, 
    NAME, 
    MNTHSCHEME.SCHCODE, 
    SCHEME.SCHEMETYPE,
    MNTHSCHEME.REGNO,
    MNTHSCHEME.USERID,
    NEWSCHEME.JID,
    NEWSCHEME.BILLDATE,SCHEME.INS_TYPE;


    """;

      dynamic results = await service.fetchData(query);
      commonUtils.log.i("Query executed successfully: $query");
      commonUtils.log.i("Result Data: $results");

      if (results != null) {
        List<Map<String, dynamic>> jsonResult = [];

        if (results is List<dynamic>) {
          jsonResult = results.cast<Map<String, dynamic>>();
        } else if (results is String) {
          jsonResult = jsonDecode(results).cast<Map<String, dynamic>>();
        }

        List<MdlMysavingsScheme> rateMaster = jsonResult
            .map((data) => MdlMysavingsScheme.fromjson(data))
            .toList();

        commonUtils.log.i("Rate Master: $rateMaster");
        return rateMaster;
      } else {
        commonUtils.log.e("Results are null.");
        return [];
      }
    } catch (e, stackTrace) {
      commonUtils.log.e("An error occurred: $e");
      commonUtils.log.e("Stack trace: $stackTrace");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchDataFromSchemeLedger(
      String accno, String Schemco) async {
    final SqlConnectionService service = SqlConnectionService();
    // Fluttertoast.showToast(msg: "$accno");

    try {
      String? userid = SharedPreferencesHelper.getString("USERID");

      String query = """
          SELECT  CONVERT(VARCHAR(100),MNTHSCHEME.ROD,105) AS PAID,
          CONVERT(VARCHAR(100),MNTHSCHEME.SCHAMT ,105)AS PAIDAMOUNT ,
          CONVERT(VARCHAR(100),MNTHSCHEME.VOUNO,105)as VOUNO  FROM SCHEME INNER JOIN
           MNTHSCHEME ON SCHEME.SCHEMENO=MNTHSCHEME.SCHCODE 
           INNER JOIN CHITAMOUNT ON MNTHSCHEME.CHITID=CHITAMOUNT.CHITID
            INNER JOIN NEWSCHEME ON MNTHSCHEME.ACCNO=NEWSCHEME.ACCNO  
            WHERE MNTHSCHEME.SCHCODE='$Schemco' and MNTHSCHEME.REGNO='$accno' and MNTHSCHEME.CANCEL<>'Y'
             AND NEWSCHEME.CANCEL<>'Y' AND SCHEMETYPE='AMOUNT' ORDER BY ROD  
           """;

      dynamic results = await service.fetchData(query);
      commonUtils.log.i("Query executed successfully: $query");
      commonUtils.log.i("Result Data: $results");

      if (results != null) {
        List<Map<String, dynamic>> schemeList = [];

        if (results is List<dynamic>) {
          schemeList = results.cast<Map<String, dynamic>>();
        } else if (results is String) {
          List<dynamic> jsonResult = jsonDecode(results);
          schemeList = jsonResult.cast<Map<String, dynamic>>();
        }

        return schemeList;
      } else {
        commonUtils.log.e("Results are null.");
        return [];
      }
    } catch (e, stackTrace) {
      commonUtils.log.e("An error occurred: $e");
      commonUtils.log.e("Stack trace: $stackTrace");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchDataFromWeightSchemeLedger(
      String accno, String Schemco) async {
    final SqlConnectionService service = SqlConnectionService();
    // Fluttertoast.showToast(msg: "$accno");

    try {
      String? userid = SharedPreferencesHelper.getString("USERID");

      String query = """
      
    
SELECT  CONVERT(VARCHAR(100),MNTHSCHEME.ROD,105) AS PAID,
CONVERT(VARCHAR(100),MNTHSCHEME.SCHAMT ,105)AS PAIDAMOUNT,
CONVERT(VARCHAR(100),MNTHSCHEME.GOLDRATE,105) as RATE
  ,CONVERT(VARCHAR(100),MNTHSCHEME.METVAL,105)as WEIGHT ,
  CONVERT(VARCHAR(100),MNTHSCHEME.VOUNO,105)as VOUNO 
  FROM SCHEME INNER JOIN MNTHSCHEME ON SCHEME.SCHEMENO=MNTHSCHEME.SCHCODE 
  INNER JOIN CHITAMOUNT ON MNTHSCHEME.CHITID=CHITAMOUNT.CHITID
   INNER JOIN NEWSCHEME ON MNTHSCHEME.ACCNO=NEWSCHEME.ACCNO 
    WHERE MNTHSCHEME.SCHCODE='$Schemco' and MNTHSCHEME.REGNO='$accno' and MNTHSCHEME.CANCEL<>'Y'
     AND NEWSCHEME.CANCEL<>'Y' AND SCHEMETYPE='WEIGHT' ORDER BY ROD
 
         """;

      dynamic results = await service.fetchData(query);
      commonUtils.log.i("Query executed successfully: $query");
      commonUtils.log.i("Result Data: $results");

      if (results != null) {
        List<Map<String, dynamic>> schemeList = [];

        if (results is List<dynamic>) {
          schemeList = results.cast<Map<String, dynamic>>();
        } else if (results is String) {
          List<dynamic> jsonResult = jsonDecode(results);
          schemeList = jsonResult.cast<Map<String, dynamic>>();
        }

        return schemeList;
      } else {
        commonUtils.log.e("Results are null.");
        return [];
      }
    } catch (e, stackTrace) {
      commonUtils.log.e("An error occurred: $e");
      commonUtils.log.e("Stack trace: $stackTrace");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchGoldWeightSchemeLedger(
      String accno, String Schemco) async {
    final SqlConnectionService service = SqlConnectionService();
    Fluttertoast.showToast(msg: "$accno");

    try {
      String? userid = SharedPreferencesHelper.getString("USERID");

      String query = """
      SELECT   SUM(MNTHSCHEME.METVAL)
      FROM SCHEME INNER JOIN MNTHSCHEME ON SCHEME.SCHEMENO=MNTHSCHEME.SCHCODE
      INNER JOIN CHITAMOUNT ON MNTHSCHEME.CHITID=CHITAMOUNT.CHITID
      INNER JOIN NEWSCHEME ON MNTHSCHEME.ACCNO=NEWSCHEME.ACCNO
      WHERE MNTHSCHEME.SCHCODE='$Schemco' and MNTHSCHEME.REGNO='$accno' and MNTHSCHEME.CANCEL<>'Y'
      AND NEWSCHEME.CANCEL<>'Y' AND SCHEMETYPE='WEIGHT'
    """;

      dynamic results = await service.fetchData(query);
      commonUtils.log.i("Query executed successfully: $query");
      commonUtils.log.i("Result Data: $results");

      if (results != null) {
        List<Map<String, dynamic>> schemeList = [];

        if (results is List<dynamic>) {
          schemeList = results.cast<Map<String, dynamic>>();
        } else if (results is String) {
          List<dynamic> jsonResult = jsonDecode(results);
          schemeList = jsonResult.cast<Map<String, dynamic>>();
        }

        return schemeList;
      } else {
        commonUtils.log.e("Results are null.");
        return [];
      }
    } catch (e, stackTrace) {
      commonUtils.log.e("An error occurred: $e");
      commonUtils.log.e("Stack trace: $stackTrace");
      return [];
    }
  }
}
