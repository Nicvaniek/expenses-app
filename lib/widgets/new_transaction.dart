import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function onTransactionAdded;

  NewTransaction({this.onTransactionAdded});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate;

  void createTransaction() {
    final title = titleController.text;
    final amount = amountController.text;

    if (title.isEmpty ||
        amount.isEmpty ||
        double.parse(amount) <= 0 ||
        _selectedDate == null) {
      return;
    }
    widget.onTransactionAdded(title, double.parse(amount), _selectedDate);
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        // pressed cancel
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: titleController,
                onSubmitted: (_) => createTransaction(),
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: amountController,
                onSubmitted: (_) => createTransaction(),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(_selectedDate == null
                          ? 'No date chosen!'
                          : 'Chosen date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                    ),
                    AdaptiveFlatButton(
                      text: 'Choose date',
                      handler: _showDatePicker,
                    )
                  ],
                ),
              ),
              Platform.isIOS
                  ? Container(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: Theme.of(context).primaryColor,
                        child: Text('Add transaction'),
                        onPressed: createTransaction,
                      ),
                    )
                  : RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).textTheme.button.color,
                      child: Text('Add transaction'),
                      onPressed: createTransaction)
            ],
          ),
        ),
      ),
    );
  }
}
