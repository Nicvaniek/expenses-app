import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem(
      {Key key,
      @required this.transaction,
      @required this.mediaQuery,
      @required this.onDeleteTransaction,
      @required this.indexToDelete})
      : super(key: key);

  final Transaction transaction;
  final int indexToDelete;
  final MediaQueryData mediaQuery;
  final Function onDeleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('R ${transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        trailing: mediaQuery.size.width > 460
            ? FlatButton.icon(
                icon: Icon(Icons.delete),
                label: const Text('Delete'),
                textColor: Theme.of(context).errorColor,
                onPressed: () => onDeleteTransaction(indexToDelete))
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => onDeleteTransaction(indexToDelete),
              ),
      ),
    );
  }
}
