import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> adDistraction(BuildContext context) async {
  await InterstitialAd.load(
    adUnitId: 'ca-app-pub-1666012439060112/1340045907',
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        debugPrint('[AdDistraction] Interstitial ad loaded.');

        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) {
            debugPrint('[AdDistraction] Ad shown.');
          },
          onAdDismissedFullScreenContent: (ad) {
            debugPrint('[AdDistraction] Ad dismissed.');
            ad.dispose();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            debugPrint('[AdDistraction] Failed to show ad: $error');
            ad.dispose();
          },
        );

        ad.show();
      },
      onAdFailedToLoad: (LoadAdError error) {
        debugPrint('[AdDistraction] Failed to load ad: $error');
      },
    ),
  );
}
