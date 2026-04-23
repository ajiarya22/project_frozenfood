import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'katalog_produk.dart';
=======
<<<<<<< HEAD
import 'opening.dart'; // supaya SplashScreenAdmin dikenali
=======
import 'beranda.dart';
>>>>>>> 3efef7b76e7e06240bb5f2ce94d5ece0e7d62b65
>>>>>>> 3e1b5afeb8fd6bd1340c68cd3bf6f6abd72b0c9d

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      title: 'Frozen Food App',
      home: const KatalogPage(),
    );
  }
}
=======
<<<<<<< HEAD
      title: 'Refi Frozen Food',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreenAdmin(), // panggil splash screen
    );
  }
}
=======
      title: 'Frozen Food',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const Beranda(),
    );
  }
}
>>>>>>> 3efef7b76e7e06240bb5f2ce94d5ece0e7d62b65
>>>>>>> 3e1b5afeb8fd6bd1340c68cd3bf6f6abd72b0c9d
