import 'package:expenses/components/chart_bart.dart';
import 'package:expenses/components/title_card.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      final dayLetter = DateFormat.E().format(weekDay)[0];
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        final tr = recentTransactions[i];
        bool sameDay = tr.date.day == weekDay.day;
        bool sameMonth = tr.date.month == weekDay.month;
        bool sameYear = tr.date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += tr.value;
        }
      }

      return {
        'day': dayLetter,
        'value': totalSum,
      };
    });
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, item) => sum + item['value']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.reversed.map((tr) {
            return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                label: tr['day'],
                value: tr['value'],
                percent: _weekTotalValue == 0 ? 0 : (tr['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList()
        ),
      ),
    );
  }
}
