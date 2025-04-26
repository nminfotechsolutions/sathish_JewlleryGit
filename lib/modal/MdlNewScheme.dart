import 'dart:convert';

import 'package:agni_chit_saving/utils/commonUtils.dart';

import '../database/SqlConnectionService.dart';

class MdlNewScheme {
  final String chitId;
  final String schemeName;
  final String schemeAmount;
  final String noIns;
  final String totalMembers;
  final String regNo;
  final String active;
  final String schemeId;
  final String branchId;
  final String metId;
  final String groupCode;
  final String schemeType;
  final String SCHEMENO;

  MdlNewScheme({
    required this.chitId,
    required this.schemeName,
    required this.schemeAmount,
    required this.noIns,
    required this.totalMembers,
    required this.regNo,
    required this.active,
    required this.schemeId,
    required this.branchId,
    required this.metId,
    required this.groupCode,
    required this.schemeType,
    required this.SCHEMENO,
  });

  Map<String, dynamic> toJson() {
    return {
      'chitId': chitId,
      'schemeName': schemeName,
      'schemeAmount': schemeAmount,
      'noIns': noIns,
      'totalMembers': totalMembers,
      'regNo': regNo,
      'active': active,
      'schemeId': schemeId,
      'branchId': branchId,
      'metId': metId,
      'groupCode': groupCode,
      'schemeType': schemeType,
      'SCHEMENO': SCHEMENO,
    };
  }

  factory MdlNewScheme.fromJson(Map<String, dynamic> json) {
    return MdlNewScheme(
      chitId: json['CHITID'] ?? '',
      schemeName: json['SCHEMENAME'] ?? '',
      schemeAmount: json['AMOUNT'] ?? '',
      noIns: json['NOINS'] ?? '',
      totalMembers: json['TotalMembers'] ?? '',
      regNo: json['REGNO'] ?? '',
      active: json['ACTIVE'] ?? '',
      schemeId: json['SCHEMEID'] ?? '',
      branchId: json['BRANCHID'] ?? '',
      metId: json['METID'] ?? '',
      groupCode: json['GROUPCODE'] ?? '',
      SCHEMENO: json['SCHEMENO'] ?? '',
      schemeType: json['SCHEMETYPE'] ?? '',
    );
  }

  // Add copyWith method to modify schemeAmount
  MdlNewScheme copyWith({String? schemeAmount}) {
    return MdlNewScheme(
      chitId: this.chitId,
      schemeName: this.schemeName,
      schemeAmount: schemeAmount ??
          this.schemeAmount, // Only change schemeAmount if provided
      noIns: this.noIns,
      totalMembers: this.totalMembers,
      regNo: this.regNo,
      active: this.active,
      schemeId: this.schemeId,
      branchId: this.branchId,
      metId: this.metId,
      groupCode: this.groupCode,
      schemeType: this.schemeType,
      SCHEMENO: this.SCHEMENO,
    );
  }

  static late Future<List<MdlNewScheme>> FutureNewScheme;
  static late List<MdlNewScheme> allNewSchemeData = [];
  static late List<MdlNewScheme> filteredMdlNewScheme = [];

  static Future<List<MdlNewScheme>> fecthdatafromNewScheme() async {
    final SqlConnectionService sqlService = SqlConnectionService();
    try {
      String querry = """
      SELECT 
        CAST(CHITID AS VARCHAR(255)) AS CHITID,
        CAST(SCHEMENAME AS VARCHAR(255)) AS SCHEMENAME,
        CAST(AMOUNT AS VARCHAR(255)) AS AMOUNT,
        CAST(NOINS AS VARCHAR(255)) AS NOINS,
        CAST(TotalMembers AS VARCHAR(255)) AS TotalMembers,
        CAST(REGNO AS VARCHAR(255)) AS REGNO,
        CAST(ACTIVE AS VARCHAR(255)) AS ACTIVE,
        CAST(SCHEMEID AS VARCHAR(255)) AS SCHEMEID,
        CAST((select schemetype from SCHEME as SM where SM.SCHEMEID = CA.SCHEMEID) as VARCHAR(255)) as SCHEMETYPE,
        CAST((select SCHEMENO from SCHEME as SM where SM.SCHEMEID = CA.SCHEMEID) as VARCHAR(255)) as SCHEMENO,
        CAST(BRANCHID AS VARCHAR(255)) AS BRANCHID,
        CAST(METID AS VARCHAR(255)) AS METID, 
        CAST(GROUPCODE AS VARCHAR(255)) AS GROUPCODE
      FROM 
      CHITAMOUNT AS CA 
      where SCHEMEID IN (SELECT SCHEMEID FROM SCHEME WHERE WEBCHIT='Y') 
      order by schemename,CONVERT(NUMERIC(10,2),AMOUNT)
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

        List<MdlNewScheme> rateMaster =
            jsonResult.map((data) => MdlNewScheme.fromJson(data)).toList();
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
