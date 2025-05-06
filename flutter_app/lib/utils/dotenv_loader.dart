import 'package:flutter_dotenv/flutter_dotenv.dart';

/**
 * loadEnv function loads environment variables from a .env file.
 * It uses the flutter_dotenv package to read the file and make the variables available in the app.
 * The .env file should be located in the assets directory of the project.
 */
///
Future<void> loadEnv() async {
  await dotenv.load(fileName: "assets/.env");
}