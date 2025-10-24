import 'package:agni_chit_saving/constants/variables.dart';
import 'package:agni_chit_saving/modal/Mdl_MySavings_Scheme.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/widget/CommonDrawer.dart';

class schemeLedger extends StatefulWidget {
  final String customerName;
  final String schemeType;
  final String accNo;
  final String installment;
  final String Weight;
  const schemeLedger(
      {super.key,
      required this.customerName,
      required this.schemeType,
      required this.installment,
      required this.Weight,
      required this.accNo});

  @override
  State<schemeLedger> createState() => _schemeLedgerState();
}

class _schemeLedgerState extends State<schemeLedger> {
  late Future<List<Map<String, dynamic>>> FutureMySavings;

  @override
  void initState() {
    super.initState();
    FutureMySavings = initialData();
  }

  Future<List<Map<String, dynamic>>> initialData() async {
    try {
      return await _fetchNewSchemeData();
    } catch (e) {
      print('Error fetching item data: $e');
      return [];
    }
  }

/*  Future<List<Map<String, dynamic>>> _fetchNewSchemeData() async {
    try {
      String? AccNo = CommonVariables.SchemeLedger;
      String? schemenos = CommonVariables.schemeno;

      List<Map<String, dynamic>> data =
          await MdlMysavingsScheme.fetchDataFromSchemeLedger(
              AccNo!, schemenos!);
      commonUtils.log.i('Fetched data: $data');
      return data;
    } catch (e) {
      commonUtils.log.e('Error fetching item data: $e');
      return [];
    }
  }*/

  Future<List<Map<String, dynamic>>> _fetchNewSchemeData() async {
    try {
      String? AccNo = CommonVariables.SchemeLedger;
      String? schemenos = CommonVariables.schemeno;
      String schemeType = widget.schemeType;

      List<Map<String, dynamic>> data;

      if (schemeType == 'AMOUNT') {
        data = await MdlMysavingsScheme.fetchDataFromSchemeLedger(
            AccNo!, schemenos!);
      } else if (schemeType == 'WEIGHT') {
        data = await MdlMysavingsScheme.fetchDataFromWeightSchemeLedger(
            AccNo!, schemenos!);
      } else {
        data = [];
      }

      commonUtils.log.i('Fetched data: $data');
      return data;
    } catch (e) {
      commonUtils.log.e('Error fetching item data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const commonDrawer(),
      appBar: const CommonAppBar(title: "Scheme Ledger"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: FutureMySavings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            Map<String, dynamic> schemeInfo = snapshot.data!.first;
            String CutomerName = schemeInfo['NAME'] ?? 'N/A';
            String SCHEMETYPE = schemeInfo['SCHEMETYPE'] ?? 'N/A';
            String ACCNO = schemeInfo['ACCNO'] ?? 'N/A';
            String schemeno = schemeInfo['SCHEMENO'] ?? 'N/A';
            String GROUPCODE = schemeInfo['GROUPCODE'] ?? 'N/A';
            String SCHNAME = schemeInfo['SCHNAME'] ?? 'N/A';
            String INSTALLMENT = schemeInfo['INSTALLMENT'] ?? 'N/A';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/body1.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.customerName.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    "NO OF INS: ${widget.installment.toUpperCase()}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.accNo,
                                    style: TextStyle(fontSize: 13)),
                                if (widget.schemeType == 'WEIGHT')
                                  Text(
                                    'Total Weight: ${snapshot.data!.fold<double>(0, (sum, item) => sum + (double.tryParse(item['WEIGHT'] ?? '0') ?? 0)).toStringAsFixed(3)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(widget.schemeType,
                                style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /*       Expanded(
                  child: SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal, // Enables horizontal scrolling
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('VOUNO')),
                        if (widget.schemeType == 'WEIGHT')
                          DataColumn(label: Text('WEIGHT')),
                        DataColumn(label: Text('PAID DATE')),
                        DataColumn(label: Text('PAID AMOUNT')),
                        if (widget.schemeType == 'WEIGHT')
                          DataColumn(label: Text('GOLD RATE')),

                        // DataColumn(label: Text('schemeno')),
                      ],
                      rows: snapshot.data!.map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item['VOUNO'] ?? '')),
                          if (widget.schemeType == 'WEIGHT')
                            DataCell(Text(item['WEIGHT'] ?? '')),
                          DataCell(Text(item['PAID'] ?? '')),
                          DataCell(Text(item['PAIDAMOUNT'] ?? '')),
                          if (widget.schemeType == 'WEIGHT')
                            DataCell(Text(item['RATE'] ?? '')),

                          // DataCell(Text(item['SCHEMENO'] ?? '')),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),*/
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          DataTable(
                            columns: [
                              const DataColumn(label: Text('VOUNO')),
                              if (widget.schemeType == 'WEIGHT')
                                const DataColumn(label: Text('WEIGHT')),
                              const DataColumn(label: Text('PAID DATE')),
                              const DataColumn(label: Text('PAID AMOUNT')),
                              if (widget.schemeType == 'WEIGHT')
                                const DataColumn(label: Text('GOLD RATE')),
                            ],
                            rows: snapshot.data!.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(item['VOUNO'] ?? '')),
                                  if (widget.schemeType == 'WEIGHT')
                                    DataCell(Text(item['WEIGHT'] ?? '')),
                                  DataCell(Text(item['PAID'] ?? '')),
                                  DataCell(Text(item['PAIDAMOUNT'] ?? '')),
                                  if (widget.schemeType == 'WEIGHT')
                                    DataCell(Text(item['RATE'] ?? '')),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
