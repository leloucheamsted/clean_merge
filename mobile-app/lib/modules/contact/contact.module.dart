import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/contact/domain/usecases/create_contact.usecase.dart';
import 'package:tello_social_app/modules/contact/domain/usecases/reset_contacts_localdb.usecase.dart';
import 'package:tello_social_app/modules/contact/domain/usecases/reset_contacts_repo.usecase.dart';
import 'package:tello_social_app/modules/contact/external/datasources/remote_contacts.datasource.dart';
import 'package:tello_social_app/modules/contact/external/datasources/sqflite_contacts_datasource.dart';
import 'package:tello_social_app/modules/contact/infra/contact_sync.service.dart';
import 'package:tello_social_app/modules/contact/presentation/bloc/contact_list.bloc.dart';
import 'external/datasources/fake_contacts_datasource.dart';
import 'external/datasources/flutter_contacts_datasource.dart';
import 'infra/datasources/i_phonebook.datasource.dart';
import 'infra/repositories/contact_repo.dart';
import 'presentation/pages/contact_list.page.dart';

import 'domain/usecases/fetch_contacts.usecase.dart';

class ContactModule extends Module {
  @override
  // List<Module> get imports => [CoreModule()];
  List<Module> get imports => [];

  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton(
            (i) => ContactSyncService(
                  phoneBookDataSource: i(),
                  localDataSource: i(),
                  remoteDataSource: i(),
                ),
            export: false),
        Bind.lazySingleton((i) => ResetContactsRepoUseCase(i()), export: false),
        Bind.lazySingleton((i) => CreateContactUseCase(i()), export: false),
        Bind.factory((i) => ContactListBloc(), export: false),

        /*
        Bind.lazySingleton((i) => FetchContactsUseCase(i()), export: false),
        Bind.lazySingleton((i) => ContactRepo(i(), i(), i()), export: false),
        Bind.lazySingleton((i) => RemoteContactsDataSource(i()), export: false),
        Bind.lazySingleton((i) => SqfliteContactsDataSource(), export: false),

        // Bind.lazySingleton<IPhoneBookDataSource>((i) => FakeContactsDataSource(i()), export: false),
        Bind.lazySingleton<IPhoneBookDataSource>((i) => FlutterContactsDataSource(), export: false),
        */
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const ContactListPage()),
      ];
}
