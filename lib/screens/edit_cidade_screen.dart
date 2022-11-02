import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cidade_provider.dart';
import '../screens/cidades_screen.dart';

class EditCidadeScreen extends StatefulWidget {
  static const routeName = '/edit-cidade-screen';
  @override
  _EditCidadeScreenState createState() => _EditCidadeScreenState();
}

class _EditCidadeScreenState extends State<EditCidadeScreen> {
  final _form = GlobalKey<FormState>();
  var editedCidade;
  var _newCidade = Cidade(
    id: null,
    cidadeName: '',
  );

  var _initValues = {
    'cidade': '',
  };

  var _isInit = true;
  var _isLoading = false;

  String _textSelect(String str) {
    str = str.replaceAll('ã', 'a');
    str = str.replaceAll('á', 'a');
    str = str.replaceAll('é', 'e');
    str = str.replaceAll('ê', 'e');

    return str;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _newCidade = Provider.of<CidadeProvider>(context, listen: false)
            .findCidadeId(productId.toString());
        _initValues = {
          'cidade': _newCidade.cidadeName.toString(),
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

    if (_newCidade.id != null) {
      await Provider.of<CidadeProvider>(context, listen: false)
          .updateCidade(_newCidade.id.toString(), _newCidade);
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).popAndPushNamed(CidadesScreen.routeName);
    } else {
      await Provider.of<CidadeProvider>(context, listen: false)
          .addCidade(_newCidade)
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
      Navigator.of(context).popAndPushNamed(CidadesScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(
          child: Text('Adicionar nova Cidade'),
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
                            decoration: const InputDecoration(
                                labelText: 'Nome da nova cidade:'),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entre com um NOME.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              editedCidade = _textSelect(value.toString());
                              _newCidade = Cidade(
                                id: _newCidade.id,
                                cidadeName: editedCidade,
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
