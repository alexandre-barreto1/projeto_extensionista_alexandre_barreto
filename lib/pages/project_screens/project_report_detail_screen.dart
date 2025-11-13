import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/project.dart';
import '../../dto/media_avaliacao_dto.dart';
import '../../repository/projetos_repository.dart';

class ProjectReportDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectReportDetailScreen({Key? key, required this.project})
      : super(key: key);

  @override
  State<ProjectReportDetailScreen> createState() =>
      _ProjectReportDetailScreenState();
}

class _ProjectReportDetailScreenState extends State<ProjectReportDetailScreen> {
  bool _isLoading = true;
  MediaAvaliacaoDto? _mediaAvaliacao;
  String? _errorMessage;
  String _selectedPeriod = 'all';

  // Paginação de comentários
  int _currentPage = 0;
  final int _commentsPerPage = 5;

  final Map<String, String> _periods = {
    'all': 'Todos',
    'week': 'Última Semana',
    'month': 'Último Mês',
    'year': 'Último Ano',
  };

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentPage = 0; // Reset página ao carregar novos dados
    });

    try {
      final projetosRepository = Provider.of<ProjetosRepository>(
        context,
        listen: false,
      );

      final media = await projetosRepository.mediaAvaliacoes(
        widget.project.id,
        _selectedPeriod,
      );

      setState(() {
        _mediaAvaliacao = media;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar relatório: $e');
      setState(() {
        _errorMessage = 'Não foi possível carregar os dados do relatório.';
        _isLoading = false;
      });
    }
  }

  List<String> get _paginatedComments {
    if (_mediaAvaliacao == null || _mediaAvaliacao!.comentarios.isEmpty) {
      return [];
    }

    final startIndex = _currentPage * _commentsPerPage;
    final endIndex = (startIndex + _commentsPerPage)
        .clamp(0, _mediaAvaliacao!.comentarios.length);

    return _mediaAvaliacao!.comentarios.sublist(startIndex, endIndex);
  }

  int get _totalPages {
    if (_mediaAvaliacao == null || _mediaAvaliacao!.comentarios.isEmpty) {
      return 0;
    }
    return (_mediaAvaliacao!.comentarios.length / _commentsPerPage).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
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
              'Carregando relatório...',
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
              onPressed: _loadReportData,
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

    if (_mediaAvaliacao == null) {
      return const Center(
        child: Text('Nenhum dado disponível'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReportData,
      color: const Color(0xFF3F4B7C),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seletor de período
            _buildPeriodSelector(),

            // Informações gerais
            _buildGeneralInfo(),

            // Gráfico de avaliações
            _buildChart(),

            // Comentários
            _buildCommentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Período de Avaliação',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _periods.entries.map((entry) {
                final isSelected = _selectedPeriod == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPeriod = entry.key;
                        });
                        _loadReportData();
                      }
                    },
                    selectedColor: const Color(0xFF3F4B7C),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.grey[200],
                    elevation: isSelected ? 4 : 0,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfo() {
    final hasData = _mediaAvaliacao!.gameplayMedia  != null &&
        _mediaAvaliacao!.gameplayMedia ! > 0;

    if (!hasData) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange[700], size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sem Avaliações',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Este projeto ainda não recebeu avaliações no período selecionado.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final average = ((_mediaAvaliacao!.gameplayMedia  ?? 0) +
        (_mediaAvaliacao!.soundMedia  ?? 0) +
        (_mediaAvaliacao!.storyMedia  ?? 0) +
        (_mediaAvaliacao!.performaceMedia  ?? 0) +
        (_mediaAvaliacao!.gameInterfaceMedia  ?? 0)) /
        5;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3F4B7C), Color(0xFF5A6FA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  average.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '/ 10.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Média Geral',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_mediaAvaliacao!.comentarios.length} avaliações',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Período: ${_periods[_selectedPeriod]}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final hasData = _mediaAvaliacao!.gameplayMedia != null &&
        _mediaAvaliacao!.gameplayMedia ! > 0;

    if (!hasData) {
      return const SizedBox.shrink();
    }

    final metrics = [
      {
        'label': 'Gameplay',
        'value': (_mediaAvaliacao!.gameplayMedia  ?? 0).toDouble(),
        'icon': Icons.gamepad,
        'color': const Color(0xFF4CAF50),
      },
      {
        'label': 'Som',
        'value': (_mediaAvaliacao!.soundMedia  ?? 0).toDouble(),
        'icon': Icons.volume_up,
        'color': const Color(0xFF2196F3),
      },
      {
        'label': 'História',
        'value': (_mediaAvaliacao!.storyMedia  ?? 0).toDouble(),
        'icon': Icons.book,
        'color': const Color(0xFF9C27B0),
      },
      {
        'label': 'Performance',
        'value': (_mediaAvaliacao!.performaceMedia  ?? 0).toDouble(),
        'icon': Icons.speed,
        'color': const Color(0xFFFF9800),
      },
      {
        'label': 'Interface',
        'value': (_mediaAvaliacao!.gameInterfaceMedia  ?? 0).toDouble(),
        'icon': Icons.dashboard,
        'color': const Color(0xFFF44336),
      },
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart,
                color: Color(0xFF3F4B7C),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Análise Detalhada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...metrics.map((metric) => _buildMetricBar(
            label: metric['label'] as String,
            value: metric['value'] as double,
            icon: metric['icon'] as IconData,
            color: metric['color'] as Color,
          )),
        ],
      ),
    );
  }

  Widget _buildMetricBar({
    required String label,
    required double value,
    required IconData icon,
    required Color color,
  }) {
    final percentage = (value / 10) * 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    if (_mediaAvaliacao!.comentarios.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.comment_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'Sem Comentários',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Nenhum comentário foi deixado neste período.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final paginatedComments = _paginatedComments;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.comment,
                  color: Color(0xFF3F4B7C),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Comentários',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F4B7C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_mediaAvaliacao!.comentarios.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F4B7C),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de comentários
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paginatedComments.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final comment = paginatedComments[index];
              final globalIndex = (_currentPage * _commentsPerPage) + index;
              return _buildCommentItem(comment, globalIndex + 1);
            },
          ),
          // Paginação
          if (_totalPages > 1) _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildCommentItem(String comment, int number) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF3F4B7C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#$number',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F4B7C),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    comment,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Informação da página
          Text(
            'Página ${_currentPage + 1} de $_totalPages',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          // Botões de navegação
          Row(
            children: [
              IconButton(
                onPressed: _currentPage > 0
                    ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: const Color(0xFF3F4B7C),
                disabledColor: Colors.grey[400],
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _currentPage < _totalPages - 1
                    ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: const Color(0xFF3F4B7C),
                disabledColor: Colors.grey[400],
              ),
            ],
          ),
        ],
      ),
    );
  }
}