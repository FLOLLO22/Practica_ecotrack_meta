import 'dart:math';

const double metaInicial = 100.0;
const double pasoMeta = 10.0;
const double metaMinima = 10.0;

double ajustarMeta(double metaActual, double cambio) {
  return max(metaActual + cambio, metaMinima);
}

double avanceDeMeta({required double total, required double meta}) {
  if (meta <= 0) return 0.0;
  final ratio = total / meta;
  if (ratio < 0.0) return 0.0;
  if (ratio > 1.0) return 1.0;
  return ratio;
}
