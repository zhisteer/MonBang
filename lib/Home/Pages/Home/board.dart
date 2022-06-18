import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Home/create.dart';
import 'package:monbang/Home/Pages/Home/home.dart';
import 'package:monbang/Home/Pages/Home/post.dart';
import 'package:monbang/Login/components/users.dart';
import '../../home_screen.dart';
import 'post_class.dart';
import 'package:jiffy/jiffy.dart';
import 'package:characters/characters.dart';

class FreeBoard extends StatefulWidget {
  FreeBoard({Key? key}) : super(key: key);

  @override
  State<FreeBoard> createState() => _FreeBoardState();
}

class _FreeBoardState extends State<FreeBoard> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  List allResults = [];
  late Future resultsLoaded;
  List resultsList = [];
  Users loggedInUser = Users();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getPostInfo();
  }

  @override
  void dispose() {
    _searchController.removeListener(onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != '') {
      for (var postSnapshot in allResults) {
        var title = ThisPost.fromSnapshot(postSnapshot).title.toLowerCase();
        var body = ThisPost.fromSnapshot(postSnapshot).body.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase()) ||
            body.contains(_searchController.text.toLowerCase())) {
          showResults.add(postSnapshot);
        }
      }
    } else {
      showResults = allResults;
    }
    setState(() {
      resultsList = showResults;
    });
  }

  getPostInfo() async {
    var data = await _firestore
        .collection('posts')
        .doc('free')
        .collection('posts')
        .orderBy('time', descending: true)
        .get();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.email)
        .get()
        .then((value) {
      loggedInUser = Users.fromMap(value.data());
    });
    setState(() {
      allResults = data.docs;
    });
    searchResultsList();
    return data.docs;
  }

  Future<void> _refresh() async {
    await getPostInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.off(() => HomeScreen()),
          ),
          backgroundColor: Colors.black,
          title: Container(
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.white, width: 2),
            )),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
            ),
          )),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          await getPostInfo();
          setState(() {});
        },
        child: ListView.builder(
            itemCount: resultsList.length,
            itemBuilder: (BuildContext context, int index) => Post(
                  map: resultsList[index],
                  loggedInUser: loggedInUser.name,
                )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreatePost()));
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Post extends StatelessWidget {
  DocumentSnapshot map;
  String? loggedInUser;
  Post({Key? key, required this.map, required this.loggedInUser})
      : super(key: key);
  List comments = [];
  bool gotComments = false;
  String postId = '';

  getPostId() async {
    postId = map.reference.id;
  }

  @override
  Widget build(BuildContext context) {
    String subtitle = (map['body'] as String).characters.take(50).toString();
    DateTime time = (map['time'] as Timestamp).toDate();
    String timeAgo = Jiffy(time).fromNow();
    String postBy = "Nuutsaa";
    if (map["anon"] == false) {
      postBy = map["postby"];
    }
    return Card(
      child: ListTile(
        title: Text(map['title']),
        onTap: () async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Center(
                    child: CircularProgressIndicator(),
                  ));
          try {
            await getPostId();
          } on FirebaseException catch (e) {
            print(e);
          }

          Get.back();
          Get.to(() => InsidePost(
                title: map['title'],
                body: map['body'],
                postBy: postBy,
                postId: postId,
                realName: map['postby'],
                myName: map['posteremail'],
              ));
        },
        onLongPress: () {},
        dense: false,
        subtitle: Text(
          '$subtitle \n\n$timeAgo | $postBy',
        ),
        trailing: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.thumb_up,
                    size: 20,
                  ),
                ),
                Text((map['likes'].length - map['dislikes'].length).toString()),
                const Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.comment,
                    size: 20,
                  ),
                ),
                Text((map['likes'].length - map['dislikes'].length).toString())
              ],
            )
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
