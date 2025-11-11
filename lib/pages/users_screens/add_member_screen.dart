// lib/pages/add_member_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/team_member.dart';
import '../../repository/team_member_repository.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cargoController = TextEditingController();

  bool _isSaving = false;

  // Lista de cargos disponíveis
  final List<String> _cargos = [
    'Administrador',
    'Programador',
    'Designer',
    'Artista',
    'Compositor',
    'Game Designer',
    'Gerente de Projeto',
    'Tester/QA',
    'Outro',
  ];

  String? _selectedCargo;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Membro'),
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
                        Icons.person_add,
                        size: 64,
                        color: Color(0xFF3F4B7C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cadastrar Novo Membro',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F4B7C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preencha os dados do novo membro da equipe',
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

              // Campo Nome
              const Text(
                'Nome Completo',
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
                  hintText: 'Digite o nome completo',
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF3F4B7C)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, digite o nome';
                  }
                  if (value.trim().length < 3) {
                    return 'Nome deve ter pelo menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo E-mail
              const Text(
                'E-mail',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                enabled: !_isSaving,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'exemplo@email.com',
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF3F4B7C)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, digite o e-mail';
                  }
                  if (!_isValidEmail(value.trim())) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Cargo (Dropdown ou TextField)
              const Text(
                'Cargo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Dropdown para selecionar cargo
              DropdownButtonFormField<String>(
                value: _selectedCargo,
                decoration: InputDecoration(
                  hintText: 'Selecione o cargo',
                  prefixIcon: const Icon(Icons.work, color: Color(0xFF3F4B7C)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _cargos.map((cargo) {
                  return DropdownMenuItem(
                    value: cargo,
                    child: Text(cargo),
                  );
                }).toList(),
                onChanged: _isSaving ? null : (value) {
                  setState(() {
                    _selectedCargo = value;
                    if (value != 'Outro') {
                      _cargoController.text = value ?? '';
                    } else {
                      _cargoController.clear();
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um cargo';
                  }
                  return null;
                },
              ),

              // Se "Outro" for selecionado, mostra campo de texto
              if (_selectedCargo == 'Outro') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cargoController,
                  enabled: !_isSaving,
                  decoration: InputDecoration(
                    hintText: 'Digite o cargo',
                    prefixIcon: const Icon(Icons.edit, color: Color(0xFF3F4B7C)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (_selectedCargo == 'Outro' && (value == null || value.trim().isEmpty)) {
                      return 'Por favor, especifique o cargo';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 32),

              // Informação sobre senha
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF4CAF50),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Uma senha temporária será gerada automaticamente e enviada para o e-mail cadastrado.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : () {
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
                      onPressed: _isSaving ? null : _saveMember,
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

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _saveMember() async {
    // Validar formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final newMember = TeamMember(
        '',
        _nameController.text.trim(),
        _emailController.text.trim(),
        _selectedCargo == 'Outro'
            ? _cargoController.text.trim()
            : _selectedCargo ?? '',
      );

      // Chamar o método save do repository
      final teamMemberRepository = Provider.of<TeamMemberRepository>(
        context,
        listen: false,
      );

      final savedMember = await teamMemberRepository.save(newMember);

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
                  'Conta criada com sucesso, uma senha temporária será enviada para o e-mail cadastrado',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, size: 18, color: Color(0xFF3F4B7C)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        savedMember.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email, size: 18, color: Color(0xFF3F4B7C)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(savedMember.email),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.work, size: 18, color: Color(0xFF3F4B7C)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(savedMember.cargo),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar dialog
                  Navigator.of(context).pop(true); // Voltar para lista com sucesso
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

      print('Erro ao salvar membro: $e');

      // Mostrar erro
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text('Erro ao Cadastrar'),
              ],
            ),
            content: Text(
              'Não foi possível cadastrar o membro.\n\nErro: ${e.toString()}',
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
  }
}