/// Exception thrown when the MapControllerService fails
class MapServiceException implements Exception {
  /// A message describing the exception 
  final String message;

  /// The method the exception is for
  final String method;

  /// The method's result that created the exception
  final String result;

  MapServiceException({
    required this.method,
    required this.result,
    this.message = '',
    });

    @override
    String toString() {
    String output = '[$method] -> $result\n\t $message';

    return output;
  }
}