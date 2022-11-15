import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';

class ContactListItem extends StatelessWidget {
  final ContactEntity entity;
  const ContactListItem({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: ListTile(
        leading: ImgLogoWidget(
          imgSrc: entity.avatar,
          borderColor: Colors.green,
          borderWidth: 4,
        ),
        title: Text(entity.phoneNumber),
        subtitle: Text(entity.displayName ?? "noName"),
        trailing: _buildTrailing(entity),
      ),
    );
  }

  Widget _buildTrailing(ContactEntity entity) {
    if (entity.isTelloMember == true) return Icon(Icons.people);
    return SimpleButton(
      onTap: () => null,
      content: "Invite",
      width: 60,
    );
  }
}
