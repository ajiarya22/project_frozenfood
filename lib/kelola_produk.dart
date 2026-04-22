import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const FrozenFoodApp());
}

class FrozenFoodApp extends StatelessWidget {
  const FrozenFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1F21AA)),
      home: const KelolaProdukScreen(),
    );
  }
}

class Produk {
  final String id;
  final String nama;
  final String deskripsi;
  final int stock;
  final double harga;
  final String imageUrl;

  Produk({required this.id, required this.nama, required this.deskripsi, required this.stock, required this.harga, required this.imageUrl});
}

class KelolaProdukScreen extends StatefulWidget {
  const KelolaProdukScreen({super.key});

  @override
  State<KelolaProdukScreen> createState() => _KelolaProdukScreenState();
}

class _KelolaProdukScreenState extends State<KelolaProdukScreen> {
  static const String serverHost = kIsWeb ? "localhost" : "10.0.2.2";
  final String apiUrl = "http://$serverHost/produk_api.php";
  final String storageUrl = "http://$serverHost/img/";

  List<Produk> _allProduk = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _allProduk = data.map((item) => Produk(
            id: item['id']?.toString() ?? '',
            nama: item['nama']?.toString() ?? '',
            deskripsi: item['deskripsi']?.toString() ?? '',
            stock: int.tryParse(item['stock'].toString()) ?? 0,
            harga: double.tryParse(item['harga'].toString()) ?? 0,
            imageUrl: item['image_url']?.toString() ?? '',
          )).toList();
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // === FUNGSI HAPUS DATA ===
  Future<void> _deleteData(String id) async {
    try {
      final response = await http.delete(Uri.parse("$apiUrl?id=$id"));
      if (response.statusCode == 200) {
        _fetchData(); // Refresh daftar setelah hapus
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Produk berhasil dihapus"), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      debugPrint("Gagal hapus: $e");
    }
  }

  Future<void> _saveData(Map<String, dynamic> data, bool isEdit) async {
    try {
      final response = isEdit
          ? await http.put(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: json.encode(data))
          : await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: json.encode(data));

      if (response.statusCode == 200) {
        _fetchData();
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Gagal simpan: $e");
    }
  }

  void _confirmDelete(String id, String nama) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Produk?"),
        content: Text("Apakah Anda yakin ingin menghapus '$nama'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _deleteData(id);
              Navigator.pop(ctx);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showForm({Produk? produk}) {
    final isEdit = produk != null;
    final nameCtrl = TextEditingController(text: produk?.nama ?? '');
    final deskCtrl = TextEditingController(text: produk?.deskripsi ?? '');
    final priceCtrl = TextEditingController(text: produk?.harga.toStringAsFixed(0) ?? '');
    int tempStock = produk?.stock ?? 0;
    String base64Image = "";
    Uint8List? previewBytes;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(isEdit ? 'Edit Produk' : 'Tambah Produk'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
                      if (image != null) {
                        final bytes = await image.readAsBytes();
                        setDialogState(() { previewBytes = bytes; base64Image = base64Encode(bytes); });
                      }
                    },
                    child: Container(
                      height: 120, width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                      child: previewBytes != null
                          ? Image.memory(previewBytes!, fit: BoxFit.cover)
                          : (isEdit && produk.imageUrl.isNotEmpty)
                              ? Image.network("$storageUrl${produk.imageUrl}", fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
                              : const Icon(Icons.add_a_photo, size: 40),
                    ),
                  ),
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama')),
                  TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: () => setDialogState(() => tempStock > 0 ? tempStock-- : 0), icon: const Icon(Icons.remove_circle, color: Colors.red)),
                      Text(tempStock.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () => setDialogState(() => tempStock++), icon: const Icon(Icons.add_circle, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
              ElevatedButton(onPressed: () {
                _saveData({if (isEdit) 'id': produk.id, 'nama': nameCtrl.text, 'deskripsi': deskCtrl.text, 'stock': tempStock, 'harga': double.tryParse(priceCtrl.text) ?? 0, 'image_base64': base64Image}, isEdit);
              }, child: const Text("Simpan")),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9CA7D2),
      appBar: AppBar(title: const Text("Refi Frozen Food"), backgroundColor: const Color(0xFF1F21AA), foregroundColor: Colors.white),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _allProduk.length,
              itemBuilder: (ctx, i) {
                final p = _allProduk[i];
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network("$storageUrl${p.imageUrl}?t=${DateTime.now().millisecondsSinceEpoch}", width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
                    ),
                    title: Text(p.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Stok: ${p.stock} | Rp ${p.harga.toInt()}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => _showForm(produk: p)),
                        // TOMBOL HAPUS
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmDelete(p.id, p.nama)),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showForm(), child: const Icon(Icons.add)),
    );
  }
}