import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:together/view/homepage/add_post.dart';
import 'package:together/view/homepage/donate.dart';
import 'package:together/view/homepage/feed.dart';
import 'package:together/view/homepage/profile.dart';
import 'package:together/view/homepage/searchuser.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!.uid;

  late PageController pageController;

  int _page = 0;

  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigtab(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          FeedPage(),
          Search(),
          AddPost(),
          Profile(),
          DonationPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? Colors.blue : Colors.black54,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? Colors.blue : Colors.black54,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_rounded,
                color: _page == 2 ? Colors.blue : Colors.black54,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                color: _page == 3 ? Colors.blue : Colors.black54,
              ),
              label: ''),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.monetization_on_outlined,
              color: _page == 4 ? Colors.blue : Colors.black54,
            ),
            label: ''),
        ],
        onTap: navigtab,
      ),
    );
  }
}
