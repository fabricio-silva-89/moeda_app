// import 'package:flutter/material.dart';

// import '../../models/asset_model.dart';
// import '../../services/asset_service.dart';
// import '../../services/auth_service.dart';

// class ContributionConfigScreen extends StatefulWidget {
//   const ContributionConfigScreen({super.key});

//   @override
//   State<ContributionConfigScreen> createState() =>
//       _ContributionConfigScreenState();
// }

// class _ContributionConfigScreenState extends State<ContributionConfigScreen> {
//   final _contributionAmountController = TextEditingController();
//   final _assetService = AssetService();
//   final _authService = AuthService();

//   List<Asset> _assets = [];
//   late Map<String, double> _assetPercentages;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadAssets();
//   }

//   @override
//   void dispose() {
//     _contributionAmountController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadAssets() async {
//     final userId = _authService.currentUser?.uid;
//     if (userId == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Usuário não autenticado')),
//         );
//       }
//       return;
//     }

//     try {
//       final assets = await _assetService.getUserAssets(userId);
//       if (mounted) {
//         setState(() {
//           _assets = assets;
//           _assetPercentages = {
//             for (var asset in assets) asset.id: 0.0,
//           };
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erro ao carregar assets: $e')),
//         );
//       }
//     }
//   }

//   String _generateType(String name) {
//     return name.toLowerCase().replaceAll(' ', '_');
//   }

//   Future<void> _addAsset() async {
//     final nameController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Adicionar Asset'),
//         content: TextField(
//           controller: nameController,
//           decoration: const InputDecoration(
//             labelText: 'Nome do Asset',
//             hintText: 'Ex: Renda Fixa, Ações, etc',
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancelar'),
//           ),
//           TextButton(
//             onPressed: () async {
//               if (nameController.text.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Digite um nome para o asset')),
//                 );
//                 return;
//               }

//               final userId = _authService.currentUser?.uid;
//               if (userId == null) return;

//               try {
//                 final newAsset = Asset(
//                   id: '',
//                   userId: userId,
//                   name: nameController.text,
//                   type: _generateType(nameController.text),
//                   createdAt: DateTime.now(),
//                   updatedAt: DateTime.now(),
//                 );

//                 final id = await _assetService.createAsset(newAsset);
//                 final createdAsset = newAsset.copyWith(id: id);

//                 if (mounted) {
//                   setState(() {
//                     _assets.add(createdAsset);
//                     _assetPercentages[id] = 0.0;
//                   });
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('Asset adicionado com sucesso')),
//                   );
//                 }
//               } catch (e) {
//                 if (mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Erro ao adicionar asset: $e')),
//                   );
//                 }
//               }
//             },
//             child: const Text('Adicionar'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _editAssetName(Asset asset) async {
//     final nameController = TextEditingController(text: asset.name);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Editar Asset'),
//         content: TextField(
//           controller: nameController,
//           decoration: const InputDecoration(labelText: 'Nome do Asset'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancelar'),
//           ),
//           TextButton(
//             onPressed: () async {
//               if (nameController.text.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Digite um nome válido')),
//                 );
//                 return;
//               }

//               try {
//                 final updatedAsset = asset.copyWith(
//                   name: nameController.text,
//                   type: _generateType(nameController.text),
//                 );
//                 await _assetService.updateAsset(updatedAsset);

//                 if (mounted) {
//                   setState(() {
//                     final index = _assets.indexWhere((a) => a.id == asset.id);
//                     if (index >= 0) {
//                       _assets[index] = updatedAsset;
//                     }
//                   });
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Asset atualizado')),
//                   );
//                 }
//               } catch (e) {
//                 if (mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Erro ao atualizar: $e')),
//                   );
//                 }
//               }
//             },
//             child: const Text('Salvar'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _deleteAsset(Asset asset) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Excluir Asset'),
//         content: Text('Deseja realmente excluir "${asset.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancelar'),
//           ),
//           TextButton(
//             onPressed: () async {
//               try {
//                 await _assetService.deleteAsset(asset.id);

