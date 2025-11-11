#!/bin/bash
# Script para generar reporte resumido de las pruebas de Artillery

if [ -z "$1" ]; then
    echo "Uso: $0 <archivo.json> [nombre_prueba]"
    echo "Ejemplo: $0 /vagrant/reports/baseline.json baseline"
    exit 1
fi

JSON_FILE="$1"
TEST_NAME="${2:-prueba}"

if [ ! -f "$JSON_FILE" ]; then
    echo "Error: El archivo $JSON_FILE no existe"
    exit 1
fi

# Extraer métricas usando jq
echo "Generando reporte de: $TEST_NAME"
echo ""

# Crear archivo de reporte
REPORT_FILE="${JSON_FILE%.json}_resumen.md"

cat > "$REPORT_FILE" << 'HEADER'
# 📊 REPORTE DE PRUEBAS DE CARGA
HEADER

echo "## Prueba: $TEST_NAME" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "📅 **Fecha:** $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Extraer datos del JSON usando grep y sed (por si no hay jq)
if command -v jq &> /dev/null; then
    # Usar jq si está disponible
    DURATION=$(jq -r '.aggregate.phases[0].duration // 0' "$JSON_FILE")
    REQUESTS=$(jq -r '.aggregate.counters."http.requests" // 0' "$JSON_FILE")
    VUSERS=$(jq -r '.aggregate.counters."vusers.created" // 0' "$JSON_FILE")
    FAILED=$(jq -r '.aggregate.counters."vusers.failed" // 0' "$JSON_FILE")
    CODES_200=$(jq -r '.aggregate.counters."http.codes.200" // 0' "$JSON_FILE")
    CODES_502=$(jq -r '.aggregate.counters."http.codes.502" // 0' "$JSON_FILE")
    ECONNRESET=$(jq -r '.aggregate.counters."errors.ECONNRESET" // 0' "$JSON_FILE")
    ETIMEDOUT=$(jq -r '.aggregate.counters."errors.ETIMEDOUT" // 0' "$JSON_FILE")
    
    MEAN=$(jq -r '.aggregate.summaries["http.response_time"].mean // 0' "$JSON_FILE")
    MEDIAN=$(jq -r '.aggregate.summaries["http.response_time"].median // 0' "$JSON_FILE")
    P95=$(jq -r '.aggregate.summaries["http.response_time"].p95 // 0' "$JSON_FILE")
    P99=$(jq -r '.aggregate.summaries["http.response_time"].p99 // 0' "$JSON_FILE")
    MIN=$(jq -r '.aggregate.summaries["http.response_time"].min // 0' "$JSON_FILE")
    MAX=$(jq -r '.aggregate.summaries["http.response_time"].max // 0' "$JSON_FILE")
    
    REQ_RATE=$(jq -r '.aggregate.rates["http.request_rate"] // 0' "$JSON_FILE")
else
    echo "⚠️ jq no está instalado. Instalando..."
    sudo apt-get update -qq && sudo apt-get install -y jq -qq
    
    DURATION=$(jq -r '.aggregate.phases[0].duration // 0' "$JSON_FILE")
    REQUESTS=$(jq -r '.aggregate.counters."http.requests" // 0' "$JSON_FILE")
    VUSERS=$(jq -r '.aggregate.counters."vusers.created" // 0' "$JSON_FILE")
    FAILED=$(jq -r '.aggregate.counters."vusers.failed" // 0' "$JSON_FILE")
    CODES_200=$(jq -r '.aggregate.counters."http.codes.200" // 0' "$JSON_FILE")
    CODES_502=$(jq -r '.aggregate.counters."http.codes.502" // 0' "$JSON_FILE")
    ECONNRESET=$(jq -r '.aggregate.counters."errors.ECONNRESET" // 0' "$JSON_FILE")
    ETIMEDOUT=$(jq -r '.aggregate.counters."errors.ETIMEDOUT" // 0' "$JSON_FILE")
    
    MEAN=$(jq -r '.aggregate.summaries["http.response_time"].mean // 0' "$JSON_FILE")
    MEDIAN=$(jq -r '.aggregate.summaries["http.response_time"].median // 0' "$JSON_FILE")
    P95=$(jq -r '.aggregate.summaries["http.response_time"].p95 // 0' "$JSON_FILE")
    P99=$(jq -r '.aggregate.summaries["http.response_time"].p99 // 0' "$JSON_FILE")
    MIN=$(jq -r '.aggregate.summaries["http.response_time"].min // 0' "$JSON_FILE")
    MAX=$(jq -r '.aggregate.summaries["http.response_time"].max // 0' "$JSON_FILE")
    
    REQ_RATE=$(jq -r '.aggregate.rates["http.request_rate"] // 0' "$JSON_FILE")
fi

# Calcular duración en minutos y segundos
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

# Calcular tasa de éxito
if [ "$REQUESTS" -gt 0 ]; then
    SUCCESS_RATE=$(echo "scale=2; ($CODES_200 * 100) / $REQUESTS" | bc)
    FAIL_RATE=$(echo "scale=2; ($FAILED * 100) / $VUSERS" | bc)
else
    SUCCESS_RATE=0
    FAIL_RATE=0
fi

# Generar resumen
cat >> "$REPORT_FILE" << EOF
### 📈 Resumen General

