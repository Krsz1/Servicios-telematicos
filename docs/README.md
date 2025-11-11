# 🧪 Guía Completa de Pruebas - Load Balancer

Esta guía proporciona instrucciones detalladas para ejecutar y analizar pruebas de carga en el sistema de balanceo con **1, 2, 3 y 4 servidores backend**.

---

## 📋 Tabla de Contenidos

- [1. Pruebas de Carga con Artillery](#1-pruebas-de-carga-con-artillery)
- [2. Pruebas con 2 Servidores](#2-pruebas-con-2-servidores)
- [3. Pruebas con 3 Servidores](#3-pruebas-con-3-servidores-configuración-por-defecto)
- [4. Pruebas con 4 Servidores](#4-pruebas-con-4-servidores)
- [5. Pruebas con 1 Servidor](#5-pruebas-con-1-servidor-escenario-extremo)
- [6. Ver Estadísticas del Load Balancer](#6-ver-estadísticas-del-load-balancer)
- [7. Pruebas Manuales de Balanceo](#7-pruebas-manuales-de-balanceo)
- [8. Limpiar Logs](#8-limpiar-logs)
- [Análisis y Comparación de Resultados](#-análisis-y-comparación-de-resultados)
- [Comando Todo-en-Uno por Configuración](#-comando-todo-en-uno-por-configuración)

---

## ⚙️ Prerequisitos

Antes de comenzar, asegúrate de que:

- ✅ Todas las VMs estén corriendo: `vagrant status`
- ✅ El Load Balancer esté funcionando: `curl http://localhost:8080`
- ✅ Artillery esté instalado en client: `vagrant ssh client -c "artillery --version"`
- ✅ Scripts de análisis tengan permisos: `chmod +x /vagrant/analysis/*.sh`

---

## 1. Pruebas de Carga con Artillery

El proyecto incluye **3 escenarios de prueba** configurados:

### 📊 Tipos de Pruebas Disponibles

| Prueba | Descripción | Duración | Carga | Total Peticiones |
|--------|-------------|----------|-------|------------------|
| **baseline** | Carga constante | 60s | 50 req/s | ~3,000 |
| **ramp** | Carga incremental | 360s | 10→200 req/s | ~37,200 |
| **spike** | Pico de tráfico | 120s | 50→500→50 req/s | ~19,500 |

### 1.1 Conectar al Cliente

```bash
vagrant ssh client
cd /vagrant/artillery
```

### 1.2 Ejecutar Pruebas Individuales

#### Baseline: Carga Constante

```bash
artillery run baseline.yml --output /vagrant/reports/baseline.json
```

**Configuración:**
- ⏱️ Duración: 60 segundos
- 📊 Tasa: 50 peticiones/segundo
- 🎯 Comportamiento esperado: Sistema estable, latencia <50ms, 0% errores

#### Ramp: Carga Incremental

```bash
artillery run ramp.yml --output /vagrant/reports/ramp.json
```

**Configuración:**
- **Fase 1:** 120s @ 10 req/s (warmup)
- **Fase 2:** 240s @ 50 req/s (normal)
- **Fase 3:** 240s @ 100 req/s (crecimiento)
- **Fase 4:** 120s @ 200 req/s (alta carga)

#### Spike: Pico de Tráfico

```bash
artillery run spike.yml --output /vagrant/reports/spike.json
```

**Configuración:**
- **Fase 1:** 30s @ 500 req/s (pico extremo)
- **Fase 2:** 90s @ 50 req/s (recuperación)
- ⚠️ Se esperan errores durante el pico

### 1.3 Generar Reportes HTML

```bash
artillery report /vagrant/reports/baseline.json --output /vagrant/reports/baseline.html
artillery report /vagrant/reports/ramp.json --output /vagrant/reports/ramp.html
artillery report /vagrant/reports/spike.json --output /vagrant/reports/spike.html

exit
```

---

## 2. Pruebas con 2 Servidores

### Paso 1: Detener web3

```bash
vagrant halt web3
```

### Paso 2: Actualizar configuración del LB

```bash
vagrant ssh lb
sudo cp /vagrant/nginx/lb_2servers.conf /etc/nginx/conf.d/lb.conf
sudo nginx -t
sudo systemctl reload nginx
exit
```

### Paso 3: Ejecutar las 3 pruebas

```bash
vagrant ssh client
cd /vagrant/artillery
```

**Ejecutar todas las pruebas:**

```bash
# Baseline
artillery run baseline.yml --output /vagrant/reports/baseline_2servers.json

# Ramp
artillery run ramp.yml --output /vagrant/reports/ramp_2servers.json

# Spike
artillery run spike.yml --output /vagrant/reports/spike_2servers.json
```

### Paso 4: Generar reportes automáticos

```bash
chmod +x /vagrant/analysis/generate_report.sh

bash /vagrant/analysis/generate_report.sh /vagrant/reports/baseline_2servers.json "baseline_2servidores"
bash /vagrant/analysis/generate_report.sh /vagrant/reports/ramp_2servers.json "ramp_2servidores"
bash /vagrant/analysis/generate_report.sh /vagrant/reports/spike_2servers.json "spike_2servidores"

exit
```

### Paso 5: Ver estadísticas del LB

```bash
vagrant ssh lb
sudo bash /vagrant/analysis/stats.sh
exit
```

---

## 3. Pruebas con 3 Servidores (Configuración por Defecto)

### Paso 1: Levantar web3 (si está apagado)

```bash
vagrant up web3
```

### Paso 2: Restaurar configuración de 3 servidores

```bash
vagrant ssh lb
sudo cp /vagrant/nginx/lb.conf /etc/nginx/conf.d/lb.conf
sudo nginx -t
sudo systemctl reload nginx
exit
```

### Paso 3: Verificar balanceo Round-Robin

```bash
vagrant ssh client
for i in {1..9}; do 
    printf "Petición %2d: " $i
    curl -s http://192.168.56.10 | grep -o "Servidor web [0-9]"
done
exit
```

**Resultado esperado:**
```
Petición  1: Servidor web 1
Petición  2: Servidor web 2
Petición  3: Servidor web 3
Petición  4: Servidor web 1  ← Vuelve al primero
Petición  5: Servidor web 2
...
```

### Paso 4: Ejecutar las 3 pruebas

```bash
vagrant ssh client
cd /vagrant/artillery

# Ejecutar todas las pruebas
artillery run baseline.yml --output /vagrant/reports/baseline_3servers.json
artillery run ramp.yml --output /vagrant/reports/ramp_3servers.json
artillery run spike.yml --output /vagrant/reports/spike_3servers.json
```

### Paso 5: Generar reportes

```bash
bash /vagrant/analysis/generate_report.sh /vagrant/reports/baseline_3servers.json "baseline_3servidores"
bash /vagrant/analysis/generate_report.sh /vagrant/reports/ramp_3servers.json "ramp_3servidores"
bash /vagrant/analysis/generate_report.sh /vagrant/reports/spike_3servers.json "spike_3servidores"

exit
```

---

## 4. Pruebas con 4 Servidores

### 🚀 Configuración con 4 Servidores Backend

Esta sección agrega un **cuarto servidor** para evaluar el escalamiento horizontal.

### Paso 1: Crear y arrancar web4

```bash
vagrant up web4
```

**Qué hace:**
- Crea VM Ubuntu con IP: 192.168.56.14
- Instala y configura NGINX
- Tiempo estimado: 3-5 minutos

### Paso 2: Verificar que web4 esté funcionando

```bash
vagrant status web4
```

**Resultado esperado:**
```
web4                      running (virtualbox)
```

### Paso 3: Actualizar Load Balancer a 4 servidores

```bash
vagrant ssh lb
sudo cp /vagrant/nginx/lb_4servers.conf /etc/nginx/conf.d/lb.conf
sudo nginx -t
sudo systemctl reload nginx
exit
```

**Pool de backends actualizado:**
- 192.168.56.11 (web1)
- 192.168.56.12 (web2)
- 192.168.56.13 (web3)
- 192.168.56.14 (web4) ← **NUEVO**

### Paso 4: Verificar balanceo con 4 servidores

```bash
vagrant ssh client
for i in {1..12}; do 
    printf "Petición %2d: " $i
    curl -s http://192.168.56.10 | grep -o "Servidor web [0-9]"
done
exit
```

**Resultado esperado:**
```
Petición  1: Servidor web 1
Petición  2: Servidor web 2
Petición  3: Servidor web 3
Petición  4: Servidor web 4  ← El cuarto servidor
Petición  5: Servidor web 1  ← Vuelve al primero (round-robin)
...
```

### Paso 5: Ejecutar prueba BASELINE

```bash
vagrant ssh client
cd /vagrant/artillery
artillery run baseline.yml --output /vagrant/reports/baseline_4servers.json
```

⏱️ **Tiempo estimado:** 60 segundos

### Paso 6: Generar reporte de BASELINE

```bash
bash /vagrant/analysis/generate_report.sh /vagrant/reports/baseline_4servers.json "baseline_4servidores"
```

📁 **Archivo generado:** `reports/baseline_4servers_resumen.md`

### Paso 7: Ejecutar prueba RAMP

```bash
artillery run ramp.yml --output /vagrant/reports/ramp_4servers.json
```

⏱️ **Tiempo estimado:** 5-6 minutos

### Paso 8: Generar reporte de RAMP

```bash
bash /vagrant/analysis/generate_report.sh /vagrant/reports/ramp_4servers.json "ramp_4servidores"
```

### Paso 9: Ejecutar prueba SPIKE

```bash
artillery run spike.yml --output /vagrant/reports/spike_4servers.json
```

⏱️ **Tiempo estimado:** 90 segundos  
⚠️ **Nota:** Se esperan menos errores que con 2 o 3 servidores

### Paso 10: Generar reporte de SPIKE

```bash
bash /vagrant/analysis/generate_report.sh /vagrant/reports/spike_4servers.json "spike_4servidores"

exit
```

### Paso 11: Regenerar análisis comparativo completo

```bash
vagrant ssh client
bash /vagrant/analysis/generate_comparative_report.sh
exit
```

📊 **Archivo actualizado:** `reports/ANALISIS_COMPARATIVO.md`

**Qué hace:**
- Compara rendimiento: 1 vs 2 vs 3 vs 4 servidores
- Compara pruebas: baseline vs ramp vs spike
- Genera conclusiones automáticas
- Identifica configuración óptima

### Paso 12 (OPCIONAL): Restaurar a 3 servidores

```bash
# Detener web4
vagrant halt web4

# Restaurar configuración del LB
vagrant ssh lb
sudo cp /vagrant/nginx/lb.conf /etc/nginx/conf.d/lb.conf
sudo systemctl reload nginx
exit
```

---

## 5. Pruebas con 1 Servidor (Escenario Extremo)

> **⚠️ Advertencia:** Esta prueba muestra los límites de un solo servidor bajo carga

### Paso 1: Detener web2 y web3

```bash
vagrant halt web2
vagrant halt web3
```

### Paso 2: Actualizar configuración a 1 servidor

```bash
vagrant ssh lb
sudo cp /vagrant/nginx/lb_1server.conf /etc/nginx/conf.d/lb.conf
sudo nginx -t
sudo systemctl reload nginx
exit
```

### Paso 3: Ejecutar las 3 pruebas

```bash
vagrant ssh client
cd /vagrant/artillery

# Baseline
artillery run baseline.yml --output /vagrant/reports/baseline_1server.json

# Ramp (se esperan errores)
artillery run ramp.yml --output /vagrant/reports/ramp_1server.json

# Spike (probablemente falle mucho)
artillery run spike.yml --output /vagrant/reports/spike_1server.json
```

### Paso 4: Generar reportes

```bash
bash /vagrant/analysis/generate_report.sh /vagrant/reports/baseline_1server.json "baseline_1servidor"
bash /vagrant/analysis/generate_report.sh /vagrant/reports/ramp_1server.json "ramp_1servidor"
bash /vagrant/analysis/generate_report.sh /vagrant/reports/spike_1server.json "spike_1servidor"

exit
```

### Paso 5: Restaurar configuración normal

```bash
# Levantar todos los servidores
vagrant up web2
vagrant up web3

# Restaurar configuración del LB
vagrant ssh lb
sudo cp /vagrant/nginx/lb.conf /etc/nginx/conf.d/lb.conf
sudo nginx -t
sudo systemctl reload nginx
exit

# Verificar que funcione
vagrant ssh client
curl http://192.168.56.10
exit
```

---

## 6. Ver Estadísticas del Load Balancer

### Método 1: nginx_status (tiempo real)

```powershell
# Desde PowerShell en host
curl http://localhost:8080/nginx_status
```

O abrir en navegador: [http://localhost:8080/nginx_status](http://localhost:8080/nginx_status)

**Información mostrada:**
```
Active connections: 1 
server accepts handled requests
 1234 1234 5678 
Reading: 0 Writing: 1 Waiting: 0
```

### Método 2: Script de análisis completo

```bash
vagrant ssh lb
sudo bash /vagrant/analysis/stats.sh
exit
```

**El script muestra:**
- Total de peticiones procesadas
- Distribución de carga entre servidores
- Códigos de respuesta HTTP
- Tasa de errores
- Tiempos de respuesta

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

#### Códigos de estado HTTP

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

**Formato del log:**
```
192.168.56.50 - - [11/Nov/2025:10:30:45 +0000] "GET / HTTP/1.1" 200 186 "-" "Artillery" "192.168.56.11:80" 0.002
```

Incluye:
- IP del cliente
- Timestamp
- Petición HTTP
- Status code
- **Servidor backend que atendió** (`192.168.56.11:80`)
- Tiempo de respuesta (0.002s)

```bash
exit
```

---

## 7. Pruebas Manuales de Balanceo

### Desde PowerShell (Windows)

```powershell
# Hacer 10 peticiones y ver qué servidor responde
for ($i=1; $i -le 10; $i++) { 
    curl http://localhost:8080 | Select-String "Servidor" 
}
```

### Desde el cliente (Linux)

```bash
vagrant ssh client
for i in {1..10}; do 
    curl -s http://192.168.56.10 | grep "Servidor"
done
exit
```

### Prueba de concurrencia con Apache Bench

```bash
vagrant ssh client

# Prueba simple: 1000 peticiones, 10 concurrentes
ab -n 1000 -c 10 http://192.168.56.10/

# Prueba intensiva: 10000 peticiones, 100 concurrentes
ab -n 10000 -c 100 http://192.168.56.10/

exit
```

---

## 8. Limpiar Logs

```bash
vagrant ssh lb
sudo truncate -s 0 /var/log/nginx/lb_access.log
sudo truncate -s 0 /var/log/nginx/lb_error.log
sudo systemctl reload nginx
exit
```

### Hacer backup antes de limpiar

```bash
vagrant ssh lb
sudo cp /var/log/nginx/lb_access.log /vagrant/reports/backup_$(date +%Y%m%d_%H%M%S).log
sudo truncate -s 0 /var/log/nginx/lb_access.log
sudo systemctl reload nginx
exit
```

---

## 📊 Análisis y Comparación de Resultados

Después de ejecutar todas las pruebas, tendrás hasta **12 reportes** para comparar:

### 📁 Estructura de Reportes Generados

```
reports/
├── baseline_1server.json               # Datos raw
├── baseline_1server_resumen.md         # Análisis
├── baseline_2servers.json
├── baseline_2servers_resumen.md
├── baseline_3servers.json
├── baseline_3servers_resumen.md
├── baseline_4servers.json
├── baseline_4servers_resumen.md
├── ramp_1server.json
├── ramp_1server_resumen.md
├── ramp_2servers.json
├── ramp_2servers_resumen.md
├── ramp_3servers.json
├── ramp_3servers_resumen.md
├── ramp_4servers.json
├── ramp_4servers_resumen.md
├── spike_1server.json
├── spike_1server_resumen.md
├── spike_2servers.json
├── spike_2servers_resumen.md
├── spike_3servers.json
├── spike_3servers_resumen.md
├── spike_4servers.json
├── spike_4servers_resumen.md
└── ANALISIS_COMPARATIVO.md             # Análisis completo comparativo
```

---

### 🔍 Preguntas Clave para el Análisis

1. ✅ **¿Cómo cambia el rendimiento con diferentes cargas?**
2. ✅ **¿Qué pasa cuando reduces/aumentas el número de servidores?**
3. ✅ **¿La distribución de carga es equitativa?**
4. ✅ **¿Cuál es la tasa de errores bajo carga alta?**
5. ✅ **¿Cuánto tiempo de respuesta promedio hay?**
6. ✅ **¿Cómo afecta el número de servidores backend al rendimiento del sistema?**
7. ✅ **¿A partir de qué carga un solo servidor se satura?**
8. ✅ **¿El balanceador distribuye correctamente entre 2, 3 y 4 servidores?**
9. ✅ **¿Duplicar servidores duplica la capacidad?**
10. ✅ **¿Cuál es el punto óptimo de escalamiento?**

---

## 📈 Métricas Clave a Comparar

| Métrica | Descripción | Qué Buscar |
|---------|-------------|------------|
| **Tiempos de respuesta** | mean, p95, p99 | Cómo disminuyen con más servidores |
| **Tasa de éxito** | Porcentaje de requests exitosos | Mejora con más backends |
| **Tasa de errores** | Porcentaje de requests fallidos | Disminuye con más servidores |
| **Throughput** | Peticiones por segundo | Capacidad máxima de cada configuración |
| **Capacidad de picos** | Respuesta ante spike test | Resistencia con 1, 2, 3 y 4 servidores |
| **Distribución** | Equilibrio entre backends | Debe ser equitativa (~25% con 4 servers) |

---

## 🎯 Valores Óptimos Esperados

| Métrica | Valor Óptimo | 1 Servidor | 2 Servidores | 3 Servidores | 4 Servidores |
|---------|--------------|------------|--------------|--------------|--------------|
| **Latencia P95** | < 100ms | ⚠️ Alta (>200ms) | ⚠️ Media (~100ms) | ✅ Baja (<100ms) | ✅ Muy Baja (<50ms) |
| **Latencia P99** | < 200ms | ❌ Muy Alta | ⚠️ Media-Alta | ✅ Aceptable | ✅ Baja |
| **Tasa de Error (Baseline)** | 0% | ✅ 0% | ✅ 0% | ✅ 0% | ✅ 0% |
| **Tasa de Error (Spike)** | < 10% | ❌ >50% | ❌ 20-40% | ⚠️ 5-20% | ✅ <10% |
| **RPS Máximo** | Variable | ~30-50 | ~80-100 | ~120-150 | ~150-200 |
| **Distribución** | Equitativa | N/A | ~50% c/u | ~33% c/u | ~25% c/u |

---

## 🔍 Interpretación de Resultados por Escenario

### Baseline (50 req/s) - Carga Constante

| Configuración | Comportamiento Esperado |
|---------------|------------------------|
| **1 Servidor** | ⚠️ En el límite de capacidad, latencia media-alta |
| **2 Servidores** | ✅ Estable, distribución 50/50 |
| **3 Servidores** | ✅ Óptimo, distribución 33/33/33, latencia mínima |
| **4 Servidores** | ✅ Excelente, distribución 25/25/25/25, latencia muy baja |

### Ramp (10→200 req/s) - Carga Incremental

| Configuración | Comportamiento Esperado |
|---------------|------------------------|
| **1 Servidor** | ❌ Saturación >50 req/s, muchos errores en fases 3 y 4 |
| **2 Servidores** | ⚠️ Degradación >100 req/s, errores en fase 4 |
| **3 Servidores** | ✅ Estable hasta ~150 req/s, degradación gradual en fase 4 |
| **4 Servidores** | ✅ Estable hasta ~180 req/s, degradación mínima en fase 4 |

### Spike (500 req/s) - Pico de Tráfico Extremo

| Configuración | Comportamiento Esperado |
|---------------|------------------------|
| **1 Servidor** | ❌ Colapso total, >50% errores, tiempos de respuesta muy altos |
| **2 Servidores** | ❌ 20-40% errores durante pico, recuperación lenta |
| **3 Servidores** | ⚠️ 5-20% errores durante pico, recuperación moderada |
| **4 Servidores** | ✅ <10% errores durante pico, recuperación rápida |

---

## ⚡ Comando Todo-en-Uno por Configuración

Si quieres ejecutar todo automáticamente:

### Con 2 Servidores (~8 minutos)

```bash
vagrant halt web3 && \
vagrant ssh lb -c "sudo cp /vagrant/nginx/lb_2servers.conf /etc/nginx/conf.d/lb.conf && sudo nginx -t && sudo systemctl reload nginx" && \
vagrant ssh client -c "cd /vagrant/artillery && \
artillery run baseline.yml -o /vagrant/reports/baseline_2servers.json && \
bash /vagrant/analysis/generate_report.sh /vagrant/reports/baseline_2servers.json baseline_2servidores && \
artillery run ramp.yml -o /vagrant/reports/ramp_2servers.json && \
bash /vagrant/analysis/generate_report.sh /vagrant/reports/ramp_2servers.json ramp_2servidores && \
artillery run spike.yml -o /vagrant/reports/spike_2servers.json && \
bash /vagrant/analysis/generate_report.sh /vagrant/reports/spike_2servers.json spike_2servidores"
```

### Con 3 Servidores (~8 minutos)

```bash
vagrant up web3 && \
vagrant ssh lb -c "sudo cp /vagrant/nginx/lb.conf /etc/nginx/conf.d/lb.conf && sudo nginx -t && sudo systemctl reload nginx" && \
vagrant ssh client -c "cd /vagrant/artillery && \
artillery run baseline.yml -o /vagrant/reports/baseline_3servers.json && \
bash /vagrant/analysis/generate_report.sh /vagrant/reports/baseline_3servers.json baseline_3servidores && \
artillery run ramp.yml -o /vagrant/reports/ramp_3servers.json && \
bash /vagrant/analysis/generate_report.sh /vagrant/reports/ramp_3servers.json ramp_3servidores && \
artillery run spike.yml -o /vagrant/reports/spike_3servers.json && \
bash /vagrant/analysis/generate_report.sh /vagrant/reports/spike_3servers.json spike_3servidores"
```

### Con 4 Servidores (~15 minutos - incluye creación de web4)

```bash
vagrant up web4 && \
vagrant ssh lb -c "sudo cp /vagrant/nginx/lb_4servers.conf /etc/nginx/conf.d/lb.conf && sudo nginx -t && sudo systemctl reload nginx" && \
vagrant ssh client -c "cd /vagrant/artillery && \
artillery run baseline.yml -o /vagrant/reports/baseline_4servers.json && \
bash /vagrant/analysis/generate_report.sh /vagrant/reports/baseline_4servers.json baseline_4servidores && \
artillery run ramp.yml -o /vagrant/reports/ramp_4servers.json && \
bash /vagrant/analysis/generate_report.sh /vagrant/reports/ramp_4servers.json ramp_4servidores && \
artillery run spike.yml -o /vagrant/reports/spike_4servers.json && \
bash /vagrant/analysis/generate_report.sh /vagrant/reports/spike_4servers.json spike_4servidores && \
bash /vagrant/analysis/generate_comparative_report.sh"
```

---

## 🛠️ Troubleshooting

### Las pruebas fallan con errores de conexión

```bash
# Verificar que el Load Balancer esté funcionando
vagrant ssh lb -c "sudo systemctl status nginx"
vagrant ssh lb -c "sudo nginx -t"

# Verificar conectividad desde el cliente
vagrant ssh client -c "ping -c 3 192.168.56.10"
vagrant ssh client -c "curl -v http://192.168.56.10"
```

### web4 no arranca correctamente

```bash
# Destruir y recrear web4
vagrant destroy web4 -f
vagrant up web4

# Verificar logs de provisioning
vagrant up web4 --provision
```

### Los reportes no se generan

```bash
# Verificar permisos de los scripts
vagrant ssh client -c "ls -la /vagrant/analysis/*.sh"
vagrant ssh client -c "chmod +x /vagrant/analysis/*.sh"

# Verificar que exista el archivo JSON
vagrant ssh client -c "ls -lh /vagrant/reports/*.json"
```

### Artillery reporta muchos timeouts

```bash
# Opción 1: Reducir carga en los archivos YAML
# Edita artillery/*.yml y reduce arrivalRate

# Opción 2: Aumentar timeouts en NGINX
vagrant ssh lb
sudo nano /etc/nginx/conf.d/lb.conf
# Cambiar: proxy_connect_timeout, proxy_read_timeout, proxy_send_timeout
sudo nginx -t
sudo systemctl reload nginx
exit
```

### Ver logs de errores del Load Balancer

```bash
vagrant ssh lb -c "sudo tail -n 50 /var/log/nginx/lb_error.log"
```

---

## 📚 Archivos de Configuración del Proyecto

### Configuraciones NGINX disponibles

| Archivo | Servidores | Upstream Pool |
|---------|------------|---------------|
| `nginx/lb_1server.conf` | 1 | 192.168.56.11 |
| `nginx/lb_2servers.conf` | 2 | .11, .12 |
| `nginx/lb.conf` | 3 | .11, .12, .13 |
| `nginx/lb_4servers.conf` | 4 | .11, .12, .13, .14 |

### Scripts de análisis

| Script | Función |
|--------|---------|
| `analysis/generate_report.sh` | Genera resumen de un reporte individual |
| `analysis/generate_comparative_report.sh` | Genera análisis comparativo de todos los reportes |
| `analysis/stats.sh` | Muestra estadísticas en tiempo real del LB |

---

## ✅ Checklist de Completitud

Marca cuando completes cada configuración:

- [ ] **2 Servidores**
  - [ ] Baseline ejecutado y reporte generado
  - [ ] Ramp ejecutado y reporte generado
  - [ ] Spike ejecutado y reporte generado

- [ ] **3 Servidores**
  - [ ] Baseline ejecutado y reporte generado
  - [ ] Ramp ejecutado y reporte generado
  - [ ] Spike ejecutado y reporte generado

- [ ] **4 Servidores**
  - [ ] web4 creado y funcionando
  - [ ] Baseline ejecutado y reporte generado
  - [ ] Ramp ejecutado y reporte generado
  - [ ] Spike ejecutado y reporte generado

- [ ] **1 Servidor (Opcional)**
  - [ ] Baseline ejecutado y reporte generado
  - [ ] Ramp ejecutado y reporte generado
  - [ ] Spike ejecutado y reporte generado

- [ ] **Análisis Final**
  - [ ] Análisis comparativo generado
  - [ ] Todos los archivos `.md` revisados
  - [ ] Conclusiones documentadas

---

## 🏆 Conclusiones Esperadas

Al finalizar todas las pruebas, podrás demostrar:

### 1. Escalabilidad Horizontal Funcional
- El sistema escala linealmente con más servidores
- Round-robin distribuye carga equitativamente (25% con 4 servers)
- Cada servidor adicional mejora la capacidad total

### 2. Mejora en Resistencia a Picos
- Con 4 servidores: mayor capacidad de absorber tráfico extremo
- Menor tasa de errores en pruebas de spike
- Recuperación más rápida después de picos

### 3. Trade-off Recursos vs Rendimiento
- Determinar si 4 servidores justifican el costo adicional
- Identificar punto óptimo de escalamiento para tu caso de uso
- Rendimientos decrecientes al agregar más servidores

### 4. Comportamiento Bajo Diferentes Cargas
- **Carga constante:** Rendimiento excelente con cualquier configuración >1 servidor
- **Carga incremental:** Adaptación efectiva, degradación gradual predecible
- **Picos extremos:** Degradación controlada, sin caídas catastróficas

---

**Fecha de creación:** 11 de noviembre de 2025  
**Última actualización:** 11 de noviembre de 2025  
**Autor:** Krsz1  
**Versión:** 3.0