//                 if (mounted) {
//                   setState(() {
//                     _assets.removeWhere((a) => a.id == asset.id);
//                     _assetPercentages.remove(asset.id);
//                   });
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Asset excluído')),
//                   );
//                 }
//               } catch (e) {
//                 if (mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Erro ao excluir: $e')),
//                   );
//                 }
//               }
//             },
//             child: const Text('Excluir', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAssetActions(Asset asset) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.edit),
//               title: const Text('Editar'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _editAssetName(asset);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text('Excluir', style: TextStyle(color: Colors.red)),
//               onTap: () {
//                 Navigator.pop(context);
//                 _deleteAsset(asset);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   double _getTotalPercentage() {
//     return _assetPercentages.values
//         .fold<double>(0, (sum, value) => sum + value);
//   }

//   Color _getColorForIndex(int index) {
//     final colors = [Colors.blue, Colors.orange, Colors.purple, Colors.red];
//     return colors[index % colors.length];
//   }

//   Future<void> _saveConfiguration() async {
//     final totalPercentage = _getTotalPercentage();

//     if (totalPercentage != 100.0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Total de alocação deve ser 100%. Atualmente: ${totalPercentage.toStringAsFixed(1)}%',
//           ),
//         ),
//       );
//       return;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Configuração salva com sucesso!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Configurar Contribuição'),
//         ),
//         body: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Alocação de Contribuições',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: _addAsset,
//                       icon: const Icon(Icons.add),
//                       label: const Text('Adicionar'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 if (_assets.isEmpty)
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     alignment: Alignment.center,
//                     child: const Text(
//                       'Nenhum asset cadastrado. Clique em "Adicionar" para começar.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   )
//                 else
//                   ..._assets.asMap().entries.map((entry) {
//                     final index = entry.key;
//                     final asset = entry.value;
//                     final color = _getColorForIndex(index);
//                     final percentage = _assetPercentages[asset.id] ?? 0.0;

//                     return GestureDetector(
//                       onLongPress: () => _showAssetActions(asset),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 asset.name,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 '${percentage.toStringAsFixed(1)}%',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: color,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           SliderTheme(
//                             data: SliderThemeData(
//                               activeTrackColor: color,
//                               thumbColor: color,
//                             ),
//                             child: Slider(
//                               value: percentage,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _assetPercentages[asset.id] = value;
//                                 });
//                               },
//                               min: 0,
//                               max: 100,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//                       ),
//                     );
//                   }),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Total Alocado',
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                       ]),
//                 )
//                 //               Text(
//                 //            Simulation() {
//                 // final amount = double.tryParse(_contributionAmountController.text) ?? 0;

//                 // return Column(
//                 //   children: [
//                 //     ..._assets.asMap().entries.map((entry) {
//                 //       final index = entry.key;
//                 //       final asset = entry.value;
//                 //       final color = _getColorForIndex(index);
//                 //       final percentage = _assetPercentages[asset.id] ?? 0.0;
//                 //       final value = (amount * percentage) / 100;

//                 //       return Padding(
//                 //         padding: const EdgeInsets.only(bottom: 12),
//                 //         child: Container(
//                 //           padding: const EdgeInsets.all(12),
//                 //           decoration: BoxDecoration(
//                 //             border: Border.all(color: color.withOpacity(0.3)),
//                 //             borderRadius: BorderRadius.circular(8),
//                 //           ),
//                 //           child: Row(
//                 //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //             children: [
//                 //               Text(asset.name),
//                 //               Text(
//                 //                 'R\$ ${value.toStringAsFixed(2)}',
//                 //                 style: TextStyle(
//                 //                   fontWeight: FontWeight.bold,
//                 //                   color: color,
//                 //                 ),
//                 //               ),
//                 //             ],
//                 //           ),
//                 //         ),
//                 //       );
//                 //     }),
//                 //   ]
//                 //       amount,
//                 //       Colors.purple,
//                 //     ),
//                 //     const SizedBox(height: 12),
//                 //     _buildSimulationItem(
//                 //       'BDRs',
//                 //       _bdrsPercentage,
//                 //       amount,
//                 //       Colors.red,
//                 //     ),
//               ],
//             )));
//   }

//   Widget _buildSimulationItem(
//     String label,
//     double percentage,
//     double amount,
//     Color color,
//   ) {
//     final value = (amount * percentage) / 100;
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: color.withOpacity(0.3)),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label),
//           Text(
//             'R\$ ${value.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // void _saveConfiguration() {
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     const SnackBar(content: Text('Configuração salva com sucesso!')),
//   //   );
//   // }
// }
