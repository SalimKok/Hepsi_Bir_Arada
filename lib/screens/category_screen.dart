import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategorySelectionPage extends StatefulWidget {
  const CategorySelectionPage({Key? key}) : super(key: key);

  @override
  State<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  String? userId;
  List<String> allCategories = [
    'Şikayet',
    'Soru',
    'Teşekkür',
    'Öneri',
    'Spam',
    'Diğer',
  ];
  Set<String> selectedCategories = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    fetchSelectedCategories();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id');
    });

    print("Loaded userId: $userId");

    if (userId != null) {
      fetchSelectedCategories();
    } else {
      print("userId null, kullanıcı oturumu açmamış olabilir.");
    }
  }

  Future<void> fetchSelectedCategories() async {
    final url = Uri.parse(
        'http://10.0.2.2:5000/api/categories?user_id=$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<String> fetched = List<String>.from(data['categories']);
        setState(() {
          selectedCategories = fetched.toSet();
          isLoading = false;
        });
      } else {
        throw Exception('Sunucudan veri alınamadı.');
      }
    } catch (e) {
      print("Hata: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> saveCategories() async {
    final url = Uri.parse('http://10.0.2.2:5000/api/categories');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'categories': selectedCategories.toList(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kategoriler kaydedildi!')),
        );
      } else {
        print("Hata yanıtı: ${response.body}");
        throw Exception("Kaydetme başarısız: ${response.statusCode}");
      }
    } catch (e) {
      print("Kaydetme hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hata oluştu.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Seçimi'),
        backgroundColor: const Color.fromARGB(255, 245, 245, 220),
      ),
      body: Column(
        children: [
          // 👇 Bilgilendirme mesajı
          Container(
            width: double.infinity,
            color: Colors.blue.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Text(
              'Lütfen otomatik cevap vermek istediğiniz kategorileri seçin.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),

          // 👇 Liste alanı (geri kalan yüksekliği kaplar)
          Expanded(
              child: Container(
                color: const Color.fromARGB(255, 245, 245, 220),
                child: ListView.builder(
                  itemCount: allCategories.length,
                  itemBuilder: (context, index) {
                    final category = allCategories[index];
                    final isSelected = selectedCategories.contains(category);

                    return CheckboxListTile(
                      title: Text(category),
                      value: isSelected,
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveCategories,
        label: const Text('Kaydet'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
