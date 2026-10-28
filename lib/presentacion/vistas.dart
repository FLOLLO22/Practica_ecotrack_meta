import 'package:flutter/material.dart';
import '../dominio/consumo.dart';

class FormularioRegistro extends StatefulWidget {
  final String? error;
  final bool guardando;
  final Future<bool> Function(String laboratorio, String litrosTexto) alGuardar;

  const FormularioRegistro({
    super.key,
    this.error,
    required this.guardando,
    required this.alGuardar,
  });

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  String _laboratorioElegido = laboratoriosUtez.first;
  late final TextEditingController _litrosController;

  @override
  void initState() {
    super.initState();
    _litrosController = TextEditingController();
  }

  @override
  void dispose() {
    _litrosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _laboratorioElegido,
            items: laboratoriosUtez.map((lab) {
              return DropdownMenuItem(
                value: lab,
                child: Text(lab),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _laboratorioElegido = val;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('litros'),
            controller: _litrosController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Litros',
              errorText: widget.error,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.guardando
                ? null
                : () async {
                    final exito = await widget.alGuardar(
                      _laboratorioElegido,
                      _litrosController.text,
                    );
                    if (mounted && exito) {
                      _litrosController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Consumo guardado')),
                      );
                    }
                  },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class ListaHistorial extends StatelessWidget {
  final List<Consumo> consumos;
  final double total;

  const ListaHistorial({
    super.key,
    required this.consumos,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (consumos.isEmpty) {
      return const Center(child: Text('Sin consumos'));
    }
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Total: ${total.toStringAsFixed(1)} L',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...consumos.map((c) => ListTile(
              title: Text(c.laboratorio),
              trailing: Text('${c.litros.toStringAsFixed(1)} L'),
            )),
      ],
    );
  }
}

class PanelMeta extends StatelessWidget {
  final double total;
  final double meta;
  final double avance;
  final bool metaSuperada;
  final VoidCallback alSubir;
  final VoidCallback alBajar;

  const PanelMeta({
    super.key,
    required this.total,
    required this.meta,
    required this.avance,
    required this.metaSuperada,
    required this.alSubir,
    required this.alBajar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Usado: ${total.toStringAsFixed(1)} de ${meta.toStringAsFixed(1)} L'),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: avance),
          const SizedBox(height: 16),
          Text(metaSuperada ? 'Te pasaste de la meta' : 'Dentro de la meta'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                key: const Key('subirMeta'),
                icon: const Icon(Icons.add),
                onPressed: alSubir,
              ),
              IconButton(
                key: const Key('bajarMeta'),
                icon: const Icon(Icons.remove),
                onPressed: alBajar,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PantallasEcoTrack extends StatefulWidget {
  final Widget registro;
  final Widget historial;
  final Widget meta;

  const PantallasEcoTrack({
    super.key,
    required this.registro,
    required this.historial,
    required this.meta,
  });

  @override
  State<PantallasEcoTrack> createState() => _PantallasEcoTrackState();
}

class _PantallasEcoTrackState extends State<PantallasEcoTrack> {
  int _indiceSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoTrack Meta'),
      ),
      body: IndexedStack(
        index: _indiceSeleccionado,
        children: [
          widget.registro,
          widget.historial,
          widget.meta,
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceSeleccionado,
        onDestinationSelected: (idx) {
          setState(() {
            _indiceSeleccionado = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.edit),
            label: 'Registro',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag),
            label: 'Meta',
          ),
        ],
      ),
    );
  }
}
