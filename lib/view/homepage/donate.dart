import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  TextEditingController donationController = TextEditingController();
  String uid = '';
  String fullName = '';
  String email = '';
  String mobileNo = '';
  String Propic = '';


  @override
  void initState() {
    super.initState();
    getUser();
  }
  Future<void> getUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('students').where('uid', isEqualTo: user!.uid).get();
    if(querySnapshot.docs.isNotEmpty){
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      final data = documentSnapshot.data() as Map<String,dynamic>;
      setState(() {
        fullName = data['fullname'];
         Propic = data['profilepic'];
        email = data['email'];
        mobileNo = data['mobileno'];
        uid = data['uid'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('College Donation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Support Our College',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Make a donation to help fund our college programs.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              child: Text('Donate Now'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return DonationBottomSheet(
                      donationController: donationController,
                      onDonate: () {
                        // Add your donation logic here using donationController.text
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DonationBottomSheet extends StatelessWidget {
  final TextEditingController donationController;
  final VoidCallback onDonate;

  DonationBottomSheet({required this.donationController, required this.onDonate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter Donation Amount',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: donationController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            child: Text('Donate'),
            onPressed: onDonate,
          ),
        ],
      ),
    );
  }
}
