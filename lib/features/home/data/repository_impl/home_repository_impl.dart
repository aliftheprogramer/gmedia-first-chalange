import 'package:gmedia_project/features/home/data/source/home+local_data_source.dart';
import 'package:gmedia_project/features/home/domain/entity/hero_banner_entity.dart';
import 'package:gmedia_project/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource _localDataSource;

  HomeRepositoryImpl(this._localDataSource);

  @override
  Future<List<HeroBannerEntity>> getHeroBanners() async {
    final assetPaths = await _localDataSource.getBannerAssetPaths();
    return assetPaths.map((path) => HeroBannerEntity(imagePath: path)).toList();
  }
}