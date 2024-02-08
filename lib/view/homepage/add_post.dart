import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var fullname;
  var uid;
  var profilepic;
  var downloadurl;
  File? _image;
  final picker = ImagePicker();
  TextEditingController _captionController = TextEditingController();

  CollectionReference post =
  FirebaseFirestore.instance.collection('post');

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,
      imageQuality: 30,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'New Post',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: getImage,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _image == null
                      ? Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20),
           TextField(
                  controller: _captionController,
                  decoration: InputDecoration(
                    hintText: 'Write a caption...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 18),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add code here to save the post
                  setState(() {
                    _image== null || _captionController.text.isEmpty
                        ?  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image or write a caption')))
                        :addPost();
                  });
                },
                child: Text(
                  'Post',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addPost() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('students').where('uid', isEqualTo: user!.uid).get();
    if(querySnapshot.docs.isNotEmpty){
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      final data = documentSnapshot.data() as Map<String,dynamic>;
      setState(() {
        fullname = data['fullname'];
        uid = user.uid;
        profilepic = data['profilepic'];
        upload();
      });
    }
  }
  Future<void> add() async {
    return post.add({
      'uid': uid,
      'fullname': fullname,
      'profilepic': profilepic,
      'caption':_captionController.text,
      'postimage': downloadurl,
      'createdAt': DateTime.now(),
    }).then((value) => print('posted')).catchError((error) => print('Failed to add user: $error'));
}

  Future<void> upload() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference storageRef = fStorage.FirebaseStorage.instance.ref().child("posts").child(uid).child(fileName);
    fStorage.UploadTask uploadTask = storageRef.putFile(File(_image!.path));
    await uploadTask.whenComplete(() async {
      downloadurl = await uploadTask.snapshot.ref.getDownloadURL();
      add();
      clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Posted'),behavior: SnackBarBehavior.floating,backgroundColor: Colors.indigoAccent,));
    });
  }

  void clear() {
    setState(() {
      _image = null;
      _captionController.clear();
    });
  }
}

