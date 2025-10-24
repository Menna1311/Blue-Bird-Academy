import 'package:blue_bird/core/common/result.dart';

Future<Result<T>> executeSecureStorage<T>(
    Future<T> Function() storageCall) async {
  try {
    final result = await storageCall.call();
    return Success(result);
  } on Exception catch (ex) {
    return Fail(ex);
  }
}
