import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/movie.dart';
import '../services/firebase_service.dart';
import '../services/ad_service.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseService _firebaseService = FirebaseService();
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  final List<String> _categories = ['الكل', 'أكشن', 'دراما', 'رعب', 'كوميدي'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = AdService.createBannerAd();
    _bannerAd!.load().then((_) {
      setState(() {
        _isBannerAdReady = true;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أفلام ومسلسلات',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.white70,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: Column(
        children: [
          if (_isBannerAdReady && _bannerAd != null)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                return _buildMovieGrid(category);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieGrid(String category) {
    return StreamBuilder<List<Movie>>(
      stream: category == 'الكل'
          ? _firebaseService.getMoviesStream()
          : _firebaseService.getMoviesByCategoryStream(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  'خطأ في تحميل البيانات',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'تأكد من اتصالك بالإنترنت وإعداد Firebase',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }

        final movies = snapshot.data ?? [];

        if (movies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.movie, color: Colors.white54, size: 64),
                const SizedBox(height: 16),
                Text(
                  'لا توجد أفلام في هذا القسم',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieCard(
              movie: movies[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movies[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
