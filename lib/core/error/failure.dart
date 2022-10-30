import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{

  String getMessage(Failure f) {
    if (f is ServerFailure) {
      return f.msg;
    } else if (f is CacheFailure) {
      return unexpectedFailureMessage;
    }
    return tryRefreshMessage;
  }

}

// General Failures
class ServerFailure extends Failure{

  final String msg;
  ServerFailure(this.msg);

  List<Object?> get props => [];
}
class CacheFailure extends Failure{

  List<Object?> get props => [];
}

const unexpectedFailureMessage = 'There is something wrong. Please report this error, thank you.';
const tryRefreshMessage = '.\nTry refreshing the page';