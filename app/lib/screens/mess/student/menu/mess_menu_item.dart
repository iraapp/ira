import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:ira/screens/mess/student/menu/edit_delete_mess_item_modal_sheet.dart';
import 'package:ira/screens/mess/student/models/mess_menu_model.dart';

// ignore: must_be_immutable
class MessMenuItem extends StatelessWidget {
  String mediaUrl = FlavorConfig.instance.variables['mediaUrl'];
  MessMenuItemModel menuItem;
  final bool editable;
  final VoidCallback updateView;

  MessMenuItem({
    Key? key,
    required this.menuItem,
    required this.editable,
    required this.updateView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (editable) {
            showModalBottomSheet(
              context: context,
              builder: (context) => EditDeleteMessItemModalSheet(
                successCallback: updateView,
                menuItem: menuItem,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          menuItem.name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          menuItem.veg
                              ? 'assets/icons/veg.png'
                              : 'assets/icons/nonveg.png',
                          height: 15,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      menuItem.description,
                      textAlign: TextAlign.left,
                      softWrap: false,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Image(
                width: 90,
                height: 90,
                image: CachedNetworkImageProvider(
                  mediaUrl + menuItem.imageUrl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
