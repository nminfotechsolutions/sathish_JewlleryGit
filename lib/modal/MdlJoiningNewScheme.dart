import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:intl/intl.dart';

class MdlJoiningNewScheme {
  final String vouNo;
  final String jid;
  final String schName;
  final String schCode;
  final String schAmt;
  final String regNo;
  final String name;
  final String add1;
  final String add2;
  final String add3;
  final String city;
  final String state;
  final String country;
  final String mobNo;
  final String cash;
  final String card;
  final String cardName;
  final String cardNo;
  final String cardAmt;
  final String cheque;
  final String chequeNo;
  final String chequeDate;
  final String chequeAmt;
  final String mobTran;
  final String billNo;
  final String billDate;
  final String closeDate;
  final String accNo;
  final String flag;
  final String cancel;
  final String branchId;
  final String metId;
  final String metval;
  final String closeBillNo;
  final String time;
  final String goldRate;
  final String silverRate;
  final String lock;
  final String remarks;
  final String nomIni;
  final String adharNo;
  final String rod;
  final String chitId;
  final String schemeId;
  final String userId;
  final String groupcode;
  final String pgrswt;
  final String pnetwt;
  final String pamount;
  final String SCHEMENO;
  final String REFNO;
  final String TIME;

  MdlJoiningNewScheme({
    required this.vouNo,
    required this.jid,
    required this.schName,
    required this.schCode,
    required this.schAmt,
    required this.regNo,
    required this.name,
    required this.add1,
    required this.add2,
    required this.add3,
    required this.city,
    required this.state,
    required this.REFNO,
    required this.country,
    required this.mobNo,
    required this.cash,
    required this.card,
    required this.cardName,
    required this.cardNo,
    required this.cardAmt,
    required this.cheque,
    required this.chequeNo,
    required this.chequeDate,
    required this.chequeAmt,
    required this.mobTran,
    required this.billNo,
    required this.billDate,
    required this.closeDate,
    required this.accNo,
    required this.flag,
    required this.cancel,
    required this.branchId,
    required this.metId,
    required this.metval,
    required this.closeBillNo,
    required this.time,
    required this.goldRate,
    required this.silverRate,
    required this.lock,
    required this.remarks,
    required this.nomIni,
    required this.adharNo,
    required this.rod,
    required this.chitId,
    required this.schemeId,
    required this.userId,
    required this.groupcode,
    required this.pgrswt,
    required this.pnetwt,
    required this.pamount,
    required this.SCHEMENO,
    required this.TIME,
  });

