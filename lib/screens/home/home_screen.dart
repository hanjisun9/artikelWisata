import 'dart:convert';

import 'package:artikel_wisata/services/artikel_service.dart';
import 'package:artikel_wisata/widgets/grid_artikel_populer.dart';
import 'package:flutter/material.dart';
import '../../widgets/grid_artikel_populer.dart';
import '../../controllers/artikel_controller.dart';
import '../../models/artikel_model.dart';
import '../../widgets/grid_artikel_all.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Artikel> artikelAll = [];
  int page = 1;
  final int limit = 5;
  bool isLoading = false;
  bool hasMore = true;
  late Future<List<Artikel>> _futureArtikelPopuler;

  @override
  void initState() {
    super.initState();
    loadArtikel();  
    _futureArtikelPopuler = ArtikelController.getArtikel(1, 4);
  }

  Future<void> loadArtikel() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final getArtikel = await ArtikelService.getArtikel(page, limit);
      final totalData = jsonDecode(getArtikel.body)['totalData'];

      final data = await ArtikelController.getArtikel(page, limit);

      setState(() {
        artikelAll.addAll(data);
        if (artikelAll.length >= totalData) {
          hasMore = false;
        } else {
          page++;
        }
      });
    } catch (e) {
      debugPrint('Gagal memuat artikel: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

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
                    ),
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
                    ),
                  ),
                  onChanged: (value) {
                    print('Kata kunci: $value');
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Populer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                FutureBuilder(
                  future: _futureArtikelPopuler,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final artikelList = snapshot.data ?? [];

                      return Column(
                        children: [
                          GridArtikelPopuler(artikelList: artikelList),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Color(0XFFD1A824),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/news-paper.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Lihat Artikel Kamu',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'Yuk, Mulai Buat Artikel Kamu Sendiri',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                        color: Color(0XFFD1A824),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Artikel Lainnya',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0XFFD1A824),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          GridArtikelAll(artikelList: artikelAll),

                          const SizedBox(height: 10),
                          if (hasMore)
                            Center(
                              child: ElevatedButton(
                                onPressed: isLoading ? null : loadArtikel,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0XFFD1A824),
                                ),
                                child: isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Load More'),
                              ),
                            )
                          else
                            Center(
                              child: const Text('Semua artikel sudah dimuat'),
                            ),
                        ],
                      );
                    }
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
