// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:projeto_extensionista_alexandre_barreto/pages/project_screens/project_details_screen.dart';
// import 'package:projeto_extensionista_alexandre_barreto/pages/project_screens/project_evaluation_screen.dart';
// import 'package:projeto_extensionista_alexandre_barreto/repository/projetos_repository.dart';
//
// import '../../model/project.dart';
//
// class ProjectEvaluationsScreen extends StatefulWidget {
//   const ProjectEvaluationsScreen({super.key});
//
//   @override
//   _ProjectEvaluationsScreenState createState() => _ProjectEvaluationsScreenState();
// }
//
// class _ProjectEvaluationsScreenState extends State<ProjectEvaluationsScreen> {
//   final ProjetosRepository _projetosRepository = ProjetosRepository();
//   bool _isLoading = true;
//   List<Project> _projetos = [];
//   String? _errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     _carregarProjetos(); // Chama o método para carregar os dados
//   }
//
//   final nameController = TextEditingController();
//   final statusController = TextEditingController();
//   final qrCodeController = TextEditingController();
//   final genreController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Avaliações de Projetos'),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: _projetos.length,
//         itemBuilder: (context, index) {
//           return _buildProjectCard(_projetos[index]);
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddProjectDialog(),
//         backgroundColor: const Color(0xFF4A5BAE),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildProjectCard(Project project) {
//     final genreController = project.genre ?? '';
//     return
//       InkWell(
//         onTap: () {
//           _showProjectDetails(project);
//         },
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 16),
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       project.name,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 genreController,
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Avaliação: ${projectDetail.score}%',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       color: _scoreController >= 80 ? Colors.green :
//                       _scoreController >= 60 ? Colors.orange : Colors.red,
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => _showAvaliarProject(project),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF4A5BAE),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text('Avaliar'),
//                   ),
//                 ],
//               ),
//               if (_scoreController > 0) ...[
//                 const SizedBox(height: 12),
//                 LinearProgressIndicator(
//                   value: _scoreController / 100,
//                   backgroundColor: Colors.grey[300],
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     _scoreController >= 80 ? Colors.green :
//                     _scoreController >= 60 ? Colors.orange : Colors.red,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       );
//   }
//
//   void _showAvaliarProject(Project project) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProjectEvaluationScreen(project: project),
//       ),
//     );
//   }
//
//   void _showProjectDetails(Project project) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProjectDetailsScreen(
//           project: project,
//           onProjectUpdated: (updatedProject) {
//             setState(() {
//               int index = _projetos.indexWhere((p) => p.name == project.name);
//               if (index != -1) {
//                 _projetos[index] = updatedProject;
//               }
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   void _showAddProjectDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Novo Projeto'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Nome do Projeto',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: statusController,
//               decoration: const InputDecoration(
//                 labelText: 'Status',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancelar'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (nameController.text.isNotEmpty && statusController.text.isNotEmpty) {
//                 setState(() {
//                   _salvarProjeto();
//                 });
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('Adicionar'),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Future<void> _salvarProjeto() async {
//     Project project = Project("", nameController.text, statusController.text, qrCodeController.text, genreController.text);
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//     try {
//       project = await _projetosRepository.save(project);
//       _carregarProjetos();
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       print("Erro ao salvar o projeto: $e");
//       setState(() {
//         _errorMessage = "Erro ao salvar o projeto. Tente novamente.";
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _carregarProjetos() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//     try {
//       final projetos = await _projetosRepository.listAll();
//       setState(() {
//         _projetos = projetos;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print("Erro ao carregar avaliações: $e");
//       setState(() {
//         _errorMessage = "Falha ao carregar dados. Tente novamente.";
//         _isLoading = false;
//       });
//     }
//   }
// }