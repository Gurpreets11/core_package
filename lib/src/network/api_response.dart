/// An optional wrapper for pairing a decoded value with response
/// metadata (status code, a server message) when a `fromJson` mapper
/// needs more than just the body — e.g. `ApiClient.get<ApiResponse<Lead>>`.
///
/// Most calls don't need this: `ApiClient`'s typed methods hand your
/// `fromJson` the decoded body directly. Reach for this wrapper only
/// when you also need the status code or a server-provided message
/// alongside the parsed data.
class ApiResponse<T> {
  /// Creates an [ApiResponse].
  const ApiResponse({
    required this.data,
    required this.statusCode,
    this.message,
  });

  /// The decoded response payload.
  final T data;

  /// The HTTP status code of the response.
  final int statusCode;

  /// An optional server-provided message (e.g. a success message).
  final String? message;
}
