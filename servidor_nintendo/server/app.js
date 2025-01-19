const express = require('express');
const app = express();
const port = 3000;

app.use(express.static('public'));

app.use('/images', express.static('images'));

// Ruta universal: /api/:filename
app.get('/api/:filename', (req, res) => {
    const fs = require('fs');
    const path = require('path');
  
    // Obtenemos el nombre del archivo desde el parámetro :filename
    const { filename } = req.params;
  
    // Construimos la ruta completa al archivo JSON
    const filePath = path.join('../public', `${filename}.json`);
  
    // Intentamos leer el archivo
    fs.readFile(filePath, 'utf8', (err, data) => {
      if (err) {
        // Si ocurre un error (p.ej. no existe el archivo), respondemos con 404
        return res.status(404).json({ error: 'Archivo no encontrado: '+filename });
      }
      try {
        // Parseamos el contenido como JSON
        const jsonData = JSON.parse(data);
        // Devolvemos el objeto parseado
        res.json(jsonData);
      } catch (parseError) {
        // Si hubo problema al parsear, enviamos un 500
        res.status(500).json({ error: 'Error al parsear JSON' });
      }
    });
  });
  

// Iniciar servidor
const httpServer = app.listen(port, () => {
  console.log(`Servidor escuchando en: http://0.0.0.0:${port}`);
});

// Manejar señales para apagar el servidor correctamente
process.on('SIGTERM', shutDown);
process.on('SIGINT', shutDown);

function shutDown() {    
  console.log('Recibida señal de kill, cerrando servidor...');
  httpServer.close();
  process.exit(0);
}
