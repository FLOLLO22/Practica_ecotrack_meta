# Gestión de estado — EcoTrack Meta

**Equipo:** Estudiantes
**Fecha:** 2026-10-28

## Tipos de estado en nuestro código

| Dato | Tipo (efímero, compartido, derivado, persistido) | Dónde vive |
| --- | --- | --- |
| Pestaña activa | Efímero | State de PantallasEcoTrack |
| Texto del campo de litros | Efímero | State de FormularioRegistro |
| consumos y meta | Compartido | ConsumosViewModel |
| total y metaSuperada | Derivado | Getters de ConsumosViewModel |
| Lo que regresa todos() | Persistido | MemoriaConsumoRepository |

## Criterios

| Criterio | A · ChangeNotifier puro | B · provider |
| --- | --- | --- |
| Dato compartido | ConsumosViewModel pasado por constructor | ConsumosViewModel expuesto en el árbol con ChangeNotifierProvider |
| Capas | ConsumosViewModel valida con la función del dominio validarLitros | ConsumosViewModel valida con la función del dominio validarLitros |
| Encaje con el diagrama | Adapters (RegistroCN, HistorialCN, MetaCN) escuchan con ListenableBuilder | Adapters (RegistroProvider, HistorialProvider, MetaProvider) escuchan con context.watch |
| Constructores que reciben vm | Todos los adaptadores (RegistroCN, HistorialCN, MetaCN) reciben vm | Ningún adaptador recibe vm |
| Quién libera el ViewModel | State de AppChangeNotifier en su dispose() | ChangeNotifierProvider automáticamente al desmontarse |
| Costo de adoptarla ahora | Bajo en proyectos pequeños, alto si hay subpantallas profundas por prop drilling | Muy bajo porque provider evita prop drilling en el árbol de widgets |
| Sustitución de la fuente de datos | Inyección por constructor de ConsumoRepository en AppChangeNotifier | Inyección por constructor de ConsumoRepository en AppProvider |

## Elección

Elegimos: B · provider

Se mantiene esta pieza del diagrama: ConsumosViewModel

Esta pieza es la que podría sustituirse después: MemoriaConsumoRepository
