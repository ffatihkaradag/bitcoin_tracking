import 'dart:io';

import 'package:bitcoin_tracking/services/Coin.dart';
import 'package:bitcoin_tracking/widgets/CryptoCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCurrency = 'TRY';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};

  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await Coin().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

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
        title: Text("Bitcoin Tracker"),
        actions: [Platform.isIOS ? iOSPicker() : androidDropdown()],
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                cryptoCurrency: 'BTC',
                selectedCurrency: selectedCurrency,
                value: isWaiting ? '?' : coinValues['BTC'],
              ),
              CryptoCard(
                cryptoCurrency: 'ETH',
                selectedCurrency: selectedCurrency,
                value: isWaiting ? '?' : coinValues['ETH'],
              ),
              CryptoCard(
                cryptoCurrency: 'LTC',
                selectedCurrency: selectedCurrency,
                value: isWaiting ? '?' : coinValues['LTC'],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getData();
        },
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
