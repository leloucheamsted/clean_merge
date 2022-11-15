import 'package:tello_social_app/modules/user/domain/entities/app_user.dart';
import 'package:tello_social_app/modules/user/infra/datasources/i_user.datasource.dart';

import '../../../core/services/interfaces/ihttpclient_service.dart';

class UserRemoteDataSource implements IUserDataSource {
  final IHttpClientService _client;
  UserRemoteDataSource(this._client);

  String _getUrl(String actionName) {
    return "/User/$actionName";
  }

  @override
  Future<AppUser?> getDetails({String? userId}) async {
    final res = await _client.get(
      _getUrl(userId == null ? "GetUserByToken" : "GetUser"),
      params: userId == null ? null : {"id": userId},
    );
    return res == null ? null : AppUser.fromMap(res);
  }

  @override
  Future<void> setDisplayName(String displayName) {
    return _client.put(_getUrl("UpdateUserNickName"),
        postData: {"nickName": displayName});
  }

  @override
  Future<void> setPhoto(String imgPath) {
    // TODO: implement setPhoto
    throw UnimplementedError();
  }
}
