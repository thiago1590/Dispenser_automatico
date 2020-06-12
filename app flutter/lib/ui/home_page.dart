import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import "package:flutter/material.dart";

const color = const Color(0xff8FD9DB);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> remedios = Map();

  List proxs = [];
  DateTime proximo, proximo2, proximo3;
  String prox, prox2, prox3, pass;
  var nome;
  List medHr = [];
  List medHrDate = [];
  List medHrString = [];
  int posicao, pos, status1, status2;
  int check = 0;

  void convertDate(List old, List val) {
    DateTime now = new DateTime.now();
    for (int i = 0; i < old.length; i++) {
      String a = old[i];
      String date = "${now.year}-${now.month}-${now.day} $a";
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
      DateTime dateTime = dateFormat.parse(date);
      val.add(dateTime);
    }
    val.sort((a, b) => a.compareTo(b));
  }

  void proximahr(List old) {
    DateTime now = new DateTime.now();
    var dif1 = -100000;
    DateTime hour =
        new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    for (int i = 0; i < old.length; i++) {
      var dif2 = hour.difference(old[i]).inMinutes;
      if (dif2 > dif1 && old[i].isAfter(hour)) {
        proxs.length = 3;
        proximo = old[i];
        DateTime hr = proximo;
        prox = DateFormat('kk:mm').format(hr);
        proxs[0] = prox;
        pos = i;
        check = 1;

        dif1 = hour.difference(old[i]).inMinutes;
      }
    }
    proxs.length = 3;
    if (check == 0) {
      proximo = old[0];
      DateTime hr = proximo;
      prox = DateFormat('kk:mm').format(hr);
      proxs.length = 3;
      proxs[0] = "$prox";
      pos = 0;
    }
    if (pos == 0) {
      proxs.length = 3;
      int tam = old.length;
      DateTime hr1 = old[tam - 1];
      DateTime hr2 = old[tam - 2];
      proxs[1] = DateFormat('kk:mm').format(hr1);
      proxs[2] = DateFormat('kk:mm').format(hr2);
    }
    if (pos == 1) {
      proxs.length = 3;
      DateTime hr1 = old[0];
      DateTime hr2 = old[old.length - 1];
      proxs[1] = DateFormat('kk:mm').format(hr1);
      proxs[2] = DateFormat('kk:mm').format(hr2);
    }
    if (pos > 1) {
      proxs.length = 3;
      DateTime hr1 = old[pos - 1];
      DateTime hr2 = old[pos - 2];
      proxs[1] = DateFormat('kk:mm').format(hr1);
      proxs[2] = DateFormat('kk:mm').format(hr2);
    }
    check = 0;
  }

  void checar() {
    DateTime now = new DateTime.now();
    DateTime hour =
        new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    String date1 = "${now.year}-${now.month}-${now.day} ${proxs[1]}";
    String date2 = "${now.year}-${now.month}-${now.day} ${proxs[2]}";
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    DateTime dateTime1 = dateFormat.parse(date1);
    DateTime dateTime2 = dateFormat.parse(date2);
    if (dateTime1.isBefore(hour)) {
      setState(() {
        status1 = 0;
      }); 
    }
    if (dateTime1.isAfter(hour)) {
      status1 = 1;
    }
    if (dateTime2.isBefore(hour)) {
      status2 = 0;
    }
    if (dateTime2.isAfter(hour)) {
      status2 = 1;
    }
    if (status1 == 1 && status2 == 1) {
      String pass = proxs[1];
      proxs[1] = proxs[2];
      proxs[2] = pass;
    }
    print(status1);
    print(status2);
  }

  void checar2() {
    DateTime now = new DateTime.now();
    DateTime hour =
        new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    String date1 = "${now.year}-${now.month}-${now.day} ${proxs[1]}";
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    DateTime dateTime1 = dateFormat.parse(date1);
    if (dateTime1.isBefore(hour)) {
      status1 = 0;
    }
    if (dateTime1.isAfter(hour)) {
      status1 = 1;
    }
    print(status1);
  }

  void getName() {
    List value = remedios.values.toList();
    List key = remedios.keys.toList();
    String a = prox;
    for (int i = 0; i < remedios.length; i++) {
      if (value[i] == a) {
        posicao = i;
      }
    }
    if (this.mounted) {
      setState(() {
        nome = key[posicao];
      });
    }
  }
  
  void delayFunc() {
    List key = remedios.keys.toList();
    if (remedios.length == 1) {
      proxs.length = 3;
      pass = medHr[0];
      nome = key[0];
    } else if (remedios.length == 2) {
      convertDate(medHr, medHrDate);
      List key = remedios.keys.toList();
      DateTime now = new DateTime.now();
      var dif1 = -100000;
      DateTime hour =
          new DateTime(now.year, now.month, now.day, now.hour, now.minute);
      for (int i = 0; i < medHrDate.length; i++) {
        var dif2 = hour.difference(medHrDate[i]).inMinutes;
        if (dif2 > dif1 && medHrDate[i].isAfter(hour)) {
          
            proxs.length = 2;
            proximo = medHrDate[i];
            DateTime hr = proximo;
            prox = DateFormat('kk:mm').format(hr);
            proxs[0] = prox;
            nome = key[i];
            pos = i;
            check = 1;
          
          dif1 = hour.difference(medHrDate[i]).inMinutes;
        }
      }
      if (check == 0) {
        if(this.mounted){
          setState(() {
          proximo = medHrDate[0];
          DateTime hr = proximo;
          prox = DateFormat('kk:mm').format(hr);
          proxs.length = 2;
          proxs[0] = prox;
          pos = 0;
          nome = key[0];
        });
        }
        
      }
      if (pos == 1) {
        DateTime hr1 = medHrDate[0];
        proxs.length = 2;
        proxs[1] = DateFormat('kk:mm').format(hr1);
      }
      if (pos == 0) {
        DateTime hr1 = medHrDate[1];
        proxs.length = 2;
        proxs[1] = DateFormat('kk:mm').format(hr1);
      }
      check = 0;
      checar2();
    } else {
      convertDate(medHr, medHrDate);
      proximahr(medHrDate);
      getName();
      checar();
    }
    _saveData();
  }

  Widget status(int stat) {
    if (stat == 0) {
      return Row(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: <Widget>[
                Text("Tomado",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600)),
                Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 47,
                )
              ],
            ),
          )
        ],
      );
    }
    if (stat == 1) {
      return Row(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: <Widget>[
                Text("Próximo",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600)),
                Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.black45,
                  size: 47,
                )
              ],
            ),
          )
        ],
      );
    }
  }

  Widget linha() {
    if (remedios.length == 1) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(pass == null ? "" : "$pass",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black.withOpacity(0.6))),
            Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: <Widget>[
                      Text("Próximo",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w600)),
                      Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.black45,
                        size: 47,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
    }
    if (remedios.length == 2) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(proxs[1] == null ? "" : "${proxs[1]}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black.withOpacity(0.6))),
                status(status1 == null ? 0 : status1),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(proxs[0] == null ? "" : "${proxs[0]}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black.withOpacity(0.6))),
                Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: <Widget>[
                          Text("Próximo",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w600)),
                          Icon(
                            Icons.radio_button_unchecked,
                            color: Colors.black45,
                            size: 47,
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }
    if (remedios.length >= 3) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(proxs[2] == null ? "" : "${proxs[2]}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black.withOpacity(0.6))),
                status(status2 == null ? 0 : status2),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${proxs[1]}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black.withOpacity(0.6))),
                status(status1 == null ? 0 : status1),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${proxs[0]}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black.withOpacity(0.6))),
                Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: <Widget>[
                          Text("Próximo",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w600)),
                          Icon(
                            Icons.radio_button_unchecked,
                            color: Colors.black45,
                            size: 47,
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }
  }

  Future dataFuture;
  _getData() async {
    return await getJson();
  }

  Future getJson() async {
    await _readData2().then((data) {
      
        remedios = json.decode(data);
        medHr = remedios.values.toList();
      

      delayFunc();
      _readData().then((data) {
        if(this.mounted){
          setState(() {
          if (data.isNotEmpty) {
            proxs = json.decode(data);
          }
        });
        }
      });
      return proxs;
    });
  }

  @override
  void initState() {
    super.initState();
    dataFuture = _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: FutureBuilder(
        future: dataFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("");
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text("");
            case ConnectionState.done:
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 80),
                      color: color,
                      child: Column(
                        children: <Widget>[
                          Text("Próximo remédio:",
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white)),
                          Divider(thickness: 0),
                          Text(nome == null ? "" : "$nome às",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 45,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text(remedios.length == 1 ? pass : "${proxs[0]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 45,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 45,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Agenda',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                            linha(),
                          ],
                        )),
                  ),
                ],
              );
            default:
              return Text("default");
          }
        },
      ),
    ));
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _getFile2() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data2.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(proxs);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<String> _readData2() async {
    try {
      final file = await _getFile2();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
