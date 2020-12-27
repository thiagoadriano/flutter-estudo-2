import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Formulario extends StatefulWidget {
  final void Function(String, double, DateTime) fn;

  Formulario(this.fn);

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _tituloController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // ciclos de vida do widget stateful
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(Formulario oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _submitForm() {
    if (_tituloController.text.isNotEmpty &&
        _valueController.text.isNotEmpty &&
        _selectedDate != null) {
      this.widget.fn(_tituloController.text,
          double.tryParse(_valueController.text) ?? 0.0, _selectedDate);
      _tituloController.clear();
      _valueController.clear();
    }
  }

  _showDatePicker() {
    showDatePicker(
            context: context,
            firstDate: DateTime(2019),
            lastDate: DateTime.now().add(Duration(days: 61)),
            initialDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom
            ),
            child: Column(children: [
              TextField(
                  controller: _tituloController,
                  onSubmitted: (_) => _submitForm(),
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Titulo')),
              TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submitForm(),
                  maxLength: 8,
                  controller: _valueController,
                  decoration: const InputDecoration(labelText: 'Valor (R\$)')),
              Container(
                height: 70,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedDate != null
                          ? DateFormat('dd/MM/yy').format(_selectedDate)
                          : 'Nenhuma data selecionada!'),
                      FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: const Text(
                            'selecionar Data',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: _showDatePicker)
                    ]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                RaisedButton(
                    onPressed: _submitForm,
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                    child: const Text('Nova Transacao'))
              ])
            ]),
          )),
    );
  }
}
