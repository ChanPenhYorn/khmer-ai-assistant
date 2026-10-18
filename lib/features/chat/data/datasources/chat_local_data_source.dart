/// Raw storage contract for conversations.
///
/// Kept as untyped maps so the storage format (currently a JSON document in
/// shared preferences) stays an implementation detail of this layer.
abstract interface class ChatLocalDataSource {
  Future<List<Map<String, dynamic>>> readAll();

  Future<void> writeAll(List<Map<String, dynamic>> conversations);
}
