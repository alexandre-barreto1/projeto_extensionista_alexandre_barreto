// // Project Evaluation Detail Screen
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../model/project.dart';
//
// class ProjectEvaluationScreen extends StatefulWidget {
//   final Project project;
//
//   const ProjectEvaluationScreen({Key? key, required this.project}) : super(key: key);
//
//   @override
//   _ProjectEvaluationScreenState createState() => _ProjectEvaluationScreenState();
// }
//
// class _ProjectEvaluationScreenState extends State<ProjectEvaluationScreen> {
//   final Map<String, double> evaluationCriteria = {
//     'Gameplay': 0,
//     'Gráficos': 0,
//     'Som': 0,
//     'História': 0,
//     'Performance': 0,
//     'Interface': 0,
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Avaliação - ${widget.project.name}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Critérios de Avaliação',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             Expanded(
//               child: ListView(
//                 children: evaluationCriteria.keys.map((criterion) {
//                   return _buildCriterionSlider(criterion);
//                 }).toList(),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _saveEvaluation,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF4A5BAE),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                 ),
//                 child: const Text(
//                   'Salvar Avaliação',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCriterionSlider(String criterion) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 criterion,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 '${evaluationCriteria[criterion]!.round()}/10',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Slider(
//             value: evaluationCriteria[criterion]!,
//             min: 0,
//             max: 10,
//             divisions: 10,
//             activeColor: const Color(0xFF4A5BAE),
//             onChanged: (value) {
//               setState(() {
//                 evaluationCriteria[criterion] = value;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _saveEvaluation() {
//     double average = evaluationCriteria.values.reduce((a, b) => a + b) / evaluationCriteria.length;
//     int finalScore = (average * 10).round();
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Avaliação salva! Nota final: $finalScore%'),
//         backgroundColor: const Color(0xFF4A5BAE),
//       ),
//     );
//
//     Navigator.pop(context);
//   }
// }