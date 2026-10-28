import 'package:flutter/foundation.dart';
import '../datos/consumo_repository.dart';
import '../dominio/consumo.dart';
import '../dominio/meta.dart';

class ConsumosViewModel extends ChangeNotifier {
  final ConsumoRepository _repository;

  List<Consumo> _consumos = [];
  String? _error;
  bool _guardando = false;
  double _meta = metaInicial;

  ConsumosViewModel(this._repository);

  List<Consumo> get consumos => List.unmodifiable(_consumos);
  String? get error => _error;
  bool get guardando => _guardando;
  double get meta => _meta;

  double get total => _consumos.fold(0.0, (sum, c) => sum + c.litros);
  double get avance => avanceDeMeta(total: total, meta: _meta);
  bool get metaSuperada => total > _meta;

  Future<void> cargar() async {
    _consumos = await _repository.todos();
    notifyListeners();
  }

  Future<bool> guardar(String laboratorio, String litrosTexto) async {
    final textoLimpio = litrosTexto.trim().replaceAll(',', '.');
    final litrosParsed = double.tryParse(textoLimpio);
    final err = validarLitros(litrosParsed);

    if (err != null) {
      _error = err;
      notifyListeners();
      return false;
    }

    _guardando = true;
    _error = null;
    notifyListeners();

    final consumo = Consumo(
      laboratorio: laboratorio,
      litros: litrosParsed!,
    );
    await _repository.guardar(consumo);
    _consumos = await _repository.todos();
    _guardando = false;
    notifyListeners();
    return true;
  }

  void subirMeta() {
    _meta = ajustarMeta(_meta, pasoMeta);
    notifyListeners();
  }

  void bajarMeta() {
    _meta = ajustarMeta(_meta, -pasoMeta);
    notifyListeners();
  }
}
