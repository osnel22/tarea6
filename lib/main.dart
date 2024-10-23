import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(ToolboxApp());
}

class ToolboxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toolbox App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toolbox App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(' Predicción de Género'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GenderPredictorScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.cake),
              title: Text('Predicción de Edad'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgePredictorScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Universidades por País'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UniversityScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text('Clima en RD'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Últimas Noticias'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: ToolboxView(),
    );
  }
}

// Vista 1: Caja de herramientas (ya implementada)
class ToolboxView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caja de Herramientas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido a la Toolbox App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/toolbox.jpg',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Una aplicación para diversas funcionalidades',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Vista 2: Predicción de Género (ya implementada)
class GenderPredictorScreen extends StatefulWidget {
  @override
  _GenderPredictorScreenState createState() => _GenderPredictorScreenState();
}

class _GenderPredictorScreenState extends State<GenderPredictorScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _gender = '';
  Color _backgroundColor = Colors.white;

  Future<void> _predictGender() async {
    final name = _nameController.text;
    if (name.isEmpty) return;

    final url = Uri.parse('https://api.genderize.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _gender = data['gender'];
        if (_gender == 'male') {
          _backgroundColor = Colors.blue;
        } else if (_gender == 'female') {
          _backgroundColor = Colors.pink;
        } else {
          _backgroundColor = Colors.grey;
        }
      });
    } else {
      setState(() {
        _gender = 'Error al obtener el género';
        _backgroundColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predictor de Género'),
      ),
      body: Container(
        color: _backgroundColor,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Introduce tu nombre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictGender,
              child: Text('Predecir Género'),
            ),
            SizedBox(height: 20),
            if (_gender.isNotEmpty)
              Text(
                'Género: $_gender',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

// Vista 3: Predicción de Edad
class AgePredictorScreen extends StatefulWidget {
  @override
  _AgePredictorScreenState createState() => _AgePredictorScreenState();
}

class _AgePredictorScreenState extends State<AgePredictorScreen> {
  final TextEditingController _nameController = TextEditingController();
  int? _predictedAge;
  String _ageGroup = '';
  String _imagePath = 'assets/unknown.png'; // Imagen por defecto

  // Función para predecir la edad usando la API Agify
  Future<void> _predictAge() async {
    final name = _nameController.text;
    if (name.isEmpty) return;

    final url = Uri.parse('https://api.agify.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _predictedAge = data['age'];
        if (_predictedAge! < 18) {
          _ageGroup = 'Joven';
          _imagePath = 'assets/young.png'; // Imagen de un joven
        } else if (_predictedAge! < 60) {
          _ageGroup = 'Adulto';
          _imagePath = 'assets/adult.png'; // Imagen de un adulto
        } else {
          _ageGroup = 'Anciano';
          _imagePath = 'assets/anciano.png'; // Imagen de un anciano
        }
      });
    } else {
      setState(() {
        _ageGroup = 'Error al predecir la edad';
        _imagePath = 'assets/error.png'; // Imagen de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predictor de Edad'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Introduce tu nombre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictAge,
              child: Text('Predecir Edad'),
            ),
            SizedBox(height: 20),
            if (_predictedAge != null)
              Column(
                children: [
                  Text(
                    'Edad predicha: $_predictedAge años',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Grupo de edad: $_ageGroup',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    _imagePath,
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class UniversityScreen extends StatefulWidget {
  @override
  _UniversityScreenState createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  final TextEditingController _countryController = TextEditingController();
  List _universities = [];
  bool _loading = false;

  Future<void> _fetchUniversities() async {
    final country = _countryController.text;
    if (country.isEmpty) return;

    final url =
        Uri.parse('http://universities.hipolabs.com/search?country=$country');
    setState(() {
      _loading = true;
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _universities = data;
        _loading = false;
      });
    } else {
      setState(() {
        _universities = [];
        _loading = false;
      });
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universidades por País'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Introduce el nombre del país',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchUniversities,
              child: Text('Buscar Universidades'),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : _universities.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _universities.length,
                          itemBuilder: (context, index) {
                            final university = _universities[index];
                            return Card(
                              child: ListTile(
                                title: Text(university['name']),
                                subtitle: Text(university['domains'][0]),
                                trailing: IconButton(
                                  icon: Icon(Icons.link),
                                  onPressed: () {
                                    _launchURL(university['web_pages'][0]);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Text('No se encontraron universidades'),
          ],
        ),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _weatherDescription = '';
  double _temperature = 0;
  bool _loading = false;

  Future<void> _fetchWeather() async {
    setState(() {
      _loading = true;
    });

    final apiKey = 'eb8af2e760c2fb4a8a4030d2987fb587';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Santo%20Domingo&appid=$apiKey&lang=es&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _weatherDescription = data['weather'][0]['description'];
        _temperature = data['main']['temp'];
        _loading = false;
      });
    } else {
      setState(() {
        _weatherDescription = 'No se pudo obtener el clima';
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Obtener el clima al cargar la vista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima en RD'),
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Clima Actual en Santo Domingo:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Descripción: $_weatherDescription',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Temperatura: ${_temperature.toStringAsFixed(1)} °C',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> _articles = [];
  bool _loading = false;
  String _errorMessage = '';

  Future<void> _fetchNews() async {
    setState(() {
      _loading = true;
    });

    final url = Uri.parse('https://www.nasa.gov/wp-json/wp/v2/posts');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _articles = data;
          _loading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Error: ${response.statusCode} - ${response.reasonPhrase}';
          _loading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error al conectarse al servidor: $error';
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Últimas Noticias'),
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : _errorMessage.isNotEmpty
                ? Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )
                : ListView.builder(
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      final article = _articles[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(article['title']['rendered']),
                          subtitle: Text(article['excerpt']['rendered']
                              .replaceAll(RegExp(r'<[^>]*>'),
                                  '')), // Eliminar etiquetas HTML
                          onTap: () {
                            // Navegar al enlace de la noticia
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Visitar Noticia'),
                                  content: Text('¿Deseas visitar la noticia?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        // Abrir la URL en el navegador
                                        launch(article['link']);
                                      },
                                      child: Text('Visitar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/fotoCV.jpg'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nombre: Jose Gonzalez',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: 20210599@itla.edo.do',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Teléfono: (829) 686-2604',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Descripción:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Soy un desarrollador apasionado por la creación de aplicaciones innovadoras. '
              'Estoy buscando oportunidades para aplicar mis habilidades y crecer profesionalmente.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
