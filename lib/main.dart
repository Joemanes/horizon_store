import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizon Store',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => LoginPage())));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 120, color: Colors.white),
              SizedBox(height: 30),
              Text('Horizon Store',
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: 10),
              Text('store Vestimantè',
                  style: TextStyle(fontSize: 18, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  static Map<String, String> users = {};

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      if (users.containsKey(email) &&
          users[email] == _passwordController.text) {
        await (await SharedPreferences.getInstance())
            .setString('current_user', email);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => HomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Imèl oswa modpas pa bon!'),
            backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[700]!, Colors.blue[400]!])),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(Icons.shopping_bag, size: 100, color: Colors.white),
                    SizedBox(height: 20),
                    Text('Horizon Store',
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 10),
                    Text('Konekte',
                        style: TextStyle(fontSize: 20, color: Colors.white70)),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Imèl',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.email, color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white70)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Tanpri antre imèl'
                          : (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(v))
                              ? 'Imèl pa valab'
                              : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Modpas',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.lock, color: Colors.white70),
                        suffixIcon: IconButton(
                            icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white70)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Tanpri antre modpas'
                          : null,
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue[700],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Text('KONEKTE',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)))),
                    SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Pa gen kont? ',
                          style: TextStyle(color: Colors.white70)),
                      TextButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (c) => SignupPage())),
                          child: Text('Enskri',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)))
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _signup() {
    if (_formKey.currentState!.validate()) {
      _LoginPageState.users[_emailController.text.trim()] =
          _passwordController.text;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Kont ou an kreye!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white)),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[700]!, Colors.blue[400]!])),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(Icons.person_add, size: 80, color: Colors.white),
                    SizedBox(height: 20),
                    Text('Kreye yon Kont',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: 'Imèl',
                          labelStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.email, color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white70)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2))),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Tanpri antre imèl'
                          : (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(v))
                              ? 'Imèl pa valab'
                              : (_LoginPageState.users.containsKey(v.trim()))
                                  ? 'Imèl deja itilize'
                                  : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: 'Modpas',
                          labelStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.lock, color: Colors.white70),
                          suffixIcon: IconButton(
                              icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white70),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white70)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2))),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Tanpri antre modpas'
                          : (v.length < 8)
                              ? 'Modpas dwe gen 8+ karaktè'
                              : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: 'Konfime Modpas',
                          labelStyle: TextStyle(color: Colors.white70),
                          prefixIcon:
                              Icon(Icons.lock_outline, color: Colors.white70),
                          suffixIcon: IconButton(
                              icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white70),
                              onPressed: () => setState(() =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white70)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2))),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Tanpri konfime modpas'
                          : (v != _passwordController.text)
                              ? 'Modpas pa menm'
                              : null,
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: _signup,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue[700],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Text('ENSKRI',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class Product {
  final String id, name, image, price, description, category, brand;
  Product(
      {required this.id,
      required this.name,
      required this.image,
      required this.price,
      required this.description,
      required this.category,
      required this.brand});
}

class ProductData {
  static List<Product> getAllProducts() => [
        Product(
            id: '1',
            name: 'Chemiz Elegans',
            image:
                'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
            price: '450',
            description: 'Chemiz gason an koton kalite siperyè.',
            category: 'Chemiz',
            brand: 'Classic Style'),
        Product(
            id: '2',
            name: 'Chemiz Kazwèl',
            image:
                'https://images.unsplash.com/photo-1602810319428-019690571b5b?w=400',
            price: '380',
            description: 'Chemiz kazwèl konforab.',
            category: 'Chemiz',
            brand: 'Classic Style'),
        Product(
            id: '3',
            name: 'T-Shirt Fanm',
            image:
                'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
            price: '350',
            description: 'T-shirt fanm modèn.',
            category: 'T-Shirt',
            brand: 'Urban Chic'),
        Product(
            id: '4',
            name: 'T-Shirt Espo',
            image:
                'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=400',
            price: '320',
            description: 'T-shirt pou egzèsis.',
            category: 'T-Shirt',
            brand: 'Urban Chic'),
        Product(
            id: '5',
            name: 'Jean Klasik',
            image:
                'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
            price: '750',
            description: 'Pantalon jean di kou.',
            category: 'Pantalon',
            brand: 'Denim Pro'),
        Product(
            id: '6',
            name: 'Jean Modèn',
            image:
                'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400',
            price: '680',
            description: 'Jean modèn ak koup ajiste.',
            category: 'Pantalon',
            brand: 'Design Pro'),
        Product(
            id: '7',
            name: 'Rad Ete',
            image:
                'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
            price: '850',
            description: 'Rad ete lejè.',
            category: 'Rad',
            brand: 'Summer Belle'),
        Product(
            id: '8',
            name: 'Wòb Elegans',
            image:
                'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=400',
            price: '1150',
            description: 'Wòb pou okasyon.',
            category: 'Rad',
            brand: 'Summer Belle'),
        Product(
            id: '9',
            name: 'Soulye Espo',
            image:
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
            price: '1250',
            description: 'Soulye espo konforab.',
            category: 'Soulye',
            brand: 'Sport Elite'),
        Product(
            id: '10',
            name: 'Bòt',
            image:
                'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=400',
            price: '1400',
            description: 'Bòt solid.',
            category: 'Soulye',
            brand: 'Sport Elite'),
        Product(
            id: '11',
            name: 'Jakèt',
            image:
                'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
            price: '950',
            description: 'Jakèt cho.',
            category: 'Akseswa',
            brand: 'Winter Warm'),
        Product(
            id: '12',
            name: 'Chapo',
            image:
                'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=400',
            price: '250',
            description: 'Chapo fashionable.',
            category: 'Akseswa',
            brand: 'Winter Warm'),
      ];
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = ProductData.getAllProducts();

  Future<void> addToCart(Product p) async {
    List<String> cart =
        (await SharedPreferences.getInstance()).getStringList('cart') ?? [];
    cart.add(
        '${p.id}|${p.name}|${p.image}|${p.price}|${p.description}|${p.category}|${p.brand}');
    await (await SharedPreferences.getInstance()).setStringList('cart', cart);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${p.name} ajoute!'), backgroundColor: Colors.green));
  }

  void filter(String type, String val) {
    setState(() => products = ProductData.getAllProducts()
        .where((p) => type == 'cat' ? p.category == val : p.brand == val)
        .toList());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Horizon Store'),
          backgroundColor: Colors.blue[700],
          actions: [
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (c) => ShoppingListPage())))
          ]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue[700]),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.store, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text('Horizon Store',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold))
                    ])),
            ExpansionTile(
                leading: Icon(Icons.category),
                title: Text('Kategori'),
                children: [
                  'Chemiz',
                  'T-Shirt',
                  'Pantalon',
                  'Rad',
                  'Soulye',
                  'Akseswa'
                ]
                    .map((c) =>
                        ListTile(title: Text(c), onTap: () => filter('cat', c)))
                    .toList()),
            ExpansionTile(
                leading: Icon(Icons.branding_watermark),
                title: Text('Mak'),
                children: [
                  'Classic Style',
                  'Urban Chic',
                  'Design Pro',
                  'Summer Belle',
                  'Sport Elite',
                  'Winter Warm'
                ]
                    .map((b) => ListTile(
                        title: Text(b), onTap: () => filter('brand', b)))
                    .toList()),
            Divider(),
            ListTile(
                leading: Icon(Icons.list),
                title: Text('Lis Pwodwi'),
                onTap: () {
                  setState(() => products = ProductData.getAllProducts());
                  Navigator.pop(context);
                }),
            ListTile(
                leading: Icon(Icons.logout),
                title: Text('Dekonekte'),
                onTap: () async {
                  await (await SharedPreferences.getInstance())
                      .remove('current_user');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (c) => LoginPage()),
                      (r) => false);
                }),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65),
          itemCount: products.length,
          itemBuilder: (c, i) {
            final p = products[i];
            return GestureDetector(
              onTap: () => Navigator.push(
                  c,
                  MaterialPageRoute(
                      builder: (c) => ProductDetailPage(product: p))),
              child: Card(
                elevation: 4,
                child: Column(
                  children: [
                    Expanded(
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(p.image, fit: BoxFit.cover))),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  maxLines: 2),
                              SizedBox(height: 4),
                              Text('${p.price} HTG',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 8),
                              SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue[700]),
                                      icon: Icon(Icons.shopping_cart, size: 16),
                                      label: Text('Achte',
                                          style: TextStyle(fontSize: 12)),
                                      onPressed: () => addToCart(p)))
                            ])),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Product product;
  ProductDetailPage({required this.product});

  Future<void> addToCart(BuildContext c) async {
    List<String> cart =
        (await SharedPreferences.getInstance()).getStringList('cart') ?? [];
    cart.add(
        '${product.id}|${product.name}|${product.image}|${product.price}|${product.description}|${product.category}|${product.brand}');
    await (await SharedPreferences.getInstance()).setStringList('cart', cart);
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(
        content: Text('${product.name} ajoute!'),
        backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(product.name), backgroundColor: Colors.blue[700]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 400,
                child: Image.network(product.image, fit: BoxFit.cover)),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(children: [
                    Chip(
                        label: Text(product.category),
                        backgroundColor: Colors.blue[100]),
                    SizedBox(width: 8),
                    Chip(
                        label: Text(product.brand),
                        backgroundColor: Colors.orange[100])
                  ]),
                  SizedBox(height: 16),
                  Text('${product.price} HTG',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700])),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Text('Deskripsyon',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(product.description, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 32),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          icon: Icon(Icons.shopping_cart),
                          label: Text('AJOUTE NAN Panye',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          onPressed: () => addToCart(context))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}  

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  List<Product> cart = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    List<String> c =
        (await SharedPreferences.getInstance()).getStringList('cart') ?? [];
    setState(() => cart = c.map((i) {
          var p = i.split('|');
          return Product(
              id: p[0],
              name: p[1],
              image: p[2],
              price: p[3],
              description: p[4],
              category: p[5],
              brand: p[6]);
        }).toList());
  }

  Future<void> clear() async {
    await (await SharedPreferences.getInstance()).remove('cart');
    loadCart();
  }

  Future<void> remove(int i) async {
    List<String> c =
        (await SharedPreferences.getInstance()).getStringList('cart') ?? [];
    c.removeAt(i);
    await (await SharedPreferences.getInstance()).setStringList('cart', c);
    loadCart();
  }

  double total() =>
      cart.fold(0.0, (s, p) => s + (double.tryParse(p.price) ?? 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Panye (${cart.length})'),
          backgroundColor: Colors.blue[700],
          actions: [
            if (cart.isNotEmpty)
              IconButton(
                  icon: Icon(Icons.delete_sweep),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (c) =>
                          AlertDialog(title: Text('Efase tout?'), actions: [
                            TextButton(
                                child: Text('Non'),
                                onPressed: () => Navigator.pop(c)),
                            TextButton(
                                child: Text('Wi'),
                                onPressed: () {
                                  clear();
                                  Navigator.pop(c);
                                })
                          ])))
          ]),
      body: cart.isEmpty
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 100, color: Colors.grey[300]),
                  SizedBox(height: 20),
                  Text('Panye ou vid',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold))
                ]))
          : Column(children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (c, i) {
                        final p = cart[i];
                        return Card(
                            child: ListTile(
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(p.image,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover)),
                                title: Text(p.name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${p.price} HTG',
                                    style: TextStyle(color: Colors.green[700])),
                                trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => remove(i))));
                      })),
              Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('${total().toStringAsFixed(0)} HTG',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700]))
                        ]),
                    SizedBox(height: 16),
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700]),
                            onPressed: () => showDialog(
                                context: context,
                                builder: (c) => AlertDialog(
                                        title: Text('Kòmand konfime!'),
                                        content: Text(
                                            'Total: ${total().toStringAsFixed(0)} HTG\n\nMèsi!'),
                                        actions: [
                                          TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                clear();
                                                Navigator.pop(c);
                                              })
                                        ])),
                            child: Text('KONFIME',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))))
                  ])),
            ]),
    );
  }
}
