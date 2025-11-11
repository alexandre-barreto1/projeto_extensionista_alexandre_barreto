// lib/pages/review_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/projeto_avaliacao.dart';
import '../../repository/projetos_repository.dart';

class ReviewScreen extends StatefulWidget {
  final Map<String, dynamic> game;

  const ReviewScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double gameplayRating = 3.0;
  double graphicsRating = 3.0;
  double soundRating = 3.0;
  double storyRating = 3.0;
  double performanceRating = 3.0;
  double interfaceRating = 3.0;
  final _commentController = TextEditingController();

  // Adicionar estado de loading
  bool _isSaving = false;

  double get averageRating {
    return (gameplayRating + graphicsRating + soundRating +
        storyRating + performanceRating + interfaceRating) / 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliar Jogo'),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.game['name'] as String,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F4B7C),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFB300), size: 32),
                  const SizedBox(width: 8),
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' / 5.0',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Avalie os seguintes aspectos:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRatingSlider(
              'Gameplay',
              gameplayRating,
              Icons.gamepad,
                  (value) => setState(() => gameplayRating = value),
            ),
            _buildRatingSlider(
              'Graphics',
              graphicsRating,
              Icons.palette,
                  (value) => setState(() => graphicsRating = value),
            ),
            _buildRatingSlider(
              'Sound',
              soundRating,
              Icons.volume_up,
                  (value) => setState(() => soundRating = value),
            ),
            _buildRatingSlider(
              'Story',
              storyRating,
              Icons.book,
                  (value) => setState(() => storyRating = value),
            ),
            _buildRatingSlider(
              'Performance',
              performanceRating,
              Icons.speed,
                  (value) => setState(() => performanceRating = value),
            ),
            _buildRatingSlider(
              'Interface',
              interfaceRating,
              Icons.dashboard,
                  (value) => setState(() => interfaceRating = value),
            ),
            const SizedBox(height: 24),
            const Text(
              'Comentário (opcional):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Compartilhe sua experiência com o jogo...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : () {
                  _submitReview(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
                  'Enviar Avaliação',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSlider(
      String label,
      double value,
      IconData icon,
      ValueChanged<double> onChanged,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF3F4B7C), size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF4CAF50),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: const Color(0xFF4CAF50),
              overlayColor: const Color(0xFF4CAF50).withOpacity(0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 5,
              divisions: 10,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('5', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submitReview(BuildContext context) async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Obter o ID do projeto do game map
      final projectId = widget.game['id'] as String?;

      if (projectId == null || projectId.isEmpty) {
        throw Exception('ID do projeto não encontrado');
      }

      // Criar objeto ProjetoAvaliacao
      // Converter ratings de 0-5 para 0-10 multiplicando por 2
      final avaliacao = ProjetoAvaliacao(
        projectId,
        (gameplayRating * 2).round(),      // gameplay
        (soundRating * 2).round(),         // sound
        (storyRating * 2).round(),         // story
        (performanceRating * 2).round(),   // performance
        (interfaceRating * 2).round(),     // gameInterface
        _commentController.text.isEmpty ? null : _commentController.text, // comentario
      );

      // Obter o repository via Provider
      final projetosRepository = Provider.of<ProjetosRepository>(
        context,
        listen: false,
      );

      // Chamar o método salvarAvaliacao
      final avaliacaoSalva = await projetosRepository.salvarAvaliacao(avaliacao);

      setState(() {
        _isSaving = false;
      });

      // Mostrar dialog de sucesso
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 32,
                ),
                SizedBox(width: 8),
                Text('Avaliação Enviada!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Obrigado por avaliar ${widget.game['name']}!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nota média: ${averageRating.toStringAsFixed(1)}/5.0',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Detalhes da avaliação:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildScoreRow('🎮 Gameplay', gameplayRating),
                _buildScoreRow('🎨 Gráficos', graphicsRating),
                _buildScoreRow('🔊 Som', soundRating),
                _buildScoreRow('📖 História', storyRating),
                _buildScoreRow('⚡ Performance', performanceRating),
                _buildScoreRow('🖥️ Interface', interfaceRating),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar dialog
                  Navigator.of(context).pop(); // Voltar para detalhes do jogo
                },
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
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      // Mostrar erro
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 32),
                SizedBox(width: 8),
                Text('Erro ao Enviar'),
              ],
            ),
            content: Text(
              'Não foi possível enviar sua avaliação.\n\nErro: ${e.toString()}',
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

      print('Erro ao salvar avaliação: $e');
    }
  }

  Widget _buildScoreRow(String label, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            score.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}