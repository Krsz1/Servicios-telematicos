# 📊 REPORTE DE PRUEBAS DE CARGA
## Prueba: spike_3servidores

📅 **Fecha:** 2025-11-11 09:59:19

### 📈 Resumen General

| Métrica | Valor |
|---------|-------|
| ⏱️ **Duración total** | 0 minutos, 0 segundos |
| 🌐 **Peticiones totales** | 19500 |
| 👥 **Usuarios simulados** | 19500 |
| ✅ **Respuestas exitosas (HTTP 200)** | 9536 (48.90%) |
| ⚠️ **Errores 502 (Bad Gateway)** | 4849 |
| ❌ **Usuarios fallidos** | 5115 (26.23%) |
| 🔌 **Errores ECONNRESET** | 3390 |
| ⏰ **Errores ETIMEDOUT** | 1725 |
| 🚀 **Tasa de peticiones promedio** | 142 req/seg |

### ⏱️ Tiempos de Respuesta

| Métrica | Valor (ms) |
|---------|------------|
| 🕒 **Tiempo medio (mean)** | 1432.3 |
| 💨 **Mediana (median)** | 1107.9 |
| 📊 **Mínimo** | 0 |
| 📊 **Máximo** | 9430 |
| 🧭 **p95 (percentil 95)** | 5272.4 |
| 🧭 **p99 (percentil 99)** | 7557.1 |

---

### 🔍 Interpretación Técnica

#### 🔴 **Sistema Saturado - Requiere Atención**

- **Tasa de éxito:** 48.90% - Alto porcentaje de fallos.
- **Tiempo de respuesta:** 1432.3 ms promedio - Tiempos muy elevados.
- **Tasa de fallos:** 26.23% - El sistema no puede manejar esta carga.

**Problemas detectados:**
- Errores ETIMEDOUT: 1725 - Conexiones que tardan demasiado
- Errores ECONNRESET: 3390 - Conexiones rechazadas o reiniciadas
- Errores 502: 4849 - Los backends no responden

**Acciones urgentes:**
1. ⚡ Aumentar el número de servidores backend
2. 🔧 Optimizar la configuración de NGINX (keepalive, buffers)
3. 📊 Revisar recursos del sistema (RAM, CPU, conexiones)
4. ⏱️ Ajustar timeouts y límites de conexiones


### 📊 Análisis por Fases

Esta prueba tiene múltiples fases con diferente intensidad de carga.
Revisa el archivo JSON o el reporte HTML para detalles de cada fase.


---

**Archivo JSON completo:** `spike_3servers.json`

**Para ver el reporte HTML detallado, ejecuta:**
```bash
artillery report "/vagrant/reports/spike_3servers.json" --output "/vagrant/reports/spike_3servers.html"
```

