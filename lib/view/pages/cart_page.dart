import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appdelivery/view/components/my_add_order.dart';
import 'package:appdelivery/view/components/my_popup_informaddress.dart';
import 'package:appdelivery/view/controllers/order_controller.dart';
import 'package:appdelivery/view/controllers/sacola_controller.dart';
import 'package:appdelivery/view/components/phone_input_field.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> products = [];
  final sacolaController = SacolaController();
  final orderController = OrderController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false; // Variável para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    loadSacola();
  }

  Future<void> loadSacola() async {
    await sacolaController.loadSacolaId();
    if (sacolaController.sacolaAtualId == null) {
      // Cria uma nova sacola se não houver uma ativa
      await sacolaController.createSacola(subtotal: 0.0);
    }
    await sacolaController.fetchProdutosNaSacola();

    if (!mounted) return;
    setState(() {
      products = sacolaController.products;
    });
  }

  void _onOrderCompleted() {
    setState(() {
      products.clear();
      nameController.clear();
      phoneController.clear();
      deliveryType = 'Retirada no balcão';
      paymentMethod = 'cartao';
    });

    // Exibe um SnackBar com a mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pedido adicionado com sucesso!'),
        backgroundColor: const Color.fromARGB(255, 243, 210, 23),
        duration: Duration(seconds: 3),
      ),
    );
  }

  String? deliveryType = 'Retirada no balcão';
  String? paymentMethod = 'cartao';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final double deliveryFee = 5.0;

  @override
  Widget build(BuildContext context) {
    double total = products.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    if (deliveryType == 'Delivery') {
      total += deliveryFee;
    }

    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 229, 184),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Sacola',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 130, 30, 60)),
                    ),
                  ),
                  Divider(
                    indent: 10.0,
                    endIndent: 10.0,
                    color: Colors.black,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final productTotal = formatter
                          .format(product['price'] * product['quantity']);
                      final produtoId = product['id'];
                      return Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${product['quantity']}x',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        fontFamily: 'Arial',
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    SizedBox(width: 20.0),
                                    Text(
                                      '${product['name']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Arial',
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Total: $productTotal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Arial',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Preço Unitário: ${formatter.format(product['price'])}',
                                      style: TextStyle(fontSize: 12)),
                                  Text('Observações: ',
                                      style: TextStyle(fontSize: 12)),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    heightFactor: 0.5,
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.black,
                                      onPressed: () async {
                                        setState(() {
                                          isLoading =
                                              true; // Inicia o carregamento
                                        });

                                        await sacolaController
                                            .removerDaSacola(produtoId);

                                        setState(() {
                                          isLoading =
                                              false; // Finaliza o carregamento
                                          products = sacolaController.products;
                                        });

                                        // Exibe um SnackBar com a mensagem de sucesso
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Produto removido com sucesso!'),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 187, 217, 36),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            subtitleTextStyle: TextStyle(
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 68, 66, 66),
                            ),
                          ),
                          Divider(
                            indent: 10.0,
                            endIndent: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color.fromARGB(255, 130, 30, 60),
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Center(
                            child: Text(
                              'Dados',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 14.0),
                              child: Text(
                                'Nome',
                                style: TextStyle(
                                  fontFamily: 'arial',
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 3),
                            Padding(
                              padding: EdgeInsets.only(left: 14.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 40.0,
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Nome e sobrenome",
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: const Color.fromARGB(
                                          255, 154, 154, 154)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, preencha este campo';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 17),
                            Padding(
                              padding: EdgeInsets.only(left: 14.0),
                              child: Text(
                                'Telefone',
                                style: TextStyle(
                                  fontFamily: 'arial',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 3),
                            Padding(
                              padding: EdgeInsets.only(left: 14.0),
                              child: Container(
                                height: 40.0,
                                width: MediaQuery.of(context).size.width / 2,
                                child: PhoneInputField(
                                    controller: phoneController),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color.fromARGB(255, 130, 30, 60),
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Center(
                            child: Text(
                              'Entrega',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio<String>(
                                    value: 'Retirada no balcão',
                                    groupValue: deliveryType,
                                    onChanged: (value) {
                                      setState(() {
                                        deliveryType = value;
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Retirada no balcão',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Arial',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio<String>(
                                    value: 'Delivery',
                                    groupValue: deliveryType,
                                    onChanged: (value) {
                                      setState(() {
                                        deliveryType = value;
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Delivery',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Arial',
                                    ),
                                  ),
                                  const Text(
                                    '(R\$5,00)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Arial',
                                      color: Color.fromARGB(150, 50, 50, 50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: ElevatedButton.icon(
                              onPressed: deliveryType == 'Delivery'
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MyPopupInformAddress();
                                        },
                                      );
                                    }
                                  : null,
                              icon:
                                  Icon(Icons.location_on, color: Colors.black),
                              label: Text(
                                'Informar Endereço',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.5),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 221, 0),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                disabledBackgroundColor:
                                    const Color.fromARGB(255, 140, 140, 140),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color.fromARGB(255, 130, 30, 60),
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Center(
                            child: Text(
                              'Pagamento',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 30.0, left: 30, top: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'cartao',
                              groupValue: paymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  paymentMethod = value;
                                });
                              },
                            ),
                            const Text('Cartão',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Arial')),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'dinheiro',
                              groupValue: paymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  paymentMethod = value;
                                });
                              },
                            ),
                            const Text('Dinheiro',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Arial')),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'pix',
                              groupValue: paymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  paymentMethod = value;
                                });
                              },
                            ),
                            const Text('Pix',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Arial')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Divider(
                    color: Colors.black,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0, left: 18.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Pedido:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Arial'),
                            ),
                            Spacer(),
                            Text(
                              formatter.format(total -
                                  (deliveryType == 'Delivery'
                                      ? deliveryFee
                                      : 0)),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Arial'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (deliveryType == 'Delivery')
                          Row(
                            children: [
                              const Text(
                                'Frete:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Arial'),
                              ),
                              Spacer(),
                              Text(
                                formatter.format(deliveryFee),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Arial'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 18.0, left: 18, right: 18),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Total: ${formatter.format(total)}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arial'),
                      ),
                    ),
                  ),
                  AddOrderButton(
                    nameController: nameController,
                    phoneController: phoneController,
                    deliveryType: deliveryType!,
                    paymentMethod: paymentMethod!,
                    total: total,
                    products: products
                        .map((product) => product['name'] as String)
                        .toList(),
                    sacolaController: sacolaController,
                    onOrderCompleted: _onOrderCompleted,
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
