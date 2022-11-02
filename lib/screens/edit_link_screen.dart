import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/links.dart';
import '../providers/links_provider.dart';
import '../screens/propagandas_screen.dart';

class EditLinksScreen extends StatefulWidget {
  static const routeName = '/edit-link-screen';
  @override
  _EditLinksScreenState createState() => _EditLinksScreenState();
}

class _EditLinksScreenState extends State<EditLinksScreen> {
  final _form = GlobalKey<FormState>();
  var _newLink = Links(
    id: null,
    linkUrl: '',
  );

  var _initValues = {
    'link': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final linkId = ModalRoute.of(context)!.settings.arguments;
      if (linkId != null) {
        _newLink = Provider.of<LinksProvider>(context, listen: false)
            .findLinkId(linkId.toString());
        _initValues = {
          'link': _newLink.linkUrl.toString(),
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

    if (_newLink.id != null) {
      await Provider.of<LinksProvider>(context, listen: false)
          .updateLinks(_newLink.id.toString(), _newLink);
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).popAndPushNamed(PropagandasScreen.routeName);
    } else {
      await Provider.of<LinksProvider>(context, listen: false)
          .addLink(_newLink)
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
      Navigator.of(context).popAndPushNamed(PropagandasScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(
          child: Text('Adicionar novo Link'),
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
                            initialValue: _initValues['link'].toString(),
                            decoration:
                                const InputDecoration(labelText: 'Link  :'),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entre com um LINK.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _newLink = Links(
                                id: _newLink.id,
                                linkUrl: value,
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
