import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> adDistraction(BuildContext context) async {
  await InterstitialAd.load(
    adUnitId: 'ca-app-pub-1666012439060112/1340045907',
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {

        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) {
          },
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
          },
        );

        ad.show();
      },
      onAdFailedToLoad: (LoadAdError error) {
      },
    ),
  );
}