import 'dart:convert';
import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/routes/app_export.dart';

class MdlRateMaster {
  final String SNO;
  final String GOLD;
  final String SILVER;
  final String DATE;
  final String UPDATED;
  final String ACTIVE;

  MdlRateMaster({
    required this.SNO,
    required this.GOLD,
    required this.SILVER,
    required this.DATE,
    required this.UPDATED,
    required this.ACTIVE,
  });

  factory MdlRateMaster.fromjson(Map<String, dynamic> json) {
    return MdlRateMaster(
      SNO: json['SNO'] ?? '',
      GOLD: json['GOLD'] ?? '',
      SILVER: json['SILVER'] ?? '',
      DATE: json['DATE'] ?? '',
      UPDATED: json['UPDATED'] ?? '',
      ACTIVE: json['ACTIVE'] ?? '',
    );
  }

  static  List<MdlRateMaster> Ratemaster = [];

  static String? GoldRate = "0.00";

  static String? SilverRate = "0.00";

  static String date = '';

  static Future<List<MdlRateMaster>> fecthdatafromrate() async {
    final SqlConnectionService sqlService = SqlConnectionService();
    try {
      String querry = """
      select convert(varchar (20),SNO) as SNO,
             convert(varchar(20),gold) as GOLD,
             convert(varchar(20),silver) as SILVER, 
             convert(varchar(20),date) as DATE,
             convert(varchar(20),UPDATED) as UPDATED,
             convert(varchar(20),ACTIVE) as ACTIVE 
      from RATEMASTER""";

      dynamic results = await sqlService.fetchData(querry);
      commonUtils.log.i('Query: $querry');

      if (results != null) {
        List<Map<String, dynamic>> jsonResult = [];

        if (results is List<dynamic>) {
          jsonResult = results.cast<Map<String, dynamic>>();
        } else if (results is String) {
          jsonResult = jsonDecode(results).cast<Map<String, dynamic>>();
        }

        List<MdlRateMaster> Ratemaster =
        jsonResult.map((data) => MdlRateMaster.fromjson(data)).toList();
        commonUtils.log.i('Number of records fetched: ${Ratemaster.length}');

        return Ratemaster;
      } else {
        return [];
      }
    } catch (e) {
      commonUtils.log.i('Error in ratemaster: $e');
      return [];
    }
  }


}
