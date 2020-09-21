import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses_app/widgets/chart.dart';
import 'package:personal_expenses_app/widgets/new_transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';

import 'models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(PersonalExpensesApp());
}

class PersonalExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Expenses',
      theme: ThemeData(
          fontFamily: 'QuickSand',
          primarySwatch: Colors.pink,
          accentColor: Colors.blue,
          errorColor: Colors.redAccent,
          textTheme: TextTheme(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(
                  headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 20)))),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((element) =>
            element.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _openNewTransactionSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(
              onTransactionAdded: _addTransaction,
            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _addTransaction(String txTitle, double txAmount, DateTime date) {
    Transaction transaction = Transaction(
        title: txTitle,
        amount: txAmount,
        date: date,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(transaction);
    });
  }

  double _calculateExactHeight(
      double fraction, MediaQueryData mediaQuery, PreferredSizeWidget appBar) {
    return (mediaQuery.size.height -
            mediaQuery.padding.top -
            appBar.preferredSize.height) *
        fraction;
  }

  List<Widget> _buildLandscapeContent(bool showChart, MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, TransactionList txList) {
    final result = [
      Container(
        height: _calculateExactHeight(0.15, mediaQuery, appBar),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Show chart',
              style: Theme.of(context).textTheme.headline6,
            ),
            Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              },
            ),
          ],
        ),
      )
    ];
    if (showChart) {
      result.add(Container(
        height: _calculateExactHeight(0.85, mediaQuery, appBar),
        child: Chart(
          transactions: _recentTransactions,
        ),
      ));
    } else {
      result.add(
        Container(
          height: _calculateExactHeight(0.85, mediaQuery, appBar),
          child: txList,
        ),
      );
    }
    return result;
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, TransactionList txList) {
    return [
      Container(
        height: _calculateExactHeight(0.3, mediaQuery, appBar),
        child: Chart(
          transactions: _recentTransactions,
        ),
      ),
      Container(
        height: _calculateExactHeight(0.7, mediaQuery, appBar),
        child: txList,
      )
    ];
  }

  Widget _buildCupertinoNavigationBar() {
    return CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () => _openNewTransactionSheet(context),
            child: Icon(CupertinoIcons.add),
          )
        ],
      ),
    );
  }

  Widget _buildMaterialNavigationBar() {
    return AppBar(
      title: Text('My Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openNewTransactionSheet(context),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final txList = TransactionList(
      transactions: _userTransactions,
      onDeleteTransaction: (index) {
        setState(() {
          _userTransactions.removeAt(index);
        });
      },
    );

    final PreferredSizeWidget appBar = Platform.isIOS
        ? _buildCupertinoNavigationBar()
        : _buildMaterialNavigationBar();

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(_showChart, mediaQuery, appBar, txList),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txList)
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _openNewTransactionSheet(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: pageBody);
  }
}
