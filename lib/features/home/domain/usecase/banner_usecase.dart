import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/home/domain/entity/hero_banner_entity.dart';
import 'package:gmedia_project/features/home/domain/repository/home_repository.dart';

class GetHeroBannersUseCase implements Usecase<List<HeroBannerEntity>, NoParams> {
  final HomeRepository _homeRepository;

  GetHeroBannersUseCase(this._homeRepository);

  @override
  Future<List<HeroBannerEntity>> call({NoParams? param}) async {
    return await _homeRepository.getHeroBanners();
  }
}