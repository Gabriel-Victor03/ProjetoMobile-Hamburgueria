import 'package:appdelivery/view/components/my_appbar.dart';
import 'package:appdelivery/view/components/my_table.dart';
import 'package:appdelivery/view/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersPages extends StatefulWidget {
  const OrdersPages({super.key});

  @override
  State<OrdersPages> createState() => _OrdersPagesState();
}

class _OrdersPagesState extends State<OrdersPages> {
  final store = OrderController();
  List<Map<String, dynamic>> orders = []; // Changed to dynamic

  @override
  void initState() {
    super.initState();
    loadPedidos();
  }

  void loadPedidos() async {
    List<Map<String, String>> dados = await store.fetchOrders();

    setState(() {
      orders = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [
          SizedBox(height: 30),
          Center(
            child: Text(
              "Pedidos",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 229, 184),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(child: Icon(Icons.checklist)),
                        Expanded(
                          child: Text(
                            'Nº PEDIDO',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'HORÁRIO',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'NOME',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'STATUS',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'DETALHES',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      bool isActive = order['status'] == 'true'; // Check status

                      return Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 229, 184),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Checkbox(
                                value: isActive,
                                onChanged: (value) {
                                  setState(() {
                                    orders[index]['status'] = value! ? 'true' : 'false';
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: Text(
                                order["id"] ?? '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                order["hora"] ?? '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                order["name"] ?? '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                isActive ? 'Finalizado' : 'Andamento',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 130, 30, 60),
                                      padding: EdgeInsets.all(3),
                                      maximumSize: Size(50, 50),
                                      minimumSize: Size(5, 5),
                                    ),
                                    onPressed: () {
                                      openDetails(
                                        order['id'].toString(),
                                        order['name'].toString(),
                                        order['phone'].toString(),
                                        order['total'].toString(),
                                        order['status'].toString(),
                                      );
                                    },
                                    child: Transform.rotate(
                                      angle: 1.64159,
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future openDetails(
    String id,
    String name,
    String phone,
    String total,
    String status,
  ) =>
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            width: 520,
            height: 340,
            child: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: 240,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 24, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Pedido: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(
                              text: id,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      width: 240,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      width: 240,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 24, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Cliente: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(
                              text: name,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              width: 450,
                              padding: EdgeInsets.fromLTRB(3, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 30,
                                    padding: EdgeInsets.only(left: 13),
                                    child: Text(
                                      "Qt",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Produto',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Add',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Observações',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 300,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 260,
                                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(11, 0, 5, 0),
                                                child: Text(
                                                  '0',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                child: Text(
                                                  'teste',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                width: 65,
                                                child: Text(
                                                  '0',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(5, 0, 13, 0),
                                                width: 65,
                                                child: Text(
                                                  'Tudo ok',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 11),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          indent: 0.8,
                                          endIndent: 0.8,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 240,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Entrega: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Delivery",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 240,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Endereço: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Rua 01',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