| Métrica | Valor |
|---------|-------|
| ⏱️ **Duración total** | ${MINUTES} minutos, ${SECONDS} segundos |
| 🌐 **Peticiones totales** | ${REQUESTS} |
| 👥 **Usuarios simulados** | ${VUSERS} |
| ✅ **Respuestas exitosas (HTTP 200)** | ${CODES_200} (${SUCCESS_RATE}%) |
| ⚠️ **Errores 502 (Bad Gateway)** | ${CODES_502} |
| ❌ **Usuarios fallidos** | ${FAILED} (${FAIL_RATE}%) |
| 🔌 **Errores ECONNRESET** | ${ECONNRESET} |
| ⏰ **Errores ETIMEDOUT** | ${ETIMEDOUT} |
| 🚀 **Tasa de peticiones promedio** | ${REQ_RATE} req/seg |

### ⏱️ Tiempos de Respuesta

| Métrica | Valor (ms) |
|---------|------------|
| 🕒 **Tiempo medio (mean)** | ${MEAN} |
| 💨 **Mediana (median)** | ${MEDIAN} |
| 📊 **Mínimo** | ${MIN} |
| 📊 **Máximo** | ${MAX} |
| 🧭 **p95 (percentil 95)** | ${P95} |
| 🧭 **p99 (percentil 99)** | ${P99} |

---

### 🔍 Interpretación Técnica

EOF

# Análisis automático basado en las métricas
if [ "$FAIL_RATE" != "0" ]; then
    FAIL_INT=$(echo "$FAIL_RATE" | cut -d. -f1)
else
    FAIL_INT=0
fi

if [ "$MEAN" != "0" ]; then
    MEAN_INT=$(echo "$MEAN" | cut -d. -f1)
else
    MEAN_INT=0
fi

# Determinar el estado del sistema
if [ "$FAIL_INT" -lt 5 ] && [ "$MEAN_INT" -lt 200 ]; then
    cat >> "$REPORT_FILE" << EOF
#### ✅ **Sistema Estable y Saludable**

- **Tasa de éxito:** ${SUCCESS_RATE}% - El sistema responde correctamente a la mayoría de las peticiones.
- **Tiempo de respuesta:** ${MEAN} ms promedio - Tiempos de respuesta rápidos y aceptables.
- **Errores mínimos:** Solo ${FAIL_RATE}% de fallos - El balanceador de carga distribuye correctamente la carga.

**Conclusión:** El sistema está funcionando correctamente bajo esta carga. El balanceador de carga NGINX está bien configurado y los servidores backend responden de manera eficiente.

EOF
elif [ "$FAIL_INT" -lt 20 ] && [ "$MEAN_INT" -lt 500 ]; then
    cat >> "$REPORT_FILE" << EOF
#### ⚠️ **Sistema Bajo Presión pero Funcional**

- **Tasa de éxito:** ${SUCCESS_RATE}% - Algunas peticiones están fallando.
- **Tiempo de respuesta:** ${MEAN} ms promedio - Los tiempos están aumentando.
- **Tasa de fallos:** ${FAIL_RATE}% - El sistema muestra signos de saturación.

**Recomendaciones:**
- Considerar aumentar el número de servidores backend
- Ajustar los timeouts de NGINX (actualmente 5s-10s)
- Verificar recursos (CPU, RAM) en los servidores backend

EOF
elif [ "$FAIL_INT" -lt 50 ]; then
    cat >> "$REPORT_FILE" << EOF
#### 🔴 **Sistema Saturado - Requiere Atención**

- **Tasa de éxito:** ${SUCCESS_RATE}% - Alto porcentaje de fallos.
- **Tiempo de respuesta:** ${MEAN} ms promedio - Tiempos muy elevados.
- **Tasa de fallos:** ${FAIL_RATE}% - El sistema no puede manejar esta carga.

**Problemas detectados:**
- Errores ETIMEDOUT: ${ETIMEDOUT} - Conexiones que tardan demasiado
- Errores ECONNRESET: ${ECONNRESET} - Conexiones rechazadas o reiniciadas
- Errores 502: ${CODES_502} - Los backends no responden

**Acciones urgentes:**
1. ⚡ Aumentar el número de servidores backend
2. 🔧 Optimizar la configuración de NGINX (keepalive, buffers)
3. 📊 Revisar recursos del sistema (RAM, CPU, conexiones)
4. ⏱️ Ajustar timeouts y límites de conexiones

EOF
else
    cat >> "$REPORT_FILE" << EOF
#### 💥 **Sistema Colapsado - Falla Crítica**

- **Tasa de éxito:** ${SUCCESS_RATE}% - La mayoría de peticiones fallan.
- **Tasa de fallos:** ${FAIL_RATE}% - El sistema está completamente saturado.

**Problemas críticos:**
- El balanceador de carga no puede distribuir efectivamente la carga
- Los servidores backend están sobrecargados o caídos
- La infraestructura actual no soporta esta carga

**Acciones inmediatas:**
1. 🚨 Reducir la carga de entrada
2. 🔄 Verificar que todos los servidores backend estén funcionando
3. 📈 Escalar horizontalmente (más servidores)
4. 🔍 Revisar logs para identificar cuellos de botella

EOF
fi

# Análisis por fases si es ramp o spike
if echo "$TEST_NAME" | grep -iq "ramp\|spike"; then
    cat >> "$REPORT_FILE" << EOF

### 📊 Análisis por Fases

Esta prueba tiene múltiples fases con diferente intensidad de carga.
Revisa el archivo JSON o el reporte HTML para detalles de cada fase.

EOF
fi

cat >> "$REPORT_FILE" << EOF

---

**Archivo JSON completo:** \`$(basename "$JSON_FILE")\`

**Para ver el reporte HTML detallado, ejecuta:**
\`\`\`bash
artillery report "$JSON_FILE" --output "${JSON_FILE%.json}.html"
\`\`\`

EOF

echo ""
echo "✅ Reporte generado en: $REPORT_FILE"
echo ""
cat "$REPORT_FILE"
