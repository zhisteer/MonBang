import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Ads/job_ad.dart';
import 'package:monbang/Home/Pages/Ads/search_ad.dart';
import 'package:monbang/Home/Pages/Ads/successful.dart';

import '../containers/post_field.dart';

enum Gender { M, F, O }

enum Term { short, long }

enum Housing { yes, no }

class AddAd extends StatefulWidget {
  AddAd({Key? key}) : super(key: key);

  @override
  State<AddAd> createState() => _AddAdState();
}

class _AddAdState extends State<AddAd> {
  Gender? _gender;
  Term? _term;
  bool genderChecked = false;
  bool termChecked = false;
  String cityValue = "Хотоо сонгоно уу..";
  bool citySelected = false;
  Housing? _housing;
  bool housingChecked = false;
  bool allDone = false;
  bool gotWage = false;
  final _formKeyAd = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController wageController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Ажлын зар нэмэх",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Visibility(
            visible: allDone,
            child: IconButton(
              icon: Icon(Icons.post_add),
              onPressed: () {
                PosttoFire();
              },
            ),
          )
        ],
      ),
      body: ListView(children: [
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 1.0, color: Color.fromARGB(142, 114, 114, 114)),
                ),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Хайж байгаа\n хүний хүйс: "),
                  ),
                  Row(children: [
                    Radio<Gender>(
                      value: Gender.M,
                      groupValue: _gender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _gender = value;
                          genderChecked = true;
                        });
                      },
                    ),
                    Text("Эр")
                  ]),
                  Row(children: [
                    Radio<Gender>(
                      value: Gender.F,
                      groupValue: _gender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _gender = value;
                          genderChecked = true;
                        });
                      },
                    ),
                    Text("Эм"),
                  ]),
                  Row(children: [
                    Radio<Gender>(
                      value: Gender.O,
                      groupValue: _gender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _gender = value;
                          genderChecked = true;
                        });
                      },
                    ),
                    Text(
                      "Хамаагүй",
                    ),
                  ]),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: genderChecked ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Ажиллах\n хугацаа: "),
                  ),
                  SizedBox(
                    width: 26,
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Row(children: [
                          Radio<Term>(
                            value: Term.short,
                            groupValue: _term,
                            onChanged: (Term? value) {
                              setState(() {
                                _term = value;
                                termChecked = true;
                              });
                            },
                          ),
                          Text("1 өдөр"),
                        ]),
                        Row(children: [
                          Radio<Term>(
                            value: Term.long,
                            groupValue: _term,
                            onChanged: (Term? value) {
                              setState(() {
                                _term = value;
                                termChecked = true;
                              });
                            },
                          ),
                          Text("Урт хугацааны"),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: termChecked ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Ажиллах хот: "),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton<String>(
                    value: cityValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        cityValue = newValue!;
                        citySelected = true;
                      });
                    },
                    items: <String>['Хотоо сонгоно уу..', 'Two', 'Free', 'Four']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: citySelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Байртай эсэх: "),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Row(children: [
                          Radio<Housing>(
                            value: Housing.yes,
                            groupValue: _housing,
                            onChanged: (Housing? value) {
                              setState(() {
                                _housing = value;
                                housingChecked = true;
                              });
                            },
                          ),
                          Text("Байртай"),
                        ]),
                        Row(children: [
                          Radio<Housing>(
                            value: Housing.no,
                            groupValue: _housing,
                            onChanged: (Housing? value) {
                              setState(() {
                                _housing = value;
                                housingChecked = true;
                              });
                            },
                          ),
                          Text("Байргүй"),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: housingChecked ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Цалин: "),
                  ),
                  Flexible(
                    child: TextField(
                      controller: wageController,
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      cursorColor: Color.fromARGB(255, 0, 0, 0),
                      decoration: InputDecoration(hintText: "100,000/өдөр"),
                      onChanged: (value) {
                        if (gotWage == false) {
                          setState(() {
                            gotWage = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: gotWage ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 1.0, color: Color.fromARGB(142, 114, 114, 114)),
                  ),
                ),
                child: Form(
                  key: _formKeyAd,
                  child: Column(
                    children: [
                      PostField(
                        hintText: "Гарчиг",
                        controller: titleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("value is empty");
                          }
                        },
                        height: 0.07,
                      ),
                      PostField(
                        hintText: "Агуулга",
                        controller: contentController,
                        onChanged: (value) {
                          if (allDone == false) {
                            setState(() {
                              allDone = true;
                            });
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("value is empty");
                          }
                        },
                        height: 0.25,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }

  PosttoFire() {
    Map<Gender, String> genderToString = {
      Gender.M: "Эрэгтэй",
      Gender.F: "Эмэгтэй",
      Gender.O: "Хамаагүй"
    };
    Map<String, dynamic> jobAd = {
      "gender": genderToString[_gender],
      "term": _term == Term.short ? "1 өдөр" : "Урт хугацааны",
      "city": cityValue,
      "housing": _housing == Housing.yes ? "Байртай" : "Байргүй",
      "title": titleController.text,
      "content": contentController.text,
      "time": FieldValue.serverTimestamp(),
      "wage": wageController.text,
    };
    _firestore
        .collection("Ads")
        .doc("ad")
        .collection("adlist")
        .doc("Ажлын Зар")
        .collection("Ажлын зарнууд")
        .add(jobAd);
    Get.off(() => SearchJob());
  }
}
