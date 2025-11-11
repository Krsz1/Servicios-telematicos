#!/bin/bash
# Script para analizar estadísticas del Load Balancer

echo "=========================================="
echo "ESTADÍSTICAS DEL LOAD BALANCER"
echo "=========================================="
echo ""

LOG_FILE="/var/log/nginx/lb_access.log"

# Total de peticiones
echo "📊 TOTAL DE PETICIONES:"
total=$(cat $LOG_FILE | wc -l)
echo "   $total peticiones"
echo ""

# Distribución por servidor backend
echo "🖥️  DISTRIBUCIÓN POR SERVIDOR:"
cat $LOG_FILE | grep -oP '\d+\.\d+\.\d+\.\d+:\d+' | sort | uniq -c | sort -rn
echo ""

# Códigos de estado HTTP
echo "📈 CÓDIGOS DE ESTADO HTTP:"
cat $LOG_FILE | awk '{print $9}' | sort | uniq -c | sort -rn
echo ""

# Tasa de errores
echo "❌ TASA DE ERRORES:"
errores_4xx=$(cat $LOG_FILE | awk '{print $9}' | grep '^4' | wc -l)
errores_5xx=$(cat $LOG_FILE | awk '{print $9}' | grep '^5' | wc -l)
exitosos=$(cat $LOG_FILE | awk '{print $9}' | grep '^2' | wc -l)

echo "   Exitosas (2xx): $exitosos ($(echo "scale=2; $exitosos * 100 / $total" | bc)%)"
echo "   Errores cliente (4xx): $errores_4xx ($(echo "scale=2; $errores_4xx * 100 / $total" | bc)%)"
echo "   Errores servidor (5xx): $errores_5xx ($(echo "scale=2; $errores_5xx * 100 / $total" | bc)%)"
echo ""

# Tiempo de respuesta promedio
echo "⏱️  TIEMPOS DE RESPUESTA:"
tiempos=$(cat $LOG_FILE | awk '{print $NF}' | grep -v '-')
if [ ! -z "$tiempos" ]; then
    promedio=$(echo "$tiempos" | awk '{sum+=$1; count++} END {print sum/count}')
    minimo=$(echo "$tiempos" | sort -n | head -1)
    maximo=$(echo "$tiempos" | sort -n | tail -1)
    
    echo "   Promedio: ${promedio}s"
    echo "   Mínimo: ${minimo}s"
    echo "   Máximo: ${maximo}s"
else
    echo "   No hay datos de tiempo de respuesta"
fi
echo ""

# Peticiones por minuto (últimos 10 minutos)
echo "📅 TASA DE LLEGADA (últimos 10 minutos):"
cat $LOG_FILE | tail -1000 | awk '{print $4}' | cut -d: -f1-3 | uniq -c | tail -10
echo ""

# Top 10 IPs con más peticiones
echo "🌐 TOP 10 IPs CON MÁS PETICIONES:"
cat $LOG_FILE | awk '{print $1}' | sort | uniq -c | sort -rn | head -10
echo ""

echo "=========================================="
