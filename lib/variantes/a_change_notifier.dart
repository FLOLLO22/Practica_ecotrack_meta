import 'package:flutter/material.dart';
import '../datos/consumo_repository.dart';
import '../presentacion/consumos_view_model.dart';
import '../presentacion/vistas.dart';

class AppChangeNotifier extends StatefulWidget {
  final ConsumoRepository repositorio;

  const AppChangeNotifier({super.key, required this.repositorio});

  @override
  State<AppChangeNotifier> createState() => _AppChangeNotifierState();
}

class _AppChangeNotifierState extends State<AppChangeNotifier> {
  late final ConsumosViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ConsumosViewModel(widget.repositorio);
    vm.cargar();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PantallasEcoTrack(
        registro: RegistroCN(vm: vm),
        historial: HistorialCN(vm: vm),
        meta: MetaCN(vm: vm),
      ),
    );
  }
}

class RegistroCN extends StatelessWidget {
  final ConsumosViewModel vm;

  const RegistroCN({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return FormularioRegistro(
          error: vm.error,
          guardando: vm.guardando,
          alGuardar: vm.guardar,
        );
      },
    );
  }
}

class HistorialCN extends StatelessWidget {
  final ConsumosViewModel vm;

  const HistorialCN({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return ListaHistorial(
          consumos: vm.consumos,
          total: vm.total,
        );
      },
    );
  }
}

class MetaCN extends StatelessWidget {
  final ConsumosViewModel vm;

  const MetaCN({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return PanelMeta(
          total: vm.total,
          meta: vm.meta,
          avance: vm.avance,
          metaSuperada: vm.metaSuperada,
          alSubir: vm.subirMeta,
          alBajar: vm.bajarMeta,
        );
      },
    );
  }
}
