// lib/features/home/domain/repository/home_repository.dart


import 'package:gmedia_project/features/home/domain/entity/hero_banner_entity.dart';

abstract class HomeRepository {
  Future<List<HeroBannerEntity>> getHeroBanners();
}