import "package:flutter/material.dart";
import "package:safetracker/components/mylist_tile.dart";

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onLogout;
  const MyDrawer({
    super.key, 
    required this.onProfileTap, 
    required this.onLogout
    }
    );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            )
          ),
          //home list tile
          MyListTile(
            icon: Icons.home, 
            text:'Home',
            onTap: ()=> Navigator.pop(context) ,
            ),

          //Profile list tile
          MyListTile(
            icon: Icons.person, 
            text: 'Profile', 
            onTap:onProfileTap,
            ),
          MyListTile(
            icon: Icons.logout, 
            text: 'Logout', 
            onTap:onLogout),  
        ],
      ),
    );
  }
}