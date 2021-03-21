//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      import 'package:flutter/material.dart';
//
//class Historique extends StatefulWidget {
//  @override
//  _HistoriqueState createState() => _HistoriqueState();
//}
//
//class _HistoriqueState extends State<Historique> {
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Scaffold(
//      appBar: AppBar(title: Text("E-target",textScaleFactor: 1.5,),centerTitle: true,),
//      body: Padding(
//        padding: const EdgeInsets.all(20),
//        child: Column(
//          children: <Widget>[
//            Center(child: Text("HISTORIQUE",textScaleFactor: 2,)),
//            Center(child: Text("Test de TabBar",textScaleFactor: 1.2,style: TextStyle(color: Colors.red),)),
//            Container(
//              height: 500,
//              child: DefaultTabController(
//                length: 2,
//                child: Scaffold(
//appBar: TabBar(
//
//unselectedLabelColor: Colors.grey,
//tabs: [
//Tab(
////                         text: "Instantané",
//icon: Icon(Icons.message),
//child: Container(
//padding: EdgeInsets.all(10),
//decoration: BoxDecoration(
//color: Colors.blue,
//borderRadius: BorderRadius.all(Radius.circular(20))
//),
//child: Text("Instantané"),
//),
//),
//Tab(text: "Groupé",icon: Icon(Icons.message),),
//],
//),
//body: TabBarView(
//children: [
//Container(
//color: Colors.green,
//child: Center(
//child: Text("Historique des Messages instantanés"),
//),
//),
//Container(
//color: Colors.blue,
//child: Center(
//child: Text("Historique des Messages groupés"),
//),
//),
//]
//),
//),
//),
//),
//],
//),
//),
//
//);
//}
//}
//

import 'package:flutter/material.dart';


/// This Widget is the main application widget.
class Historique extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final _controller = TextEditingController();

  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(6),
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
      ),
    );
  }
}
