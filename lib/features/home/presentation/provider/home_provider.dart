import 'package:flutter/material.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/home/domain/entity/hero_banner_entity.dart';
import 'package:gmedia_project/features/home/domain/usecase/banner_usecase.dart';

class HomeProvider extends ChangeNotifier {
  final GetHeroBannersUseCase _getHeroBannersUseCase;

  HomeProvider(this._getHeroBannersUseCase) {
    fetchBanners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<HeroBannerEntity> _banners = [];
  List<HeroBannerEntity> get banners => _banners;

  Future<void> fetchBanners() async {
    _isLoading = true;
    notifyListeners();

    try {
      _banners = await _getHeroBannersUseCase.call(param: NoParams());
    } catch (e) {
      // Handle error jika diperlukan
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}