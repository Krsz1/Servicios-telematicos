# 📊 REPORTE DE PRUEBAS DE CARGA
## Prueba: spike_4servidores

📅 **Fecha:** 2025-11-11 11:23:43

### 📈 Resumen General

| Métrica | Valor |
|---------|-------|
| ⏱️ **Duración total** | 0 minutos, 0 segundos |
| 🌐 **Peticiones totales** | 19500 |
| 👥 **Usuarios simulados** | 19500 |
| ✅ **Respuestas exitosas (HTTP 200)** | 10867 (55.72%) |
| ⚠️ **Errores 502 (Bad Gateway)** | 3538 |
| ❌ **Usuarios fallidos** | 5095 (26.12%) |
| 🔌 **Errores ECONNRESET** | 3635 |
| ⏰ **Errores ETIMEDOUT** | 1460 |
| 🚀 **Tasa de peticiones promedio** | 132 req/seg |

### ⏱️ Tiempos de Respuesta

| Métrica | Valor (ms) |
|---------|------------|
| 🕒 **Tiempo medio (mean)** | 1374.7 |
| 💨 **Mediana (median)** | 18 |
| 📊 **Mínimo** | 0 |
| 📊 **Máximo** | 9150 |
| 🧭 **p95 (percentil 95)** | 5826.9 |
| 🧭 **p99 (percentil 99)** | 7709.8 |

---

### 🔍 Interpretación Técnica

#### 🔴 **Sistema Saturado - Requiere Atención**

- **Tasa de éxito:** 55.72% - Alto porcentaje de fallos.
- **Tiempo de respuesta:** 1374.7 ms promedio - Tiempos muy elevados.
- **Tasa de fallos:** 26.12% - El sistema no puede manejar esta carga.

**Problemas detectados:**
- Errores ETIMEDOUT: 1460 - Conexiones que tardan demasiado
- Errores ECONNRESET: 3635 - Conexiones rechazadas o reiniciadas
- Errores 502: 3538 - Los backends no responden

**Acciones urgentes:**
1. ⚡ Aumentar el número de servidores backend
2. 🔧 Optimizar la configuración de NGINX (keepalive, buffers)
3. 📊 Revisar recursos del sistema (RAM, CPU, conexiones)
4. ⏱️ Ajustar timeouts y límites de conexiones


### 📊 Análisis por Fases

Esta prueba tiene múltiples fases con diferente intensidad de carga.
Revisa el archivo JSON o el reporte HTML para detalles de cada fase.


---

**Archivo JSON completo:** `spike_4servers.json`

**Para ver el reporte HTML detallado, ejecuta:**
```bash
artillery report "/vagrant/reports/spike_4servers.json" --output "/vagrant/reports/spike_4servers.html"
```

