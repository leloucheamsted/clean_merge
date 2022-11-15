import '../../domain/entities/app_user.dart';

abstract class IUserDataSource {
  Future<void> setDisplayName(String displayName);
  Future<void> setPhoto(String imgPath);
  Future<AppUser?> getDetails({String? userId});
}
