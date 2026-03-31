import 'dart:convert';
import 'package:fashigon_mobile_app/models/banner_model.dart';
import 'package:fashigon_mobile_app/global_variables.dart';
import 'package:http/http.dart' as http;

class BannerController {
  // fetch Bannners
  Future<List<BannerModel>> loadBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();
        return banners;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      throw Exception('Error loading banners: $e');
    }
  }
}
