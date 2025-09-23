import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RotatingBannerAd extends StatefulWidget {
  const RotatingBannerAd({super.key});

  @override
  State<RotatingBannerAd> createState() => _RotatingBannerAdState();
}

class _RotatingBannerAdState extends State<RotatingBannerAd> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  Timer? _rotationTimer;

  final List<String> _adUnitIds = [
    'ca-app-pub-1666012439060112/3856165087',
    // Add more ad unit IDs here if needed
  ];
  int _currentIndex = 0;

  void _loadAd() {
    _bannerAd?.dispose();
    setState(() => _isAdLoaded = false);

    final ad = BannerAd(
      adUnitId: _adUnitIds[_currentIndex],
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _bannerAd = ad as BannerAd;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          debugPrint('BannerAd failed to load: $error');
          setState(() => _isAdLoaded = false);
        },
      ),
    );

    ad.load();
  }

  void _rotateAd() {
    _currentIndex = (_currentIndex + 1) % _adUnitIds.length;
    _loadAd();
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
    if (_adUnitIds.length > 1) {
      _rotationTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        if (mounted) _rotateAd();
      });
    }
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded && _bannerAd != null
        ? Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          )
        : const SizedBox.shrink();
  }
}
