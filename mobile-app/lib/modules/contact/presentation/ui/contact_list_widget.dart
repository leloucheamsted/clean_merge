import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/presentation/ui/contact_list_item.dart';
import 'package:tello_social_app/modules/core/presentation/list/grid_widget.dart';
import 'package:tello_social_app/modules/core/presentation/list/list_widget.dart';

class ContactListWidget extends StatelessWidget {
  final List<ContactEntity> items;
  const ContactListWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridWidget(
      itemCount: items.length,
      itemBuilder: _itemBuilder,
      crossAxisCount: 3,
      mainAxisSpacing: 20,
      crossAxisSpacing: 4,
      childAspectRatio: 10 / 16,
    );
    // return ListWidget(itemCount: items.length, itemBuilder: _itemBuilder);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final ContactEntity item = items[index];

    return ContactListItem(entity: item);
  }
}
