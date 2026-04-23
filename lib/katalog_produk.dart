import 'package:flutter/material.dart';

class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {

  String selectedCategory = "Sosis";
  String searchText = "";
  TextEditingController searchController = TextEditingController();

  int cartCount = 0;
  double cartScale = 1.0;

  Map<String, List<Map<String, String>>> products = {
    "Sosis": [
      {
        "name": "Sosis Sapi Kanzlerr",
        "price": "Rp. 38.000",
        "image": "assets/sosis.jpg"
      },
      {
        "name": "Sosis Ayam Belfoods",
        "price": "Rp. 35.000",
        "image": "assets/sosis.jpg"
      },
      {
        "name": "Sosis So Nice",
        "price": "Rp. 32.000",
        "image": "assets/sosis.jpg"
      },
    ],
    "Nugget": [
      {
        "name": "Nugget Fiesta",
        "price": "Rp. 45.000",
        "image": "assets/nugget.jpg"
      },
      {
        "name": "Nugget Champ",
        "price": "Rp. 40.000",
        "image": "assets/nugget.jpg"
      },
      {
        "name": "Nugget Belfoods",
        "price": "Rp. 42.000",
        "image": "assets/nugget.jpg"
      },
    ],
    "Bakso": [
      {
        "name": "Bakso Ikan Cidea",
        "price": "Rp. 30.000",
        "image": "assets/baksoikan.jpg"
      },
      {
        "name": "Bakso Sapi",
        "price": "Rp. 28.000",
        "image": "assets/baksoikan.jpg"
      },
      {
        "name": "Bakso Ayam",
        "price": "Rp. 27.000",
        "image": "assets/baksoikan.jpg"
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8D9AC1),
      body: SafeArea(
        child: Column(
          children: [

            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Katalog Produk",
                        style: TextStyle(
                          fontFamily: "Afacad",
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1F2A66),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Order Your Favourite\nProduk!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),

                  /// CART
                  Stack(
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        size: 35,
                        color: Colors.white,
                      ),
                      Positioned(
                      right: 0,
                      top: 0,
                      child: AnimatedScale(
                        scale: cartScale,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "$cartCount",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    )
                  ])
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: searchController,
                   onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                   decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// PRODUCT AREA
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [

                    /// CATEGORY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        categoryButton("Sosis"),
                        categoryButton("Nugget"),
                        categoryButton("Bakso"),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// PRODUCT GRID
                    Expanded(
                      child: GridView.builder(
                        itemCount: products[selectedCategory]!
                          .where((product) => product["name"]!
                              .toLowerCase()
                              .contains(searchText.toLowerCase()))
                          .length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.80,
                        ),
                        itemBuilder: (context, index) {

                          var filteredProducts = products[selectedCategory]!
                              .where((product) => product["name"]!
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()))
                              .toList();

                          var product = filteredProducts[index];

                          return productCard(
                            product["name"] ?? "",
                            product["price"] ?? "",
                            product["image"] ?? "assets/sosis.jpg",
                            () {
                              setState(() {
                                cartCount++;
                                cartScale = 1.5;
                              });

                              Future.delayed(const Duration(milliseconds: 200), () {
                                if (mounted) {
                                  setState(() {
                                    cartScale = 1.0;
                                  });
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),

      /// NAVBAR
      bottomNavigationBar: SizedBox(
        height: 71,
        child: Row(
          children: [

            Expanded(
              child: Container(
                color: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.home),
                  iconSize: 55,
                  color: Colors.blue,
                  onPressed: () {},
                ),
              ),
            ),

            Expanded(
              child: Container(
                color: const Color(0xff4A34B1),
                child: IconButton(
                  icon: const Icon(Icons.call),
                  iconSize: 55,
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),

            Expanded(
              child: Container(
                color: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.store),
                  iconSize: 55,
                  color: Colors.blue,
                  onPressed: () {},
                ),
              ),
            ),

            Expanded(
              child: Container(
                color: const Color(0xff4A34B1),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  iconSize: 55,
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
          ], // Children
        ),
      ),
    );
  }

  /// CATEGORY BUTTON
  Widget categoryButton(String text) {

    bool active = selectedCategory == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
          searchText = "";
          searchController.clear();
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.deepPurple : const Color.fromARGB(217, 217, 217, 217),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// PRODUCT CARD
  Widget productCard(String name, String price, String image, VoidCallback onAdd) {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 74, 52, 177),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// IMAGE
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        /// NAME
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const Spacer(),

        /// PRICE + BUTTON
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
  }
}
