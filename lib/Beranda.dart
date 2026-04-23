import 'package:flutter/material.dart';
import 'service/api_service.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  String search = "";
  String selectedCategory = "Nugget";

  late Future<List> futureProduk;

  @override
  void initState() {
    super.initState();
    futureProduk = ApiService.getProduk();
  }

  /// FILTER (SUDAH AMAN)
  List getFilteredProducts(List data) {
    return data.where((p) {
      String kategori = (p['nama_kategori'] ?? "").toString();
      String nama = (p['nama_produk'] ?? "").toString();
      String desk = (p['deskripsi'] ?? "").toString();

      bool sesuaiKategori =
          kategori.toLowerCase() == selectedCategory.toLowerCase();

      bool sesuaiSearch = search.isEmpty ||
          nama.toLowerCase().contains(search.toLowerCase()) ||
          desk.toLowerCase().contains(search.toLowerCase());

      return sesuaiKategori && sesuaiSearch;
    }).toList();
  }

  /// BUTTON KATEGORI
  Widget categoryButton(String title) {
    bool isSelected = selectedCategory == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = title;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF4919B9)
                : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// CARD PRODUK
  Widget productCard(Map product) {
    return Expanded(
      child: Container(
        height: 210,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF4919B9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// GAMBAR
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "http://172.16.106.48/frozen_food/images/${product["gambar"] ?? ""}",
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (c, e, s) =>
                    const SizedBox(height: 80, child: Icon(Icons.image)),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product["nama_produk"] ?? "-",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Expanded(
              child: Text(
                product["deskripsi"] ?? "-",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ),

            Text(
              "Rp ${product["harga"] ?? "0"}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9FA8DA), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  children: const [
                    Icon(Icons.store,
                        size: 60, color: Color(0xFF4919B9)),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Selamat Datang Di",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Text("REFI FROZEN FOOD",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4919B9))),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                /// SEARCH
                TextField(
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),

                const SizedBox(height: 20),

                /// KATEGORI
                Row(
                  children: [
                    categoryButton("Sosis"),
                    categoryButton("Nugget"),
                    categoryButton("Bakso"),
                  ],
                ),

                const SizedBox(height: 20),

                Text(selectedCategory,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),

                const SizedBox(height: 10),

                /// FUTURE BUILDER FINAL
                FutureBuilder<List>(
                  future: futureProduk,
                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("Data kosong"),
                      );
                    }

                    var products =
                        getFilteredProducts(snapshot.data!);

                    if (products.isEmpty) {
                      return const Center(
                        child: Text("Produk tidak ditemukan"),
                      );
                    }

                    List<Widget> rows = [];
                    for (int i = 0; i < products.length; i += 2) {
                      rows.add(
                        Row(
                          children: [
                            productCard(products[i]),
                            if (i + 1 < products.length)
                              productCard(products[i + 1])
                            else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                      );
                    }

                    return Column(children: rows);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}