import 'package:flutter/material.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/providers/user_provider.dart';


import 'package:raj_eat/screens/home/drawer_side.dart';
class MyProfile extends StatefulWidget {
  final UserProvider userProvider;
  MyProfile({required this.userProvider});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget listTile({IconData icon = Icons.error, String title=''}) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }

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
        drawer: DrawerSide( userProvider: widget.userProvider,),
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
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
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
                      padding: EdgeInsets.only(left: 20),
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
                                    color: textColor),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                userData?.userEmail ??'',

                              ),
                            ],
                        ),
                       CircleAvatar(
                         radius: 15,
                         backgroundColor: primaryColor,
                         child: CircleAvatar(
                           radius: 12,
                           child: Icon(
                             Icons.edit,
                             color: primaryColor,
                           ),
                           backgroundColor: scaffoldBackgroundColor,
                         ),
                      ),
                          ],
                      ),
                    ),
                  ],
              ),
                listTile(icon: Icons.shop_outlined, title: "My Orders"),
                listTile(
                    icon: Icons.location_on_outlined,
                    title: "My Delivery Address"),
                listTile(
                    icon: Icons.person_outline, title: "Refer A Friends"),


                listTile(
                    icon: Icons.exit_to_app_outlined, title: "Log Out"),
          ],
          ),
        ),
        ],
      ),
       Padding(
         padding: const EdgeInsets.only(top: 40, left: 30),
        child: CircleAvatar(
         radius: 50,
            backgroundColor: primaryColor,
         child: CircleAvatar(
           backgroundImage: NetworkImage(
               userData?.userImage ??
               "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwxJM9PX5vBMVEDgnR_bqroYBU8l6EGJ7F1g&s"
           ),
          radius: 45,
    backgroundColor: scaffoldBackgroundColor),

    ),

    ),

    ],
      ),

    );
  }
}