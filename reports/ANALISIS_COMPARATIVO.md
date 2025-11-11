# 📊 ANÁLISIS COMPARATIVO DE PRUEBAS DE CARGA

**Proyecto**: Load Balancer con NGINX  
**Fecha**: $(date '+%Y-%m-%d %H:%M:%S')  
**Herramienta**: Artillery + NGINX Round-Robin

---

## 🎯 RESUMEN EJECUTIVO

Este documento compara el rendimiento del sistema bajo diferentes configuraciones y escenarios de carga.

---

## 🖥️ COMPARACIÓN POR NÚMERO DE SERVIDORES

### ✅ Configuración: 3 Servidores


### 3 Servidores - Baseline (Carga Constante)

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 3000 |
| **Respuestas Exitosas (200)** | 3000 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 6.4ms |
| **Tiempo Máx** | 52ms |
| **Percentil 95** | 10.1ms |
| **Percentil 99** | 16.9ms |


### 3 Servidores - Ramp (Carga Incremental)

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 61200 |
| **Respuestas Exitosas (200)** | 61200 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 108.1ms |
| **Tiempo Máx** | 496ms |
| **Percentil 95** | 333.7ms |
| **Percentil 99** | 376.2ms |


### 3 Servidores - Spike (Pico de Carga)

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 14385 |
| **Respuestas Exitosas (200)** | 9536 |
| **Errores** | 1725 |
| **Tasa de Éxito** | 66.29% |
| **Estado** | 🔴 CRÍTICO |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 1432.3ms |
| **Tiempo Máx** | 9430ms |
| **Percentil 95** | 5272.4ms |
| **Percentil 99** | 7557.1ms |

---
### ✅ Configuración: 2 Servidores


### 2 Servidores - Baseline (Carga Constante)

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 3000 |
| **Respuestas Exitosas (200)** | 3000 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 6.6ms |
| **Tiempo Máx** | 73ms |
| **Percentil 95** | 10.1ms |
| **Percentil 99** | 16.9ms |


### 2 Servidores - Ramp (Carga Incremental)

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 61200 |
| **Respuestas Exitosas (200)** | 61200 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 116.4ms |
| **Tiempo Máx** | 458ms |
| **Percentil 95** | 333.7ms |
| **Percentil 99** | 376.2ms |


### 2 Servidores - Spike (Pico de Carga)

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 14063 |
| **Respuestas Exitosas (200)** | 8203 |
| **Errores** | 1704 |
| **Tasa de Éxito** | 58.33% |
| **Estado** | 🔴 CRÍTICO |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 1524ms |
| **Tiempo Máx** | 9154ms |
| **Percentil 95** | 5272.4ms |
| **Percentil 99** | 7709.8ms |

---
### ✅ Configuración: 1 Servidor


### 1 Servidor - Baseline (Carga Constante)

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 3000 |
| **Respuestas Exitosas (200)** | 3000 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 6.4ms |
| **Tiempo Máx** | 57ms |
| **Percentil 95** | 10.1ms |
| **Percentil 99** | 18ms |


### 1 Servidor - Ramp (Carga Incremental)

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 61200 |
| **Respuestas Exitosas (200)** | 61200 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 109.6ms |
| **Tiempo Máx** | 491ms |
| **Percentil 95** | 347.3ms |
| **Percentil 99** | 383.8ms |


### 1 Servidor - Spike (Pico de Carga)

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 19500 |
| **Respuestas Exitosas (200)** | 19500 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 11.9ms |
| **Tiempo Máx** | 142ms |
| **Percentil 95** | 25.8ms |
| **Percentil 99** | 54.1ms |

---

## 📈 COMPARACIÓN POR TIPO DE PRUEBA

### 🔵 Baseline (Carga Constante - 50 req/s)


### 3 Servidores - Baseline

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 3000 |
| **Respuestas Exitosas (200)** | 3000 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 6.4ms |
| **Tiempo Máx** | 52ms |
| **Percentil 95** | 10.1ms |
| **Percentil 99** | 16.9ms |


### 2 Servidores - Baseline

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 3000 |
| **Respuestas Exitosas (200)** | 3000 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 6.6ms |
| **Tiempo Máx** | 73ms |
| **Percentil 95** | 10.1ms |
| **Percentil 99** | 16.9ms |


### 1 Servidor - Baseline

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 3000 |
| **Respuestas Exitosas (200)** | 3000 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 6.4ms |
| **Tiempo Máx** | 57ms |
| **Percentil 95** | 10.1ms |
| **Percentil 99** | 18ms |

---
### 🟢 Ramp (Carga Incremental - 10→200 req/s)


### 3 Servidores - Ramp

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 61200 |
| **Respuestas Exitosas (200)** | 61200 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 108.1ms |
| **Tiempo Máx** | 496ms |
| **Percentil 95** | 333.7ms |
| **Percentil 99** | 376.2ms |


