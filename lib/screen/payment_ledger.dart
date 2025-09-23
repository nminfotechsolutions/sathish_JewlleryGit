import 'package:agni_chit_saving/constants/app_loader.dart';
import 'package:agni_chit_saving/modal/Mdl_Transaction.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/widget/CommonDrawer.dart';

class payment_ledger extends StatefulWidget {
  const payment_ledger({super.key});

  @override
  State<payment_ledger> createState() => _payment_ledgerState();
}

class _payment_ledgerState extends State<payment_ledger> {
  String Companyname = '';

  late Future<List<MdlTransaction>> FutureMySavings = Future.value([]);
  @override
  void initState() {
    super.initState();
    FutureMySavings = _fetchNewSchemeData();
    Companyname = SharedPreferencesHelper.getString('company_name') ?? '';
  }

  Future<List<MdlTransaction>> _fetchNewSchemeData() async {
    try {
      return MdlTransaction.fetchDataFromSavings();
    } catch (e) {
      print('Error fetching item data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: commonDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              'https://www.bneedsbill.com/flutterimg/agnisoftimg/Companylogo.png',
              height: 40,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              Companyname,
              style: TextStyle(
                color: Color(0XFF953130),
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Transaction History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<MdlTransaction>>(
                future: FutureMySavings,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: AppLoader.circularProgress());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No transactions found today."));
                  }

                  List<MdlTransaction> ledgerList = snapshot.data!;

                  return RefreshIndicator(
                    onRefresh: _fetchNewSchemeData,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: ledgerList.length,
                      itemBuilder: (context, index) {
                        var item = ledgerList[index];
                        commonUtils.log.i(item);
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            title: Text(
                              item.name.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "VNO : ${item.vouno}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent.shade100,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "RS : ${item.AMOUNT}",
                                      style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("PAID DATE: ${item.rod}",
                                          style: TextStyle(
                                            color: Colors.teal.shade800,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Spacer(),
                                    Expanded(
                                      child: Text("Id : ${item.tran_id}",
                                          style: TextStyle(
                                              color: Colors.grey.shade700)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
