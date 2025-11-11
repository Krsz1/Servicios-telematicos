# 📊 REPORTE DE PRUEBAS DE CARGA
## Prueba: baseline_1servidor

📅 **Fecha:** 2025-11-11 10:08:36

### 📈 Resumen General

| Métrica | Valor |
|---------|-------|
| ⏱️ **Duración total** | 0 minutos, 0 segundos |
| 🌐 **Peticiones totales** | 3000 |
| 👥 **Usuarios simulados** | 3000 |
| ✅ **Respuestas exitosas (HTTP 200)** | 3000 (100.00%) |
| ⚠️ **Errores 502 (Bad Gateway)** | 0 |
| ❌ **Usuarios fallidos** | 0 (0%) |
| 🔌 **Errores ECONNRESET** | 0 |
| ⏰ **Errores ETIMEDOUT** | 0 |
| 🚀 **Tasa de peticiones promedio** | 43 req/seg |

### ⏱️ Tiempos de Respuesta

| Métrica | Valor (ms) |
|---------|------------|
| 🕒 **Tiempo medio (mean)** | 6.4 |
| 💨 **Mediana (median)** | 6 |
| 📊 **Mínimo** | 0 |
| 📊 **Máximo** | 57 |
| 🧭 **p95 (percentil 95)** | 10.1 |
| 🧭 **p99 (percentil 99)** | 18 |

---

### 🔍 Interpretación Técnica

#### ✅ **Sistema Estable y Saludable**

- **Tasa de éxito:** 100.00% - El sistema responde correctamente a la mayoría de las peticiones.
- **Tiempo de respuesta:** 6.4 ms promedio - Tiempos de respuesta rápidos y aceptables.
- **Errores mínimos:** Solo 0% de fallos - El balanceador de carga distribuye correctamente la carga.

**Conclusión:** El sistema está funcionando correctamente bajo esta carga. El balanceador de carga NGINX está bien configurado y los servidores backend responden de manera eficiente.


---

**Archivo JSON completo:** `baseline_1server.json`

**Para ver el reporte HTML detallado, ejecuta:**
```bash
artillery report "/vagrant/reports/baseline_1server.json" --output "/vagrant/reports/baseline_1server.html"
```