  factory MdlJoiningNewScheme.fromjson(Map<String, dynamic> json) {
    return MdlJoiningNewScheme(
        vouNo: json['vouNo'] ?? '',
        jid: json['jid'] ?? '',
        schName: json['schName'] ?? '',
        schCode: json['schCode'] ?? '',
        schAmt: json['schAmt'] ?? '',
        regNo: json['regNo'] ?? '',
        name: json['name'] ?? '',
        add1: json['add1'] ?? '',
        add2: json['add2'] ?? '',
        add3: json['add3'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        country: json['country'] ?? '',
        mobNo: json['mobNo'] ?? '',
        cash: json['cash'] ?? '',
        card: json['card'] ?? '',
        REFNO: json['REFNO'] ?? '',
        cardName: json['cardName'] ?? '',
        cardNo: json['cardNo'] ?? '',
        cardAmt: json['cardAmt'] ?? '',
        cheque: json['cheque'] ?? '',
        chequeNo: json['chequeNo'] ?? '',
        chequeDate: json['chequeDate'] ?? '',
        chequeAmt: json['chequeAmt'] ?? '',
        mobTran: json['mobTran'] ?? '',
        billNo: json['billNo'] ?? '',
        billDate: json['billDate'] ?? '',
        closeDate: json['closeDate'] ?? '',
        accNo: json['accNo'] ?? '',
        flag: json['flag'] ?? '',
        cancel: json['cancel'] ?? '',
        branchId: json['branchId'] ?? '',
        metId: json['metId'] ?? '',
        metval: json['metval'] ?? '',
        closeBillNo: json['closeBillNo'] ?? '',
        time: json['time'] ?? '',
        goldRate: json['goldRate'] ?? '',
        silverRate: json['silverRate'] ?? '',
        lock: json['lock'] ?? '',
        remarks: json['remarks'] ?? '',
        nomIni: json['nomIni'] ?? '',
        adharNo: json['adharNo'] ?? '',
        rod: json['rod'] ?? '',
        chitId: json['chitId'] ?? '',
        schemeId: json['schemeId'] ?? '',
        userId: json['USERID'] ?? '',
        groupcode: json['groupCode'] ?? '',
        pgrswt: json['pgrsWt'] ?? '',
        pnetwt: json['pnetWt'] ?? '',
        SCHEMENO: json['SCHEMENO'] ?? '',
        pamount: json['pAmount'] ?? '',
        TIME: json['time'] ?? '');
  }

  static Future<void> updateDataFromServer(
      List<MdlJoiningNewScheme> NewJoiningSchemeList,
      String Trans_id,
      String status) async {
    final SqlConnectionService sqlService = SqlConnectionService();

    for (var itemData in NewJoiningSchemeList) {
      String jid = itemData.jid;
      String schName = itemData.schName;
      String schCode = itemData.schCode;
      String schAmt = itemData.schAmt;
      String regNo = itemData.regNo;
      String name = itemData.name;
      String add1 = itemData.add1;
      String add2 = itemData.add2;
      String add3 = itemData.add3;
      String mobNo = itemData.mobNo;
      String billDate = itemData.billDate;
      String closeDate = itemData.closeDate;
      commonUtils.log.i(closeDate);
      // DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(closeDate!);
      // String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      String flag = itemData.flag;
      String cancel = itemData.cancel;
      String branchId = itemData.branchId;
      String metId = itemData.metId;
      String metval = itemData.metval;
      String goldRate = itemData.goldRate;
      String silverRate = itemData.silverRate;
      String nomIni = itemData.nomIni;
      String adharNo = itemData.adharNo;
      String rod = itemData.rod;
      String chitId = itemData.chitId;
      String schemeId = itemData.schemeId;
      String userId = itemData.userId;
      String groupcode = itemData.groupcode;
      String cash = itemData.cash;
      String card = itemData.card;
      String cardName = itemData.cardName;
      String pgrswt = itemData.pgrswt;
      String pnetwt = itemData.pnetwt;
      String pamount = itemData.pamount;
      String schemeno = itemData.SCHEMENO;
      String time = itemData.TIME;

      /* String query = """
   DECLARE @vouno INT
      SELECT @vouno = ISNULL(MAX(vouno), 0) + 1 FROM NEWSCHEME

      DECLARE @vouno1 INT
      SELECT @vouno1 = ISNULL(MAX(vouno), 0) + 1 FROM MNTHSCHEME

      DECLARE @regno INT
      DECLARE @MYOUT TABLE (BILLNO INT)
      UPDATE SCHEME SET REGNO = REGNO + 1 OUTPUT INSERTED.REGNO INTO @MYOUT WHERE SCHEMENO = '$schemeno'
      SELECT @regno = BILLNO FROM @MYOUT


	  DECLARE @RE TABLE (RNO INT);


UPDATE COMPANY
SET RNO = RNO + 1
OUTPUT INSERTED.RNO INTO @RE;


DECLARE @refno VARCHAR(50);
DECLARE @refno1 VARCHAR(50);


SELECT TOP 1
    @refno = 'ONLINE' + CAST(RNO AS VARCHAR),
    @refno1 = 'ONLINE' + CAST(RNO AS VARCHAR)
FROM @RE;
DECLARE @time TIME = CONVERT(TIME, GETDATE());

      INSERT INTO NEWSCHEME (VOUNO, JID, SCHNAME, SCHCODE, SCHAMT, REGNO, NAME, ADD1, ADD2, ADD3, MOBNO, CASH, CARD, CARDNAME, FLAG, CANCEL, METID, METVAL, GOLDRATE, SILVERRATE, NOMINI, ADHARNO, USERID, accno, refno, [time])
      VALUES (@vouno, '$jid', '$schName', '$schemeno', '$schAmt', @regno, '$name', '$add1', '$add2', '$add3', '$mobNo', '$cash', '$card', '$cardName', '$flag', '$cancel', '$metId', '$pgrswt', '$goldRate', '$silverRate', '$nomIni', '$adharNo', '$userId', '$schemeno' + CAST(@regno AS VARCHAR), @refno, @time)

      INSERT INTO MNTHSCHEME (VOUNO, ROD, SCHNAME, SCHCODE, SCHAMT, REGNO, CASH, CARD, CARDNAME, CHITID, FLAG, CANCEL, BRANCHID, METVAL, SCHEMEID, GOLDRATE, SILVERRATE, USERID, accno, pgrswt, pnetwt, pamount, TRANS_ID, STATUS, refno,[time])
      VALUES (@vouno1, '$rod', '$schName', '$schemeno', '$schAmt', @regno, '$cash', '$card', '$cardName', '$chitId', '$flag', '$cancel', '$branchId', '$pgrswt', '$schemeId', '$goldRate', '$silverRate', '$userId', '$schemeno' + CAST(@regno AS VARCHAR), '$pgrswt', '$pnetwt', '$pamount', '$Trans_id', '$status', @refno1,@time)""";*/

      String query = """
   DECLARE @vouno INT;
   SELECT @vouno = ISNULL(MAX(vouno), 0) + 1 FROM NEWSCHEME;

   DECLARE @vouno1 INT;
   SELECT @vouno1 = ISNULL(MAX(vouno), 0) + 1 FROM MNTHSCHEME;

   DECLARE @regno INT;
   DECLARE @MYOUT TABLE (BILLNO INT);
   UPDATE SCHEME 
   SET REGNO = REGNO + 1 
   OUTPUT INSERTED.REGNO INTO @MYOUT 
   WHERE SCHEMENO = '$schemeno';
   SELECT @regno = BILLNO FROM @MYOUT;

   DECLARE @RE TABLE (RNO INT);
   UPDATE COMPANY 
   SET RNO = RNO + 1 
   OUTPUT INSERTED.RNO INTO @RE;

   DECLARE @refno VARCHAR(50);
   DECLARE @refno1 VARCHAR(50);
   SELECT TOP 1 
       @refno = 'ONLINE' + CAST(RNO AS VARCHAR),
       @refno1 = 'ONLINE' + CAST(RNO AS VARCHAR)
   FROM @RE;

   DECLARE @time TIME = CONVERT(TIME, GETDATE());

   INSERT INTO NEWSCHEME (
       VOUNO, JID, SCHNAME, SCHCODE, SCHAMT, REGNO, NAME, ADD1, ADD2, ADD3, MOBNO, 
       CASH, CARD, CARDNAME, FLAG, CANCEL, METID, METVAL, GOLDRATE, SILVERRATE, 
       NOMINI, ADHARNO, USERID, accno, refno, [time]
   ) VALUES (
       @vouno, '$jid', '$schName', '$schemeno', CAST('$schAmt' AS NUMERIC), @regno, 
       '$name', '$add1', '$add2', '$add3', '$mobNo', 
       CAST('$cash' AS NUMERIC), CAST('$card' AS NUMERIC), '$cardName', '$flag', '$cancel', 
       '$metId', CAST('$pgrswt' AS NUMERIC), CAST('$goldRate' AS NUMERIC), CAST('$silverRate' AS NUMERIC), 
       '$nomIni', '$adharNo', CAST('$userId' AS INT), '$schemeno' + CAST(@regno AS VARCHAR), 
       @refno, @time
   );

   INSERT INTO MNTHSCHEME (
       VOUNO, ROD, SCHNAME, SCHCODE, SCHAMT, REGNO, CASH, CARD, CARDNAME, 
       CHITID, FLAG, CANCEL, BRANCHID, METVAL, SCHEMEID, GOLDRATE, SILVERRATE, 
       USERID, accno, pgrswt, pnetwt, pamount, 
       TRANS_ID, STATUS, refno, [time]
   ) VALUES (
       @vouno1, '$rod', '$schName', '$schemeno', CAST('$schAmt' AS NUMERIC), @regno, 
       CAST('$cash' AS NUMERIC), CAST('$card' AS NUMERIC), '$cardName', 
       '$chitId', '$flag', '$cancel', '$branchId', 
       '$metval' , '$schemeId', CAST('$goldRate' AS NUMERIC), CAST('$silverRate' AS NUMERIC), 
       CAST('$userId' AS INT), '$schemeno' + CAST(@regno AS VARCHAR), 
       $pgrswt, CAST('$pnetwt' AS NUMERIC), CAST('$pamount' AS NUMERIC), 
       '$Trans_id', '$status', @refno1, @time
   );
""";

      commonUtils.log.i(query);

      String? result = await sqlService.writeData(query);
      if (result != null) {
        commonUtils.log
            .i('New Scheme Data insert successfully in server: $result');
      } else {
        commonUtils.log
            .e('Failed to insert data for item with id ${itemData.schName}');
      }
    }
  }

  static Future<void> updateDataFromServerForPayNow(
      List<MdlJoiningNewScheme> NewJoiningSchemeList,
      String? Trans_id,
      String? status) async {
    final SqlConnectionService sqlService = SqlConnectionService();

    for (var itemData in NewJoiningSchemeList) {
      String jid = itemData.jid;
      String schName = itemData.schName;
      String schCode = itemData.schCode;
      String schAmt = itemData.schAmt;
      String regNo = itemData.regNo;
      String name = itemData.name;
      String add1 = itemData.add1;
      String add2 = itemData.add2;
      String add3 = itemData.add3;
      String mobNo = itemData.mobNo;
      String billDate = itemData.billDate;
      String flag = itemData.flag;
      String cancel = itemData.cancel;
      String branchId = itemData.branchId;
      String metId = itemData.metId;
      String metval = itemData.metval;
      String goldRate = itemData.goldRate;
      String silverRate = itemData.silverRate;
      String nomIni = itemData.nomIni;
      String adharNo = itemData.adharNo;
      String rod = itemData.rod;
      String chitId = itemData.chitId;
      String schemeId = itemData.schemeId;
      String userId = itemData.userId;
      String groupcode = itemData.groupcode;
      String cash = itemData.cash;
      String card = itemData.card;
      String cardName = itemData.cardName;
      String pgrswt = itemData.pgrswt;
      String pnetwt = itemData.pnetwt;
      String pamount = itemData.pamount;
      String schemeno = itemData.schCode;

/*
      String query = '''
      DECLARE @vouno INT
      SELECT @vouno = ISNULL(MAX(vouno), 0) + 1 FROM MNTHSCHEME

      DECLARE @refno VARCHAR(50) = 'ONLINE' + CAST(@regno AS VARCHAR)
      DECLARE @regno INT = $regNo;
DECLARE @refno VARCHAR(50) = 'ONLINE' + CAST(@regno AS VARCHAR);


      INSERT INTO MNTHSCHEME (VOUNO, ROD, SCHNAME, SCHCODE, SCHAMT, REGNO, CASH,CARD,CARDNAME,CHITID, FLAG, CANCEL, BRANCHID, METVAL, SCHEMEID, GOLDRATE, SILVERRATE, USERID, accno,pgrswt,pnetwt,pamount,refno)
      VALUES (@vouno, '$rod', '$schName', '$schemeno', '$schAmt', $regNo, '$cash', '$card', '$cardName', '$chitId', '$flag', '$cancel', '$branchId', '$pgrswt', '$schemeId', '$goldRate', '$silverRate', '$userId', '$schemeno' + CAST($regNo AS VARCHAR),$pgrswt,$pnetwt,$pamount,@refno)
    ''';
*/

      String query = '''
  
DECLARE @vouno INT;
    DECLARE @regno INT = $regNo; -- assign before using
    
    
    DECLARE @RE TABLE (RNO INT);

    UPDATE COMPANY 
    SET RNO = RNO + 1
    OUTPUT INSERTED.RNO INTO @RE;
    
    
    DECLARE @refno VARCHAR(50);


    SELECT TOP 1 
        @refno = 'ONLINE' + CAST(RNO AS VARCHAR)
    
    FROM @RE;
    
    DECLARE @time TIME = CONVERT(TIME, GETDATE());
    SELECT @vouno = ISNULL(MAX(vouno), 0) + 1 FROM MNTHSCHEME;
 
       INSERT INTO MNTHSCHEME (VOUNO, ROD, SCHNAME, SCHCODE, SCHAMT, REGNO, 
       CASH, CARD, CARDNAME, CHITID, FLAG, CANCEL, BRANCHID, METVAL, SCHEMEID,
        GOLDRATE, SILVERRATE, USERID, accno, pgrswt, pnetwt, pamount, TRANS_ID, STATUS, refno,[time])
          VALUES (@vouno, '$rod', '$schName', '$schemeno', '$schAmt', @regno, '$cash', 
          '$card', '$cardName', '$chitId', '$flag', '$cancel', '$branchId', '$pgrswt',
           '$schemeId', '$goldRate', '$silverRate', '$userId', '$schemeno' + CAST(@regno AS VARCHAR),
            '$pgrswt', '$pnetwt', '$pamount', '$Trans_id', '$status',@refno,@time)
''';

/*
      DECLARE @vouno INT;
    DECLARE @regno INT = $regNo; -- assign before using
    DECLARE @refno VARCHAR(50) = 'ONLINE' + CAST(@regno AS VARCHAR);

    SELECT @vouno = ISNULL(MAX(vouno), 0) + 1 FROM MNTHSCHEME;
    INSERT INTO MNTHSCHEME (VOUNO, ROD, SCHNAME, SCHCODE, SCHAMT, REGNO, CASH, CARD, CARDNAME, CHITID, FLAG, CANCEL, BRANCHID, METVAL, SCHEMEID, GOLDRATE, SILVERRATE, USERID, accno, pgrswt, pnetwt, pamount, TRANS_ID, STATUS, refno)
    VALUES (@vouno, '$rod', '$schName', '$schemeno', '$schAmt', @regno, '$cash', '$card', '$cardName', '$chitId', '$flag', '$cancel', '$branchId', '$pgrswt', '$schemeId', '$goldRate', '$silverRate', '$userId', '$schemeno' + CAST(@regno AS VARCHAR), '$pgrswt', '$pnetwt', '$pamount', '$Trans_id', '$status', @refno)
*/

      print(query + 'aaaaaaaaaaaaaaaa');
      commonUtils.log.i(query);

      String? result = await sqlService.writeData(query);
      commonUtils.log.i(result);
      if (result != null) {
        commonUtils.log
            .i('New Scheme Data insert successfully in server: $result');
      } else {
        commonUtils.log
            .e('Failed to insert data for item with id ${itemData.schName}');
      }
    }
  }

  static Future<void> updateDummyDataFromServer(
      List<MdlJoiningNewScheme> NewJoiningSchemeList,
      String Trans_id,
      String status) async {
    final SqlConnectionService sqlService = SqlConnectionService();

    for (var itemData in NewJoiningSchemeList) {
      String jid = itemData.jid;
      String schName = itemData.schName;
      String schCode = itemData.schCode;
      String schAmt = itemData.schAmt;
      String regNo = itemData.regNo;
      String name = itemData.name;
      String add1 = itemData.add1;
      String add2 = itemData.add2;
      String add3 = itemData.add3;
      String mobNo = itemData.mobNo;
      String billDate = itemData.billDate;
      String closeDate = itemData.closeDate;
      commonUtils.log.i(closeDate);
      // DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(closeDate!);
      // String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      String flag = itemData.flag;
      String cancel = itemData.cancel;
      String branchId = itemData.branchId;
      String metId = itemData.metId;
      String metval = itemData.metval;
      String goldRate = itemData.goldRate;
      String silverRate = itemData.silverRate;
      String nomIni = itemData.nomIni;
      String adharNo = itemData.adharNo;
      String rod = itemData.rod;
      String chitId = itemData.chitId;
      String schemeId = itemData.schemeId;
      String userId = itemData.userId;
      String groupcode = itemData.groupcode;
      String cash = itemData.cash;
      String card = itemData.card;
      String cardName = itemData.cardName;
      String pgrswt = itemData.pgrswt;
      String pnetwt = itemData.pnetwt;
      String pamount = itemData.pamount;
      String schemeno = itemData.SCHEMENO;
      String time = itemData.TIME;

      /* String query = """
   DECLARE @vouno INT
      SELECT @vouno = ISNULL(MAX(vouno), 0) + 1 FROM NEWSCHEME

      DECLARE @vouno1 INT
      SELECT @vouno1 = ISNULL(MAX(vouno), 0) + 1 FROM MNTHSCHEME

      DECLARE @regno INT
      DECLARE @MYOUT TABLE (BILLNO INT)
      UPDATE SCHEME SET REGNO = REGNO + 1 OUTPUT INSERTED.REGNO INTO @MYOUT WHERE SCHEMENO = '$schemeno'
      SELECT @regno = BILLNO FROM @MYOUT


	  DECLARE @RE TABLE (RNO INT);


UPDATE COMPANY
SET RNO = RNO + 1
OUTPUT INSERTED.RNO INTO @RE;


DECLARE @refno VARCHAR(50);
DECLARE @refno1 VARCHAR(50);


SELECT TOP 1
    @refno = 'ONLINE' + CAST(RNO AS VARCHAR),
    @refno1 = 'ONLINE' + CAST(RNO AS VARCHAR)
FROM @RE;
DECLARE @time TIME = CONVERT(TIME, GETDATE());

      INSERT INTO NEWSCHEME (VOUNO, JID, SCHNAME, SCHCODE, SCHAMT, REGNO, NAME, ADD1, ADD2, ADD3, MOBNO, CASH, CARD, CARDNAME, FLAG, CANCEL, METID, METVAL, GOLDRATE, SILVERRATE, NOMINI, ADHARNO, USERID, accno, refno, [time])
      VALUES (@vouno, '$jid', '$schName', '$schemeno', '$schAmt', @regno, '$name', '$add1', '$add2', '$add3', '$mobNo', '$cash', '$card', '$cardName', '$flag', '$cancel', '$metId', '$pgrswt', '$goldRate', '$silverRate', '$nomIni', '$adharNo', '$userId', '$schemeno' + CAST(@regno AS VARCHAR), @refno, @time)

      INSERT INTO MNTHSCHEME (VOUNO, ROD, SCHNAME, SCHCODE, SCHAMT, REGNO, CASH, CARD, CARDNAME, CHITID, FLAG, CANCEL, BRANCHID, METVAL, SCHEMEID, GOLDRATE, SILVERRATE, USERID, accno, pgrswt, pnetwt, pamount, TRANS_ID, STATUS, refno,[time])
      VALUES (@vouno1, '$rod', '$schName', '$schemeno', '$schAmt', @regno, '$cash', '$card', '$cardName', '$chitId', '$flag', '$cancel', '$branchId', '$pgrswt', '$schemeId', '$goldRate', '$silverRate', '$userId', '$schemeno' + CAST(@regno AS VARCHAR), '$pgrswt', '$pnetwt', '$pamount', '$Trans_id', '$status', @refno1,@time)""";*/

      String query = """
   DECLARE @vouno INT;
   SELECT @vouno = ISNULL(MAX(vouno), 0) + 1 FROM NEWSCHEME;

   DECLARE @vouno1 INT;
   SELECT @vouno1 = ISNULL(MAX(vouno), 0) + 1 FROM MNTHSCHEME;

   DECLARE @regno INT;
   DECLARE @MYOUT TABLE (BILLNO INT);
   UPDATE SCHEME 
   SET REGNO = REGNO + 1 
   OUTPUT INSERTED.REGNO INTO @MYOUT 
   WHERE SCHEMENO = '$schemeno';
   SELECT @regno = BILLNO FROM @MYOUT;

   DECLARE @RE TABLE (RNO INT);
   UPDATE COMPANY 
   SET RNO = RNO + 1 
   OUTPUT INSERTED.RNO INTO @RE;

   DECLARE @refno VARCHAR(50);
   DECLARE @refno1 VARCHAR(50);
   SELECT TOP 1 
       @refno = 'ONLINE' + CAST(RNO AS VARCHAR),
       @refno1 = 'ONLINE' + CAST(RNO AS VARCHAR)
   FROM @RE;

   DECLARE @time TIME = CONVERT(TIME, GETDATE());

   INSERT INTO AGTN (
       VOUNO, JID, SCHNAME, SCHCODE, SCHAMT, REGNO, NAME, ADD1, ADD2, ADD3, MOBNO, 
       CASH, CARD, CARDNAME, FLAG, CANCEL, METID, METVAL, GOLDRATE, SILVERRATE, 
       NOMINI, ADHARNO, USERID, accno, refno, [time]
   ) VALUES (
       @vouno, '$jid', '$schName', '$schemeno', CAST('$schAmt' AS NUMERIC), @regno, 
       '$name', '$add1', '$add2', '$add3', '$mobNo', 
       CAST('$cash' AS NUMERIC), CAST('$card' AS NUMERIC), '$cardName', '$flag', '$cancel', 
       '$metId', CAST('$pgrswt' AS NUMERIC), CAST('$goldRate' AS NUMERIC), CAST('$silverRate' AS NUMERIC), 
       '$nomIni', '$adharNo', CAST('$userId' AS INT), '$schemeno' + CAST(@regno AS VARCHAR), 
       @refno, @time
   );

   INSERT INTO AGTM (
       VOUNO, ROD, SCHNAME, SCHCODE, SCHAMT, REGNO, CASH, CARD, CARDNAME, 
       CHITID, FLAG, CANCEL, BRANCHID, METVAL, SCHEMEID, GOLDRATE, SILVERRATE, 
       USERID, accno, pgrswt, pnetwt, pamount, 
       TRANS_ID, STATUS, refno, [time]
   ) VALUES (
       @vouno1, '$rod', '$schName', '$schemeno', CAST('$schAmt' AS NUMERIC), @regno, 
       CAST('$cash' AS NUMERIC), CAST('$card' AS NUMERIC), '$cardName', 
       '$chitId', '$flag', '$cancel', '$branchId', 
       CAST('$pgrswt' AS NUMERIC), '$schemeId', CAST('$goldRate' AS NUMERIC), CAST('$silverRate' AS NUMERIC), 
       CAST('$userId' AS INT), '$schemeno' + CAST(@regno AS VARCHAR), 
       $pgrswt, CAST('$pnetwt' AS NUMERIC), CAST('$pamount' AS NUMERIC), 
       '$Trans_id', '$status', @refno1, @time
   );
""";

      commonUtils.log.i(query);

      String? result = await sqlService.writeData(query);
      if (result != null) {
        commonUtils.log
            .i('New Scheme Data insert successfully in server: $result');
      } else {
        commonUtils.log
            .e('Failed to insert data for item with id ${itemData.schName}');
      }
    }
  }
}
