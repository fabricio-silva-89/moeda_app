import 'package:flutter/material.dart';

class ContributionScreen extends StatefulWidget {
  const ContributionScreen({super.key});

  @override
  State<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
  final _contributionAmountController = TextEditingController();

  double _rendaFixaPercentage = 25;
  double _fiisPercentage = 25;
  double _acoesPercentage = 35;
  double _bdrsPercentage = 15;

  @override
  void dispose() {
    _contributionAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Contribuição'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alocação de Contribuições',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildAllocationSlider(
              'Renda Fixa',
              _rendaFixaPercentage,
              (value) {
                setState(() => _rendaFixaPercentage = value);
              },
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildAllocationSlider(
              'FIIs',
              _fiisPercentage,
              (value) {
                setState(() => _fiisPercentage = value);
              },
              Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildAllocationSlider(
              'Ações',
              _acoesPercentage,
              (value) {
                setState(() => _acoesPercentage = value);
              },
              Colors.purple,
            ),
            const SizedBox(height: 16),
            _buildAllocationSlider(
              'BDRs',
              _bdrsPercentage,
              (value) {
                setState(() => _bdrsPercentage = value);
              },
              Colors.red,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Alocado',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${(_rendaFixaPercentage + _fiisPercentage + _acoesPercentage + _bdrsPercentage).toStringAsFixed(1)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Valor da Contribuição',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contributionAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Simulação de Distribuição',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSimulation(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveConfiguration,
                child: const Text('Salvar Configuração'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationSlider(
    String label,
    double value,
    Function(double) onChanged,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${value.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                )),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            thumbColor: color,
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: 0,
            max: 100,
          ),
        ),
      ],
    );
  }

  Widget _buildSimulation() {
    final amount = double.tryParse(_contributionAmountController.text) ?? 0;

    return Column(
      children: [
        _buildSimulationItem(
          'Renda Fixa',
          _rendaFixaPercentage,
          amount,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildSimulationItem(
          'FIIs',
          _fiisPercentage,
          amount,
          Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildSimulationItem(
          'Ações',
          _acoesPercentage,
          amount,
          Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildSimulationItem(
          'BDRs',
          _bdrsPercentage,
          amount,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildSimulationItem(
    String label,
    double percentage,
    double amount,
    Color color,
  ) {
    final value = (amount * percentage) / 100;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _saveConfiguration() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuração salva com sucesso!')),
    );
  }
}
