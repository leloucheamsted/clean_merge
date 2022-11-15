import 'dart:io';

abstract class IMetaDataRetriever {
  Future<MetaDataModel> fromFile(File file);
}

class MetaDataModel {
  final String? mimeType;
  final int? duration;
  MetaDataModel({
    this.mimeType,
    this.duration,
  });
}
