import 'dart:io';

import 'package:agni_chit_saving/modal/MdlProfileScreen.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/screen/My_Savings_Screen.dart';
import 'package:agni_chit_saving/screen/Profile_Screen.dart';
import 'package:agni_chit_saving/screen/Signin_Screen.dart';
import 'package:agni_chit_saving/screen/payment_ledger.dart';
import 'package:agni_chit_saving/screen/rewards.dart';
import 'package:agni_chit_saving/widget/CommonContainer.dart';
import 'package:image_picker/image_picker.dart';

class commonDrawer extends StatefulWidget {
  const commonDrawer({super.key});

  @override
  State<commonDrawer> createState() => _commonDrawerState();
}

class _commonDrawerState extends State<commonDrawer> {
  late Future<List<MdlProfileScreen>> futureMdlProfileScreen;
  List<MdlProfileScreen> allMdlProfileScreen = [];
  List<MdlProfileScreen> filteredMdlProfileScreen = [];
  final List<String> phoneNumbers = ["9498736981", "9842159991"];
  @override
  void initState() {
    super.initState();
    _initializeProfileData();
  }

  Uint8List? imageBytes;
  String imgPath = "";

  Future<void> _initializeProfileData() async {
    futureMdlProfileScreen = _fetchProfileScreen();
    futureMdlProfileScreen.then((profileData) async {
      if (profileData.isNotEmpty) {
        setState(() {
          imgPath = profileData[0].Imgpath;
        });

        await _loadProfileImage(imgPath);
      }
    });
  }

  Future<List<MdlProfileScreen>> _fetchProfileScreen() async {
    try {
      return MdlProfileScreen.fecthProfileScreenquerry();
    } catch (e) {
      commonUtils.log.i('Error fetching item data: $e');
      return [];
    }
  }

  void _showPhoneNumberDialog(BuildContext context) {
    List<String> phoneNumbers = ["9498736981", "9842159991"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("CUSTOMER CARE NO :"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: phoneNumbers.map((number) {
              return GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: number));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Copied: $number"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadProfileImage(String imgPath) async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();*/
    String? filePath = imgPath.toString();
    if (filePath != null) {
      setState(() {
        imgPath = filePath;
      });
      imageBytes = await File(filePath).readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade300,
                  Colors.grey.shade600,
                ],
              ),
            ),
            child: Column(
              children: [
                Stack(children: [
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: imageBytes != null
                                    ? MemoryImage(imageBytes!)
                                    : AssetImage('assets/images/profile.png')
                                        as ImageProvider,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.blue.shade900,
              size: 20,
            ),
            title: const Text(
              'MY PROFILE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/ProfileScreen');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_box,
              color: Colors.blue.shade900,
              size: 20,
            ),
            title: const Text(
              ' JOIN NOW',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/CommonBottomnavigation');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.monetization_on,
              color: Colors.blue.shade900,
              size: 20,
            ),
            title: const Text(
              'PAY DUE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MySavingsScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              color: Colors.blue.shade900,
              size: 20,
            ),
            title: const Text(
              'PAYMENT HISTORY',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => payment_ledger()));
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.Textcolor,
              radius: 16,
              child: Icon(
                Icons.logout,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: const Text(
              'Log Out',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: AppColors.BodyColor,
                    title: Center(
                        child: Text(
                      'LOGOUT',
                      style:
                          commonTextStyleMedium(color: AppColors.CommonColor),
                    )),
                    content: const SingleChildScrollView(
                      child: Column(
                        children: const [
                          Text('Are you sure you want to log out?'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('NO'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context, true);
                          SharedPreferences allPrefs =
                              await SharedPreferences.getInstance();
                          await allPrefs.clear();
                        },
                        child: const Text('YES'),
                      ),
                    ],
                  );
                },
              ).then((value) {
                if (value == true) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SigninScreen()));
                }
              });
            },
          ),
          const SizedBox(
            height: 50,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CUSTOMER CARE NO:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: phoneNumbers.map((number) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: number));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Copied: $number"),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone,
                                      color: Colors.blue, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    number,
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (number != phoneNumbers.last)
                            const Divider(thickness: 1),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
