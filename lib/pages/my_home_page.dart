import 'dart:io';
import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transactions_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:expenses/components/formulario.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  // ciclos de vida do wiget
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // cilcos de vida do app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);

  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _addTransaction(String title, double value, DateTime selectedDate) {
    setState(() {
      _transactions.add(Transaction(
          id: Random().nextInt(1000).toString(),
          title: title,
          value: value,
          date: selectedDate));
    });
    Navigator.of(context).pop();
  }

  _openShowFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Formulario(_addTransaction);
        });
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  Widget build(BuildContext context) {
    bool _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Despesas Pessoais',
          style:
              TextStyle(fontSize: 20 * MediaQuery.of(context).textScaleFactor)),
      actions: [
        if (_isLandscape)
        IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.show_chart, color: Colors.white),
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            }),

        IconButton(
            icon: Icon(Icons.add_circle, color: Colors.white),
            onPressed: () => _openShowFormModal(context))
      ],
    );
    final media = MediaQuery.of(context);
    final availableSize =
        media.size.height - media.padding.top - appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: SafeArea(child: _transactions.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Nenhuma transacao cadastrada',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 20),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                          height: constraints.maxHeight * 0.60,
                          child: Image.asset(
                            'assets/images/waiting.png',
                            fit: BoxFit.cover,
                          ))
                    ],
                  ),
                );
              },
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_showChart || !_isLandscape)
                    Container(
                        height: availableSize * (_isLandscape ? 0.8 : 0.3),
                        child:  Chart(_recentTransactions)),
                  if (!_showChart || !_isLandscape)
                    Container(
                        height: availableSize * (_isLandscape ? 1 : 0.7),
                        child:  TransactionsList(_transactions, _removeTransaction))
                ],
              ),
            )),
      floatingActionButton: Platform.isIOS ? Container() :      
      FloatingActionButton(
          child: const Icon(Icons.add), onPressed: () => _openShowFormModal(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
