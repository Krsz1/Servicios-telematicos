# 📊 REPORTE DE PRUEBAS DE CARGA
## Prueba: spike_1servidor

📅 **Fecha:** 2025-11-11 10:33:36

### 📈 Resumen General

| Métrica | Valor |
|---------|-------|
| ⏱️ **Duración total** | 0 minutos, 0 segundos |
| 🌐 **Peticiones totales** | 19500 |
| 👥 **Usuarios simulados** | 19500 |
| ✅ **Respuestas exitosas (HTTP 200)** | 19500 (100.00%) |
| ⚠️ **Errores 502 (Bad Gateway)** | 0 |
| ❌ **Usuarios fallidos** | 0 (0%) |
| 🔌 **Errores ECONNRESET** | 0 |
| ⏰ **Errores ETIMEDOUT** | 0 |
| 🚀 **Tasa de peticiones promedio** | 126 req/seg |

### ⏱️ Tiempos de Respuesta

| Métrica | Valor (ms) |
|---------|------------|
| 🕒 **Tiempo medio (mean)** | 11.9 |
| 💨 **Mediana (median)** | 8.9 |
| 📊 **Mínimo** | 0 |
| 📊 **Máximo** | 142 |
| 🧭 **p95 (percentil 95)** | 25.8 |
| 🧭 **p99 (percentil 99)** | 54.1 |

---

### 🔍 Interpretación Técnica

#### ✅ **Sistema Estable y Saludable**

- **Tasa de éxito:** 100.00% - El sistema responde correctamente a la mayoría de las peticiones.
- **Tiempo de respuesta:** 11.9 ms promedio - Tiempos de respuesta rápidos y aceptables.
- **Errores mínimos:** Solo 0% de fallos - El balanceador de carga distribuye correctamente la carga.

**Conclusión:** El sistema está funcionando correctamente bajo esta carga. El balanceador de carga NGINX está bien configurado y los servidores backend responden de manera eficiente.


### 📊 Análisis por Fases

Esta prueba tiene múltiples fases con diferente intensidad de carga.
Revisa el archivo JSON o el reporte HTML para detalles de cada fase.


---

**Archivo JSON completo:** `spike_1server.json`

**Para ver el reporte HTML detallado, ejecuta:**
```bash
artillery report "/vagrant/reports/spike_1server.json" --output "/vagrant/reports/spike_1server.html"
```

