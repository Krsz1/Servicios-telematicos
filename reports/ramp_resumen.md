# 📊 REPORTE DE PRUEBAS DE CARGA
## Prueba: prueba

📅 **Fecha:** 2025-11-11 08:45:44

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
| 🚀 **Tasa de peticiones promedio** | 85 req/seg |

### ⏱️ Tiempos de Respuesta

| Métrica | Valor (ms) |
|---------|------------|
| 🕒 **Tiempo medio (mean)** | 11 |
| 💨 **Mediana (median)** | 6 |
| 📊 **Mínimo** | 0 |
| 📊 **Máximo** | 3093 |
| 🧭 **p95 (percentil 95)** | 13.9 |
| 🧭 **p99 (percentil 99)** | 23.8 |

---

### 🔍 Interpretación Técnica

#### ✅ **Sistema Estable y Saludable**

- **Tasa de éxito:** 100.00% - El sistema responde correctamente a la mayoría de las peticiones.
- **Tiempo de respuesta:** 11 ms promedio - Tiempos de respuesta rápidos y aceptables.
- **Errores mínimos:** Solo 0% de fallos - El balanceador de carga distribuye correctamente la carga.

**Conclusión:** El sistema está funcionando correctamente bajo esta carga. El balanceador de carga NGINX está bien configurado y los servidores backend responden de manera eficiente.


---

**Archivo JSON completo:** `ramp.json`

**Para ver el reporte HTML detallado, ejecuta:**
```bash
artillery report "/vagrant/reports/ramp.json" --output "/vagrant/reports/ramp.html"
```

