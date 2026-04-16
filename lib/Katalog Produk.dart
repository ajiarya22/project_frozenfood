import 'package:flutter/material.dart';

// Model Produk
class Produk {
  final String id;
  final String nama;
  final String deskripsi;
  final int harga;
  final String imageUrl;
  final String kategori;

  Produk({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.imageUrl,
    required this.kategori,
  });
}

// Model Item Keranjang
class KeranjangItem {
  final Produk produk;
  int jumlah;

  KeranjangItem({required this.produk, this.jumlah = 1});
}

// Data Produk
final List<Produk> daftarProduk = [
  Produk(
    id: '1',
    nama: 'Sosis Sapi Kanzler',
    deskripsi: 'Sosis sapi premium renyah di luar, lembut di dalam',
    harga: 34000,
    imageUrl: 'https://storage.googleapis.com/tagjs-prod.appspot.com/v1/GkxOaYqOxd/bn6j6jw9_expires_30_days.png',
    kategori: 'Sosis',
  ),
  Produk(
    id: '2',
    nama: 'Sosis Ayam Premium',
    deskripsi: 'Sosis ayam pilihan dengan bumbu rempah khas',
    harga: 28000,
    imageUrl: 'https://storage.googleapis.com/tagjs-prod.appspot.com/v1/GkxOaYqOxd/2n27u08d_expires_30_days.png',
    kategori: 'Sosis',
  ),
  Produk(
    id: '3',
    nama: 'Nugget Ayam Crispy',
    deskripsi: 'Nugget ayam super crispy dengan lapisan tepung renyah',
    harga: 32000,
    imageUrl: 'https://storage.googleapis.com/tagjs-prod.appspot.com/v1/GkxOaYqOxd/7gei1a7d_expires_30_days.png',
    kategori: 'Nugget',
  ),
  Produk(
    id: '4',
    nama: 'Nugget Keju Spesial',
    deskripsi: 'Nugget isi keju meleleh, favorit anak-anak',
    harga: 38000,
    imageUrl: 'https://storage.googleapis.com/tagjs-prod.appspot.com/v1/GkxOaYqOxd/f5ko7w2t_expires_30_days.png',
    kategori: 'Nugget',
  ),
  Produk(
    id: '5',
    nama: 'Bakso Sapi Jumbo',
    deskripsi: 'Bakso sapi jumbo dengan tekstur kenyal dan gurih',
    harga: 45000,
    imageUrl: 'https://storage.googleapis.com/tagjs-prod.appspot.com/v1/GkxOaYqOxd/cn60p91h_expires_30_days.png',
    kategori: 'Bakso',
  ),
  Produk(
    id: '6',
    nama: 'Bakso Urat Premium',
    deskripsi: 'Bakso urat asli dengan kuah kaldu spesial',
    harga: 42000,
    imageUrl: 'https://storage.googleapis.com/tagjs-prod.appspot.com/v1/GkxOaYqOxd/ua93o7rs_expires_30_days.png',
    kategori: 'Bakso',
  ),
];

class KatalogProduk extends StatefulWidget {
  const KatalogProduk({super.key});

  @override
  KatalogProdukState createState() => KatalogProdukState();
}

