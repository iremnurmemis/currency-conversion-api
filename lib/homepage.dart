
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'currency.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dio dio=new Dio();
  List<String> currencies = [];
  String selectedCurrency = "";
  bool isLoading = false;
  bool isCurrencyLoading = false;
  Currency? currentCurrency;

  @override
  void initState() {
    super.initState();
    BaseOptions options = BaseOptions();
    options.baseUrl = 'https://api.frankfurter.app/';
    dio = new Dio(options);
    getCurrencies();
  }

  Future<void> getCurrency(String code) async {
    setState(() {
      isCurrencyLoading = true;
    });

    final response = await dio.get("latest?from=$code");
    if (response.statusCode == 200) {
      currentCurrency = Currency.fromJson(response.data);
    }
    setState(() {
      isCurrencyLoading = false;
    });
  }

  Future<List<String>> getCurrencies() async {
    setState(() {
      isLoading = true;
    });

    final response = await dio.get("currencies");
    if (response.statusCode == 200) {
      (response.data as Map).forEach((key, value) {
        currencies.add(key);
      });
    }
    setState(() {
      isLoading = false;
    });
    selectedCurrency = currencies[0];
    return currencies;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("CURRENCY API"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text("Currencies : "),
              isLoading
                  ? CircularProgressIndicator()
                  : DropdownButton<String>(
                      value: selectedCurrency,
                      onChanged: (value) async {
                        setState(() {
                          selectedCurrency = value ?? "";
                        });
                        await getCurrency(selectedCurrency);
                      },
                      items: currencies
                          .map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList()),
              SizedBox(
                height: 50,
              ),
              _buildItems,
            ],
          ),
        ),
      )),
    );
  }

  Widget get _buildItems => currentCurrency != null
      ? isCurrencyLoading
      ? CircularProgressIndicator()
      : Column(
    children: [
      Text('Currency : ${currentCurrency?.base ??  "N/A "} '),
      Text("Date : ${currentCurrency?.date?.toString() ?? "N/A"}"),
      ListView.separated(
        separatorBuilder: (_, ind) => Divider(),
        padding: EdgeInsets.all(10),
        controller: ScrollController(),
        shrinkWrap: true,
        itemCount: currentCurrency?.rates?.entries.length ?? 0,
        itemBuilder: (_, index) => ListTile(
          trailing: Text(currentCurrency?.rates?.entries.toList()[index]?.value.toString() ?? ""),
          leading: Text(currentCurrency?.rates?.entries.toList()[index]?.key ?? ""),
        ),
      )
    ],
  )
      : Container();

}
