import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../assets/domain/models/asset_model.dart';
import 'wallet_controller.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      init: WalletController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
      builder: (controller) {
        return Scaffold(
          appBar: _WalletAppBar(controller: controller),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAssetModal(context, controller),
            child: const Icon(Icons.add),
          ),
          body: Obx(() {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage != null) {
              return _ErrorView(controller: controller);
            }

            if (controller.assets.isEmpty) {
              return _EmptyView(
                onAdd: () => _showAssetModal(context, controller),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.loadAssets,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _ChartSection(controller: controller),
                  ),
                  SliverToBoxAdapter(
                    child: Obx(() {
                      final byType = controller.assetsByType;
                      if (byType.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: byType.entries.map((entry) {
                          return _AssetTypeSection(
                            type: entry.key,
                            assets: entry.value,
                            typeTotal: controller.typeTotal(entry.key),
                            onEdit: (asset) => _showAssetModal(
                                context, controller,
                                asset: asset),
                            onDelete: (asset) =>
                                _confirmDelete(context, controller, asset),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WalletController controller,
    AssetModel asset,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remover ativo'),
        content: Text('Deseja remover "${asset.name}" da carteira?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (confirmed == true && asset.id != null) {
      await controller.deleteAsset(asset.id!);
    }
  }

  void _showAssetModal(
    BuildContext context,
    WalletController controller, {
    AssetModel? asset,
  }) {
    showDialog(
      context: context,
      builder: (_) => _AssetModal(
        asset: asset,
        onSave: (name, type, currentValue, score) async {
          if (asset != null) {
            await controller.updateAsset(asset.copyWith(
              name: name,
              type: type,
              currentValue: currentValue,
              score: score,
            ));
          } else {
            await controller.addAsset(
              name: name,
              type: type,
              currentValue: currentValue,
              score: score,
            );
          }
        },
      ),
    );
  }
}

// ─── AppBar ───────────────────────────────────────────────────────────────────

class _WalletAppBar extends StatefulWidget implements PreferredSizeWidget {
  final WalletController controller;
  const _WalletAppBar({required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<_WalletAppBar> createState() => _WalletAppBarState();
}

class _WalletAppBarState extends State<_WalletAppBar> {
  bool _searching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
      if (!_searching) {
        _searchController.clear();
        widget.controller.updateSearchQuery('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _searching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Buscar ativo...',
                border: InputBorder.none,
              ),
              onChanged: widget.controller.updateSearchQuery,
            )
          : const Text('Carteira'),
      actions: [
        IconButton(
          icon: Icon(_searching ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
      ],
    );
  }
}

// ─── Pie Chart Section ────────────────────────────────────────────────────────

class _ChartSection extends StatelessWidget {
  final WalletController controller;
  const _ChartSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = controller.totalValue;
      final byType = controller.assetsByType;

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                      sections: byType.entries.map((entry) {
                        final typeVal = controller.typeTotal(entry.key);
                        final pct = total > 0 ? (typeVal / total * 100) : 0.0;
                        return PieChartSectionData(
                          value: typeVal > 0 ? typeVal : 0.001,
                          color: _colorForType(entry.key),
                          title: pct >= 5 ? '${pct.toStringAsFixed(1)}%' : '',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 12)),
                      Text(
                        _formatCurrency(total),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: byType.keys.map((type) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _colorForType(type),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _labelForType(type),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            const Divider(),
          ],
        ),
      );
    });
  }
}

// ─── Asset Type Section ───────────────────────────────────────────────────────

class _AssetTypeSection extends StatelessWidget {
  final String type;
  final List<AssetModel> assets;
  final double typeTotal;
  final void Function(AssetModel) onEdit;
  final void Function(AssetModel) onDelete;

  const _AssetTypeSection({
    required this.type,
    required this.assets,
    required this.typeTotal,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _colorForType(type),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _labelForType(type),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Text(
                _formatCurrency(typeTotal),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        ...assets.map((asset) => _AssetTile(
              asset: asset,
              onEdit: onEdit,
              onDelete: onDelete,
            )),
        const Divider(height: 1),
      ],
    );
  }
}

// ─── Asset Tile ───────────────────────────────────────────────────────────────

class _AssetTile extends StatelessWidget {
  final AssetModel asset;
  final void Function(AssetModel) onEdit;
  final void Function(AssetModel) onDelete;

  const _AssetTile({
    required this.asset,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(asset.name, style: const TextStyle(fontSize: 14)),
      subtitle: Text(
        _formatCurrency(asset.currentValue),
        style: const TextStyle(fontSize: 13),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _colorForType(asset.type).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${asset.score} pts',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _colorForType(asset.type),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => onEdit(asset),
            tooltip: 'Editar',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
            onPressed: () => onDelete(asset),
            tooltip: 'Remover',
          ),
        ],
      ),
    );
  }
}

// ─── Empty View ───────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyView({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 72,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Sua carteira está vazia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione seus ativos para visualizar\na alocação da sua carteira.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar primeiro ativo'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error View ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final WalletController controller;
  const _ErrorView({required this.controller});

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              controller.clearError();
              controller.loadAssets();
            },
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

// ─── Add / Edit Modal ─────────────────────────────────────────────────────────

class _AssetModal extends StatefulWidget {
  final AssetModel? asset;
  final Future<void> Function(
      String name, String type, double currentValue, int score) onSave;

  const _AssetModal({this.asset, required this.onSave});

  @override
  State<_AssetModal> createState() => _AssetModalState();
}

class _AssetModalState extends State<_AssetModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _valueCtrl;
  late final TextEditingController _scoreCtrl;
  late String _selectedType;
  bool _saving = false;

  static const _types = [
    ('renda_fixa', 'Renda Fixa'),
    ('fiis', 'FIIs'),
    ('acoes_nacionais', 'Ações Nacionais'),
    ('acoes_internacionais', 'Ações Internacionais'),
    ('cripto', 'Cripto'),
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.asset?.name ?? '');
    _valueCtrl = TextEditingController(
        text: widget.asset != null && widget.asset!.currentValue > 0
            ? widget.asset!.currentValue.toStringAsFixed(2)
            : '');
    _scoreCtrl = TextEditingController(
        text: widget.asset != null ? '${widget.asset!.score}' : '');
    _selectedType = widget.asset?.type ?? _types.first.$1;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valueCtrl.dispose();
    _scoreCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await widget.onSave(
      _nameCtrl.text.trim(),
      _selectedType,
      double.tryParse(_valueCtrl.text.replaceAll(',', '.')) ?? 0.0,
      int.tryParse(_scoreCtrl.text) ?? 0,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.asset != null;
    return AlertDialog(
      title: Text(isEditing ? 'Editar ativo' : 'Adicionar ativo'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: _types
                    .map((t) => DropdownMenuItem(
                          value: t.$1,
                          child: Text(t.$2),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Ex: VISC11, ITUB4, CDB...',
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Valor Atual',
                  prefixText: 'R\$ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o valor';
                  final parsed = double.tryParse(v.replaceAll(',', '.'));
                  if (parsed == null || parsed < 0) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _scoreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Pontuação',
                  hintText: 'Ex: 80',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Informe a pontuação';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

Color _colorForType(String type) {
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

String _labelForType(String type) {
  switch (type) {
    case 'renda_fixa':
      return 'Renda Fixa';
    case 'acoes_nacionais':
      return 'Ações Nacionais';
    case 'acoes_internacionais':
      return 'Ações Internacionais';
    case 'fiis':
      return 'FIIs';
    case 'cripto':
      return 'Cripto';
    default:
      return type;
  }
}

String _formatCurrency(double value) {
  return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+,)'), (m) => '${m[1]}.')}';
}
