import 'package:flutter/material.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/providers/review_cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:raj_eat/providers/user_provider.dart';
import 'package:raj_eat/providers/wishlist_provider.dart';
import 'package:raj_eat/screens/notification/notification.dart';
import 'package:raj_eat/screens/review_cart/review_cart.dart';
import 'package:raj_eat/screens/my_profile/my_profile.dart';
import 'package:raj_eat/screens/wishList/wish_list.dart';



import 'home_screen.dart';

class DrawerSide extends StatefulWidget {
  final UserProvider userProvider;
  const DrawerSide({super.key, required this.userProvider});

  @override
  _DrawerSideState createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  Widget listTile({String title = '', IconData iconData = Icons.error,
    void Function()? onTap, // Specify onTap as a nullable function
  }) {
    return ListTile(

      onTap: onTap ?? () {}, // Use onTap if provided, otherwise use an empty function
      leading: Icon(
        iconData,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),

    );

  }



  @override
  Widget build(BuildContext context) {
    var userData = widget.userProvider.currentUserData;
    return Drawer(
      child: Container(

        color: primaryColor,
        child: ListView(
          children: [
            DrawerHeader(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 43,
                      backgroundColor: Colors.white54,
                      child: CircleAvatar(
                        backgroundColor: Colors.yellow,
                        backgroundImage: NetworkImage(userData?.userImage ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwxJM9PX5vBMVEDgnR_bqroYBU8l6EGJ7F1g&s"),
                        radius: 40,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(userData?.userName ?? ''),
                        Text(
                          userData?.userEmail ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),



                  ],

                ),
              ),
            ),
            listTile(iconData: Icons.home_max_outlined,title: "Home",
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()),);
                }),
            listTile(
              iconData: Icons.shop_outlined,
              title: "Review Cart",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Consumer<ReviewCartProvider>(
                      builder: (context, reviewCartProvider, _) => ReviewCart(
                        reviewCartProvider: reviewCartProvider,
                      ),
                    ),
                  ),
                );
              },
            ),

            listTile(iconData: Icons.person_outline,title: "My Profile",onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile(userProvider:widget.userProvider)),);
            } ),
            listTile(iconData: Icons.notifications_outlined,title: "notification",
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()),);
                }),

            listTile(
              iconData: Icons.favorite_outline,
              title: "Wishlist",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Consumer<WishListProvider>(
                      builder: (context, wishListProvider, _) =>  WishLsit(
                        wishListProvider: wishListProvider,
                      ),
                    ),
                  ),
                );
              },
            ),


            listTile(iconData: Icons.copy_outlined,title: "raise a complaint"),
            Container(
              height: 350,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Text("contact support"),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("call us:"),
                      SizedBox(
                        width: 10,
                      ),
                      Text("92106824"),
                    ],
                  ),
                  SizedBox(height: 5,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                  ),
                  Row(
                    children: [
                      Text("Mail us:"),
                      SizedBox(
                        width: 10,
                      ),
                      Text("mezraninader@gmail.com",overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}