import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_add_member.usecase.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_attach.usecase.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_detach.usecase.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_find_by_id.usecase.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_remove_member.usecase.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_rename.usecase.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_setphoto.usecas.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/message_list.usecase.dart';
import 'package:tello_social_app/modules/chat/external/datasources/fake_messages.datasource%20.dart';
import 'package:tello_social_app/modules/chat/external/datasources/remote_group.datasource.dart';
import 'package:tello_social_app/modules/chat/infra/datasource/i_group_datasource.dart';
import 'package:tello_social_app/modules/chat/infra/datasource/i_message_datasource.dart';
import 'package:tello_social_app/modules/chat/infra/repositories/group.repository.dart';
import 'package:tello_social_app/modules/chat/infra/repositories/message.repository.dart';
import 'package:tello_social_app/modules/chat/presentation/blocs/group_detail_bloc.dart';
import 'package:tello_social_app/modules/chat/presentation/pages/group_create.page.dart';
import 'package:tello_social_app/modules/chat/presentation/pages/group_home.page.dart';
import 'package:tello_social_app/modules/chat/presentation/pages/group_messages.page.dart';

import 'package:tello_social_app/modules/core/services/implementations/audioplayer/adapters/just_audio_player_adapter.dart';
import 'package:tello_social_app/modules/core/services/implementations/audioplayer/manager/audio_player_manager.dart';
import 'package:tello_social_app/modules/core/services/interfaces/i_audio_player.dart';
import 'package:tello_social_app/modules/ptt/ptt.module.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import 'domain/usecases/group_create.usecase.dart';
import 'domain/usecases/group_delete.usecase.dart';
import 'domain/usecases/group_fetchlist.usecase.dart';
import 'domain/usecases/group_set_active.usecase.dart';
import 'presentation/blocs/create_group.bloc.dart';
import 'presentation/blocs/fetch_grop_list_bloc.dart';
import 'presentation/blocs/remove_group.bloc.dart';
import 'presentation/pages/group_detail_circle.page.dart';
import 'presentation/pages/group_edit.page.dart';
import 'presentation/pages/group_list.page.dart';

class GroupModule extends Module {
  @override
  List<Module> get imports => [PttModule()];
  // List<Module> get imports => [];

  @override
  List<Bind<Object>> get binds => [
        Bind<AudioPlayerManager>((i) => AudioPlayerManager(i()), export: false, onDispose: (obj) {
          obj.dispose();
        }),
        // Bind.lazySingleton((i) => AudioPlayerManager(i()), export: false),
        // Bind.lazySingleton<IAudioPlayer>((i) => AudioPlayersAdapter(), export: false),
        Bind.lazySingleton<IAudioPlayer>((i) => JustAudioPlayerAdapter(), export: false),
        // Bind.factory<IAudioPlayer>((i) => AudioPlayersSvc(), export: false),

        Bind.factory((i) => CreateGroupBloc(), export: false),
        Bind.lazySingleton((i) => GroupDetailBloc(), export: false),
        // Bind.factory((i) => GroupDetailBloc(), export: false),
        // Bind.lazySingleton((i) => FetchGroupListBloc(), export: false),
        Bind.lazySingleton((i) => RemoveGroupBloc(), export: false),

        Bind.lazySingleton((i) => GroupAttachUseCase(i()), export: false),
        Bind.lazySingleton((i) => GroupDetachUseCase(i()), export: false),
        Bind.lazySingleton((i) => GroupSetActiveUseCase(i()), export: false),
        Bind.lazySingleton((i) => GroupFindByIdUseCase(i()), export: false),
        // Bind.lazySingleton((i) => GroupFetchListUseCase(i()), export: false),
        Bind.lazySingleton((i) => GroupCreateUseCase(i()), export: false),
        Bind.lazySingleton((i) => GroupDeleteUseCase(i()), export: false),
        Bind.lazySingleton((i) => GroupAddMemberUseCase(i()), export: false),
        Bind.lazySingleton((i) => GroupRemoveMemberUseCase(i()), export: false),
        Bind.lazySingleton((i) => GroupSetPhotoUseCase(i()), export: false),
        Bind.lazySingleton((i) => GroupRenameUseCase(i()), export: false),

        // Bind.lazySingleton((i) => GroupRepository(i()), export: false),

        // Bind.lazySingleton<IGroupDataSource>((i) => RemoteGroupDataSource(i()), export: false),
        // Bind.lazySingleton<IGroupDataSource>((i) => FakeGroupDataSource(), export: false),

        Bind.lazySingleton((i) => MessageListUseCase(i()), export: false),
        Bind.lazySingleton((i) => MessageRepository(i()), export: false),
        Bind.lazySingleton<IMessageDataSource>((i) => FakeMessagesDataSource(), export: false),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(AppRoute.groupHome.pathAsChild, child: (context, args) => const GroupHomePage()),
        ChildRoute(AppRoute.groupCreate.pathAsChild, child: (context, args) => const GroupCreatePage()),
        ChildRoute(AppRoute.groupList.pathAsChild, child: (context, args) => const GroupListPage()),
        ChildRoute(AppRoute.groupMessages.pathAsChild,
            child: (context, args) => GroupMessagesPage(
                  groupId: args.params["id"],
                )),
        ChildRoute(AppRoute.groupDetail.pathAsChild,
            child: (context, args) => GroupDetailCirclePage(
                  groupId: args.params["id"],
                )),
        ChildRoute(AppRoute.groupEdit.pathAsChild,
            child: (context, args) => GroupEditPage(
                  groupId: args.params["id"],
                )),
      ];
}
