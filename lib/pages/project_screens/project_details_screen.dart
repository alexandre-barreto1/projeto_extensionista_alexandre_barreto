// // Project Edit Screen
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../model/project.dart';
//
// class ProjectDetailsScreen extends StatefulWidget {
//   final Project project;
//   final Function(Project) onProjectUpdated;
//
//   const ProjectDetailsScreen({
//     Key? key,
//     required this.project,
//     required this.onProjectUpdated,
//   }) : super(key: key);
//
//   @override
//   _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
// }
//
// class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
//   late TextEditingController _nameController;
//   late String _selectedStatus;
//   late String _qrcodeController;
//   late String _genreController;
//
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.project.name);
//     _selectedStatus = widget.project.status;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text('Editar Projeto'),
//         backgroundColor: const Color(0xFF4A5BAE),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _saveProject,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Project Header Card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF4A5BAE), Color(0xFF6C7CE7)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.games,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'Edição de Projeto',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Gênero: ${widget.project.genre}',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.9),
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // Project Name Section
//             _buildSection(
//               title: 'Nome do Projeto',
//               icon: Icons.edit,
//               child: TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   hintText: 'Digite o nome do projeto',
//                   prefixIcon: Icon(Icons.gamepad, color: const Color(0xFF4A5BAE)),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: Color(0xFF4A5BAE), width: 2),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // Status Section
//             _buildSection(
//               title: 'Status do Projeto',
//               icon: Icons.flag,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: _selectedStatus,
//                     isExpanded: true,
//                     icon: Icon(Icons.arrow_drop_down, color: const Color(0xFF4A5BAE)),
//                     items:[],
//                     // _statusOptions.map((StatusOption option) {
//                     //   return DropdownMenuItem<String>(
//                     //     value: option.name,
//                     //     child: Row(
//                     //       children: [
//                     //         Container(
//                     //           width: 12,
//                     //           height: 12,
//                     //           decoration: BoxDecoration(
//                     //             color: option.color,
//                     //             shape: BoxShape.circle,
//                     //           ),
//                     //         ),
//                     //         const SizedBox(width: 12),
//                     //         Text(
//                     //           option.name,
//                     //           style: TextStyle(
//                     //             color: option.color,
//                     //             fontWeight: FontWeight.w500,
//                     //           ),
//                     //         ),
//                     //       ],
//                     //     ),
//                     //   );
//                     // }).toList(),
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         setState(() {
//                           _selectedStatus = newValue;
//                           // _selectedStatusColor = _statusOptions
//                           //     .firstWhere((option) => option.name == newValue)
//                           //     .color;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // QR Code Section
//             _buildSection(
//               title: 'QR Code do Projeto',
//               icon: Icons.qr_code,
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Column(
//                   children: [
//                     // QR Code Placeholder (seria substituído por biblioteca de QR Code real)
//                     Container(
//                       width: 200,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.grey.shade300, width: 2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.qr_code,
//                             size: 80,
//                             color: Colors.grey[400],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'QR Code',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             _nameController.text.isNotEmpty
//                                 ? _nameController.text
//                                 : widget.project.name,
//                             style: TextStyle(
//                               color: Colors.grey[500],
//                               fontSize: 12,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // QR Code Info
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF4A5BAE).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.info_outline,
//                                 color: const Color(0xFF4A5BAE),
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               const Text(
//                                 'Informações do QR Code',
//                                 style: TextStyle(
//                                   color: Color(0xFF4A5BAE),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'ID: ${_generateProjectId(_nameController.text.isNotEmpty ? _nameController.text : widget.project.name)}',
//                             style: TextStyle(color: Colors.grey[700], fontSize: 12),
//                           ),
//                           Text(
//                             'Status: $_selectedStatus',
//                             style: TextStyle(color: Colors.grey[700], fontSize: 12),
//                           ),
//                           Text(
//                             'Gênero: ${widget.project.genre}',
//                             style: TextStyle(color: Colors.grey[700], fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // Action Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             onPressed: _shareQRCode,
//                             icon: const Icon(Icons.share),
//                             label: const Text('Compartilhar'),
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: const Color(0xFF4A5BAE),
//                               side: const BorderSide(color: Color(0xFF4A5BAE)),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             onPressed: _downloadQRCode,
//                             icon: const Icon(Icons.download),
//                             label: const Text('Baixar'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF4A5BAE),
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 32),
//
//             // Save Button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton.icon(
//                 onPressed: _isLoading ? null : _saveProject,
//                 icon: _isLoading
//                     ? const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                     : const Icon(Icons.save),
//                 label: Text(_isLoading ? 'Salvando...' : 'Salvar Alterações'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF4CAF50),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   elevation: 3,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSection({
//     required String title,
//     required IconData icon,
//     required Widget child,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: const Color(0xFF4A5BAE), size: 24),
//             const SizedBox(width: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF4A5BAE),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         child,
//       ],
//     );
//   }
//
//   String _generateProjectId(String projectName) {
//     // Gerar um ID baseado no nome do projeto
//     String id = projectName.toLowerCase().replaceAll(' ', '_');
//     int hash = id.hashCode.abs();
//     return 'SK_${hash.toString().padLeft(6, '0')}';
//   }
//
//   void _shareQRCode() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('🔗 QR Code compartilhado com sucesso!'),
//         backgroundColor: Color(0xFF4A5BAE),
//       ),
//     );
//   }
//
//   void _downloadQRCode() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('⬇️ QR Code baixado para a galeria!'),
//         backgroundColor: Color(0xFF4CAF50),
//       ),
//     );
//   }
//
//   Future<void> _saveProject() async {
//     if (_nameController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Por favor, digite um nome para o projeto.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     // Simular salvamento
//     await Future.delayed(const Duration(seconds: 1));
//
//     // Criar projeto atualizado
//     Project updatedProject = Project(
//       _generateProjectId(_nameController.text),
//       _nameController.text.trim(),
//       _selectedStatus,
//       _qrcodeController,
//       _genreController
//     );
//
//     // Callback para atualizar a lista
//     widget.onProjectUpdated(updatedProject);
//
//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//
//       // Mostrar sucesso
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Row(
//             children: [
//               Icon(Icons.check_circle, color: Colors.green, size: 28),
//               const SizedBox(width: 8),
//               const Text('Projeto Atualizado!'),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('✅ Alterações salvas com sucesso!'),
//               const SizedBox(height: 12),
//               Text('📛 Nome: ${_nameController.text}'),
//               Text('🏷️ Status: $_selectedStatus'),
//               Text('🎮 Gênero: ${widget.project.genre}'),
//               const SizedBox(height: 8),
//               Text('🆔 ID: ${_generateProjectId(_nameController.text)}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Fechar dialog
//                 Navigator.pop(context); // Voltar para lista de projetos
//               },
//               child: const Text(
//                 'OK',
//                 style: TextStyle(
//                   color: Color(0xFF4A5BAE),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
// }