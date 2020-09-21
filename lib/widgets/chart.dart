import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> transactions;

  Chart({this.transactions});

  List<Map<String, Object>> get _groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var total = 0.0;
      transactions
          .where((t) =>
              t.date.day == weekDay.day &&
              t.date.month == weekDay.month &&
              t.date.year == weekDay.year)
          .forEach((element) => total += element.amount);
      return {'day': DateFormat.E().format(weekDay), 'amount': total};
    }).reversed.toList();
  }

  double get _totalTransactionValue {
    return _groupedTransactions.fold(
        0.0, (previousValue, element) => previousValue + element['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ..._groupedTransactions.map((e) {
              double amount = e['amount'] as double;
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    topLabel: 'R ${amount.toStringAsFixed(0)}',
                    bottomLabel: e['day'],
                    percentage: _totalTransactionValue > 0
                        ? amount / _totalTransactionValue
                        : 0),
              );
            })
          ],
        ),
      ),
    );
  }
}