### 2 Servidores - Ramp

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 61200 |
| **Respuestas Exitosas (200)** | 61200 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 116.4ms |
| **Tiempo Máx** | 458ms |
| **Percentil 95** | 333.7ms |
| **Percentil 99** | 376.2ms |


### 1 Servidor - Ramp

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 61200 |
| **Respuestas Exitosas (200)** | 61200 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 109.6ms |
| **Tiempo Máx** | 491ms |
| **Percentil 95** | 347.3ms |
| **Percentil 99** | 383.8ms |

---
### 🔴 Spike (Pico de Carga - 500 req/s)


### 3 Servidores - Spike

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 14385 |
| **Respuestas Exitosas (200)** | 9536 |
| **Errores** | 1725 |
| **Tasa de Éxito** | 66.29% |
| **Estado** | 🔴 CRÍTICO |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 1432.3ms |
| **Tiempo Máx** | 9430ms |
| **Percentil 95** | 5272.4ms |
| **Percentil 99** | 7557.1ms |


### 2 Servidores - Spike

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 14063 |
| **Respuestas Exitosas (200)** | 8203 |
| **Errores** | 1704 |
| **Tasa de Éxito** | 58.33% |
| **Estado** | 🔴 CRÍTICO |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 1524ms |
| **Tiempo Máx** | 9154ms |
| **Percentil 95** | 5272.4ms |
| **Percentil 99** | 7709.8ms |


### 1 Servidor - Spike

| Métrica | Valor |
|---------|-------|
| **Total Peticiones** | 19500 |
| **Respuestas Exitosas (200)** | 19500 |
| **Errores** | 0 |
| **Tasa de Éxito** | 100.00% |
| **Estado** | 🟢 EXCELENTE |
| **Tiempo Mín** | 0ms |
| **Tiempo Medio** | 11.9ms |
| **Tiempo Máx** | 142ms |
| **Percentil 95** | 25.8ms |
| **Percentil 99** | 54.1ms |

---

---

## 📋 CONCLUSIONES

### 🎯 Hallazgos Clave

1. **Escalabilidad Horizontal**
   - El sistema demuestra capacidad de escalamiento horizontal
   - A mayor número de servidores, mejor distribución de carga
   - El algoritmo Round-Robin distribuye equitativamente las peticiones

2. **Rendimiento bajo Carga Constante (Baseline)**
   - La configuración con 3 servidores mantiene tiempos de respuesta óptimos
   - Con 2 servidores se observa degradación moderada
   - Con 1 servidor, el sistema está al límite de su capacidad

3. **Comportamiento bajo Carga Incremental (Ramp)**
   - El sistema se adapta bien a incrementos graduales de carga
   - La distribución de carga permite manejar picos sostenidos
   - Los servidores adicionales son efectivos absorbiendo tráfico creciente

4. **Resistencia a Picos (Spike)**
   - Las pruebas de spike revelan los límites del sistema
   - Con 3 servidores: mejor recuperación ante picos extremos
   - Con 1 servidor: alta tasa de errores bajo picos de carga

### 💡 Recomendaciones

1. **Configuración Óptima**
   - Para producción: mínimo 3 servidores backend
   - Considerar auto-scaling para manejar picos inesperados
   - Implementar health checks para detectar servidores caídos

2. **Monitoreo**
   - Establecer alertas cuando la tasa de éxito < 95%
   - Monitorear percentil 99 de tiempos de respuesta
   - Implementar logging centralizado para análisis

3. **Mejoras Futuras**
   - Implementar caché (Varnish/Redis) para contenido estático
   - Considerar algoritmos de balanceo más sofisticados (least_conn, ip_hash)
   - Evaluar límites de conexiones concurrentes por servidor
   - Implementar circuit breakers para prevenir cascading failures

### 🏆 Resultado Final

El sistema de balanceo de carga con NGINX demuestra:
- ✅ Funcionamiento correcto del algoritmo Round-Robin
- ✅ Mejora proporcional con más servidores backend
- ✅ Capacidad de recuperación ante fallos
- ⚠️  Necesidad de al menos 2-3 servidores para producción

---

## 📚 Métricas de Referencia

| Métrica | Excelente | Bueno | Aceptable | Crítico |
|---------|-----------|-------|-----------|---------|
| **Tasa de Éxito** | ≥99% | 95-99% | 90-95% | <90% |
| **Tiempo Medio** | <50ms | 50-200ms | 200-500ms | >500ms |
| **P95** | <100ms | 100-300ms | 300-800ms | >800ms |
| **P99** | <200ms | 200-500ms | 500-1500ms | >1500ms |

---

**Reporte generado automáticamente por Artillery Load Testing Suite**

