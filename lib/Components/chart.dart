import 'package:despesas_pessoais/Components/chartBar.dart';
import 'package:despesas_pessoais/Models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  List<Transaction> recentTransactions;

  Chart(this.recentTransactions, {super.key});

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var transaction in recentTransactions) {
        bool sameDay = transaction.date.day == weekDay.day;
        bool sameMonth = transaction.date.month == weekDay.month;
        bool sameYear = transaction.date.year == weekDay.year;
        if (sameYear && sameMonth && sameDay) {
          totalSum += transaction.value;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(
        0.0, (sum, transaction) => sum + (transaction['value'] as double));
  }

  @override
  Widget build(BuildContext context) {
    groupedTransactions;
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions
              .map((transaction) => Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      label: transaction['day'].toString(),
                      value: double.tryParse(transaction['value'].toString()) ??
                          0.0,
                      percentage: _weekTotalValue == 0
                          ? 0.0
                          : (transaction['value'] as double) / _weekTotalValue,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
