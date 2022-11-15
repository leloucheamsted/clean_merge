import "package:collection/collection.dart" show groupBy;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tello_social_app/modules/contact/domain/usecases/create_contact.usecase.dart';
import 'package:tello_social_app/modules/contact/domain/usecases/reset_contacts_repo.usecase.dart';
import 'package:tello_social_app/modules/core/presentation/action_state.dart';
import 'package:tello_social_app/modules/core/presentation/list/grouped_grid_widget.dart';
import 'package:tello_social_app/modules/core/services/dialog_service.dart';

import '../../../common/widget/search_app_bar.dart';
import '../../domain/entities/contact.entity.dart';
import '../../domain/usecases/fetch_contacts.usecase.dart';
import '../../domain/usecases/reset_contacts_localdb.usecase.dart';

typedef GrouppedContactList = Map<GroupGridHeader, List<ContactEntity>>;

class ContactListBloc {
  // late final _streamBinder = EitherStreamBinder<GrouppedContactList>();

  // late final ResetContactsLocalDbUseCase resetContactsLocalDbUseCase = Modular.get();
  late final ResetContactsRepoUseCase resetContactsRepoUseCase = Modular.get();

  late final CreateContactUseCase createUseCase = Modular.get();
  late final FetchContactsUseCase fetchUseCase = Modular.get();
  late final SearchAppBarBloc<GrouppedContactList> _searchAppBarBloc =
      SearchAppBarBloc<GrouppedContactList>(_onSearchChanged);

  SearchAppBarBloc get searchAppBarBloc => _searchAppBarBloc;
  // Stream<ActionState<GrouppedContactList>> get outStream => _searchAppBarBloc.state;

  Stream<ActionState<GrouppedContactList>> get outStream => Rx.combineLatest2<
          ActionState<GrouppedContactList>,
          List<String>?,
          ActionState<GrouppedContactList>>(
        _searchAppBarBloc.state,
        _memberPhonesStream,
        (a, b) {
          if (a.data == null || b == null) {
            return a;
          }
          a.data!.forEach((key, value) {
            value.forEach((element) {
              element.isMember = b.contains(element.phoneNumber);
            });
          });
          return a;
        },
      );

  List<String>? _members;

  Stream<List<String>> _memberPhonesStream =
      Stream.fromFuture(Future.value([]));
  void setMembersPhonesSream(Stream<List<String>>? memberPhonesStream) {
    if (memberPhonesStream != null) {
      _memberPhonesStream = memberPhonesStream;
    }
  }

  void setMembers(List<String>? members) {
    _members = members;
  }

  Future reload() {
    return _loadData();
  }

  Future<GrouppedContactList> _loadData({String? keyword}) async {
    final response =
        await fetchUseCase.call(ContactFilterInput(keyword: keyword));

    if (response.isLeft()) {
      final failure =
          response.fold((f) => f, (r) => throw UnimplementedError());
      throw failure;
      // return ActionState.error(failure);
    } else {
      final list = response.getOrElse(() => throw "Unex");
      return list.isEmpty ? {} : _mapToGrouppedList(list);
    }
  }

  void _mapIsMember(ContactEntity entity) {
    final bool st =
        _members == null ? false : _members!.contains(entity.phoneNumber);
    entity.isMember = st;
  }

  GrouppedContactList _mapToGrouppedList(List<ContactEntity> list) {
    // list.forEach(_mapIsMember);
    print("_mapToGrouppedList");
    return groupBy(
        list,
        (el) => el.isTelloMember == true
            ? GroupGridHeader(sortIndex: 0, title: "Tello Member")
            : GroupGridHeader(sortIndex: 1, title: "No Tello Member"));
    // : GroupGridHeader(sortIndex: el.displayName.codeUnitAt(0), title: el.displayName[0]));
  }

  void dispose() {
    _searchAppBarBloc.dispose();
    // _streamBinder.dispose();
  }

  void doSearch(String str) {
    _searchAppBarBloc.doSearch(str);
  }

  Future<GrouppedContactList> _onSearchChanged(String value) =>
      _loadData(keyword: value);

  void actionAddContact() async {
    // final String? name = await DialogService.showTextInputDialog(title: "Enter group name", hint: "group name");
    final responseEither = await createUseCase.call(null);

    responseEither.fold(
        (l) => DialogService.simpleAlert(
            title: "FailedToCreateContact", body: l.toString()),
        (r) => DialogService.showToast(msg: "Contact Created"));
  }

  Future<void> actionUpload() async {
    // await resetContactsLocalDbUseCase.call(null);
    reload();
  }

  Future<void> actionResetDb() async {
    await resetContactsRepoUseCase.call(null);
    await DialogService.showToast(
        msg: "Contacts Local Db removed. Need to restart app");
    // Restart.restartApp();
  }
}
