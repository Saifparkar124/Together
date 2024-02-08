import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:together/view/homepage/showprofile.dart';


class Search extends StatefulWidget {
  const Search({super.key});
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List SearchResult = [];
  List _resultList = [];

  var msgController = TextEditingController();

  @override
  void initState() {
    msgController.addListener(onSearchChange);
    // TODO: implement initState
    super.initState();
  }
  onSearchChange(){
    print(msgController.text);
    SearchResultList();
  }
  SearchResultList(){
    var showresult = [];
    if(msgController.text != ""){
      for(var clientSnapshot  in SearchResult){
        var fullname = clientSnapshot['fullname'].toString().toLowerCase();
        if(fullname.contains(msgController.text.toLowerCase())){
          showresult.add(clientSnapshot);
        }
      }
    }else{
      showresult = List.from(SearchResult);
    }
    setState(() {
      _resultList = showresult;
    });
  }

  searchFirebase() async {
    final result = await FirebaseFirestore.instance.collection('students').orderBy('fullname').get();

    setState(() {
      SearchResult = result.docs;
    });
    SearchResultList();
  }
@override
  void dispose() {
    msgController.removeListener(onSearchChange);
    msgController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    searchFirebase();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(child: Text("Search your Friend",style: TextStyle(
          fontSize: 20,
          color: Colors.black
        ),)),
        bottom: PreferredSize(
    preferredSize: Size.fromHeight(40),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CupertinoSearchTextField(
      controller: msgController,
      ),
    ),
    )
      ),
      body: ListView.separated(
    itemCount: _resultList.length,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: CachedNetworkImageProvider(_resultList[index]['profilepic']),
        ),
      title: InkWell(
        onTap: (){
          Get.to(ShowProfile(),arguments: [
            {'uid': _resultList[index]['uid']}
          ]);
        },
          child: Text(_resultList[index]['fullname'])),
      subtitle: Text(_resultList[index]['email']),
      );
    }, separatorBuilder: (BuildContext context, int index) {
      return Divider();
      },

      ),);
  }
}




Container buildnoContent() {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/search.json", height: 300),
        ],
      ),
    ),
  );
}
