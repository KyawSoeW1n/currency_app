import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  static const BASE_URL = "http://forex.cbm.gov.mm/api/";
  static const LATEST = "latest";
  static const CURRENCY_LIST_URL = "currencies";
  var chooseDate;
  Map<String, dynamic> rateData;
  List<Map<String, dynamic>> rateDataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Exchange"),
        backgroundColor: Colors.blueGrey,
      ),
      body: rateDataList.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: rateDataList.map((listData) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: ListTile(
                      leading: Text(
                        listData['currency_name'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        listData['currency_value'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  getLatestCurrency(String route) async {
    await http.get(BASE_URL + route).then((response) {
      Map<String, dynamic> responseData = json.decode(response.body);
      rateData = responseData["rates"];
      rateData.forEach((k, v) => addToList('$k', '$v'));
      setState(() {});
    });
  }

  getCurrencyList(String route) async {
    await http.get(BASE_URL + route).then((response) {
      Map<String, dynamic> responseData = json.decode(response.body);
      rateData = responseData["rates"];
      if (rateData != null) rateData.forEach((k, v) => addToList('$k', '$v'));
      setState(() {});
    });
  }

  addToList(String key, String value) {
    Map<String, dynamic> map = {"currency_name": key, "currency_value": value};
    rateDataList.add(map);
  }

  @override
  void initState() {
    super.initState();
    getLatestCurrency(LATEST);
    getCurrencyList(CURRENCY_LIST_URL);
  }
}
