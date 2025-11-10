# Proyecto: Balanceo de Carga de Servidores Web

Este proyecto implementa un clúster de servidores web con balanceo de carga utilizando NGINX, automatizado con Vagrant y VirtualBox, e incluye pruebas de carga con Artillery.

## 📋 Tabla de Contenidos

- [Descripción](#descripción)
- [Arquitectura](#arquitectura)
- [Requisitos Previos](#requisitos-previos)
- [Instalación y Configuración](#instalación-y-configuración)
- [Uso](#uso)
- [Pruebas de Carga](#pruebas-de-carga)
- [Monitoreo y Estadísticas](#monitoreo-y-estadísticas)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Resultados Esperados](#resultados-esperados)

## 📖 Descripción

Este proyecto consiste en la implementación de un sistema de balanceo de carga que distribuye las peticiones HTTP entre múltiples servidores web backend. El balanceador de carga actúa como frontend, recibiendo todas las peticiones y distribuyéndolas entre los servidores disponibles.

### Características Principales:

- ✅ Balanceador de carga NGINX con 3 servidores web backend
- ✅ Automatización completa con Vagrant
- ✅ Máquina virtual dedicada para pruebas de carga
- ✅ Múltiples escenarios de prueba con Artillery
- ✅ Monitoreo y logging detallado
- ✅ Manejo de timeouts y failover automático

## 🏗️ Arquitectura

```
┌──────────────┐
│   Cliente    │
│  (Artillery) │
└──────┬───────┘
       │
       ▼
┌─────────────────────┐
│  Load Balancer (LB) │
│  192.168.56.10:80   │
│      (NGINX)        │
└──────────┬──────────┘
           │
    ┌──────┴──────┬──────────┐
    ▼             ▼          ▼
┌────────┐   ┌────────┐   ┌────────┐
│ Web1   │   │ Web2   │   │ Web3   │
│.56.11  │   │.56.12  │   │.56.13  │
│(NGINX) │   │(NGINX) │   │(NGINX) │
└────────┘   └────────┘   └────────┘
```

### Máquinas Virtuales:

| Máquina | IP | Puerto | Función |
|---------|------------|--------|---------|
| **lb** | 192.168.56.10 | 8080→80 | Balanceador de carga |
| **web1** | 192.168.56.11 | 80 | Servidor web backend 1 |
| **web2** | 192.168.56.12 | 80 | Servidor web backend 2 |
| **web3** | 192.168.56.13 | 80 | Servidor web backend 3 |
| **client** | 192.168.56.50 | - | Cliente para pruebas de carga |

## 🔧 Requisitos Previos

### Software Necesario:

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) >= 6.1
- [Vagrant](https://www.vagrantup.com/downloads) >= 2.2
- Al menos 4 GB de RAM disponible
- 10 GB de espacio en disco

### Verificar Instalación:

```powershell
vagrant --version
VBoxManage --version
```

## 🚀 Instalación y Configuración

### 1. Clonar o Descargar el Proyecto

```powershell
cd c:\Users\Krsna\Downloads\project-loadbalancer
```

### 2. Levantar el Entorno

```powershell
# Iniciar todas las máquinas virtuales
vagrant up
```

Este comando creará y configurará automáticamente:
- 1 balanceador de carga
- 3 servidores web
- 1 máquina cliente con Artillery instalado

**Tiempo estimado**: 5-10 minutos (primera vez)

### 3. Verificar el Estado

```powershell
# Ver el estado de las VMs
vagrant status

# SSH a una máquina específica
vagrant ssh lb
vagrant ssh web1
vagrant ssh client
```

## 💻 Uso

### Acceder al Balanceador de Carga

Desde tu máquina host:

```powershell
# Abrir en navegador
Start-Process "http://localhost:8080"

# O usar curl
curl http://localhost:8080
```

Cada vez que refresques la página, verás respuestas de diferentes servidores backend, demostrando el balanceo de carga.

### Acceso Directo a Servidores (Solo para Pruebas)

```powershell
# Desde dentro de las VMs
vagrant ssh client
curl http://192.168.56.11  # Web1
curl http://192.168.56.12  # Web2
curl http://192.168.56.13  # Web3
```

## 🔥 Pruebas de Carga

El proyecto incluye 3 escenarios de prueba con Artillery:

### 1. Baseline - Carga Constante

Simula tráfico constante moderado:

```powershell
vagrant ssh client
cd /vagrant/artillery
artillery run baseline.yml
```

**Configuración:**
- Duración: 60 segundos
- Tasa de llegada: 50 peticiones/segundo
- Total: ~3,000 peticiones

### 2. Spike - Pico de Tráfico

Simula un pico súbito de tráfico:

```powershell
vagrant ssh client
cd /vagrant/artillery
artillery run spike.yml
```

**Configuración:**
- Fase 1: 30s @ 500 req/s (pico alto)
- Fase 2: 90s @ 50 req/s (recuperación)
- Total: ~19,500 peticiones

### 3. Ramp - Incremento Gradual

Simula crecimiento progresivo de usuarios:

```powershell
vagrant ssh client
cd /vagrant/artillery
artillery run ramp.yml
```

**Configuración:**
- Fase 1: 120s @ 10 req/s
- Fase 2: 240s @ 50 req/s
- Fase 3: 240s @ 100 req/s
- Fase 4: 120s @ 200 req/s
- Total: ~37,200 peticiones

### Guardar Reportes

```bash
# Ejecutar y guardar JSON
artillery run baseline.yml -o /vagrant/reports/baseline-$(date +%Y%m%d-%H%M%S).json

# Generar reporte HTML
artillery report /vagrant/reports/baseline.json
```

## 📊 Monitoreo y Estadísticas

### 1. Estado del Balanceador (NGINX Status)

```powershell
# Desde el host
curl http://localhost:8080/nginx_status

# Desde la VM cliente
vagrant ssh client
curl http://192.168.56.10/nginx_status
```

**Información proporcionada:**
- Conexiones activas
- Peticiones totales
- Lecturas/escrituras/esperas

### 2. Logs del Balanceador

```powershell
vagrant ssh lb
sudo tail -f /var/log/nginx/lb_access.log
sudo tail -f /var/log/nginx/lb_error.log
```

**El log incluye:**
- IP del cliente
- Timestamp
- Petición HTTP
- Status code
- **Servidor backend que atendió** (`$upstream_addr`)
- Tiempo de respuesta

Ejemplo de línea de log:
```
192.168.56.50 - - [10/Nov/2025:10:30:45 +0000] "GET / HTTP/1.1" 200 186 "-" "Artillery" "192.168.56.11:80" 0.002
```

### 3. Análisis de Resultados Artillery

Los reportes JSON incluyen:

- **Contadores:**
  - `http.requests`: Total de peticiones
  - `errors.ETIMEDOUT`: Peticiones con timeout
  - `vusers.failed`: Usuarios virtuales fallidos
  
- **Tasas:**
  - `http.request_rate`: Peticiones por segundo

- **Resúmenes:**
  - Tiempos de respuesta (min, max, mean, p95, p99)
  - Códigos de respuesta HTTP

## 📁 Estructura del Proyecto

```
project-loadbalancer/
│
├── Vagrantfile                 # Configuración de VMs
│
├── nginx/
│   └── lb.conf                 # Configuración del balanceador NGINX
│
├── provision/
│   ├── provision-lb.sh         # Script para configurar load balancer
│   ├── provision-web.sh        # Script para configurar servidores web
│   └── provision-client.sh     # Script para configurar cliente
│
├── artillery/
│   ├── baseline.yml            # Prueba de carga constante
│   ├── spike.yml               # Prueba de pico de tráfico
│   └── ramp.yml                # Prueba de incremento gradual
│
├── reports/
│   └── baseline.json           # Resultados de pruebas
│
└── web/
    ├── index1.html             # Página ejemplo servidor 1
    └── index2.html             # Página ejemplo servidor 2
```

## 📈 Resultados Esperados

### Configuración con 3 Servidores

#### Baseline (50 req/s):
- ✅ Sistema estable
- ✅ Baja latencia (<50ms promedio)
- ✅ 0% de errores esperados
- ✅ Distribución equitativa entre servidores

#### Spike (500 req/s):
- ⚠️ Posibles timeouts durante el pico
- ⚠️ Incremento en latencia (100-500ms)
- ✅ Recuperación rápida en fase 2
- ⚠️ Tasa de error: 5-20% durante pico

#### Ramp (10→200 req/s):
- ✅ Comportamiento progresivo
- ✅ Sistema estable hasta ~100 req/s
- ⚠️ Degradación gradual >150 req/s
- ⚠️ Posibles errores en fase 4 (200 req/s)

### Experimentando con Diferentes Números de Servidores

#### Modificar el Número de Backends:

Editar `Vagrantfile`:

```ruby
backends = 2  # Cambiar de 3 a 2, 4, 5, etc.
```

Luego actualizar `nginx/lb.conf`:

```nginx
upstream backend {
    server 192.168.56.11;
    server 192.168.56.12;
    # Agregar/quitar según sea necesario
}
```

Reiniciar:

```powershell
vagrant destroy -f
vagrant up
```

#### Resultados Esperados por Configuración:

| Servidores | Max req/s | Latencia | Observaciones |
|------------|-----------|----------|---------------|
| 1 servidor | ~30-50 | Alta | Cuello de botella evidente |
| 2 servidores | ~80-100 | Media | Mejor distribución |
| 3 servidores | ~120-150 | Baja | Balance óptimo para este caso |
| 4+ servidores | ~150-200 | Baja | Mejoras marginales |

## 🛠️ Comandos Útiles

### Gestión de VMs

```powershell
# Iniciar todas las VMs
vagrant up

# Iniciar VM específica
vagrant up lb

# Detener todas las VMs
vagrant halt

# Reiniciar VM
vagrant reload lb

# Destruir y recrear
vagrant destroy -f
vagrant up

# Ver estado
vagrant status

# SSH a una VM
vagrant ssh client
```

### Pruebas Rápidas

```powershell
# Desde Windows PowerShell (host)
# Prueba simple
for ($i=1; $i -le 10; $i++) { curl http://localhost:8080 }

# Desde VM cliente
vagrant ssh client
for i in {1..10}; do curl -s http://192.168.56.10 | grep "Servidor"; done
```

### Reiniciar Servicios

```bash
# En VM lb
vagrant ssh lb
sudo systemctl restart nginx
sudo systemctl status nginx

# En VM web1/web2/web3
vagrant ssh web1
sudo systemctl restart nginx
```

## 🐛 Troubleshooting

### Las VMs no inician

```powershell
# Verificar VirtualBox
VBoxManage list vms
VBoxManage list runningvms

# Limpiar y reiniciar
vagrant destroy -f
vagrant up
```

### El balanceador no responde

```powershell
vagrant ssh lb
sudo systemctl status nginx
sudo nginx -t  # Verificar configuración
sudo tail -f /var/log/nginx/error.log
```

### Artillery no funciona

```powershell
vagrant ssh client
which artillery
npm list -g artillery
sudo npm install -g artillery  # Reinstalar si es necesario
```

### Errores de timeout en pruebas

- Reducir `arrivalRate` en archivos YAML
- Aumentar timeouts en `nginx/lb.conf`
- Verificar recursos del host (RAM/CPU)

## 📚 Referencias

- [NGINX Load Balancing](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/)
- [Artillery Documentation](https://www.artillery.io/docs)
- [Vagrant Documentation](https://www.vagrantup.com/docs)

## 👨‍💻 Autor

Proyecto desarrollado para el curso de Sistemas Distribuidos.

---

**Fecha**: Noviembre 2025
**Versión**: 1.0
