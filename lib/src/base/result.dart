import 'package:meta/meta.dart';

import '../exceptions/failure.dart';

/// A simple success/failure result type, avoiding a hard dependency on
/// any specific functional-programming package (e.g. dartz/fpdart) so
/// consuming apps can adopt whichever they prefer on top of this.
///
/// Use [when] to handle both branches at once, or [map]/[flatMap] to
/// transform a successful value while short-circuiting on failure —
/// useful when chaining several use cases:
///
/// ```dart
/// final result = (await loginUseCase(params))
///     .flatMap((user) => Result.success(user.organizations.first));
/// ```
@immutable
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result] wrapping [value].
  const factory Result.success(T value) = Success<T>;

  /// Creates a failed [Result] wrapping [failure].
  const factory Result.failure(Failure failure) = Failed<T>;

  /// Returns `true` if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if this is a [Failed].
  bool get isFailure => this is Failed<T>;

  /// Folds this result into a single value by calling [onSuccess] or
  /// [onFailure] as appropriate.
  R when<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    final self = this;
    return switch (self) {
      Success<T>() => onSuccess(self.value),
      Failed<T>() => onFailure(self.failure),
    };
  }

  /// Transforms a successful value with [transform]. If this is a
  /// [Failed], the failure passes through unchanged.
  Result<R> map<R>(R Function(T value) transform) {
    final self = this;
    return switch (self) {
      Success<T>() => Result.success(transform(self.value)),
      Failed<T>() => Result.failure(self.failure),
    };
  }

  /// Chains another [Result]-returning operation onto a successful value.
  /// If this is a [Failed], the failure passes through and [transform] is
  /// never called — this is what lets you compose several use cases
  /// without nested `when()` calls.
  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    final self = this;
    return switch (self) {
      Success<T>() => transform(self.value),
      Failed<T>() => Result.failure(self.failure),
    };
  }

  /// Returns the successful value, or [fallback] (computed lazily) if
  /// this is a [Failed].
  T getOrElse(T Function(Failure failure) fallback) {
    final self = this;
    return switch (self) {
      Success<T>() => self.value,
      Failed<T>() => fallback(self.failure),
    };
  }

  /// Returns the successful value, or `null` if this is a [Failed].
  T? get valueOrNull {
    final self = this;
    return self is Success<T> ? self.value : null;
  }

  /// Returns the [Failure], or `null` if this is a [Success].
  Failure? get failureOrNull {
    final self = this;
    return self is Failed<T> ? self.failure : null;
  }
}

/// A successful [Result].
final class Success<T> extends Result<T> {
  /// Creates a [Success] wrapping [value].
  const Success(this.value);

  /// The successful value.
  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Success<T> && value == other.value);

  @override
  int get hashCode => value.hashCode;
}

/// A failed [Result].
final class Failed<T> extends Result<T> {
  /// Creates a [Failed] wrapping [failure].
  const Failed(this.failure);

  /// The failure describing what went wrong.
  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Failed<T> && failure == other.failure);

  @override
  int get hashCode => failure.hashCode;
}

/// Convenience for constructing a [Failure]-based [Result] with less
/// boilerplate inside use cases and repositories.
extension ResultFailureX on Failure {
  /// Wraps this [Failure] in a failed [Result].
  Result<T> toResult<T>() => Result<T>.failure(this);
}
