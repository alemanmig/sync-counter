# Test Plan: Contador Síncrono de N bits con Enable y Reset

## 1. Objetivo

Definir los casos de prueba dirigidos para validar el comportamiento funcional del módulo [`rtl/sync_counter.sv`](/Users/miguel/Documents/alemanmig/sync-counter/rtl/sync_counter.sv).

Este plan se deriva de:

- [docs/especificacion_sync_counter.md](/Users/miguel/Documents/alemanmig/sync-counter/docs/especificacion_sync_counter.md)
- [docs/verification_plan_sync_counter.md](/Users/miguel/Documents/alemanmig/sync-counter/docs/verification_plan_sync_counter.md)

## 2. Configuración base de pruebas

Salvo que se indique lo contrario, los casos de prueba se ejecutan con:

- `N = 4`
- `ResetValue = '0`

Equivalencia de señales entre especificación y DUT:

| Señal en especificación | Señal en DUT |
| --- | --- |
| `clk` | `clk_i` |
| `rst_n` | `rst_ni` |
| `enable` | `enable_i` |
| `count` | `count_o` |

## 3. Casos de prueba

### TC1 - Conteo con enable activo

**Objetivo**

Verificar que el contador incrementa cuando `enable_i = 1`.

**Precondiciones**

- `N = 4`
- Reset aplicado y luego liberado
- `enable_i = 1`
- `count_o` inicia en `0`

**Estímulo**

- Mantener `enable_i = 1`
- Observar el contador durante 10 ciclos de reloj

**Resultado esperado**

- Después de 3 ciclos de reloj, `count_o = 3`
- Después de 10 ciclos totales, `count_o = 10`

**Requisitos cubiertos**

- `R2`, `R4`

### TC2 - Retención con enable desactivado

**Objetivo**

Verificar que el contador mantiene su valor cuando `enable_i = 0`.

**Precondiciones**

- `count_o = 10`

**Estímulo**

- Desactivar `enable_i = 0` durante 2 ciclos
- Activar nuevamente `enable_i = 1`

**Resultado esperado**

- Durante los 2 ciclos con `enable_i = 0`, `count_o` permanece en `10`
- Al reactivar `enable_i`, en el siguiente ciclo `count_o = 11`

**Requisitos cubiertos**

- `R3`
- `R2`

### TC3 - Wraparound

**Objetivo**

Verificar el comportamiento de wraparound del contador.

**Precondiciones**

- `N = 4`
- `enable_i = 1`
- `count_o = 15` (`4'hF`)

**Estímulo**

- Aplicar 1 ciclo adicional de reloj con `enable_i = 1`

**Resultado esperado**

- En el siguiente ciclo, `count_o = 0`

**Requisitos cubiertos**

- `R4`

### TC4 - Reset

**Objetivo**

Verificar que el reset asíncrono activo en bajo reinicia el contador.

**Precondiciones**

- El contador se encuentra en un valor arbitrario distinto de `0`

**Estímulo**

- Forzar `rst_ni = 0`
- Liberar reset con `rst_ni = 1`
- Activar `enable_i = 1`

**Resultado esperado**

- Al activar `rst_ni = 0`, `count_o` pasa a `0`
- Después de liberar reset, el contador permanece en `0` hasta el siguiente ciclo habilitado
- Una vez reanudado el conteo con `enable_i = 1`, el contador incrementa desde `0`

**Nota**

Este resultado esperado asume `ResetValue = '0`, que es el valor por defecto del RTL.

**Requisitos cubiertos**

- `R5`
- `R6`

### TC5 - Conteo continuo

**Objetivo**

Verificar una secuencia continua de conteo con `enable_i` permanentemente activo.

**Precondiciones**

- `N = 4`
- Reset aplicado y liberado correctamente
- `enable_i = 1` durante toda la prueba

**Estímulo**

- Observar el contador por múltiples ciclos consecutivos

**Resultado esperado**

- La secuencia observada debe ser:
- `0, 1, 2, ..., 15, 0, 1, ...`

**Requisitos cubiertos**

- `R2`
- `R4`
- `R5`

## 4. Resumen de cobertura por caso

| Test Case | Descripción | Requisitos cubiertos |
| --- | --- | --- |
| `TC1` | Conteo con enable activo | `R2`, `R4` |
| `TC2` | Retención con enable desactivado | `R2`, `R3` |
| `TC3` | Wraparound | `R4` |
| `TC4` | Reset asíncrono activo en bajo | `R5`, `R6` |
| `TC5` | Conteo continuo | `R2`, `R4`, `R5` |

## 5. Criterio de aprobación

El Test Plan se considera aprobado cuando:

- Todos los casos `TC1` a `TC5` pasan sin discrepancias.
- Los resultados observados coinciden con el comportamiento esperado definido en la especificación.
- No se detectan desviaciones funcionales en enable, reset, incremento o wraparound.
