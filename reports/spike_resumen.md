# 📊 REPORTE DE PRUEBAS DE CARGA
## Prueba: prueba

📅 **Fecha:** 2025-11-11 08:46:31

### 📈 Resumen General

| Métrica | Valor |
|---------|-------|
| ⏱️ **Duración total** | 0 minutos, 0 segundos |
| 🌐 **Peticiones totales** | 19500 |
| 👥 **Usuarios simulados** | 19500 |
| ✅ **Respuestas exitosas (HTTP 200)** | 9227 (47.31%) |
| ⚠️ **Errores 502 (Bad Gateway)** | 5749 |
| ❌ **Usuarios fallidos** | 4524 (23.20%) |
| 🔌 **Errores ECONNRESET** | 3222 |
| ⏰ **Errores ETIMEDOUT** | 1302 |
| 🚀 **Tasa de peticiones promedio** | 140 req/seg |

### ⏱️ Tiempos de Respuesta

| Métrica | Valor (ms) |
|---------|------------|
| 🕒 **Tiempo medio (mean)** | 1378.8 |
| 💨 **Mediana (median)** | 727.9 |
| 📊 **Mínimo** | 0 |
| 📊 **Máximo** | 9220 |
| 🧭 **p95 (percentil 95)** | 5272.4 |
| 🧭 **p99 (percentil 99)** | 8186.6 |

---

### 🔍 Interpretación Técnica

#### 🔴 **Sistema Saturado - Requiere Atención**

- **Tasa de éxito:** 47.31% - Alto porcentaje de fallos.
- **Tiempo de respuesta:** 1378.8 ms promedio - Tiempos muy elevados.
- **Tasa de fallos:** 23.20% - El sistema no puede manejar esta carga.

**Problemas detectados:**
- Errores ETIMEDOUT: 1302 - Conexiones que tardan demasiado
- Errores ECONNRESET: 3222 - Conexiones rechazadas o reiniciadas
- Errores 502: 5749 - Los backends no responden

**Acciones urgentes:**
1. ⚡ Aumentar el número de servidores backend
2. 🔧 Optimizar la configuración de NGINX (keepalive, buffers)
3. 📊 Revisar recursos del sistema (RAM, CPU, conexiones)
4. ⏱️ Ajustar timeouts y límites de conexiones


---

**Archivo JSON completo:** `spike.json`

**Para ver el reporte HTML detallado, ejecuta:**
```bash
artillery report "/vagrant/reports/spike.json" --output "/vagrant/reports/spike.html"
```

