import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../model/project.dart';
import '../../model/projeto_data.dart';
import '../../repository/projetos_repository.dart';
import '../../repository/projetos-data_repository.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isSaving = false;

  // Status e Gênero
  String? _selectedStatus;
  String? _selectedGenero;

  // Imagens
  Uint8List? _qrCodeImage;
  Uint8List? _imagemPrincipal;
  Uint8List? _imagem2;
  Uint8List? _imagem3;

  // Listas de opções
  final List<String> _statusOptions = [
    'Em Desenvolvimento',
    'Em Teste',
    'Finalizado',
  ];

  final List<String> _generoOptions = [
    'Aventura',
    'Aventura/RPG',
    'RPG',
    'Plataforma',
    'Puzzle',
    'Ação',
    'Estratégia',
    'Outros',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String tipo) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {

        final fileSize = await image.length(); // tamanho em bytes

        const maxSizeInBytes = 20 * 1024 * 1024; // 20 MB

        if (fileSize > maxSizeInBytes) {
          print("⚠️ A imagem é maior que 20MB!");
          showTooLargeDialog(context);
          return;
        }

        print("✅ Imagem dentro do limite: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB");

        final bytes = await image.readAsBytes();
        setState(() {
          switch (tipo) {
            case 'qrcode':
              _qrCodeImage = bytes;
              break;
            case 'principal':
              _imagemPrincipal = bytes;
              break;
            case 'imagem2':
              _imagem2 = bytes;
              break;
            case 'imagem3':
              _imagem3 = bytes;
              break;
          }
        });
      }
    } catch (e) {
      print('Erro ao selecionar imagem: $e');
      _showErrorDialog('Erro ao selecionar imagem: ${e.toString()}');
    }
  }

  void _removeImage(String tipo) {
    setState(() {
      switch (tipo) {
        case 'qrcode':
          _qrCodeImage = null;
          break;
        case 'principal':
          _imagemPrincipal = null;
          break;
        case 'imagem2':
          _imagem2 = null;
          break;
        case 'imagem3':
          _imagem3 = null;
          break;
      }
    });
  }

  void showTooLargeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Imagem muito grande'),
        content: const Text('Por favor, selecione uma imagem menor que 20MB.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Projeto'),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ícone e título
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F4B7C).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_circle,
                        size: 64,
                        color: Color(0xFF3F4B7C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cadastrar Novo Projeto',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F4B7C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preencha as informações do projeto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Nome do Projeto
              const Text(
                'Nome do Projeto *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                enabled: !_isSaving,
                decoration: InputDecoration(
                  hintText: 'Digite o nome do projeto',
                  prefixIcon: const Icon(Icons.games, color: Color(0xFF3F4B7C)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, digite o nome do projeto';
                  }
                  if (value.trim().length < 3) {
                    return 'Nome deve ter pelo menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Status
              const Text(
                'Status *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  hintText: 'Selecione o status',
                  prefixIcon: const Icon(Icons.flag, color: Color(0xFF3F4B7C)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Gênero
              const Text(
                'Gênero *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGenero,
                decoration: InputDecoration(
                  hintText: 'Selecione o gênero',
                  prefixIcon: const Icon(Icons.category, color: Color(0xFF3F4B7C)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _generoOptions.map((genero) {
                  return DropdownMenuItem(
                    value: genero,
                    child: Text(genero),
                  );
                }).toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                  setState(() {
                    _selectedGenero = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um gênero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Seção de Imagens
              const Text(
                'Imagens do Projeto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F4B7C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Adicione imagens para ilustrar o projeto',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),

              // QR Code
              _buildImagePicker(
                'QR Code',
                'qrcode',
                _qrCodeImage,
                Icons.qr_code,
              ),
              const SizedBox(height: 16),

              // Imagem Principal
              _buildImagePicker(
                'Imagem Principal',
                'principal',
                _imagemPrincipal,
                Icons.image,
              ),
              const SizedBox(height: 16),

              // Imagem 2
              _buildImagePicker(
                'Imagem 2',
                'imagem2',
                _imagem2,
                Icons.image,
              ),
              const SizedBox(height: 16),

              // Imagem 3
              _buildImagePicker(
                'Imagem 3',
                'imagem3',
                _imagem3,
                Icons.image,
              ),
              const SizedBox(height: 32),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF3F4B7C)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF3F4B7C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text(
                        'Cadastrar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(
      String label,
      String tipo,
      Uint8List? imageBytes,
      IconData icon,
      ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF3F4B7C), size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (imageBytes != null) ...[
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () => _removeImage(tipo),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            InkWell(
              onTap: _isSaving ? null : () => _pickImage(tipo),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toque para adicionar imagem',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveProject() async {
    // Validar formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Converter imagens para base64
      String? qrCodeBase64;
      String? imagemPrincipalBase64;

      if (_qrCodeImage != null) {
        qrCodeBase64 = 'data:image/png;base64,${base64Encode(_qrCodeImage!)}';
      }

      if (_imagemPrincipal != null) {
        imagemPrincipalBase64 =
        'data:image/png;base64,${base64Encode(_imagemPrincipal!)}';
      }

      // Criar objeto Project
      final newProject = Project(
        '', // ID será gerado pelo backend
        _nameController.text.trim(),
        _selectedStatus!,
        qrCodeBase64,
        _selectedGenero!,
        imagemPrincipalBase64
      );

      // Salvar projeto
      final projetosRepository = Provider.of<ProjetosRepository>(
        context,
        listen: false,
      );

      final savedProject = await projetosRepository.save(newProject);

      // Se houver imagem 2 ou 3, salvar ProjectData
      if (_imagem2 != null || _imagem3 != null) {
        String? imagem2Base64;
        String? imagem3Base64;

        if (_imagem2 != null) {
          imagem2Base64 = 'data:image/png;base64,${base64Encode(_imagem2!)}';
        }

        if (_imagem3 != null) {
          imagem3Base64 = 'data:image/png;base64,${base64Encode(_imagem3!)}';
        }

        final projectData = ProjectData(
          '', // ID será gerado pelo backend
          imagem2Base64,
          imagem3Base64,
          savedProject.id,
        );

        final projetosDataRepository = Provider.of<ProjetosDataRepository>(
          context,
          listen: false,
        );

         await projetosDataRepository.save(projectData);
      }

      setState(() {
        _isSaving = false;
      });

      // Mostrar dialog de sucesso
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 32,
                ),
                SizedBox(width: 12),
                Text('Sucesso!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Projeto cadastrado com sucesso!',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.games, size: 18, color: Color(0xFF3F4B7C)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        savedProject.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.flag, size: 18, color: Color(0xFF3F4B7C)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(savedProject.status),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.category,
                        size: 18, color: Color(0xFF3F4B7C)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(savedProject.genero ?? 'N/A'),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar dialog
                  Navigator.of(context)
                      .pop(true); // Voltar para lista com sucesso
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFF3F4B7C),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      print('Erro ao salvar projeto: $e');

      // Mostrar erro
      if (mounted) {
        _showErrorDialog('Não foi possível cadastrar o projeto.\n\nErro: ${e.toString()}');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Erro'),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}