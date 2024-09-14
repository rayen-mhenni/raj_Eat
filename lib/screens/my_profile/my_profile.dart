import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Import for image_picker
import 'package:firebase_storage/firebase_storage.dart'; // Import for firebase_storage
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/providers/user_provider.dart';
import 'package:raj_eat/screens/home/drawer_side.dart';
import 'package:raj_eat/screens/my_profile/my_order.dart';
import 'package:raj_eat/screens/reservation/table_reservation_page.dart';
import 'package:raj_eat/singin/login_page.dart'; // Import LoginPage

class MyProfile extends StatefulWidget {
  final UserProvider userProvider;
  const MyProfile({super.key, required this.userProvider});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.userProvider.currentData?.userImage; // Initialize with the current image
  }

  Future<void> _updateProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/${DateTime.now().toString()}');
      final uploadTask = storageRef.putFile(file);

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update user profile image URL in provider and Firestore
      await widget.userProvider.updateUserProfileImage(downloadUrl);

      setState(() {
        _imageUrl = downloadUrl; // Update the local state with the new URL
      });
    }
  }

  Widget listTile({
    IconData icon = Icons.error,
    String title = '',
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        const Divider(height: 1),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var userData = widget.userProvider.currentData;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: 18,
            color: textColor,
          ),
        ),
      ),
      drawer: DrawerSide(userProvider: widget.userProvider),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 100,
                color: primaryColor,
              ),
              Container(
                height: 548,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 250,
                          height: 80,
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData?.userName ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(userData?.userEmail ?? ''),
                                ],
                              ),
                              GestureDetector(
                                onTap: _updateProfileImage,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: primaryColor,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: scaffoldBackgroundColor,
                                    child: Icon(
                                      Icons.edit,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    listTile(
                      icon: Icons.shop_outlined,
                      title: "My Orders",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyOrder(),
                          ),
                        );
                      },
                    ),
                    listTile(
                      icon: Icons.location_on_outlined,
                      title: "My Delivery Address",
                      onTap: () {
                        // Handle My Delivery Address tap
                      },
                    ),
                    listTile(
                      icon: Icons.person_outline,
                      title: "Reservation",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TableReservationPage(),
                          ),
                        );
                      },
                    ),
                    listTile(
                      icon: Icons.exit_to_app_outlined,
                      title: "Log Out",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 30),
            child: GestureDetector(
              onTap: _updateProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: primaryColor,
                child: CircleAvatar(
                  backgroundImage: _imageUrl != null
                      ? NetworkImage(_imageUrl!)
                      : NetworkImage(
                    userData?.userImage ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwxJM9PX5vBMVEDgnR_bqroYBU8l6EGJ7F1g&s",
                  ),
                  radius: 45,
                  backgroundColor: scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
