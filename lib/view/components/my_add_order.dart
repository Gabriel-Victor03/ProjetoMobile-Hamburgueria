import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:appdelivery/view/controllers/sacola_controller.dart';

class AddOrderButton extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final String deliveryType;
  final String paymentMethod;
  final double total;
  final List<String> products;
  final SacolaController sacolaController;
  final VoidCallback onOrderCompleted;

  const AddOrderButton({
    Key? key,
    required this.nameController,
    required this.phoneController,
    required this.deliveryType,
    required this.paymentMethod,
    required this.total,
    required this.products,
    required this.sacolaController,
    required this.onOrderCompleted,
  }) : super(key: key);

  @override
  _AddOrderButtonState createState() => _AddOrderButtonState();
}

class _AddOrderButtonState extends State<AddOrderButton> {
  bool _isProcessing = false;

  final Map<String, String> deliveryTypeIds = {
    'Retirada no balcão': '11dSCRWhfh',
    'Delivery': 'xGkqFvXENJ',
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200.0,
        child: ElevatedButton.icon(
          onPressed: _isProcessing
              ? null
              : () async {
                  setState(() {
                    _isProcessing = true;
                  });

                  final deliveryTypeId = deliveryTypeIds[widget.deliveryType];

                  if (deliveryTypeId == null) {
                    print("Erro: Tipo de entrega inválido.");
                    setState(() {
                      _isProcessing = false;
                    });
                    return;
                  }

                  final pedido = ParseObject('Pedido')
                    ..set('nome', widget.nameController.text)
                    ..set('telefone', widget.phoneController.text)
                    ..set('status', true)
                    ..set('data', DateTime.now())
                    ..set('hora', DateTime.now().toIso8601String())
                    ..set('observacao', '')
                    ..addRelation('tipo_entrega_pedido', [
                      ParseObject('Tipo_Entrega')..objectId = deliveryTypeId
                    ])
                    ..addRelation('sacola_pedido', [
                      ParseObject('Sacola')
                        ..objectId = widget.sacolaController.sacolaAtualId
                    ])
                    ..set('preco_total', widget.total);

                  final response = await pedido.save();

                  if (response.success) {
                    print("Pedido salvo com sucesso!");
                    await widget.sacolaController.finalizarCompra();
                    widget.onOrderCompleted();
                  } else {
                    print("Erro ao salvar pedido: ${response.error?.message}");
                  }

                  setState(() {
                    _isProcessing = false;
                  });
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 53, 155, 56),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          icon: _isProcessing
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                )
              : const Icon(Icons.check, color: Colors.white),
          label: Text(
            _isProcessing ? "Processando..." : "Finalizar pedido",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
