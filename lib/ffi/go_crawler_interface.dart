import '../models/directory_item.dart';

abstract class GoCrawlerInterface {
  Future<List<DirectoryItem>> deepCrawl(String targetUrl, {String proxyUri = ""});
}
