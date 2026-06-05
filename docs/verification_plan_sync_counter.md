# Verification Plan: Contador Síncrono de N bits con Enable y Reset

## 1. Objetivo

Definir la estrategia de verificación para el módulo [`rtl/sync_counter.sv`](/Users/miguel/Documents/alemanmig/sync-counter/rtl/sync_counter.sv), asegurando que su implementación cumple con la especificación funcional documentada en [docs/especificacion_sync_counter.md](/Users/miguel/Documents/alemanmig/sync-counter/docs/especificacion_sync_counter.md).

## 2. Alcance

La verificación cubre los siguientes aspectos del diseño:

- Parametrización del ancho del contador mediante `N`.
- Incremento del contador cuando `enable_i = 1`.
- Retención del valor cuando `enable_i = 0`.
- Wraparound natural módulo `2^N`.
- Reset asíncrono activo en bajo.
- Reinicio al valor configurado por `ResetValue`, considerando por defecto `ResetValue = '0`.

## 3. Suposiciones

- El reloj `clk_i` es estable y los eventos relevantes ocurren en su flanco ascendente.
- La verificación base usará `N = 4`, salvo que se indique lo contrario.
- Los casos que esperan reset a `0` asumen `ResetValue = '0`, que coincide con el valor por defecto del RTL.
- La nomenclatura de puertos en el DUT sigue convención LowRISC: `clk_i`, `rst_ni`, `enable_i`, `count_o`.

## 4. Estrategia de verificación

La verificación funcional se basará en simulación dirigida con observación ciclo a ciclo del valor de `count_o`.

Se validarán:

- Secuencias básicas de conteo.
- Comportamiento con `enable_i` desactivado.
- Condición de overflow y wraparound.
- Respuesta inmediata al reset asíncrono.
- Conteo continuo desde reset.

## 5. Features a verificar

| ID | Feature | Descripción |
| --- | --- | --- |
| `F1` | Parametrización | El ancho del contador está definido por `N`. |
| `F2` | Enable | El contador sólo incrementa cuando `enable_i = 1`. |
| `F3` | Hold | El contador conserva su valor cuando `enable_i = 0`. |
| `F4` | Incremento | El contador incrementa exactamente en `+1` por ciclo habilitado. |
| `F5` | Wraparound | El contador envuelve de `2^N - 1` a `0`. |
| `F6` | Reset asíncrono | El contador se reinicia inmediatamente al activar `rst_ni = 0`. |
| `F7` | Valor de reset | El contador toma `ResetValue` durante reset. |

## 6. Matriz de trazabilidad requisito-verificación

| ID | Requisito | Método de verificación | Criterio de aceptación |
| --- | --- | --- | --- |
| `R1` | El contador debe ser parametrizable por `N`. | Simulación con instancia `N=4` y revisión estructural del RTL. | `count_o` tiene ancho `N` y opera entre `0` y `2^N-1`. |
| `R2` | Cuando `enable=1`, el contador incrementa por flanco ascendente. | Simulación dirigida. | `count_o(n+1) = count_o(n) + 1`. |
| `R3` | Cuando `enable=0`, el contador mantiene su valor. | Simulación dirigida. | `count_o` no cambia entre ciclos con `enable_i = 0`. |
| `R4` | El contador envuelve módulo `2^N`. | Simulación dirigida en valor máximo. | Después de `2^N - 1`, el siguiente valor es `0`. |
| `R5` | El reset es asíncrono y activo en bajo. | Simulación dirigida aplicando `rst_ni = 0` fuera del flanco de reloj. | `count_o` se actualiza a valor de reset inmediatamente. |
| `R6` | El valor de reset es `0` o parametrizable. | Simulación con valor por defecto y revisión del parámetro `ResetValue`. | Con configuración por defecto, `count_o = 0` durante reset. |

## 7. Cobertura funcional esperada

La verificación debe cubrir al menos:

- Activación y desactivación de `enable_i`.
- Conteo desde `0` hasta valor intermedio.
- Conteo desde valor intermedio hasta máximo.
- Transición de máximo a `0`.
- Aplicación de reset desde un valor arbitrario.
- Conteo continuo durante múltiples ciclos.

## 8. Riesgos y observaciones

- La especificación original nombra puertos como `clk`, `rst_n`, `enable` y `count`, pero el RTL usa `clk_i`, `rst_ni`, `enable_i` y `count_o`.
- La mayoría de los casos de prueba esperan reset a `0`; esto es correcto con la configuración por defecto del DUT.
- Si en el futuro se cambia `ResetValue`, deberán ajustarse los resultados esperados de los tests relacionados con reset.

## 9. Criterio de salida

La verificación se considera satisfactoria cuando:

- Todos los casos de prueba del Test Plan pasan.
- No existen discrepancias funcionales contra la especificación.
- La trazabilidad requisito-verificación queda completamente cubierta.
