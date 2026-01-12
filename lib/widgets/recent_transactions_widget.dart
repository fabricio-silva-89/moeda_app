import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart' as transaction_model;

class RecentTransactionsWidget extends StatelessWidget {
  final List<transaction_model.Transaction> transactions;

  const RecentTransactionsWidget({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transações Recentes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (transactions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Nenhuma transação realizada'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      transaction.type.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(transaction.date),
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      currencyFormatter.format(transaction.amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
