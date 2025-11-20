import 'package:artikel_wisata/widgets/grid_artikel_populer.dart';
import 'package:flutter/material.dart';
import '../../widgets/grid_artikel_populer.dart';
import '../../controllers/artikel_controller.dart';
import '../../models/artikel_model.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: const AssetImage(
                        'assets/images/echan.jpeg',
                      ),
                      radius: 25,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Lee Donghyuck', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.notifications,
                      color: Color(0XFFD1A824),
                      size: 30,
                    )
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Tempat Wisata',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Color(0XFFD1A824).withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    )
                  ),
                  onChanged: (value) {
                    print(
                      'Kata kunci: $value',
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Populer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                FutureBuilder(
                  future: ArtikelController.getArtikel(), 
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else{
                      final artikelList = snapshot.data ?? [];
                      final List<Artikel> artikelPopuler = artikelList.take(4).toList();

                      return GridArtikelPopuler(artikelList: artikelPopuler);
                    }
                  }
                  ),
              ],
            ),
            ),
        ),
      )
      );
  }
}