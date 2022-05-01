/// Configuration for AD Unit ID
/// Edit these with what you got from google mobile ad sdk
/// Get your keys from here
/// https://admob.google.com/home/
class AdConfig {
  /// If the ad is on
  static const bool isAdOn = false;

  /// How many post after you wanna display ads [HomePage] or [FeatureTab]
  static int adIntervalInHomePage = 5;

  /// How many post after you wanna display ads in CategoryView
  static int adIntervalInCategory = 5;

  /// TODO: ADD YOUR ANDROID BANNER ID HERE
  /* <---- ANDROID -----> */
  static const String androidBannerAdID = '';

  /// TODO: ADD YOUR AD ID ID HERE
  static const String androidInterstitialAdID = '';

  /* <---- IOS -----> */
  /// TODO: ADD YOUR AD ID ID HERE
  static const String iosBannerAdID = '';

  /// TODO: ADD YOUR AD ID ID HERE
  static const String iosInterstitialAdID = '';
}
