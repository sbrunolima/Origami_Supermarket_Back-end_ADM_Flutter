import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final setores = [
    'Sem Setor',
    'Hortifruti',
    'Acougue',
    'Congelados',
    'Resfriados',
    'Padaria',
    'Paes e Bolos',
    'Mercearia',
    'Matinais',
    'Biscoitos',
    'Bebidas',
    'Limpeza',
    'Perfumaria',
    'Pet Shop',
  ];

  final oferta = [
    'SIM',
    'NÃO',
  ];

  final granel = [
    'SIM',
    'NÃO',
  ];

  final _priceFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _newProduct = Product(
    id: null,
    title: '',
    price: '',
    offerPrice: '',
    imageUrl: '',
    sector: '',
    oferta: false,
    granel: false,
  );

  var _initValues = {
    'title': '',
    'price': '',
    'offerPrice': '',
    'imageUrl': '',
    'sector': '',
    'oferta': false,
    'granel': false,
  };

  String? novoSetor;
  String? novaOferta;
  String? novaGranel;
  var _isOferta;
  var _isGranel;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _newProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId.toString());
        _initValues = {
          'title': _newProduct.title.toString(),
          'price': _newProduct.price.toString(),
          'offerPrice': _newProduct.offerPrice.toString(),
          'imageUrl': '',
          'sector': _newProduct.sector.toString(),
          'oferta': _newProduct.oferta,
          'granel': _newProduct.granel,
        };
        _imageUrlController.text = _newProduct.imageUrl.toString();
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
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

    if (_newProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_newProduct.id.toString(), _newProduct);
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      await Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_newProduct)
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
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(
          child: Text('Adicionar ou Editar Produto'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
              ),
              child: Row(
                children: const [
                  Text('SALVAR '),
                  Icon(Icons.save, size: 20),
                ],
              ),
              onPressed: () {
                // Verifica se o setor está vazio, evitando NULL

                _saveForm(context);
              },
            ),
          ),
          const SizedBox(width: 60),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'].toString(),
                      decoration: const InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entre com um NOME.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: value,
                          price: _newProduct.price,
                          offerPrice: _newProduct.offerPrice,
                          imageUrl: _newProduct.imageUrl,
                          sector: novoSetor == null
                              ? _newProduct.sector
                              : novoSetor,
                          oferta: _isOferta == null
                              ? _newProduct.oferta
                              : _isOferta,
                          granel: _isGranel == null
                              ? _newProduct.granel
                              : _isGranel,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: _initValues['price'].toString(),
                      decoration:
                          const InputDecoration(labelText: 'Preço do Produto'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entre com um PREÇO.';
                        }
                        if (double.tryParse(
                                value.toString().replaceAll(',', '.')) ==
                            null) {
                          return 'Entre com um PREÇO valido.';
                        }
                        if (double.tryParse(
                                value.toString().replaceAll(',', '.'))! <=
                            0) {
                          return 'Entre com um PREÇO valido.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: _newProduct.title,
                          price: value.toString().replaceAll(',', '.'),
                          offerPrice: _newProduct.offerPrice,
                          imageUrl: _newProduct.imageUrl,
                          sector: novoSetor == null
                              ? _newProduct.sector
                              : novoSetor,
                          oferta: _isOferta == null
                              ? _newProduct.oferta
                              : _isOferta,
                          granel: _isGranel == null
                              ? _newProduct.granel
                              : _isGranel,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: _initValues['offerPrice'].toString(),
                      decoration:
                          const InputDecoration(labelText: 'Preço em Oferta'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (double.tryParse(
                                  value.toString().replaceAll(',', '.')) ==
                              null) {
                            return 'Entre com um PREÇO valido.';
                          }
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: _newProduct.title,
                          price: _newProduct.price,
                          offerPrice: value.toString().isEmpty
                              ? '0.0'
                              : value.toString().replaceAll(',', '.'),
                          imageUrl: _newProduct.imageUrl,
                          sector: novoSetor == null
                              ? _newProduct.sector
                              : novoSetor,
                          oferta: _isOferta == null
                              ? _newProduct.oferta
                              : _isOferta,
                          granel: _isGranel == null
                              ? _newProduct.granel
                              : _isGranel,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 6, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Entre com o LINK',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Link da Imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm(context);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entre com um LINK valido.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Entre com um LINK valido.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Entre com um LINK valido.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _newProduct = Product(
                                id: _newProduct.id,
                                title: _newProduct.title,
                                price: _newProduct.price,
                                offerPrice: _newProduct.offerPrice,
                                imageUrl: value,
                                sector: novoSetor == null
                                    ? _newProduct.sector
                                    : novoSetor,
                                oferta: _isOferta == null
                                    ? _newProduct.oferta
                                    : _isOferta,
                                granel: _isGranel == null
                                    ? _newProduct.granel
                                    : _isGranel,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  observerAba('Setor Atual:', _newProduct.sector.toString()),
                  const SizedBox(height: 10),
                  _newProduct.oferta
                      ? observerAba('Observações:', 'Item em Oferta')
                      : observerAba('Observações:', 'Nenhuma'),
                  const SizedBox(height: 10),
                  _newProduct.granel
                      ? observerAba('Granel?', 'Sim')
                      : observerAba('Granel?', 'Não'),
                  const SizedBox(height: 10),
                  dropMenuSetor('Setor do Produto:', novoSetor),
                  const SizedBox(height: 10),
                  dropMenuOferta('Produto em Oferta?', novaOferta),
                  const SizedBox(height: 10),
                  dropMenuGranel('Produto a Granel?', novaGranel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget observerAba(String title, String sector) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      sector.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropMenuSetor(String title, var dado) {
    return ListTile(
      leading: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(6)),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton<String>(
                    hint: _newProduct.sector.toString().isEmpty
                        ? const Text(
                            'Obrigatório',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          )
                        : Text(
                            '${_newProduct.sector.toString()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                    value: dado,
                    iconSize: 36,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                    isExpanded: true,
                    items: setores.map(buildSetoresMenu).toList(),
                    onChanged: (value) => setState(() {
                      this.novoSetor = value;
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropMenuOferta(String title, var dado) {
    return ListTile(
      leading: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(6)),
            child: DropdownButtonHideUnderline(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  hint: _newProduct.oferta == true
                      ? Text(
                          'SIM',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          'NÃO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                  value: dado,
                  iconSize: 36,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  isExpanded: true,
                  items: oferta.map(buildOfertasMenu).toList(),
                  onChanged: (value) => setState(() {
                    this.novaOferta = value;
                    if (value == 'SIM') {
                      _isOferta = true;
                    } else {
                      _isOferta = false;
                    }
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropMenuGranel(String title, var dado) {
    return ListTile(
      leading: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(6)),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton<String>(
                    hint: _newProduct.granel == true
                        ? Text(
                            'SIM',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'NÃO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                    value: dado,
                    iconSize: 36,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                    isExpanded: true,
                    items: granel.map(buildOfertasMenu).toList(),
                    onChanged: (value) => setState(() {
                      this.novaGranel = value;
                      if (value == 'SIM') {
                        _isGranel = true;
                      } else {
                        _isGranel = false;
                      }
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildSetoresMenu(String setor) => DropdownMenuItem(
        value: setor,
        child: Text(
          setor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  DropdownMenuItem<String> buildOfertasMenu(String setor) => DropdownMenuItem(
        value: setor,
        child: Text(
          setor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  DropdownMenuItem<String> buildGranelMenu(String setor) => DropdownMenuItem(
        value: setor,
        child: Text(
          setor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
