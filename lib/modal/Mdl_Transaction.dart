import 'dart:convert';

import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/utils/commonUtils.dart';
import 'package:agni_chit_saving/widget/CommonSharedPrefrences.dart';

class MdlTransaction {
  String name;
  String rod;
  String vouno;
  String tran_id;
  String AMOUNT;
  String accNo;

  MdlTransaction({
    required this.name,
    required this.rod,
    required this.tran_id,
    required this.AMOUNT,
    required this.vouno,
    required this.accNo,
  });
  factory MdlTransaction.fromjson(Map<String, dynamic> json) {
    return MdlTransaction(
      name: json['NAME']?.toString() ?? '',
      accNo: json['ACCNO']?.toString() ?? '',
      vouno: json['VOUNO'].toString(), // Converts VOUNO (int) to String
      rod: json['ROD']?.toString() ?? '',
      AMOUNT: json['AMOUNT']?.toString() ?? '',

      tran_id: json['TRANS_ID'].toString(), // Converts TRANS_ID (int) to String
    );
  }

  static Future<List<MdlTransaction>> fetchDataFromSavings() async {
    final SqlConnectionService service = SqlConnectionService();

    try {
      String? userid = SharedPreferencesHelper.getString("USERID");
      String query = """

SELECT 
    NEWSCHEME.NAME,NEWSCHEME.ACCNO,MNTHSCHEME.VOUNO, 
    MNTHSCHEME.ROD AS ROD, 
    ISNULL(SUM(MNTHSCHEME.CASH), 0) + 
    ISNULL(SUM(MNTHSCHEME.CARD), 0) + 
    ISNULL(SUM(MNTHSCHEME.CHEQUE), 0) + 
    ISNULL(SUM(MNTHSCHEME.MOBTRAN), 0) + 
    ISNULL(SUM(MNTHSCHEME.BONUS), 0) AS AMOUNT, 
    CONVERT(VARCHAR(MAX), MAX(CONVERT(VARCHAR(MAX), MNTHSCHEME.TRANS_ID))) AS TRANS_ID
FROM 
    MNTHSCHEME  
INNER JOIN 
    NEWSCHEME ON NEWSCHEME.ACCNO = MNTHSCHEME.ACCNO 
WHERE 
    MNTHSCHEME.USERID = $userid
    AND NEWSCHEME.CANCEL <> 'Y' 
    AND MNTHSCHEME.CANCEL <> 'Y' 
GROUP BY 
    NEWSCHEME.NAME,MNTHSCHEME.VOUNO,MNTHSCHEME.ROD,NEWSCHEME.ACCNO
ORDER BY
ROD desc;

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

        List<MdlTransaction> rateMaster =
            jsonResult.map((data) => MdlTransaction.fromjson(data)).toList();

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
}
