import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_adm/screens/frete_screen.dart';

import '../providers/frete_provider.dart';

class EditFreteScreen extends StatefulWidget {
  static const routeName = '/edit-frete-screen';
  @override
  _EditFreteScreenState createState() => _EditFreteScreenState();
}

class _EditFreteScreenState extends State<EditFreteScreen> {
  final _form = GlobalKey<FormState>();
  var _newFrete = Frete(
    id: null,
    valorFrete: '',
  );

  var _initValues = {
    'frete': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final freteId = ModalRoute.of(context)!.settings.arguments;
      if (freteId != null) {
        _newFrete = Provider.of<FreteProvider>(context, listen: false)
            .freteId(freteId.toString());
        _initValues = {
          'frete': _newFrete.valorFrete.toString(),
        };
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm(BuildContext context) async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_newFrete.id != null) {
      await Provider.of<FreteProvider>(context, listen: false)
          .updateFrete(_newFrete.id.toString(), _newFrete);
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).popAndPushNamed(FreteScreen.routeName);
    } else {
      await Provider.of<FreteProvider>(context, listen: false)
          .addFrete(_newFrete)
          .catchError((error) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('A não!'),
            content: const Text(
              'Ocorreu um erro carregando os dados.',
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  child: const Text('Voltar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      });
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).popAndPushNamed(FreteScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(
          child: Text('Adicionar novo Valor de Frete'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _initValues['frete'].toString(),
                            decoration:
                                const InputDecoration(labelText: 'Frete:'),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entre com um VALOR.';
                              }
                              if (double.tryParse(
                                      value.toString().replaceAll(',', '.')) ==
                                  null) {
                                return 'Entre com um VALOR valido.';
                              }
                              if (double.tryParse(
                                      value.toString().replaceAll(',', '.'))! <=
                                  0) {
                                return 'Entre com um VALOR valido.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _newFrete = Frete(
                                id: _newFrete.id,
                                valorFrete:
                                    value.toString().replaceAll(',', '.'),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 120,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blueAccent,
                                    ),
                                    child: Row(
                                      children: const [
                                        Text('SALVAR   '),
                                        Icon(Icons.save, size: 20),
                                      ],
                                    ),
                                    onPressed: () {
                                      _saveForm(context);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 120,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.redAccent,
                                    ),
                                    child: const Text('CANCELAR'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
