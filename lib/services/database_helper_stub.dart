import 'package:sqflite/sqflite.dart';

Future<DatabaseFactory> getWebDatabaseFactory() async {
  throw UnsupportedError('getWebDatabaseFactory is only supported on web');
}
