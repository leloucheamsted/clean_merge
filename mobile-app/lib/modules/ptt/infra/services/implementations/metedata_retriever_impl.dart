import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart' as plugin;
import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_metadata_retriever.dart';

class MetaDataRetriever implements IMetaDataRetriever {
  @override
  Future<MetaDataModel> fromFile(File file) async {
    final plugin.Metadata metaData = await plugin.MetadataRetriever.fromFile(file);
    return MetaDataModel(
      mimeType: metaData.mimeType,
      duration: metaData.trackDuration,
    );
  }
}
