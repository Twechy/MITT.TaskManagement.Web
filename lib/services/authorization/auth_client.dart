import '../base_client.dart';
import '../projects/project_model.dart';
import 'models.dart';

class AuthClient extends BaseClient {
  Future<JwtResponse> signinUser(SigninDto signinDto) async {
    var response = await post('Auth/SignIn', signinDto.toJson());

    return JwtResponse.fromJson(response.data);
  }

  Future<OperationResult> changeUserPin(ChangePinDto changePinDto) async {
    var response = await post('Auth/ChangePin', changePinDto.toJson());

    return OperationResult.fromJson(response.data);
  }
}
