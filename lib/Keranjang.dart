import 'package:flutter/material.dart';

class KeranjangPayments extends StatelessWidget {
  const KeranjangPayments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9EA8D6),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              Row(
                children: const [

                  Icon(Icons.arrow_back),

                  SizedBox(width: 10),

                  Text(
                    "Keranjang Saya",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F21AA),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Column(
                    children: [

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Rangkuman Pesanan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 10),

                      itemProduk(),

                      itemProduk(),

                      const Divider(),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Subtotal Pesanan"),
                          Text("Rp. 56.000"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Metode pembayaran",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const ListTile(
                        leading: Icon(Icons.money),
                        title: Text("Bayar Di Tempat"),
                      ),

                      const ListTile(
                        leading: Icon(Icons.phone),
                        title: Text("Lewat Whatsapp"),
                      ),

                      const Spacer(),

                      Container(
                        width: double.infinity,
                        height: 50,

                        decoration: BoxDecoration(
                          color: const Color(0xFF4919B9),
                          borderRadius: BorderRadius.circular(25),
                        ),

                        child: const Center(
                          child: Text(
                            "Lanjut Ke Pembayaran",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget itemProduk() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        children: [

          Image.network(
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/GkxOaYqOxd/2kt3g1gu_expires_30_days.png",
            width: 60,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sosis Ayam Keju"),
                Text("Stok : 100"),
              ],
            ),
          ),

          Row(
            children: const [

              Icon(Icons.remove_circle_outline),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text("1"),
              ),

              Icon(Icons.add_circle_outline),
            ],
          )
        ],
      ),
    );
  }
}