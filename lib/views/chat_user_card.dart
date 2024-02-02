import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric( horizontal: 09, vertical: 05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //color: Colors.blue,
      elevation: 1,
      child: InkWell(
        onTap: (){},
        child:  ListTile(
          //user profile pic
          //leading: const CircleAvatar(child: Icon(CupertinoIcons.person),),
          leading:ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              height: 55,
              width: 55,
              imageUrl: widget.user.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
            ),
          ),

          //Username
          title: Text(widget.user.name),

          //last message
          subtitle: Text(widget.user.about , maxLines: 1,),

          //last message time
          trailing: Container(width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.lightGreenAccent.shade400,
                borderRadius: BorderRadius.circular(10)),
          ),
          // trailing: const Text(
          //   '12:00',
          //   style: TextStyle(color: Colors.black54),
          // ),
        ),
      ),
      );
  }
}
