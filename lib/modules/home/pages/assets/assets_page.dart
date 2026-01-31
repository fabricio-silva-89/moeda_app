import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'assets_controller.dart';

class AssetsPage extends GetView<AssetsController> {
  const AssetsPage({super.key});

  void _showAddAssetDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Novo Ativo'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome do Ativo',
            hintText: 'Ex: Ouro, COE',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.createAsset(nameController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssetsController>(
      init: AssetsController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Configurar Ativos'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddAssetDialog(context),
              ),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Erro: ${controller.errorMessage}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.clearError,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            if (controller.assets.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Nenhum ativo configurado ainda',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showAddAssetDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar Ativo'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alocação de Contribuições',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ...controller.assets.map((asset) {
                    return Column(
                      children: [
                        AllocationSlider(
                          label: asset.name,
                          value: asset.percentage,
                          onChanged: (value) =>
                              controller.updateAssetPercentage(
                            asset.id!,
                            value,
                          ),
                          color: _getColorForAssetType(asset.type),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                  Obx(() {
                    final total = controller.assets.fold(
                      0.0,
                      (sum, asset) => sum + asset.percentage,
                    );
                    final isValid = (total - 100).abs() < 0.01;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isValid
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isValid ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total de Alocação',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isValid ? Colors.green : Colors.red,
                            ),
                          ),
                          Text(
                            '${total.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isValid ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }),
          bottomNavigationBar: BottomAppBar(
            padding: const EdgeInsets.all(16),
            child: Obx(() => ElevatedButton(
                  onPressed: controller.isSaving ? null : controller.onSave,
                  child: controller.isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Salvar Configuração'),
                )),
          ),
        );
      },
    );
  }

  Color _getColorForAssetType(String type) {
    switch (type) {
      case 'renda_fixa':
        return Colors.blue;
      case 'acoes_nacionais':
        return Colors.green;
      case 'acoes_internacionais':
        return Colors.orange;
      case 'fiis':
        return Colors.purple;
      case 'cripto':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class AllocationSlider extends StatelessWidget {
  final String label;
  final double value;
  final Function(double) onChanged;
  final Color color;

  const AllocationSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${value.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                )),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            thumbColor: color,
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: 0,
            max: 100,
          ),
        ),
      ],
    );
  }
}
