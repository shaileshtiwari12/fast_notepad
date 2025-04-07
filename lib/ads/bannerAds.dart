// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAds extends StatefulWidget {
  const BannerAds({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BannerAdsState createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-6853478844820529/8882010140',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Failed to load a banner ad: ${error.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SafeArea(
        child: _isAdLoaded
            ? SizedBox(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
            : const SizedBox.shrink(),
        
      ),
    );
  }
}
