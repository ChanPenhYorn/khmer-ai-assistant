/// Lifecycle of a single AI request in a tool screen.
enum GenerationStatus {
  /// Nothing requested yet.
  idle,

  /// A request is in flight.
  loading,

  /// The last request produced output.
  success,

  /// The last request failed; [failure] explains why.
  failure;

  bool get isLoading => this == GenerationStatus.loading;

  bool get hasFailed => this == GenerationStatus.failure;

  bool get hasOutput => this == GenerationStatus.success;
}
