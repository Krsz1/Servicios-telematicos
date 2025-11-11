# 🌐 Proyecto: Balanceo de Carga de Servidores Web

![NGINX](https://img.shields.io/badge/NGINX-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Vagrant](https://img.shields.io/badge/Vagrant-1563FF?style=for-the-badge&logo=vagrant&logoColor=white)
![VirtualBox](https://img.shields.io/badge/VirtualBox-183A61?style=for-the-badge&logo=virtualbox&logoColor=white)
![Artillery](https://img.shields.io/badge/Artillery-FF6C37?style=for-the-badge&logo=artillery&logoColor=white)

Este proyecto implementa un **clúster de servidores web con balanceo de carga** utilizando NGINX, automatizado completamente con Vagrant y VirtualBox, e incluye pruebas de carga exhaustivas con Artillery.

---

## 📋 Tabla de Contenidos

- [Descripción](#-descripción)
- [Características Principales](#-características-principales)
- [Arquitectura del Sistema](#️-arquitectura-del-sistema)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Configuración](#-instalación-y-configuración)
- [Guía de Uso](#-guía-de-uso)
- [Pruebas de Carga](#-pruebas-de-carga)
- [Monitoreo y Estadísticas](#-monitoreo-y-estadísticas)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Resultados Esperados](#-resultados-esperados)
- [Comandos Útiles](#️-comandos-útiles)
- [Solución de Problemas](#-solución-de-problemas)
- [Documentación Adicional](#-documentación-adicional)

---

## 📖 Descripción

Este proyecto es una implementación práctica de un **sistema de balanceo de carga** que distribuye peticiones HTTP entre múltiples servidores web backend. El balanceador de carga actúa como punto de entrada único (frontend) y distribuye el tráfico de manera inteligente entre los servidores disponibles.

### 🎯 Objetivos del Proyecto

- ✅ Implementar balanceo de carga con NGINX
- ✅ Automatizar la infraestructura con Vagrant
- ✅ Realizar pruebas de rendimiento y estrés
- ✅ Analizar el comportamiento bajo diferentes cargas
- ✅ Demostrar alta disponibilidad y escalabilidad

### 🎓 Aplicaciones Educativas

Este proyecto es ideal para aprender sobre:

- **Sistemas Distribuidos**: Comprende cómo funcionan los sistemas de múltiples nodos
- **Alta Disponibilidad**: Aprende estrategias de failover y redundancia
- **Balanceo de Carga**: Entiende algoritmos de distribución de tráfico
- **DevOps**: Practica automatización de infraestructura como código
- **Testing de Performance**: Domina herramientas de pruebas de carga

---

## ✨ Características Principales

- 🔄 **Balanceador de carga NGINX** con 3 servidores web backend
- 🤖 **Automatización completa** con Vagrant (infraestructura como código)
- 🧪 **Máquina virtual dedicada** para pruebas de carga
- 📊 **Múltiples escenarios de prueba** con Artillery (baseline, ramp, spike)
- 📈 **Monitoreo y logging detallado** en tiempo real
- ⚡ **Manejo de timeouts** y failover automático
- 🔍 **Scripts de análisis** para interpretar resultados
- 📁 **Generación de reportes** automáticos en JSON y HTML

---

## 🏗️ Arquitectura del Sistema

```
┌──────────────────────┐
│   Cliente Externo    │
│   (Navegador/API)    │
└──────────┬───────────┘
           │
           ▼
    [localhost:8080]
           │
           ▼
┌──────────────────────┐
│  Load Balancer (lb)  │
│   192.168.56.10:80   │
│      NGINX Proxy     │
└──────────┬───────────┘
           │
     ┌─────┴─────┬──────────┐
     ▼           ▼          ▼
┌─────────┐ ┌─────────┐ ┌─────────┐
│  Web1   │ │  Web2   │ │  Web3   │
│ .56.11  │ │ .56.12  │ │ .56.13  │
│ NGINX   │ │ NGINX   │ │ NGINX   │
└─────────┘ └─────────┘ └─────────┘

        ┌─────────────────┐
        │  Client (Artillery) │
        │   192.168.56.50     │
        │  Pruebas de Carga   │
        └─────────────────┘
```

### 🖥️ Máquinas Virtuales

| Máquina | IP Privada | Puerto Host | Función | RAM | CPU |
|---------|------------|-------------|---------|-----|-----|
| **lb** | 192.168.56.10 | 8080→80 | Balanceador de carga NGINX | 512MB | 1 |
| **web1** | 192.168.56.11 | 80 | Servidor web backend #1 | 256MB | 1 |
| **web2** | 192.168.56.12 | 80 | Servidor web backend #2 | 256MB | 1 |
| **web3** | 192.168.56.13 | 80 | Servidor web backend #3 | 256MB | 1 |
| **client** | 192.168.56.50 | - | Cliente de pruebas Artillery | 512MB | 1 |

**Total de recursos:** ~2 GB RAM, 5 CPUs virtuales

---

## 🔧 Requisitos Previos

### Software Necesario

Antes de comenzar, asegúrate de tener instalado:

1. **VirtualBox** >= 6.1
   - [Descargar VirtualBox](https://www.virtualbox.org/wiki/Downloads)
   - Plataformas: Windows, macOS, Linux

2. **Vagrant** >= 2.2
   - [Descargar Vagrant](https://www.vagrantup.com/downloads)
   - Plataformas: Windows, macOS, Linux

3. **Recursos del Sistema**
   - Al menos **4 GB de RAM** disponible
   - **10 GB de espacio** en disco
   - Procesador con soporte de virtualización (Intel VT-x / AMD-V)

### Verificar Instalación

Ejecuta en tu terminal:

```bash
# Verificar Vagrant
vagrant --version
# Salida esperada: Vagrant 2.x.x

# Verificar VirtualBox
VBoxManage --version
# Salida esperada: 6.x.x o superior
```

### Habilitar Virtualización

Si tienes problemas, asegúrate de que la virtualización esté habilitada en tu BIOS/UEFI:
- **Intel:** Busca "Intel VT-x" o "Virtualization Technology"
- **AMD:** Busca "AMD-V" o "SVM Mode"

---

## 🚀 Instalación y Configuración

### Paso 1: Clonar el Repositorio

```bash
# Clonar desde GitHub
git clone https://github.com/Krsz1/Servicios-telematicos.git

# Entrar al directorio
cd Servicios-telematicos
```

### Paso 2: Levantar el Entorno

```bash
# Iniciar todas las máquinas virtuales
vagrant up
```

Este comando automáticamente:
- ✅ Descarga la imagen de Ubuntu/Debian (primera vez)
- ✅ Crea y configura las 5 máquinas virtuales
- ✅ Instala y configura NGINX en lb, web1, web2, web3
- ✅ Instala Node.js y Artillery en client
- ✅ Configura la red privada entre VMs
- ✅ Aplica todas las configuraciones necesarias

⏱️ **Tiempo estimado:** 5-10 minutos (primera vez), 2-3 minutos (subsecuentes)

### Paso 3: Verificar el Estado

```bash
# Ver el estado de todas las VMs
vagrant status
```

**Salida esperada:**
```
Current machine states:

lb                        running (virtualbox)
web1                      running (virtualbox)
web2                      running (virtualbox)
web3                      running (virtualbox)
client                    running (virtualbox)
```

---

## 💻 Guía de Uso

### Acceder al Balanceador de Carga

#### Opción 1: Navegador Web

```bash
# Windows PowerShell
Start-Process "http://localhost:8080"

# macOS/Linux
open http://localhost:8080  # macOS
xdg-open http://localhost:8080  # Linux
```

#### Opción 2: cURL

```bash
# Hacer una petición simple
curl http://localhost:8080

# Ver qué servidor responde
curl -s http://localhost:8080 | grep "Servidor"
```

#### Opción 3: Múltiples Peticiones

```powershell
# Windows PowerShell: Hacer 10 peticiones
for ($i=1; $i -le 10; $i++) { 
    curl http://localhost:8080 | Select-String "Servidor" 
}
```

```bash
# Linux/macOS: Hacer 10 peticiones
for i in {1..10}; do 
    curl -s http://localhost:8080 | grep "Servidor"
done
```

Cada vez que refresques o hagas una petición, verás respuestas de **diferentes servidores backend**, demostrando que el balanceo de carga funciona correctamente.

### Acceso Directo a Servidores (Testing)

```bash
# Conectarse a la VM cliente
vagrant ssh client

# Probar cada servidor directamente
curl http://192.168.56.11  # Web1
curl http://192.168.56.12  # Web2
curl http://192.168.56.13  # Web3

# Probar el balanceador
curl http://192.168.56.10  # Load Balancer

exit
```

---

## 🔥 Pruebas de Carga

El proyecto incluye **3 escenarios de prueba** configurados con Artillery:

### 1️⃣ Baseline - Carga Constante

**Objetivo:** Establecer una línea base del rendimiento del sistema

```bash
vagrant ssh client
cd /vagrant/artillery
artillery run baseline.yml --output /vagrant/reports/baseline.json
```

**Configuración:**
- ⏱️ **Duración:** 60 segundos
- 📊 **Tasa de llegada:** 50 peticiones/segundo
- 🎯 **Total estimado:** ~3,000 peticiones
- 📈 **Comportamiento esperado:** Sistema estable, latencia <50ms, 0% errores

### 2️⃣ Spike - Pico de Tráfico

**Objetivo:** Simular un pico súbito de tráfico (como Black Friday)

```bash
artillery run spike.yml --output /vagrant/reports/spike.json
```

**Configuración:**
- **Fase 1:** 30s @ 500 req/s (pico alto)
- **Fase 2:** 90s @ 50 req/s (recuperación)
- 🎯 **Total estimado:** ~19,500 peticiones
- 📈 **Comportamiento esperado:** 5-20% errores durante pico, recuperación rápida

### 3️⃣ Ramp - Incremento Gradual

**Objetivo:** Simular crecimiento progresivo de usuarios

```bash
artillery run ramp.yml --output /vagrant/reports/ramp.json
```

**Configuración:**
- **Fase 1:** 120s @ 10 req/s (calentamiento)
- **Fase 2:** 240s @ 50 req/s (normal)
- **Fase 3:** 240s @ 100 req/s (crecimiento)
- **Fase 4:** 120s @ 200 req/s (alta carga)
- 🎯 **Total estimado:** ~37,200 peticiones
- 📈 **Comportamiento esperado:** Estable hasta ~150 req/s, degradación gradual después

### Generar Reportes HTML

```bash
# Generar reporte visual en HTML
artillery report /vagrant/reports/baseline.json --output /vagrant/reports/baseline.html
artillery report /vagrant/reports/spike.json --output /vagrant/reports/spike.html
artillery report /vagrant/reports/ramp.json --output /vagrant/reports/ramp.html

exit
```

Los reportes HTML incluyen:
- 📊 Gráficos de latencia en tiempo real
- 📈 Histogramas de distribución de respuesta
- 🎯 Métricas de percentiles (p50, p95, p99)
- ❌ Tasa de errores y códigos HTTP

---

## 📊 Monitoreo y Estadísticas

### 1. Estado del Balanceador (NGINX Status)

```bash
# Desde el host
curl http://localhost:8080/nginx_status

# Desde la VM cliente
vagrant ssh client
curl http://192.168.56.10/nginx_status
exit
```

**Información proporcionada:**
```
Active connections: 1 
server accepts handled requests
 1234 1234 5678 
Reading: 0 Writing: 1 Waiting: 0
```

- **Active connections:** Conexiones activas actuales
- **Requests:** Total de peticiones procesadas
- **Reading/Writing/Waiting:** Estado de las conexiones

### 2. Logs del Balanceador

```bash
vagrant ssh lb

# Ver logs de acceso (últimas 50 líneas)
sudo tail -n 50 /var/log/nginx/lb_access.log

# Ver logs en tiempo real
sudo tail -f /var/log/nginx/lb_access.log

# Ver logs de error
sudo tail -f /var/log/nginx/lb_error.log

exit
```

**Formato del log:**
```
192.168.56.50 - - [11/Nov/2025:10:30:45 +0000] "GET / HTTP/1.1" 200 186 "-" "Artillery" "192.168.56.11:80" 0.002
```

Incluye:
- 🌐 IP del cliente
- 🕐 Timestamp
- 📝 Petición HTTP
- ✅ Status code (200, 404, 500, etc.)
- 🎯 **Servidor backend que atendió** (`192.168.56.11:80`)
- ⏱️ Tiempo de respuesta (0.002s)

### 3. Scripts de Análisis Automático

```bash
vagrant ssh lb

# Ejecutar script de análisis completo
sudo bash /vagrant/analysis/stats.sh

exit
```

**El script muestra:**
- Total de peticiones procesadas
- Distribución de carga entre servidores
- Códigos de respuesta HTTP
- Tasa de errores
- Tiempos de respuesta promedio

---

## 📁 Estructura del Proyecto

```
Servicios-telematicos/
│
├── 📄 README.md                    # Este archivo
├── 📄 vagrantfile                  # Configuración de infraestructura
├── 📄 .gitignore                   # Archivos ignorados por Git
│
├── 📂 nginx/                       # Configuraciones NGINX
│   ├── lb.conf                    # Config del balanceador (3 servers)
│   ├── lb_2servers.conf           # Config con 2 servidores
│   └── web.conf                   # Config de servidores web
│
│
├── 📂 artillery/                   # Configuraciones de pruebas
│   ├── baseline.yml               # Prueba de carga constante
│   ├── spike.yml                  # Prueba de pico de tráfico
│   └── ramp.yml                   # Prueba de incremento gradual
│
├── 📂 analysis/                    # Scripts de análisis
│   ├── stats.sh                   # Análisis de logs NGINX
│   └── generate_report.sh         # Generador de reportes
│
├── 📂 reports/                     # Reportes generados (gitignored)
│   ├── baseline.json              # Resultados en JSON
│   ├── baseline.html              # Reportes visuales
│   └── baseline_resumen.md        # Resúmenes automáticos
│
│
├── 📂 docs/                        # Documentación adicional
│   ├── PRUEBAS.md                 # Guía detallada de pruebas
│
└── 📂 .vagrant/                    # Estado de Vagrant (gitignored)
```

---

## 📈 Resultados Esperados

### Configuración con 3 Servidores

#### Baseline (50 req/s)
- ✅ Sistema estable
- ✅ Latencia promedio: <50ms
- ✅ Latencia P95: <100ms
- ✅ Tasa de error: 0%
- ✅ Distribución equitativa: ~33% cada servidor

#### Spike (500 req/s)
- ⚠️ Posibles timeouts durante el pico
- ⚠️ Latencia durante pico: 100-500ms
- ✅ Recuperación rápida en fase 2
- ⚠️ Tasa de error durante pico: 5-20%
- ✅ Sistema se estabiliza después del pico

#### Ramp (10→200 req/s)
- ✅ Comportamiento progresivo suave
- ✅ Sistema estable hasta ~100 req/s
- ⚠️ Degradación gradual >150 req/s
- ⚠️ Posibles errores en fase 4 (200 req/s)
- ✅ Sin caídas catastróficas

### Comparación por Número de Servidores

| Métrica | 1 Servidor | 2 Servidores | 3 Servidores |
|---------|------------|--------------|--------------|
| **Max RPS** | ~30-50 | ~80-100 | ~120-150 |
| **Latencia P95** | Alta (>200ms) | Media (~100ms) | Baja (<100ms) |
| **Tasa Error (Spike)** | >50% | 20-40% | 5-20% |
| **Capacidad Total** | Limitada | Buena | Óptima |
| **Failover** | ❌ Ninguno | ⚠️ Parcial | ✅ Robusto |

---

## 🛠️ Comandos Útiles

### Gestión de Máquinas Virtuales

```bash
# Iniciar todas las VMs
vagrant up

# Iniciar VM específica
vagrant up lb
vagrant up web1

# Detener todas las VMs (apagado limpio)
vagrant halt

# Detener VM específica
vagrant halt web3

# Reiniciar VM (con recarga de configuración)
vagrant reload lb

# Destruir todas las VMs (eliminar completamente)
vagrant destroy -f

# Destruir VM específica
vagrant destroy -f web2

# Ver estado de todas las VMs
vagrant status

# Ver máquinas VirtualBox directamente
VBoxManage list runningvms
```

### Conexión SSH

```bash
# Conectarse a una VM
vagrant ssh lb
vagrant ssh web1
vagrant ssh client

# Ejecutar comando sin entrar a SSH
vagrant ssh lb -c "sudo systemctl status nginx"

# SSH con usuario específico
vagrant ssh lb -- -l vagrant
```

### Gestión de NGINX

```bash
# Dentro de la VM del balanceador
vagrant ssh lb

# Ver estado de NGINX
sudo systemctl status nginx

# Reiniciar NGINX
sudo systemctl restart nginx

# Recargar configuración (sin downtime)
sudo systemctl reload nginx

# Verificar sintaxis de configuración
sudo nginx -t

# Ver procesos NGINX
ps aux | grep nginx

exit
```

### Gestión de Logs

```bash
# Limpiar logs del balanceador
vagrant ssh lb
sudo truncate -s 0 /var/log/nginx/lb_access.log
sudo truncate -s 0 /var/log/nginx/lb_error.log
sudo systemctl reload nginx
exit

# Backup de logs
vagrant ssh lb
sudo cp /var/log/nginx/lb_access.log /vagrant/reports/backup_$(date +%Y%m%d).log
exit
```

### Pruebas Rápidas

```bash
# Test rápido de balanceo (10 peticiones)
for i in {1..10}; do curl -s http://localhost:8080 | grep "Servidor"; done

# Test de concurrencia con Apache Bench
vagrant ssh client
ab -n 1000 -c 10 http://192.168.56.10/
exit

# Monitoreo continuo
watch -n 1 'curl -s http://localhost:8080/nginx_status'
```

---

## 🐛 Solución de Problemas

### Las VMs no inician

**Problema:** `vagrant up` falla

**Soluciones:**

```bash
# 1. Verificar VirtualBox
VBoxManage list vms
VBoxManage list runningvms

# 2. Limpiar estado de Vagrant
vagrant global-status --prune
vagrant destroy -f
vagrant up

# 3. Verificar logs
vagrant up --debug > vagrant_debug.log 2>&1

# 4. Verificar virtualización (Windows PowerShell como Admin)
Get-ComputerInfo | Select-Object -Property "Hyper*"
```

### El balanceador no responde

**Problema:** `curl http://localhost:8080` falla

**Soluciones:**

```bash
# 1. Verificar estado de NGINX en lb
vagrant ssh lb
sudo systemctl status nginx
sudo nginx -t
exit

# 2. Verificar configuración
vagrant ssh lb
cat /etc/nginx/conf.d/lb.conf
sudo tail -f /var/log/nginx/lb_error.log
exit

# 3. Verificar conectividad
vagrant ssh client
ping 192.168.56.10
curl -v http://192.168.56.10
exit

# 4. Reiniciar lb
vagrant reload lb
```

### Los servidores web no responden

**Problema:** El balanceador funciona pero los backends fallan

**Soluciones:**

```bash
# 1. Verificar todos los web servers
vagrant ssh web1
sudo systemctl status nginx
exit

# 2. Probar cada servidor directamente
vagrant ssh client
curl http://192.168.56.11
curl http://192.168.56.12
curl http://192.168.56.13
exit

# 3. Ver logs del balanceador
vagrant ssh lb
sudo tail -f /var/log/nginx/lb_error.log
# Buscar errores como "upstream timed out" o "Connection refused"
exit

# 4. Reiniciar todos los servidores
vagrant reload web1
vagrant reload web2
vagrant reload web3
```

### Artillery no funciona

**Problema:** `artillery: command not found`

**Soluciones:**

```bash
# 1. Verificar instalación
vagrant ssh client
which artillery
npm list -g artillery

# 2. Reinstalar Artillery
sudo npm install -g artillery

# 3. Verificar versión
artillery --version

# 4. Re-provisionar cliente
exit
vagrant provision client
```

### Errores de timeout en pruebas

**Problema:** Muchos timeouts durante pruebas de carga

**Soluciones:**

```bash
# 1. Reducir tasa de peticiones
# Editar artillery/*.yml y reducir arrivalRate

# 2. Aumentar timeouts en NGINX
vagrant ssh lb
sudo nano /etc/nginx/conf.d/lb.conf
# Cambiar:
# proxy_connect_timeout 5s;  → 10s;
# proxy_read_timeout 10s;    → 20s;
sudo nginx -t
sudo systemctl reload nginx
exit

# 3. Verificar recursos del host
# Asegúrate de tener suficiente RAM/CPU
```

### Problemas de red entre VMs

**Problema:** Las VMs no se comunican entre sí

**Soluciones:**

```bash
# 1. Verificar IPs
vagrant ssh lb
ip addr show
exit

# 2. Ping entre VMs
vagrant ssh client
ping 192.168.56.10
ping 192.168.56.11
exit

# 3. Verificar firewall (si aplica)
vagrant ssh lb
sudo ufw status
exit

# 4. Recrear red de VirtualBox
vagrant halt
VBoxManage hostonlyif remove vboxnet0  # Cuidado: esto afecta otras VMs
vagrant up
```

---

## 📚 Documentación Adicional

### Archivos de Documentación

- 📖 **[PRUEBAS.md](docs/PRUEBAS.md)** - Guía completa de pruebas de carga

### Referencias Externas

- 📘 [NGINX Load Balancing Documentation](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/)
- 📘 [Artillery.io Documentation](https://www.artillery.io/docs)
- 📘 [Vagrant Documentation](https://www.vagrantup.com/docs)
- 📘 [VirtualBox Manual](https://www.virtualbox.org/manual/)

### Conceptos Clave

- **Load Balancing:** Distribución de carga entre múltiples servidores
- **Round Robin:** Algoritmo que distribuye peticiones secuencialmente
- **Failover:** Redirección automática cuando un servidor falla
- **High Availability:** Arquitectura que minimiza downtime
- **Horizontal Scaling:** Agregar más servidores para manejar más carga
---

## 👨‍💻 Autor

**Krsna Gutiérrez González**

- 🐙 GitHub: [@Krsz1](https://github.com/Krsz1)
- 🎓 Proyecto académico de Servicios Telemáticos

---

*Última actualización: 11 de noviembre de 2025*
