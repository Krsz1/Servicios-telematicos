# 📊 REPORTE DE PRUEBAS DE CARGA
## Prueba: spike_2servidores

📅 **Fecha:** 2025-11-11 09:23:33

### 📈 Resumen General

| Métrica | Valor |
|---------|-------|
| ⏱️ **Duración total** | 0 minutos, 0 segundos |
| 🌐 **Peticiones totales** | 19500 |
| 👥 **Usuarios simulados** | 19500 |
| ✅ **Respuestas exitosas (HTTP 200)** | 8203 (42.06%) |
| ⚠️ **Errores 502 (Bad Gateway)** | 5860 |
| ❌ **Usuarios fallidos** | 5437 (27.88%) |
| 🔌 **Errores ECONNRESET** | 3733 |
| ⏰ **Errores ETIMEDOUT** | 1704 |
| 🚀 **Tasa de peticiones promedio** | 140 req/seg |

### ⏱️ Tiempos de Respuesta

| Métrica | Valor (ms) |
|---------|------------|
| 🕒 **Tiempo medio (mean)** | 1524 |
| 💨 **Mediana (median)** | 1249.1 |
| 📊 **Mínimo** | 0 |
| 📊 **Máximo** | 9154 |
| 🧭 **p95 (percentil 95)** | 5272.4 |
| 🧭 **p99 (percentil 99)** | 7709.8 |

---

### 🔍 Interpretación Técnica

#### 🔴 **Sistema Saturado - Requiere Atención**

- **Tasa de éxito:** 42.06% - Alto porcentaje de fallos.
- **Tiempo de respuesta:** 1524 ms promedio - Tiempos muy elevados.
- **Tasa de fallos:** 27.88% - El sistema no puede manejar esta carga.

**Problemas detectados:**
- Errores ETIMEDOUT: 1704 - Conexiones que tardan demasiado
- Errores ECONNRESET: 3733 - Conexiones rechazadas o reiniciadas
- Errores 502: 5860 - Los backends no responden

**Acciones urgentes:**
1. ⚡ Aumentar el número de servidores backend
2. 🔧 Optimizar la configuración de NGINX (keepalive, buffers)
3. 📊 Revisar recursos del sistema (RAM, CPU, conexiones)
4. ⏱️ Ajustar timeouts y límites de conexiones


### 📊 Análisis por Fases

Esta prueba tiene múltiples fases con diferente intensidad de carga.
Revisa el archivo JSON o el reporte HTML para detalles de cada fase.


---

**Archivo JSON completo:** `spike_2servers.json`

**Para ver el reporte HTML detallado, ejecuta:**
```bash
artillery report "/vagrant/reports/spike_2servers.json" --output "/vagrant/reports/spike_2servers.html"
```

