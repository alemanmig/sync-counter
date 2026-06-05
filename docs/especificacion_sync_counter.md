# Especificación de Diseño: Contador Síncrono de N bits con Enable y Reset

## 1. Objetivo

Diseñar e implementar un contador ascendente parametrizable de `N` bits con señal de habilitación y reset activo en bajo.

Comportamiento esperado:

- Si `enable = 1`, el contador incrementa en cada flanco ascendente del reloj.
- Si `enable = 0`, el contador conserva su valor actual.
- El contador envuelve naturalmente de `2^N - 1` a `0`.

## 2. Elección de reset

El diseño RTL implementado usa **reset asíncrono activo en bajo**.

Esto significa que:

- Cuando `rst_ni = 0`, el contador se reinicia inmediatamente.
- Cuando `rst_ni = 1`, el contador opera de forma normal sobre el flanco ascendente de `clk_i`.

Adicionalmente, el diseño permite parametrizar el valor de reset mediante `ResetValue`, cuyo valor por defecto es `'0`.

## 3. Parámetros

| Parámetro | Tipo | Valor por defecto | Descripción |
| --- | --- | --- | --- |
| `N` | `int unsigned` | `4` | Ancho del contador en bits. |
| `ResetValue` | `logic [N-1:0]` | `'0` | Valor cargado durante el reset. |

Rango del contador:

- Desde `0` hasta `2^N - 1`.

## 4. Puertos de entrada y salida

El requerimiento original usa los nombres `clk`, `rst_n`, `enable` y `count`.
El RTL actual usa convención LowRISC para nombres de puertos:

- Entradas con sufijo `_i`
- Salidas con sufijo `_o`
- Reset activo en bajo con sufijo `_ni`

| Señal RTL | Equivalente requerido | Ancho | Dirección | Descripción |
| --- | --- | --- | --- | --- |
| `clk_i` | `clk` | `1` | Entrada | Reloj del sistema, activo en flanco ascendente. |
| `rst_ni` | `rst_n` | `1` | Entrada | Reset asíncrono activo en bajo. |
| `enable_i` | `enable` | `1` | Entrada | Habilitación del contador. |
| `count_o` | `count` | `N-1:0` | Salida | Valor actual del contador. |

## 5. Requisitos funcionales

### 5.1 Parametrización

El parámetro `N` define el ancho del contador.

- El contador tiene `N` bits.
- Su rango natural es de `0` a `2^N - 1`.

### 5.2 Control por enable

- Cuando `enable_i = 1`, el contador incrementa en el siguiente flanco ascendente del reloj.
- Cuando `enable_i = 0`, el contador mantiene su valor.

### 5.3 Incremento

En cada ciclo habilitado:

```systemverilog
count <= count + 1;
```

En el RTL actual esto se implementa con lógica combinacional de siguiente estado:

```systemverilog
count_d = count_q + 1'b1;
```

### 5.4 Wraparound

El contador envuelve de manera natural usando aritmética módulo `2^N`.

Por lo tanto:

- Si el contador vale `2^N - 1`
- y `enable_i = 1`
- el siguiente valor será `0`

### 5.5 Reset

Cuando `rst_ni = 0`:

- el contador carga inmediatamente `ResetValue`
- por defecto, `ResetValue = '0`

## 6. Correspondencia con el RTL actual

Archivo revisado:

- [`rtl/sync_counter.sv`](/Users/miguel/Documents/alemanmig/sync-counter/rtl/sync_counter.sv)

Resumen de cumplimiento:

| Requisito | Estado | Observación |
| --- | --- | --- |
| Contador ascendente de `N` bits | Cumple | `N` define el ancho de `count_q`, `count_d` y `count_o`. |
| Incremento con `enable = 1` | Cumple | Se incrementa con `count_d = count_q + 1'b1`. |
| Retención con `enable = 0` | Cumple | `count_d` toma por defecto `count_q`. |
| Wraparound módulo `2^N` | Cumple | La suma sobre `N` bits produce envoltura natural. |
| Reset activo en bajo | Cumple | Implementado en `always_ff @(posedge clk_i or negedge rst_ni)`. |
| Reset asíncrono | Cumple | La sensibilidad a `negedge rst_ni` confirma reset asíncrono. |
| Inicialización a `0` | Cumple parcialmente | Por defecto sí inicializa a `0`, pero también permite otro valor mediante `ResetValue`. |
| Nombres de puertos del enunciado | No exacto | El RTL usa nomenclatura LowRISC: `clk_i`, `rst_ni`, `enable_i`, `count_o`. |

## 7. Conclusión

El diseño RTL **sí cumple funcionalmente** con las especificaciones solicitadas.

Las únicas diferencias respecto al enunciado original son:

- Los nombres de puertos fueron adaptados al estilo LowRISC.
- El valor de reset es parametrizable mediante `ResetValue`, aunque por defecto se reinicia a `0`.

No se identificaron desviaciones funcionales en el comportamiento del contador.
