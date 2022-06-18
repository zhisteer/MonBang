import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Ads/inside_ad.dart';

import 'job_ad.dart';

enum Gender { M, F, O }

enum Term { short, long }

enum Housing { yes, no }

class SearchJob extends StatefulWidget {
  const SearchJob({Key? key}) : super(key: key);

  @override
  State<SearchJob> createState() => _SearchJobState();
}

class _SearchJobState extends State<SearchJob> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextStyle searchStyle = TextStyle(color: Colors.white);
  Gender? _gender;
  Term? _term;
  Housing? _housing;
  String cityValue = 'Хотоо сонгоно уу..';
  double _height = 0;
  bool selected = false;
  List allResults = [];
  late Future resultsLoaded;
  List resultsList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getPostInfo();
  }

  @override
  void dispose() {
    resultsList = [];
    super.dispose();
  }

  getPostInfo() async {
    var data = await FirebaseFirestore.instance
        .collection('Ads')
        .doc('ad')
        .collection('adlist')
        .doc("Ажлын Зар")
        .collection("Ажлын зарнууд")
        .orderBy('time', descending: true)
        .get();
    setState(() {
      allResults = data.docs;
    });
    resultsList = allResults;
    return data.docs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_height == 0) {
                  _height = 277;
                } else {
                  _height = 0;
                }
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
        title: const Text(
          "Ажлын зарнууд",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          AnimatedContainer(
              width: size.width,
              height: _height,
              color: Colors.black,
              duration: Duration(milliseconds: 300),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Хүйс: ", style: searchStyle),
                      ),
                      SizedBox(
                        width: 44,
                      ),
                      Row(children: [
                        Radio<Gender>(
                          value: Gender.M,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = value;
                              selected = true;
                            });
                          },
                        ),
                        Text("Эр", style: searchStyle)
                      ]),
                      Row(children: [
                        Radio<Gender>(
                          value: Gender.F,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = value;
                              selected = true;
                            });
                          },
                        ),
                        Text("Эм", style: searchStyle),
                      ]),
                      Row(children: [
                        Radio<Gender>(
                          value: Gender.O,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = value;
                              selected = true;
                            });
                          },
                        ),
                        Text(
                          "Хамаагүй",
                          style: searchStyle,
                        ),
                      ]),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Ажиллах\n хугацаа: ", style: searchStyle),
                      ),
                      SizedBox(
                        width: 26,
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Row(children: [
                              Radio<Term>(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                value: Term.short,
                                groupValue: _term,
                                onChanged: (Term? value) {
                                  setState(() {
                                    _term = value;
                                    selected = true;
                                  });
                                },
                              ),
                              Text(
                                "1 өдөр",
                                style: searchStyle,
                              ),
                            ]),
                            Row(children: [
                              Radio<Term>(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                value: Term.long,
                                groupValue: _term,
                                onChanged: (Term? value) {
                                  setState(() {
                                    _term = value;
                                    selected = true;
                                  });
                                },
                              ),
                              Text(
                                "Урт хугацааны",
                                style: searchStyle,
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ажиллах хот: ",
                          style: searchStyle,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        value: cityValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        dropdownColor: Colors.black,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            cityValue = newValue!;
                            selected = true;
                          });
                        },
                        items: <String>[
                          'Хотоо сонгоно уу..',
                          'Two',
                          'Free',
                          'Four'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Байртай эсэх: ", style: searchStyle),
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Row(children: [
                              Radio<Housing>(
                                value: Housing.yes,
                                groupValue: _housing,
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                onChanged: (Housing? value) {
                                  setState(() {
                                    _housing = value;
                                    selected = true;
                                  });
                                },
                              ),
                              Text("Байртай", style: searchStyle),
                            ]),
                            Row(children: [
                              Radio<Housing>(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                value: Housing.no,
                                groupValue: _housing,
                                onChanged: (Housing? value) {
                                  setState(() {
                                    _housing = value;
                                    selected = true;
                                  });
                                },
                              ),
                              Text(
                                "Байргүй",
                                style: searchStyle,
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(29)),
                          width: 100,
                          child: TextButton(
                              onPressed: () {
                                search();
                              },
                              child: Text(
                                "Хайх",
                                style: TextStyle(color: Colors.black),
                              )),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 0, 0),
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(29)),
                          width: 100,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  selected = false;
                                  search();
                                });
                              },
                              child: Text(
                                "Цэвэрлэх",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              )),
          Expanded(
            child: ListView.builder(
                itemCount: resultsList.length,
                itemBuilder: (BuildContext context, int index) => Post(
                      map: resultsList[index],
                    )),
          ),
        ],
      ),
    );
  }

  search() {
    var showResults = [];
    String termString = '';
    String housingString = '';
    if (_housing == Housing.yes) {
      housingString = "Байртай";
    } else if (_housing == Housing.no) {
      housingString = "Байргүй";
    }
    if (_term == Term.short) {
      termString = "1 өдөр";
    } else if (_term == Term.long) {
      termString = "Урт хугацааны";
    }
    if (selected) {
      Map<Gender, String> genderToString = {
        Gender.M: "Эрэгтэй",
        Gender.F: "Эмэгтэй",
        Gender.O: "Хамаагүй"
      };

      Map<String, dynamic> jobAd = {
        "gender": genderToString[_gender],
        "term": termString,
        "city": cityValue,
        "housing": housingString,
      };
      for (var jobs in allResults) {
        var gender = JobAd.fromSnapshot(jobs).gender;
        var city = JobAd.fromSnapshot(jobs).city;
        var term = JobAd.fromSnapshot(jobs).term;
        var housing = JobAd.fromSnapshot(jobs).housing;
        bool conditionMeets = true;

        if (gender != jobAd['gender']) {
          if (jobAd['gender'] != null) {
            conditionMeets = false;
            print('c');
          }
        }
        if (city != jobAd['city']) {
          if (jobAd['city'] != 'Хотоо сонгоно уу..') {
            conditionMeets = false;
          }
        }
        if (term != jobAd['term']) {
          if (jobAd['term'] != '') {
            print('a');
            conditionMeets = false;
          }
        }
        if (housing != jobAd['housing']) {
          if (jobAd['housing'] != '') {
            conditionMeets = false;
            print('b');
          }
        }
        print(conditionMeets);
        if (conditionMeets) {
          showResults.add(jobs);
        }
      }
    } else {
      showResults = allResults;
    }
    setState(() {
      resultsList = showResults;
      showResults = [];
      _height = 0;
    });
  }
}

class Post extends StatelessWidget {
  DocumentSnapshot map;
  Post({Key? key, required this.map}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(map['title']),
        onTap: () {
          Get.to(() => InsideAd(map: map));
        },
        onLongPress: () {},
        dense: true,
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(map['gender']),
            Text(map['housing']),
            Text(map['city']),
            Text(map['term']),
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
        isThreeLine: false,
      ),
    );
  }
}
