import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Color(0xFFEFB036), // Gold
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF23486A), // Dark Blue
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF23486A), // Dark Blue
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF23486A), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      routes: {
        '/': (context) => HomePage(onThemeChanged: (isDark) {
              setState(() {
                _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
              });
            }),
        '/second': (context) => SecondPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  HomePage({required this.onThemeChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isSwitched = false;
  bool _isPasswordVisible = false;
  List<Map<String, String>> submissions = [];

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        submissions.add({
          'text': _textController.text,
          'time': DateTime.now().toString(),
        });
        _textController.clear();
        _passwordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Main Screen")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter Your Details",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF23486A),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: "Enter Username",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xFF23486A),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                SwitchListTile(
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(color: Color(0xFF23486A)),
                  ),
                  value: _isSwitched,
                  onChanged: (value) {
                    setState(() {
                      _isSwitched = value;
                    });
                    widget.onThemeChanged(value);
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitData,
                  child: Text("Submit"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/second',
                        arguments: submissions);
                  },
                  child: Text("View Submissions"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> submissions =
        ModalRoute.of(context)!.settings.arguments as List<Map<String, String>>;
    return Scaffold(
      appBar: AppBar(title: Text("Users Information")),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: submissions.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10),
            color: Color(0xFFEFB036), // Gold
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFF23486A),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                "User Added: ${submissions[index]['text']}",
                style: TextStyle(fontSize: 18, color: Color(0xFF23486A)),
              ),
              subtitle: Text(
                "Time&Date: ${submissions[index]['time']}",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          );
        },
      ),
    );
  }
}
