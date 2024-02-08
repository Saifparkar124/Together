import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:together/view/homepage/showprofile.dart';


class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _postsStream;

  @override
  void initState() {
    super.initState();
    _postsStream = _db.collection('post').orderBy('createdAt',descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Feed',style: TextStyle(color: Colors.black,fontSize: 18),),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _postsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final posts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;
              final postDate = (post['createdAt'] as Timestamp).toDate();
              final dateString = DateFormat('MMM d, yyyy').format(postDate);
              final timeString = DateFormat('h:mm a').format(postDate);
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              post['profilepic']
                          )
                        ),
                        title: InkWell(
                          onTap: (){
                            Get.to(ShowProfile(),arguments: [
                              {"uid": post['uid']}
                            ]);
                          },
                            child: Text(post['fullname'])),
                        subtitle: Text('$dateString at $timeString'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(post['caption']),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child: SizedBox(
                          width: 500,
                          height: 250,
                          child: CachedNetworkImage(imageUrl: post['postimage'],
                          imageBuilder:(context, imageProvider) => Container(
                            height: 250,
                            width: 500,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: imageProvider
                              )
                            ),
                          ),
                            placeholder: (context, url) => Lottie.asset('assets/loadpost.json'),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      ),
                      ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
