# 📊 REPORTE DE PRUEBAS DE CARGA
## Prueba: ramp_1servidor

📅 **Fecha:** 2025-11-11 10:22:36

### 📈 Resumen General

| Métrica | Valor |
|---------|-------|
| ⏱️ **Duración total** | 0 minutos, 1 segundos |
| 🌐 **Peticiones totales** | 61200 |
| 👥 **Usuarios simulados** | 61200 |
| ✅ **Respuestas exitosas (HTTP 200)** | 61200 (100.00%) |
| ⚠️ **Errores 502 (Bad Gateway)** | 0 |
| ❌ **Usuarios fallidos** | 0 (0%) |
| 🔌 **Errores ECONNRESET** | 0 |
| ⏰ **Errores ETIMEDOUT** | 0 |
| 🚀 **Tasa de peticiones promedio** | 86 req/seg |

### ⏱️ Tiempos de Respuesta

| Métrica | Valor (ms) |
|---------|------------|
| 🕒 **Tiempo medio (mean)** | 109.6 |
| 💨 **Mediana (median)** | 7.9 |
| 📊 **Mínimo** | 0 |
| 📊 **Máximo** | 491 |
| 🧭 **p95 (percentil 95)** | 347.3 |
| 🧭 **p99 (percentil 99)** | 383.8 |

---

### 🔍 Interpretación Técnica

#### ✅ **Sistema Estable y Saludable**

- **Tasa de éxito:** 100.00% - El sistema responde correctamente a la mayoría de las peticiones.
- **Tiempo de respuesta:** 109.6 ms promedio - Tiempos de respuesta rápidos y aceptables.
- **Errores mínimos:** Solo 0% de fallos - El balanceador de carga distribuye correctamente la carga.

**Conclusión:** El sistema está funcionando correctamente bajo esta carga. El balanceador de carga NGINX está bien configurado y los servidores backend responden de manera eficiente.


### 📊 Análisis por Fases

Esta prueba tiene múltiples fases con diferente intensidad de carga.
Revisa el archivo JSON o el reporte HTML para detalles de cada fase.


---

**Archivo JSON completo:** `ramp_1server.json`

**Para ver el reporte HTML detallado, ejecuta:**
```bash
artillery report "/vagrant/reports/ramp_1server.json" --output "/vagrant/reports/ramp_1server.html"
```

