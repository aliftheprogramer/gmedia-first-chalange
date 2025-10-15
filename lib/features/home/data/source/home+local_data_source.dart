// lib/features/home/data/datasource/home_local_data_source.dart

abstract class HomeLocalDataSource {
  Future<List<String>> getBannerAssetPaths();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<List<String>> getBannerAssetPaths() async {
    // Mensimulasikan pengambilan data (bisa dari mana saja)
    await Future.delayed(const Duration(milliseconds: 500)); 
    
    // Data hardcoded karena berasal dari local assets
    return [
      'assets/1.png',
      'assets/2.png',
      'assets/3.png',
    ];
  }
}