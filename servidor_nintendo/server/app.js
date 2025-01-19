const express = require('express');
const path = require('path');
const fs = require('fs');
const app = express();
const port = 3000;

app.use(express.static('public'));

app.use('/images', express.static('images'));


app.get('/api/search', (req, res) => {
  const query = (req.query.q || '').trim().toLowerCase();

  // Si no hay término, devolvemos array vacío
  if (!query) {
    return res.json([]);
  }

  const dataDir = '../public';
  fs.readdir(dataDir, (err, files) => {
    if (err) {
      return res.status(500).json({ error: 'Error al leer el directorio.' });
    }

    // Filtramos para que sólo analicemos archivos .json
    const jsonFiles = files.filter(file => file.toLowerCase().endsWith('.json'));
    let results = [];
    let pending = jsonFiles.length;

    jsonFiles.forEach((file) => {
      const filePath = path.join(dataDir, file);

      fs.readFile(filePath, 'utf8', (err, data) => {
        pending--;

        if (!err) {
          try {
            // Aquí puedes hacer un filtrado más fino si conoces la estructura del JSON
            // Para algo básico, comprobamos si el contenido del JSON incluye el término de búsqueda
            if (data.toLowerCase().includes(query)) {
              // Podrías devolver el contenido completo o solo el nombre del fichero
              // Para ejemplo: guardamos el nombre sin .json
              results.push(file.replace('.json', ''));
            }
          } catch (parseError) {
            console.error('Error al parsear el JSON del archivo: ' + file);
          }
        }

        // Cuando hayamos leído todos los archivos, devolvemos results
        if (pending === 0) {
          res.json(results);
        }
      });
    });
  });
});


app.get('/api/images/:imageName', (req, res) => {
  const { imageName } = req.params;
  const imagePath = path.join(__dirname, '../images', imageName);

  // Comprobamos si existe el archivo
  fs.access(imagePath, fs.constants.F_OK, (err) => {
    if (err) {
      // Si no existe, enviamos un 404
      return res.status(404).json({ error: 'Imagen no encontrada' });
    }

    // Si existe, la devolvemos con sendFile
    res.sendFile(imagePath);
  });
});


app.get('/api/categories', (req, res) => {
    const dataDir = '../public';
  
    fs.readdir(dataDir, (err, files) => {
      if (err) {
        return res.status(500).json({ error: 'Error al leer el directorio.' });
      }
  
      // Filtramos para que sólo devuelva archivos con extensión .json
      const jsonFiles = files.filter(file => file.toLowerCase().endsWith('.json')).map(file => file.replace(".json", ""));
      
  
      // Devolvemos el listado en formato JSON
      res.json(jsonFiles);
    });
  });



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
