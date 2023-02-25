import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taskmanagement/services/authorization/auth_client.dart';
import 'package:taskmanagement/services/authorization/models.dart';

import '../projects/project_model.dart';

final developerBlocProvider = Provider.autoDispose<AuthBloc>((ref) {
  ref.maintainState = true;
  return AuthBloc();
});

class AuthBloc extends AuthClient {
  final CompositeSubscription _subscription = CompositeSubscription();

  Future<OperationResult> changePin(ChangePinDto changePinDto) async {
    try {
      return await changeUserPin(changePinDto);
    } catch (e) {
      return OperationResult(
        type: 2,
        messages: [],
        traceId: '',
      );
    }
  }

  Future signin(SigninDto signinDto) async {
    try {
      final subscription =
          Stream.fromFuture(signinUser(signinDto)).listen((event) {
        if (event.type == 1) {
          _userInfo.add(event.content);
        } else {
          _userInfo.addError(event.messages);
        }
      });
      _subscription.add(subscription);
    } catch (e) {
      _userInfo.addError(e);
    }
  }

  final _userInfo = BehaviorSubject<Content>();

  Stream<Content> get userInfo$ => _userInfo.stream;
}
