#!/bin/bash
echo "=== Provisionando Cliente de Pruebas ==="

# Actualizar repositorios
apt-get update

# Instalar curl si no está
apt-get install -y curl

# Instalar Node.js 20.x desde NodeSource (mejor compatibilidad)
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Verificar versión instalada
echo "Node.js version:"
node --version
echo "npm version:"
npm --version

# Limpiar instalación previa de Artillery si existe
npm uninstall -g artillery 2>/dev/null || true
npm cache clean --force

# Instalar Artillery versión específica estable
npm install -g artillery@2.0.20

# Verificar instalación
echo "Artillery version:"
artillery --version

echo "=== Cliente configurado con Artillery ==="
