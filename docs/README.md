# Guía de Pruebas - Load Balancer

Esta guía proporciona instrucciones detalladas para ejecutar y analizar pruebas de carga en el sistema de balanceo.

## 📋 Tabla de Contenidos

- [1. Pruebas de Carga con Artillery](#1-pruebas-de-carga-con-artillery)
- [2. Pruebas con Diferente Número de Servidores](#2-pruebas-con-diferente-número-de-servidores)
  - [2.1 Pruebas con 2 Servidores](#21-pruebas-con-2-servidores)
  - [2.2 Pruebas con 3 Servidores](#22-volver-a-3-servidores-y-probar)
  - [2.3 Pruebas con 1 Servidor](#23-pruebas-con-1-servidor-opcional)
  - [2.4 Restaurar Configuración](#24-restaurar-configuración-normal)
- [3. Ver Estadísticas del Load Balancer](#3-ver-estadísticas-del-load-balancer)
- [4. Pruebas Manuales de Balanceo](#4-pruebas-manuales-de-balanceo)
- [5. Limpiar Logs](#5-limpiar-logs-opcional)
- [Análisis y Comparación de Resultados](#análisis-y-comparación-de-resultados)

---

## 1. Pruebas de Carga con Artillery

### Conectar al cliente

```bash
vagrant ssh client
```

### Ejecutar diferentes escenarios de carga

```bash
cd /vagrant/artillery
```

### Baseline: Carga constante de 50 req/s por 60 segundos

```bash
artillery run baseline.yml --output /vagrant/reports/baseline.json
```

### Ramp: Carga incremental (10 → 50 → 100 → 200 req/s)

```bash
artillery run ramp.yml --output /vagrant/reports/ramp.json
```

### Spike: Pico de 500 req/s por 30 segundos, luego 50 req/s por 90 segundos

```bash
artillery run spike.yml --output /vagrant/reports/spike.json
```

### Generar reportes HTML

```bash
artillery report /vagrant/reports/baseline.json --output /vagrant/reports/baseline.html
artillery report /vagrant/reports/ramp.json --output /vagrant/reports/ramp.html
artillery report /vagrant/reports/spike.json --output /vagrant/reports/spike.html
```

```bash
exit
```

---

## 2. Pruebas con Diferente Número de Servidores

Esta sección ejecuta las **3 pruebas completas** (baseline, ramp, spike) con diferente número de servidores backend para comparar rendimiento.

### 2.1 Pruebas con 2 Servidores

#### Paso 1: Detener web3

```bash
vagrant halt web3
```

#### Paso 2: Actualizar configuración del LB

```bash
vagrant ssh lb
sudo cp /vagrant/nginx/lb_2servers.conf /etc/nginx/conf.d/lb.conf
sudo nginx -t
sudo systemctl reload nginx
exit
```

#### Paso 3: Ejecutar TODAS las pruebas desde el cliente

```bash
vagrant ssh client
cd /vagrant/artillery
```

**Prueba 1: Baseline (carga constante)**

```bash
artillery run baseline.yml --output /vagrant/reports/baseline_2servers.json
```

**Prueba 2: Ramp (carga incremental)**

```bash
artillery run ramp.yml --output /vagrant/reports/ramp_2servers.json
```

**Prueba 3: Spike (pico de carga)**

```bash
artillery run spike.yml --output /vagrant/reports/spike_2servers.json
```

#### Generar reportes automáticos

```bash
chmod +x /vagrant/analysis/generate_report.sh

/vagrant/analysis/generate_report.sh /vagrant/reports/baseline_2servers.json "baseline_2servidores"
/vagrant/analysis/generate_report.sh /vagrant/reports/ramp_2servers.json "ramp_2servidores"
/vagrant/analysis/generate_report.sh /vagrant/reports/spike_2servers.json "spike_2servidores"

exit
```

#### Paso 4: Ver estadísticas del LB

```bash
vagrant ssh lb
sudo bash /vagrant/analysis/stats.sh
exit
```

---

### 2.2 Volver a 3 Servidores y Probar

#### Paso 5: Levantar web3 nuevamente

```bash
vagrant up web3
```

#### Paso 6: Restaurar configuración original del LB

```bash
vagrant ssh lb
sudo cp /vagrant/nginx/lb.conf /etc/nginx/conf.d/lb.conf
sudo nginx -t
sudo systemctl reload nginx
exit
```

#### Paso 7: Ejecutar TODAS las pruebas con 3 servidores

```bash
vagrant ssh client
cd /vagrant/artillery
```

**Ejecutar las 3 pruebas:**

```bash
artillery run baseline.yml --output /vagrant/reports/baseline_3servers.json
artillery run ramp.yml --output /vagrant/reports/ramp_3servers.json
artillery run spike.yml --output /vagrant/reports/spike_3servers.json
```

**Generar reportes:**

```bash
/vagrant/analysis/generate_report.sh /vagrant/reports/baseline_3servers.json "baseline_3servidores"
/vagrant/analysis/generate_report.sh /vagrant/reports/ramp_3servers.json "ramp_3servidores"
/vagrant/analysis/generate_report.sh /vagrant/reports/spike_3servers.json "spike_3servidores"

exit
```

---

### 2.3 Pruebas con 1 Servidor (opcional)

> **⚠️ Escenario extremo:** Esta prueba muestra los límites de un solo servidor

#### Paso 8: Detener web2 y web3

```bash
vagrant halt web2
vagrant halt web3
```

#### Paso 9: Actualizar configuración (solo web1)

```bash
vagrant ssh lb

cat > /tmp/lb_1server.conf << 'EOF'
upstream backend {
    server 192.168.56.11;
}

log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$upstream_addr" $request_time';

server {
    listen 80;
    server_name _;

    access_log /var/log/nginx/lb_access.log main;
    error_log /var/log/nginx/lb_error.log warn;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_connect_timeout 5s;
        proxy_read_timeout 10s;
        proxy_send_timeout 10s;
        proxy_next_upstream error timeout http_502 http_503 http_504;
    }

    location = /lb {
        root /usr/share/nginx/html;
        try_files /index_lb.html =404;
    }

    location /nginx_status {
        stub_status on;
        allow 192.168.56.0/24;
        allow 127.0.0.1;
        deny all;
    }
}
EOF

sudo mv /tmp/lb_1server.conf /etc/nginx/conf.d/lb.conf
sudo nginx -t
sudo systemctl reload nginx
exit
```

#### Paso 10: Ejecutar TODAS las pruebas con 1 servidor

```bash
vagrant ssh client
cd /vagrant/artillery
```

**Baseline:**

```bash
artillery run baseline.yml --output /vagrant/reports/baseline_1server.json
```

**Ramp:**

```bash
artillery run ramp.yml --output /vagrant/reports/ramp_1server.json
```

**Spike** (probablemente falle mucho con 1 solo servidor):

```bash
artillery run spike.yml --output /vagrant/reports/spike_1server.json
```

**Generar reportes:**

```bash
/vagrant/analysis/generate_report.sh /vagrant/reports/baseline_1server.json "baseline_1servidor"
/vagrant/analysis/generate_report.sh /vagrant/reports/ramp_1server.json "ramp_1servidor"
/vagrant/analysis/generate_report.sh /vagrant/reports/spike_1server.json "spike_1servidor"

exit
```

---

### 2.4 Restaurar Configuración Normal

#### Paso 11: Levantar todos los servidores

```bash
vagrant up web2
vagrant up web3
```

#### Paso 12: Restaurar configuración del LB

```bash
vagrant ssh lb
sudo cp /vagrant/nginx/lb.conf /etc/nginx/conf.d/lb.conf
sudo nginx -t
sudo systemctl reload nginx
exit
```

#### Paso 13: Verificar que todo funcione

```bash
vagrant ssh client
curl http://192.168.56.10
exit
```

---

## 3. Ver Estadísticas del Load Balancer

### Método 1: nginx_status (tiempo real)

Desde PowerShell en host:

```powershell
curl http://192.168.56.10/nginx_status
```

O abrir en navegador: [http://localhost:8080/nginx_status](http://localhost:8080/nginx_status)

### Método 2: Script de análisis completo

```bash
vagrant ssh lb
sudo bash /vagrant/analysis/stats.sh
exit
```

### Método 3: Comandos individuales

```bash
vagrant ssh lb
```

#### Total de peticiones

```bash
sudo cat /var/log/nginx/lb_access.log | wc -l
```

#### Distribución por servidor

```bash
sudo cat /var/log/nginx/lb_access.log | grep -oP '\d+\.\d+\.\d+\.\d+:\d+' | sort | uniq -c
```

#### Códigos de estado

```bash
sudo cat /var/log/nginx/lb_access.log | awk '{print $9}' | sort | uniq -c
```

#### Tasa de errores

```bash
total=$(sudo cat /var/log/nginx/lb_access.log | wc -l)
errores=$(sudo cat /var/log/nginx/lb_access.log | awk '{print $9}' | grep '^5' | wc -l)
echo "Tasa de error: $(echo "scale=2; $errores * 100 / $total" | bc)%"
```

#### Ver logs en tiempo real

```bash
sudo tail -f /var/log/nginx/lb_access.log
```

```bash
exit
```

---

## 4. Pruebas Manuales de Balanceo

### Desde PowerShell (host)

Hacer 10 peticiones y ver qué servidor responde:

```powershell
for ($i=1; $i -le 10; $i++) { 
    curl http://localhost:8080 | Select-String "Servidor" 
}
```

### Desde el cliente (Linux)

```bash
vagrant ssh client
for i in {1..10}; do curl -s http://192.168.56.10 | grep "Servidor"; done
exit
```

---

## 5. Limpiar Logs (opcional)

```bash
vagrant ssh lb
sudo truncate -s 0 /var/log/nginx/lb_access.log
sudo systemctl reload nginx
exit
```

---

## 📊 Análisis y Comparación de Resultados

Después de ejecutar todas las pruebas, tendrás **9 reportes** para comparar:

### Estructura de Reportes

#### CON 1 SERVIDOR:
- `reports/baseline_1server_resumen.md`
- `reports/ramp_1server_resumen.md`
- `reports/spike_1server_resumen.md`

#### CON 2 SERVIDORES:
- `reports/baseline_2servers_resumen.md`
- `reports/ramp_2servers_resumen.md`
- `reports/spike_2servers_resumen.md`

#### CON 3 SERVIDORES:
- `reports/baseline_3servers_resumen.md`
- `reports/ramp_3servers_resumen.md`
- `reports/spike_3servers_resumen.md`

---

### Preguntas Clave para el Análisis

1. ✅ **¿Cómo cambia el rendimiento con diferentes cargas?**
2. ✅ **¿Qué pasa cuando reduces/aumentas el número de servidores?**
3. ✅ **¿La distribución de carga es equitativa?**
4. ✅ **¿Cuál es la tasa de errores bajo carga alta?**
5. ✅ **¿Cuánto tiempo de respuesta promedio hay?**
6. ✅ **¿Cómo afecta el número de servidores backend al rendimiento del sistema?**
7. ✅ **¿A partir de qué carga un solo servidor se satura?**
8. ✅ **¿El balanceador distribuye correctamente entre 2 vs 3 servidores?**

---

## 📈 Métricas Clave a Comparar

Para cada tipo de prueba, compara:

| Métrica | Descripción | Qué Buscar |
|---------|-------------|------------|
| **Tiempos de respuesta** | mean, p95, p99 | Cómo aumentan con menos servidores |
| **Tasa de éxito/errores** | Porcentaje de requests exitosos | Diferencia entre 1, 2 y 3 servidores |
| **Throughput** | Peticiones por segundo | Capacidad máxima de cada configuración |
| **Capacidad de picos** | Respuesta ante spike test | ¿Cuántos servidores necesitas para 500 req/s? |

### Valores Óptimos

| Métrica | Valor Óptimo | 1 Servidor | 2 Servidores | 3 Servidores |
|---------|--------------|------------|--------------|--------------|
| **Latencia P95** | < 100ms | ⚠️ Alta | ⚠️ Media | ✅ Baja |
| **Latencia P99** | < 200ms | ❌ Muy Alta | ⚠️ Media-Alta | ✅ Aceptable |
| **Tasa de Error** | < 1% | ❌ Alta | ⚠️ Moderada | ✅ Baja |
| **RPS Máximo** | Según carga | ~30-50 | ~80-100 | ~120-150 |
| **Distribución** | Equitativa | N/A | ~50% c/u | ~33% c/u |

---

## 🔍 Interpretación de Resultados por Escenario

### Baseline (50 req/s)

| Configuración | Comportamiento Esperado |
|---------------|------------------------|
| **1 Servidor** | ⚠️ Límite de capacidad, alta latencia |
| **2 Servidores** | ✅ Estable, distribución 50/50 |
| **3 Servidores** | ✅ Óptimo, distribución 33/33/33, latencia mínima |

### Ramp (10→200 req/s)

| Configuración | Comportamiento Esperado |
|---------------|------------------------|
| **1 Servidor** | ❌ Saturación >50 req/s, muchos errores |
| **2 Servidores** | ⚠️ Degradación >100 req/s |
| **3 Servidores** | ✅ Estable hasta ~150 req/s, degradación gradual después |

### Spike (500 req/s)

| Configuración | Comportamiento Esperado |
|---------------|------------------------|
| **1 Servidor** | ❌ Colapso total, >50% errores |
| **2 Servidores** | ❌ 20-40% errores durante pico |
| **3 Servidores** | ⚠️ 5-20% errores durante pico, recuperación rápida |

---

## 📁 Ubicación de Reportes

Los reportes HTML y resúmenes se guardan en: `reports/`

Ábrelos en tu navegador para ver gráficos detallados.

---

## 🎯 Conclusiones Esperadas

Después de ejecutar todas las pruebas, deberías poder responder:

1. **Escalabilidad Horizontal:**
   - ¿Duplicar servidores duplica la capacidad?
   - ¿Hay rendimientos decrecientes al agregar más servidores?

2. **Punto de Saturación:**
   - ¿Cuántas peticiones por segundo puede manejar cada configuración?
   - ¿Cuándo empiezan a aparecer errores?

3. **Distribución de Carga:**
   - ¿NGINX distribuye equitativamente?
   - ¿Algún servidor recibe más carga que otros?

4. **Costo vs Beneficio:**
   - ¿Vale la pena el tercer servidor?
   - ¿Qué configuración es óptima para tu caso de uso?

---

**Fecha de creación:** 2025-11-11  
**Última actualización:** 2025-11-11  
**Autor:** Krsz1  
**Versión:** 2.0