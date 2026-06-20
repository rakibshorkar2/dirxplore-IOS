import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/directory_item.dart';
import '../services/dio_client.dart';
import '../services/html_parser.dart';
import 'go_crawler_interface.dart';

class GoCrawler implements GoCrawlerInterface {
  static final GoCrawler _instance = GoCrawler._internal();
  factory GoCrawler() => _instance;

  GoCrawler._internal();

  @override
  Future<List<DirectoryItem>> deepCrawl(String targetUrl,
      {String proxyUri = ""}) async {
    return _deepCrawlFallback(targetUrl);
  }

  Future<List<DirectoryItem>> _deepCrawlFallback(String url) async {
    // Basic recursive crawl in Dart for Web
    final List<DirectoryItem> results = [];
    await _crawlRecursive(url, results);
    return results;
  }

  Future<void> _crawlRecursive(
      String folderUrl, List<DirectoryItem> results) async {
    try {
      final dio = DioClient().dio;
      final response = await dio.get(folderUrl);
      final htmlStr = response.data.toString();
      final items =
          await HtmlParserService.parseApacheDirectoryAsync(htmlStr, folderUrl);

      for (var item in items) {
        if (item.isDirectory) {
          results.add(item);
          // Limit depth for web fallback to prevent infinite loops or OOM
          if (results.length < 500) {
            await _crawlRecursive(item.url, results);
          }
        } else {
          results.add(item);
        }
      }
    } catch (e) {
      debugPrint("Web Crawl error: $e");
    }
  }
}
