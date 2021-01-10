import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  var _bitcoinDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info Bitcoin"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: [
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 90,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            "1 BTC = \$ ${_bitcoinDetails['rate']}",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getData();
        },
        tooltip: 'Increment',
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }

  getData() async {
    await Future.delayed(Duration(seconds: 1));
    String requestURL = 'https://bitcoin-trackingsv.herokuapp.com/api/btc';
    http.Response response = await http.get(requestURL);

    if (response.statusCode == 200) {
      _bitcoinDetails = jsonDecode(response.body);
      print("ok");
      // var _bitcoinPrice = NumberFormat.currency().format(decodedData['rate']);
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}
