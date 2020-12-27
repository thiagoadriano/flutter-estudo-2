
import 'package:expenses/components/title_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expenses/models/transaction.dart';


class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  const TransactionsList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctx, index) {
          final tr = transactions[index];
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: FittedBox(
                    child: Text('R\$${tr.value.toStringAsFixed(2)}')
                  ),
                )
              ),
              title: Text(tr.title),
              subtitle: Text(
                DateFormat('dd MMM yy').format(tr.date)
              ),
              trailing: MediaQuery.of(context).size.width > 480 ? 
                FlatButton.icon(
                  onPressed: () => onRemove(tr.id), 
                  icon: Icon(Icons.delete), 
                  label: Text('Excluir'),
                  textColor: Theme.of(context).errorColor
                )
              : IconButton(
                color: Theme.of(context).errorColor,
                icon: Icon(Icons.delete),
                onPressed: () => onRemove(tr.id),
              ),
            )
          );
        }
      );
  }
}