import 'package:flutter/material.dart';

import '../models/investment_model.dart';

class AllocationWidget extends StatelessWidget {
  final Map<InvestmentType, double> allocations;

  const AllocationWidget({
    super.key,
    required this.allocations,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alocação por Tipo de Investimento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...allocations.entries.map((entry) {
              final type = entry.key;
              final percentage = entry.value;
              final colors = {
                InvestmentType.rendalixo: Colors.blue,
                InvestmentType.fiis: Colors.orange,
                InvestmentType.acoes: Colors.purple,
                InvestmentType.bdrs: Colors.red,
              };

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(type.displayName),
                        Text('${percentage.toStringAsFixed(1)}%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 8,
                        backgroundColor:
                            colors[type]?.withOpacity(0.2) ?? Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors[type] ?? Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
