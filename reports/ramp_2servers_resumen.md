# 📊 REPORTE DE PRUEBAS DE CARGA
## Prueba: ramp_2servidores

📅 **Fecha:** 2025-11-11 09:22:52

### 📈 Resumen General

| Métrica | Valor |
|---------|-------|
| ⏱️ **Duración total** | 0 minutos, 0 segundos |
| 🌐 **Peticiones totales** | 61200 |
| 👥 **Usuarios simulados** | 61200 |
| ✅ **Respuestas exitosas (HTTP 200)** | 61200 (100.00%) |
| ⚠️ **Errores 502 (Bad Gateway)** | 0 |
| ❌ **Usuarios fallidos** | 0 (0%) |
| 🔌 **Errores ECONNRESET** | 0 |
| ⏰ **Errores ETIMEDOUT** | 0 |
| 🚀 **Tasa de peticiones promedio** | 84 req/seg |

### ⏱️ Tiempos de Respuesta

| Métrica | Valor (ms) |
|---------|------------|
| 🕒 **Tiempo medio (mean)** | 116.4 |
| 💨 **Mediana (median)** | 7.9 |
| 📊 **Mínimo** | 0 |
| 📊 **Máximo** | 458 |
| 🧭 **p95 (percentil 95)** | 333.7 |
| 🧭 **p99 (percentil 99)** | 376.2 |

---

### 🔍 Interpretación Técnica

#### ✅ **Sistema Estable y Saludable**

- **Tasa de éxito:** 100.00% - El sistema responde correctamente a la mayoría de las peticiones.
- **Tiempo de respuesta:** 116.4 ms promedio - Tiempos de respuesta rápidos y aceptables.
- **Errores mínimos:** Solo 0% de fallos - El balanceador de carga distribuye correctamente la carga.

**Conclusión:** El sistema está funcionando correctamente bajo esta carga. El balanceador de carga NGINX está bien configurado y los servidores backend responden de manera eficiente.


### 📊 Análisis por Fases

Esta prueba tiene múltiples fases con diferente intensidad de carga.
Revisa el archivo JSON o el reporte HTML para detalles de cada fase.


---

**Archivo JSON completo:** `ramp_2servers.json`

**Para ver el reporte HTML detallado, ejecuta:**
```bash
artillery report "/vagrant/reports/ramp_2servers.json" --output "/vagrant/reports/ramp_2servers.html"
```

