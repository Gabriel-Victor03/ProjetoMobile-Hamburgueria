import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class OrderController with ChangeNotifier {
  String? orderId;
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> get orders => _orders;

  Future<void> createOrder({
    required String name,
    required String phone,
    required String deliveryTypeId,
    required String sacolaId,
    required String paymentMethod,
    required double total,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      final order = ParseObject('Order')
        ..set('name', name)
        ..set('phone', phone)
        ..set('paymentMethod', paymentMethod)
        ..set('total', total)
        ..set('products', products)
        ..set('status', true) // Definindo status como booleano
        ..set('date', DateTime.now());

      // Relacionar com Tipo_Entrega
      final tipoEntrega = ParseObject('Tipo_Entrega')..objectId = deliveryTypeId;
      order.set('tipoEntrega', tipoEntrega);

      // Relacionar com Sacola
      final sacola = ParseObject('Sacola')..objectId = sacolaId;
      order.set('sacola', sacola);

      final response = await order.save();

      if (response.success && order.objectId != null) {
        orderId = order.objectId!;
        print("Novo pedido criado com ID: $orderId");
      } else {
        print("Erro ao criar pedido: ${response.error?.message}");
      }
    } catch (e) {
      print("Erro ao criar pedido: $e");
    }
  }

  Future<List<Map<String, String>>> fetchOrders() async {
    try {
      QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('Pedido'));
      var responseOrder = await query.query();

      if (responseOrder.success && responseOrder.results != null) {
        List<Map<String, String>> orders = await Future.wait(
          responseOrder.results!.map((e) async {
            final order = e as ParseObject;

            // Debugging: Print each order's data
            print("Order ID: ${order.objectId}");
            print("Order Nome: ${order.get<String>('nome')}");
            print("Order Telefone: ${order.get<String>('Telefone')}");

            // Otimizar a busca por dados relacionados
            final tipoEntregaRelation = order.getRelation('tipo_entrega_pedido');
            final tipoEntrega = await tipoEntregaRelation.getQuery().first();

            final sacolaRelation = order.getRelation('sacola_pedido');
            final sacola = await sacolaRelation.getQuery().first();

            // Mapear os dados do objeto
            return {
              'id': order.objectId ?? '',
              'nome': order.get<String>('nome') ?? '',
              'Telefone': order.get<String>('Telefone') ?? '',
              'preco_total': order.get<num>('preco_total')?.toStringAsFixed(2) ?? '0.00',
              'Status': order.get<bool>('Status') != null ? (order.get<bool>('Status')! ? 'true' : 'false') : 'Status não disponível',
              'data': order.get<DateTime>('data')?.toIso8601String() ?? '',
              'hora': order.get<String>('hora') ?? '',
              'tipo_entrega': tipoEntrega?.get<String>('nome') ?? 'Tipo de entrega não disponível',
              'observacao': order.get<String>('observacao') ?? 'Sem observação',
            };
          }).toList(),
        );

        return orders;
      } else {
        print("Erro ao buscar pedidos: ${responseOrder.error?.message}");
        return [];
      }
    } catch (e) {
      print("Erro ao buscar pedidos: $e");
      return [];
    }
}
}
