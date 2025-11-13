import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/project.dart';
import '../../repository/projetos_repository.dart';
import 'project_report_detail_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isLoading = true;
  List<Project> _projetos = [];
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _carregarProjetos();
  }

  Future<void> _carregarProjetos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final projetosRepository = Provider.of<ProjetosRepository>(
        context,
        listen: false,
      );
      final projetos = await projetosRepository.listAll();

      setState(() {
        _projetos = projetos;
        _isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar projetos: $e");
      setState(() {
        _errorMessage = "Falha ao carregar projetos. Tente novamente.";
        _isLoading = false;
      });
    }
  }

  List<Project> get _filteredProjects {
    if (_searchQuery.isEmpty) {
      return _projetos;
    }
    return _projetos.where((project) {
      return project.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (project.genero?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios de Avaliações'),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarProjetos,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Cabeçalho com informações e busca
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3F4B7C).withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.analytics,
                      color: Color(0xFF3F4B7C),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Análise de Avaliações',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3F4B7C),
                            ),
                          ),
                          Text(
                            'Selecione um projeto para ver estatísticas',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Campo de busca
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar projeto...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF3F4B7C)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF3F4B7C),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // Lista de projetos
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF3F4B7C),
            ),
            SizedBox(height: 16),
            Text(
              'Carregando projetos...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF3F4B7C),
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _carregarProjetos,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F4B7C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final filteredProjects = _filteredProjects;

    if (filteredProjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isEmpty ? Icons.folder_open : Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'Nenhum projeto cadastrado'
                  : 'Nenhum projeto encontrado',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Tente uma busca diferente',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarProjetos,
      color: const Color(0xFF3F4B7C),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredProjects.length,
        itemBuilder: (context, index) {
          final project = filteredProjects[index];
          return _buildProjectCard(project);
        },
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectReportDetailScreen(project: project),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Ícone do projeto
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getColorByGenre(project.genero ?? '').withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getGenreIcon(project.genero ?? ''),
                  size: 32,
                  color: _getColorByGenre(project.genero ?? ''),
                ),
              ),
              const SizedBox(width: 16),
              // Informações do projeto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          project.genero ?? 'Sem gênero',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(project.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        project.status,
                        style: TextStyle(
                          color: _getStatusColor(project.status),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Ícone de seta
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F4B7C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bar_chart,
                  color: Color(0xFF3F4B7C),
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorByGenre(String genre) {
    switch (genre.toLowerCase()) {
      case 'aventura':
      case 'aventura/rpg':
      case 'rpg':
        return const Color(0xFF6A1B9A);
      case 'plataforma':
        return const Color(0xFF0D47A1);
      case 'puzzle':
        return const Color(0xFF00838F);
      case 'ação':
        return const Color(0xFFD32F2F);
      case 'estratégia':
        return const Color(0xFF388E3C);
      default:
        return const Color(0xFF3F4B7C);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lançado':
      case 'concluído':
      case 'finalizado':
        return const Color(0xFF4CAF50);
      case 'em desenvolvimento':
      case 'desenvolvimento':
        return const Color(0xFFFF9800);
      case 'beta':
      case 'teste':
      case 'em teste':
        return const Color(0xFF2196F3);
      case 'pausado':
        return const Color(0xFF9E9E9E);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  IconData _getGenreIcon(String genre) {
    switch (genre.toLowerCase()) {
      case 'aventura':
      case 'aventura/rpg':
      case 'rpg':
        return Icons.explore;
      case 'plataforma':
        return Icons.videogame_asset;
      case 'puzzle':
        return Icons.extension;
      case 'ação':
        return Icons.sports_martial_arts;
      case 'estratégia':
        return Icons.emoji_objects;
      default:
        return Icons.games;
    }
  }
}