class KatalogProdukState extends State<KatalogProduk>
    with TickerProviderStateMixin {
  String searchText = '';
  String selectedKategori = 'Semua';
  List<KeranjangItem> keranjang = [];

  late AnimationController _popupController;
  late Animation<double> _popupAnimation;
  Produk? _lastAddedProduct;
  bool _showPopup = false;

  final List<String> kategoriList = ['Semua', 'Sosis', 'Nugget', 'Bakso'];

  @override
  void initState() {
    super.initState();
    _popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _popupAnimation = CurvedAnimation(
      parent: _popupController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _popupController.dispose();
    super.dispose();
  }

  int get totalKeranjang =>
      keranjang.fold(0, (sum, item) => sum + item.jumlah);

  int get totalHarga => keranjang.fold(
      0, (sum, item) => sum + item.produk.harga * item.jumlah);

  void tambahKeKeranjang(Produk produk) {
    setState(() {
      final existing = keranjang.where((e) => e.produk.id == produk.id);
      if (existing.isNotEmpty) {
        existing.first.jumlah++;
      } else {
        keranjang.add(KeranjangItem(produk: produk));
      }
      _lastAddedProduct = produk;
      _showPopup = true;
    });
    _popupController.forward(from: 0);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _popupController.reverse().then((_) {
          if (mounted) setState(() => _showPopup = false);
        });
      }
    });
  }

  List<Produk> get produkFiltered {
    return daftarProduk.where((p) {
      final matchKategori =
          selectedKategori == 'Semua' || p.kategori == selectedKategori;
      final matchSearch =
          p.nama.toLowerCase().contains(searchText.toLowerCase());
      return matchKategori && matchSearch;
    }).toList();
  }

  void bukaKeranjang() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildKeranjangSheet(),
    );
  }

  Widget _buildKeranjangSheet() {
    return StatefulBuilder(
      builder: (context, setSheetState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Keranjang Belanja',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F21AA),
                      ),
                    ),
                    Text(
                      '${keranjang.length} item',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: keranjang.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined,
                                size: 80, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text('Keranjang masih kosong',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 16)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: keranjang.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (ctx, i) {
                          final item = keranjang[i];
                          return Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.produk.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 60,
                                    height: 60,
                                    color: const Color(0xFF4919B9).withOpacity(0.2),
                                    child: const Icon(Icons.fastfood, color: Color(0xFF4919B9)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.produk.nama,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                    Text(
                                      'Rp ${_formatHarga(item.produk.harga)}',
                                      style: const TextStyle(
                                          color: Color(0xFF4919B9),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  _QtyButton(
                                    icon: Icons.remove,
                                    onTap: () {
                                      setSheetState(() {
                                        setState(() {
                                          if (item.jumlah > 1) {
                                            item.jumlah--;
                                          } else {
                                            keranjang.removeAt(i);
                                          }
                                        });
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('${item.jumlah}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                  _QtyButton(
                                    icon: Icons.add,
                                    onTap: () {
                                      setSheetState(() {
                                        setState(() => item.jumlah++);
                                      });
                                    },
                                    filled: true,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
              ),
              if (keranjang.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, -4))
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Pembayaran',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                            'Rp ${_formatHarga(totalHarga)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF1F21AA)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pesanan berhasil dibuat! 🎉'),
                                backgroundColor: Color(0xFF4919B9),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4919B9),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Pesan Sekarang',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatHarga(int harga) {
    final s = harga.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9CA7D2),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Katalog Produk',
                            style: TextStyle(
                              color: Color(0xFF1F21AA),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Order Your Favourite Produk!',
                            style: TextStyle(
                              color: Color(0xFF1F21AA),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: bukaKeranjang,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Color(0xFF4919B9),
                                size: 28,
                              ),
                            ),
                            if (totalKeranjang > 0)
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$totalKeranjang',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => searchText = v),
                      decoration: InputDecoration(
                        hintText: 'Cari produk...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Kategori Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: kategoriList.length,
                    itemBuilder: (ctx, i) {
                      final k = kategoriList[i];
                      final isSelected = selectedKategori == k;
                      return GestureDetector(
                        onTap: () => setState(() => selectedKategori = k),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF4919B9)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Text(
                            k,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF444444),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Product Grid
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: produkFiltered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off,
                                    size: 60, color: Colors.grey[300]),
                                const SizedBox(height: 12),
                                Text('Produk tidak ditemukan',
                                    style: TextStyle(color: Colors.grey[400])),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: produkFiltered.length,
                            itemBuilder: (ctx, i) {
                              return _ProdukCard(
                                produk: produkFiltered[i],
                                formatHarga: _formatHarga,
                                onTambah: () =>
                                    tambahKeKeranjang(produkFiltered[i]),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),

            // Popup Notification
            if (_showPopup && _lastAddedProduct != null)
              Positioned(
                top: 90,
                left: 24,
                right: 24,
                child: ScaleTransition(
                  scale: _popupAnimation,
                  child: FadeTransition(
                    opacity: _popupAnimation,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4919B9),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4919B9).withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ditambahkan ke keranjang! 🛒',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    _lastAddedProduct!.nama,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: bukaKeranjang,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Lihat',
                                  style: TextStyle(
                                    color: Color(0xFF4919B9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProdukCard extends StatefulWidget {
  final Produk produk;
  final String Function(int) formatHarga;
  final VoidCallback onTambah;

  const _ProdukCard({
    required this.produk,
    required this.formatHarga,
    required this.onTambah,
  });

  @override
  State<_ProdukCard> createState() => _ProdukCardState();
}

class _ProdukCardState extends State<_ProdukCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF4919B9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4919B9).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.produk.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF3A14A0),
                        child: const Icon(Icons.fastfood,
                            color: Colors.white54, size: 50),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF4919B9).withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                    // Kategori Badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.produk.kategori,
                          style: const TextStyle(
                            color: Color(0xFF4919B9),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.produk.nama,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.produk.deskripsi,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 9,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${widget.formatHarga(widget.produk.harga)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) => _controller.forward(),
                        onTapUp: (_) {
                          _controller.reverse();
                          widget.onTambah();
                        },
                        onTapCancel: () => _controller.reverse(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: Color(0xFF4919B9),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF4919B9) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? Colors.white : const Color(0xFF4919B9),
        ),
      ),
    );
  }
}