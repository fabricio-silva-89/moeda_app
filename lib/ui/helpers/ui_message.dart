// import 'package:flutter/material.dart';

// mixin UIMessagesManager<T extends StatefulWidget> on State<T> {
//   void showMessage({required String message}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void showModalInfo({
//     String? title,
//     required String message,
//     void Function()? onPressed,
//   }) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           child: Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Visibility(
//                   visible: title != null,
//                   child: Text(title ?? '', style: AppTextStyles.titleLarge),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(message, style: AppTextStyles.bodyLarge),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(
//                       height: 40,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           AppNavigation.pop();
//                           if (onPressed != null) onPressed();
//                         },
//                         child: const Text('OK'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> showModalQuestion({
//     String? title,
//     required String message,
//     void Function()? onPressedNo,
//     required void Function()? onPressedYes,
//   }) async {
//     await showDialog(
//       context: context,
//       builder: (_) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           child: Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Visibility(
//                   visible: title != null,
//                   child: Text(title ?? '', style: AppTextStyles.titleLarge),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(message, style: AppTextStyles.bodyLarge),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(
//                       height: 40,
//                       child: ElevatedButton(
//                         onPressed: onPressedNo ?? AppNavigation.pop,
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: AppColors.primary,
//                           backgroundColor: AppColors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             side: const BorderSide(color: AppColors.primary),
//                           ),
//                         ),
//                         child: const Text('Não'),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     SizedBox(
//                       height: 40,
//                       child: ElevatedButton(
//                         onPressed: onPressedYes ?? AppNavigation.pop,
//                         child: const Text('Sim'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
