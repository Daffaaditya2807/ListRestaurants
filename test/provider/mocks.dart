import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

// Generate a MockClient using the Mockito package.
// Create new file for mocks (e.g., test/mocks.dart).
@GenerateMocks([http.Client])
void main() {}
