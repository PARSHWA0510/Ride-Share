import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'dart:html';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/views/chat_user_card.dart';

import '../Screen/userdetails.dart';
import '../TabPages/acc_tab.dart';
import '../api/apis.dart';
import '../models/chat_user.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);


  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {

   @override
   void initState(){
     super.initState();
     APIs.getSelfInfo();
   }
   List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        title: Text('Chats'),
        centerTitle: true,
        leading: Icon(CupertinoIcons.home),
        actions: [
          //search user button
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
          //more features button
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> UserDetailsScreen()));
            },
              icon: const Icon(Icons.more_vert)),
        ],
      ),

      //Floating point button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20),
        child: FloatingActionButton(onPressed: (){}, child: (Icon(Icons.add_comment_rounded)),),
      ),

      body : StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        //stream: APIs.getAllUsers(),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              // final data = snapshot.data?.document;
              // list = data
              //     ?.map((e) => ChatUser.fromJson(e.data()))
              //     .toList() ??
              //     [];
              // for(var i in data!){
              //   log('\n Data : ${jsonEncode(i.data())}');
              //   list.add(i.data()['name']);
              // }

          if(list.isNotEmpty){
            return ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index)
                {
                  return  ChatUserCard(user: list[index]);
                  // return Text('Name : ${list[index]}');
                });
          }
          else{
            return const Center(child: Text('No connections Found ', style: TextStyle(fontSize: 20),));
          }
          }
        }
      ),
    );
  }
}
