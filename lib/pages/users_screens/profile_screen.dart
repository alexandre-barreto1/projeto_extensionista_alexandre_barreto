// lib/pages/profile_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_extensionista_alexandre_barreto/model/team_member.dart';
import 'package:provider/provider.dart';

import '../../repository/team_member_repository.dart';
import '../../services/auth-services.dart';
import '../login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _cargoController;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isEditingProfile = false;
  bool _isChangingPassword = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isSavingProfile = false;
  bool _isSavingPassword = false;

  TeamMember? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // Obter usuário logado do AuthService
    final authService = Provider.of<AuthService>(context, listen: false);
    _currentUser = authService.user;

    // Inicializar controllers com dados do usuário
    _nameController = TextEditingController(text: _currentUser?.name ?? '');
    _emailController = TextEditingController(text: _currentUser?.email ?? '');
    _cargoController = TextEditingController(text: _currentUser?.cargo ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil e Configurações'),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFF3F4B7C),
                  child: Text(
                    _getInitials(_currentUser?.name ?? 'User'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF4CAF50),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 16),
                      color: Colors.white,
                      onPressed: () {
                        // Change profile picture
                        _showMessage('Funcionalidade em desenvolvimento');
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Profile Information Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Informações do Perfil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isEditingProfile ? Icons.close : Icons.edit),
                          onPressed: () {
                            setState(() {
                              _isEditingProfile = !_isEditingProfile;
                              if (!_isEditingProfile) {
                                // Restaurar valores originais ao cancelar
                                _nameController.text = _currentUser?.name ?? '';
                                _emailController.text = _currentUser?.email ?? '';
                                _cargoController.text = _currentUser?.cargo ?? '';
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nome',
                      icon: Icons.person,
                      enabled: _isEditingProfile,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      icon: Icons.email,
                      enabled: _isEditingProfile,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _cargoController,
                      label: 'Cargo',
                      icon: Icons.work,
                      enabled: _isEditingProfile,
                    ),
                    if (_isEditingProfile) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSavingProfile ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: _isSavingProfile
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text('Salvar Alterações'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Alterar Senha',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isChangingPassword ? Icons.close : Icons.lock),
                          onPressed: () {
                            setState(() {
                              _isChangingPassword = !_isChangingPassword;
                              if (!_isChangingPassword) {
                                _currentPasswordController.clear();
                                _newPasswordController.clear();
                                _confirmPasswordController.clear();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (_isChangingPassword) ...[
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        controller: _currentPasswordController,
                        label: 'Senha Atual',
                        obscureText: _obscureCurrentPassword,
                        onToggle: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        controller: _newPasswordController,
                        label: 'Nova Senha',
                        obscureText: _obscureNewPassword,
                        onToggle: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: 'Confirmar Nova Senha',
                        obscureText: _obscureConfirmPassword,
                        onToggle: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSavingPassword ? null : _changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: _isSavingPassword
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text('Alterar Senha'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sair da Conta'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty && nameParts[0].length >= 2) {
      return nameParts[0].substring(0, 2).toUpperCase();
    }
    return 'SK';
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF3F4B7C)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey[100],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF3F4B7C)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    // Validações
    if (_nameController.text.trim().isEmpty) {
      _showErrorDialog('Por favor, digite seu nome.');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showErrorDialog('Por favor, digite seu e-mail.');
      return;
    }

    if (_cargoController.text.trim().isEmpty) {
      _showErrorDialog('Por favor, digite seu cargo.');
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      _showErrorDialog('Por favor, digite um e-mail válido.');
      return;
    }

    setState(() {
      _isSavingProfile = true;
    });

    try {
      // Criar objeto TeamMember atualizado
      final updatedMember = TeamMember(
        _currentUser!.id,
        _nameController.text.trim(),
        _emailController.text.trim(),
        _cargoController.text.trim(),
      );

      // Chamar o método update do repository
      final teamMemberRepository = Provider.of<TeamMemberRepository>(
        context,
        listen: false,
      );

      final savedMember = await teamMemberRepository.update(updatedMember);

      // Atualizar o usuário no AuthService
      final authService = Provider.of<AuthService>(context, listen: false);

      authService.updateUser(savedMember);

      setState(() {
        _currentUser = savedMember;
        _isSavingProfile = false;
        _isEditingProfile = false;
      });

      // Mostrar sucesso
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              const Text('Perfil Atualizado!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('✅ Suas informações foram atualizadas com sucesso!'),
              const SizedBox(height: 12),
              Text('👤 Nome: ${savedMember.name}'),
              Text('📧 E-mail: ${savedMember.email}'),
              Text('💼 Cargo: ${savedMember.cargo}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF3F4B7C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isSavingProfile = false;
      });

      print('Erro ao salvar perfil: $e');
      _showErrorDialog('Erro ao salvar perfil: ${e.toString()}');
    }
  }

  Future<void> _changePassword() async {
    // Validações
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Por favor, preencha todos os campos.');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorDialog('As senhas não coincidem.');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      _showErrorDialog('A nova senha deve ter pelo menos 6 caracteres.');
      return;
    }

    setState(() {
      _isSavingPassword = true;
    });

    try {
      // Criar objeto TeamMember com nova senha
      // Note: Você pode precisar criar um endpoint específico para mudança de senha
      // ou adicionar um campo de senha no TeamMember
      final updatedMember = TeamMember(
        _currentUser!.id,
        _currentUser!.name,
        _currentUser!.email,
        _currentUser!.cargo,
      );

      final teamMemberRepository = Provider.of<TeamMemberRepository>(
        context,
        listen: false,
      );

      await teamMemberRepository.changePass(_currentUser!.id, _newPasswordController.text, _currentPasswordController.text);

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isSavingPassword = false;
        _isChangingPassword = false;
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      });

      // Mostrar sucesso
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              const Text('Senha Alterada!'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_reset,
                color: Color(0xFF4CAF50),
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Sua senha foi alterada com sucesso!',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Por segurança, recomendamos fazer logout e login novamente.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF3F4B7C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isSavingPassword = false;
      });

      print('Erro ao alterar senha: $e');
      _showErrorDialog('Erro ao alterar senha: ${e.toString()}');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF3F4B7C),
      ),
    );
  }

  void logout() async {
    await context.read<AuthService>().logout();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            const Text('Erro'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              // Fechar o dialog
              Navigator.of(context).pop();

              // Realizar o logout
              await context.read<AuthService>().logout();

              // Limpar os campos
              if (mounted) {
                _nameController.clear();
                _emailController.clear();
                _cargoController.clear();
                _currentPasswordController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();

                Navigator.of(context).popUntil((route) => route.isFirst);

              }

              // O AuthCheck vai automaticamente detectar que user == null
              // e mostrar a tela de login
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cargoController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}