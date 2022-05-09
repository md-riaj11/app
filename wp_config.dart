import 'package:flutter/material.dart';

class WPConfig {
  /// The Name of your app
  static const String appName = 'JobBangla';

  /// TODO: ADD YOUR App name here

  /// The url of your app, should not inclued any '/' slash or any 'https://' or 'http://'
  /// Otherwise it may break the compaitbility, And your website must be
  /// a wordpress website.
  static const String url = 'bdjobdaily.xyz';

  /// TODO: ADD your website URL HERE

  /// Primary Color of the App, must be a valid hex code after '0xFF'
  static const Color primaryColor = Color(0xFF38B7FF);

  /// TODO: ADD your brand color HERE

  /// Used for redirecting users to privacy policy page on your website
  static const String privacyPolicyUrl =
      'https://bdjobdaily.com/privacy-policy/';

  /// Used for redirecting users to privacy terms & services on your website
  static const String termsAndServicesUrl =
      'https://bdjobdaily.xyz/termsAndServices/';

  /// Link to app store rating page
  static const String appStoreRatingUrl = '';

  /// Link to playstore rating page
  static const String playstoreRatingUrl = '';

  /// Support Email
  static const String supportEmail = 'contact.riaj@gmail.com';

  /// Social Links
  static const String facebookUrl = '';
  static const String youtubeUrl = '';
  static const String twitterUrl = '';

  /// If we should force user to login everytime they start the app
  static const bool forceUserToLoginEverytime = false;

  /* <---- Show Post on notificaiton -----> */
  /// If you want to enable a post dialog when a notification arrives, if
  /// it is false a small Toast will appear on the bottom of the screen, see the
  /// example below
  /// https://drive.google.com/file/d/1Dq2ZyNgXTsnFFqm4m9infbnSn4rb-vTl/view?usp=sharing
  static bool showPostDialogOnNotificaiton = false;

  /// IF you want the popular post plugin to be disabled turn this to "false"
  static bool isPopularPostPluginEnabled = false;

  /* <-----------------------> 
      Categories    
   <-----------------------> */

  /// "FEATURED" tag id From Website
  /// the feature tag id which used to identify featured articles
  static const int featuredTagID = 6;

  /// "VIDEO" tag id from website
  /// the id of the video tag, which will help us identify the post type in app
  static const int videoTagID = 4;

  /// Home Page Category Name With Their ID's, the ordering will be same in UI
  /// How to find category ID:
  /// https://njengah.com/find-wordpress-category-id/
  static final homeCategories = <int, String>{
    // ID of Category : Name of the Category
    2: 'JobNews',
    74: 'JobResult',
    106: 'Others',
  };

  /// Name of the feature category
  static const featureCategoryName = 'Trending';

  /// Show horizonatal Logo in home page or title
  /// You can replace the logo in the asset folder
  /// horizonatal logo width is 136x35
  static bool showLogoInHomePage = true;

  /// IF we should keep the caching of home categories tab caching or not
  /// if this is false, then we will fetch new data and refresh the
  /// list if user changes tab or click on one
  static bool enableHomeTabCache = true;

  /// Blocked Categories ID's which will not appear in UI
  ///
  /// How to find category ID:
  /// https://njengah.com/find-wordpress-category-id/
  static List<int> blockedCategoriesIds = [1];
}
