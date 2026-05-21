/// Failure type used as the left value of usecase `Either<Failure, T>` returns.
///
/// ponytail: sealed class over freezed. Cases are flat; upgrade to freezed
/// with per-case fields when error payloads need structured data.
sealed class Failure {
  const Failure(this.message);

  const factory Failure.network([String? message]) = NetworkFailure;
  const factory Failure.cache([String? message]) = CacheFailure;
  const factory Failure.server([String? message]) = ServerFailure;
  const factory Failure.unexpected([String? message]) = UnexpectedFailure;

  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([String? message]) : super(message ?? 'Network error');
}

final class CacheFailure extends Failure {
  const CacheFailure([String? message]) : super(message ?? 'Cache error');
}

final class ServerFailure extends Failure {
  const ServerFailure([String? message]) : super(message ?? 'Server error');
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String? message]) : super(message ?? 'Unexpected error');
}
