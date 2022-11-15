import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widget/scroll_top_widget.dart';
import 'package:tello_social_app/modules/common/widget/search_app_bar.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/presentation/bloc/contact_list.bloc.dart';
import 'package:tello_social_app/modules/contact/presentation/ui/contact_grid_item.dart';
import 'package:tello_social_app/modules/core/presentation/list/grouped_grid_widget.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';

class ContactListPageParams {
  final Function(ContactEntity contactEntity) onSelectContact;
  // final List<String> members;
  final Stream<List<String>> membersPhoneStream;
  ContactListPageParams({
    required this.onSelectContact,
    required this.membersPhoneStream,
  });
}

class ContactListPage extends StatefulWidget {
  // final Function(ContactEntity contactEntity)? onSelectContact;
  const ContactListPage({
    Key? key,
    // this.onSelectContact,
  }) : super(key: key);

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final _scrollCtrl = ScrollController(keepScrollOffset: false);

  late final ContactListBloc bloc = Modular.get();

  // Function(ContactEntity contactEntity)? onSelectContact;
  ContactListPageParams? pageParams;
  @override
  void initState() {
    pageParams = Modular.args.data == null ? null : Modular.args.data as ContactListPageParams;
    bloc.setMembersPhonesSream(pageParams?.membersPhoneStream);
    // bloc.setMembers(pageParams?.members);
    WidgetsBinding.instance.addPostFrameCallback((_) => bloc.doSearch(""));
    super.initState();
  }

  @override
  void reassemble() {
    // bloc.setMembersPhonesSream(pageParams?.membersPhoneStream);
    Future.delayed(const Duration(milliseconds: 500), () => bloc.searchAppBarBloc.doSearch(""));

    super.reassemble();
  }

  @override
  void dispose() {
    bloc.dispose();
    _scrollCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: build2(context),
      // floatingActionButton: _buildAddContact(),
    );
  }

  Widget _buildAddContact() {
    return FloatingActionButton(onPressed: bloc.actionAddContact, child: const Icon(Icons.add));
  }

  Widget build2(BuildContext context) {
    return Listener(
        onPointerDown: (_) => doUnfocus(), // onTapDown
        onPointerUp: (_) => doUnfocus(),
        child: _buildWithSearchAppBar(context));
  }

  void doUnfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Widget _buildWithSearchAppBar(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SearchAppBar(
              // onChanged: onSearchChanged,
              bloc: bloc.searchAppBarBloc,
              actions: [
                IconButton(
                  onPressed: bloc.actionResetDb,
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: bloc.actionUpload,
                  icon: Icon(Icons.replay_outlined),
                ),
              ],
              // searchDelay: const Duration(microseconds: 500),
            ),
            Expanded(child: _buildItems(context)),
          ],
        ),
        // Positioned(bottom: 0, right: 0, child: ScrollTopWidget(scrollController: _scrollCtrl)),
      ],
    );
  }

  Widget _buildItems(BuildContext context) {
    return Scrollbar(controller: _scrollCtrl, child: _buildItems2(context));
    return Stack(
      // alignment: Alignment.bottomRight,
      children: [
        Scrollbar(controller: _scrollCtrl, child: _buildItems2(context)),
        Positioned(bottom: 0, right: 0, child: ScrollTopWidget(scrollController: _scrollCtrl)),
      ],
    );
  }

  Widget _buildItems2(BuildContext context) {
    // return StreamBuilder_all<ActionState<List<ContactEntity>>>(
    return StreamBuilder_all<ActionState<GrouppedContactList>>(
      // stream: streamBinder.outStream,
      stream: bloc.outStream,
      onInitial: (context) => const SizedBox(),
      onSuccess: (_, data) {
        if (data == null || data.data == null) {
          return const NoItemsWidget(); //TODO: empty items common widget
        }

        final GrouppedContactList mapList = data.data!;

        if (mapList.isEmpty) {
          return const Center(child: Text("no contacts"));
        }
        // return ContactListWidget(items: data.data!);
        // final List<ContactEntity> items = data.data!;
        //TODO: make group in the bloc not widget build _ALL

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: GroupedGridWidget<GroupGridHeader, ContactEntity>(
            groupedItems: mapList,
            scrollController: _scrollCtrl,
            headerSorter: (a, b) => a.sortIndex.compareTo(b.sortIndex),
            headerBuilder: ((context, header) => Container(
                  padding: const EdgeInsets.all(LayoutConstants.paddingS),
                  color: Colors.white10,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(header.title),
                )),
            itemBuilder: _buildItem,
            crossAxisCount: 3,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 0.6,
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, ContactEntity item) {
    //TODO: seperate for callee by add member and seperate contacts list route
    return ContactGridItem(entity: item, onAction: () => _onItemAction(item));
    return GestureDetector(
      onTap: () => _onSelected(item),
      child: ContactGridItem(entity: item, onAction: () => _onItemAction(item)),
      // child: ContactListItem(entity: item),
    );
  }

  void _onItemAction(ContactEntity item) {
    if (pageParams != null) {
      pageParams!.onSelectContact(item);
    }
    // onSelectContact?.call(item);
  }

  void _onSelected(ContactEntity item) {
    Modular.to.pop(item);
  }
}
