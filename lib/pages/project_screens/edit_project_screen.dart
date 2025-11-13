import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../model/project.dart';
import '../../model/projeto_data.dart';
import '../../repository/projetos_repository.dart';
import '../../repository/projetos_data_repository.dart';

class EditProjectScreen extends StatefulWidget {
  final Project project;
  final ProjectData? projectData;

  const EditProjectScreen({
    Key? key,
    required this.project,
    this.projectData,
  }) : super(key: key);

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final ImagePicker _picker = ImagePicker();

  bool _isSaving = false;
  bool _isLoadingData = false;

  // Status e Gênero
  String? _selectedStatus;
  String? _selectedGenero;

  // Imagens
  Uint8List? _qrCodeImage;
  Uint8List? _imagemPrincipal;
  Uint8List? _imagem2;
  Uint8List? _imagem3;

  // Flags para saber se imagem foi alterada
  bool _qrCodeChanged = false;
  bool _imagemPrincipalChanged = false;
  bool _imagem2Changed = false;
  bool _imagem3Changed = false;

  ProjectData? _currentProjectData;

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
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Inicializar controllers com dados atuais
    _nameController = TextEditingController(text: widget.project.name);
    _selectedStatus = widget.project.status;
    _selectedGenero = widget.project.genero;

    // Decodificar imagens existentes
    _qrCodeImage = _decodeBase64Image(widget.project.qrcode);
    _imagemPrincipal = _decodeBase64Image(widget.project.imagemprincipal);

    // Carregar ProjectData se não foi fornecido
    if (widget.projectData != null) {
      _currentProjectData = widget.projectData;
      _imagem2 = _decodeBase64Image(widget.projectData!.imagem1);
      _imagem3 = _decodeBase64Image(widget.projectData!.imagem2);
    } else {
      _loadProjectData();
    }
  }

  Future<void> _loadProjectData() async {
    setState(() {
      _isLoadingData = true;
    });

    try {
      final projetosDataRepository = Provider.of<ProjetosDataRepository>(
        context,
        listen: false,
      );

      final projectData = await projetosDataRepository.buscarProjetoData(widget.project.id);

      setState(() {
        _currentProjectData = projectData;
        _imagem2 = _decodeBase64Image(projectData.imagem1);
        _imagem3 = _decodeBase64Image(projectData.imagem2);
        _isLoadingData = false;
      });
    } catch (e) {
      print('Erro ao carregar ProjectData: $e');
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  Uint8List? _decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return null;
    }

    try {
      if (base64String.startsWith('data:image')) {
        base64String = base64String.split(',').last;
      }
      return base64Decode(base64String);
    } catch (e) {
      print('Erro ao decodificar imagem: $e');
      return null;
    }
  }

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
        final fileSize = await image.length();
        const maxSizeInBytes = 5 * 1024 * 1024; // 5 MB

        if (fileSize > maxSizeInBytes) {
          showTooLargeDialog(context);
          return;
        }

        final bytes = await image.readAsBytes();
        setState(() {
          switch (tipo) {
            case 'qrcode':
              _qrCodeImage = bytes;
              _qrCodeChanged = true;
              break;
            case 'principal':
              _imagemPrincipal = bytes;
              _imagemPrincipalChanged = true;
              break;
            case 'imagem2':
              _imagem2 = bytes;
              _imagem2Changed = true;
              break;
            case 'imagem3':
              _imagem3 = bytes;
              _imagem3Changed = true;
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
          _qrCodeChanged = true;
          break;
        case 'principal':
          _imagemPrincipal = null;
          _imagemPrincipalChanged = true;
          break;
        case 'imagem2':
          _imagem2 = null;
          _imagem2Changed = true;
          break;
        case 'imagem3':
          _imagem3 = null;
          _imagem3Changed = true;
          break;
      }
    });
  }

  void showTooLargeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Imagem muito grande'),
        content: const Text('Por favor, selecione uma imagem menor que 5MB.'),
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
        title: const Text('Editar Projeto'),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
      ),
      body: _isLoadingData
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF3F4B7C)),
            SizedBox(height: 16),
            Text('Carregando dados do projeto...'),
          ],
        ),
      )
          : SingleChildScrollView(
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
                        Icons.edit,
                        size: 64,
                        color: Color(0xFF3F4B7C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Editar Projeto',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F4B7C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Atualize as informações do projeto',
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
                'Atualize ou mantenha as imagens do projeto',
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text(
                        'Salvar Alterações',
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
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => _pickImage(tipo),
                          icon: const Icon(Icons.edit),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF3F4B7C),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _removeImage(tipo),
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Preparar imagens (converter para base64 apenas se foram alteradas)
      String? qrCodeBase64 = widget.project.qrcode;
      String? imagemPrincipalBase64 = widget.project.imagemprincipal;

      if (_qrCodeChanged) {
        qrCodeBase64 = _qrCodeImage != null
            ? 'data:image/png;base64,${base64Encode(_qrCodeImage!)}'
            : null;
      }

      if (_imagemPrincipalChanged) {
        imagemPrincipalBase64 = _imagemPrincipal != null
            ? 'data:image/png;base64,${base64Encode(_imagemPrincipal!)}'
            : null;
      }

      // Atualizar objeto Project
      final updatedProject = Project(
        widget.project.id,
        _nameController.text.trim(),
        _selectedStatus!,
        qrCodeBase64,
        _selectedGenero!,
        imagemPrincipalBase64,
      );

      // Salvar projeto usando ProjetosRepository.edit
      final projetosRepository = Provider.of<ProjetosRepository>(
        context,
        listen: false,
      );

      final savedProject = await projetosRepository.edit(updatedProject);

      // Atualizar ProjectData se houver alterações nas imagens 2 ou 3
      if (_imagem2Changed || _imagem3Changed) {
        String? imagem2Base64 = _currentProjectData?.imagem1;
        String? imagem3Base64 = _currentProjectData?.imagem2;

        if (_imagem2Changed) {
          imagem2Base64 = _imagem2 != null
              ? 'data:image/png;base64,${base64Encode(_imagem2!)}'
              : null;
        }

        if (_imagem3Changed) {
          imagem3Base64 = _imagem3 != null
              ? 'data:image/png;base64,${base64Encode(_imagem3!)}'
              : null;
        }

        final updatedProjectData = ProjectData(
          _currentProjectData?.id ?? '',
          imagem2Base64,
          imagem3Base64,
          savedProject.id,
        );

        final projetosDataRepository = Provider.of<ProjetosDataRepository>(
          context,
          listen: false,
        );

        await projetosDataRepository.edit(updatedProjectData);
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
                  'Projeto atualizado com sucesso!',
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
                    const Icon(Icons.category, size: 18, color: Color(0xFF3F4B7C)),
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
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
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

      if (mounted) {
        _showErrorDialog(
            'Não foi possível atualizar o projeto.\n\nErro: ${e.toString()}');
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