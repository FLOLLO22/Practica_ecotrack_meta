import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos/consumo_repository.dart';
import '../presentacion/consumos_view_model.dart';
import '../presentacion/vistas.dart';

class AppProvider extends StatelessWidget {
  final ConsumoRepository repositorio;

  const AppProvider({super.key, required this.repositorio});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConsumosViewModel>(
      create: (_) => ConsumosViewModel(repositorio)..cargar(),
      child: const MaterialApp(
        home: PantallasEcoTrack(
          registro: RegistroProvider(),
          historial: HistorialProvider(),
          meta: MetaProvider(),
        ),
      ),
    );
  }
}

class RegistroProvider extends StatelessWidget {
  const RegistroProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return FormularioRegistro(
      error: vm.error,
      guardando: vm.guardando,
      alGuardar: (laboratorio, litrosTexto) {
        return context.read<ConsumosViewModel>().guardar(laboratorio, litrosTexto);
      },
    );
  }
}

class HistorialProvider extends StatelessWidget {
  const HistorialProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return ListaHistorial(
      consumos: vm.consumos,
      total: vm.total,
    );
  }
}

class MetaProvider extends StatelessWidget {
  const MetaProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return PanelMeta(
      total: vm.total,
      meta: vm.meta,
      avance: vm.avance,
      metaSuperada: vm.metaSuperada,
      alSubir: () => context.read<ConsumosViewModel>().subirMeta(),
      alBajar: () => context.read<ConsumosViewModel>().bajarMeta(),
    );
  }
}
