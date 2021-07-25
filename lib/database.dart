import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getGroupByGroupname(String groupname, String username) async {
    return await Firestore.instance
        .collection("users")
        .document(username)
        .collection("Grps")
        .where("chatroomID", isEqualTo: groupname)
        .getDocuments();
  }

  getUserByUserEmail(String useremail) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: useremail)
        .getDocuments();
  }

  getAllUsers() async {
    return await Firestore.instance.collection("users").getDocuments();
  }

  getAllGroups() async {
    return await Firestore.instance.collection("GroupChat").getDocuments();
  }

  uploadUserInfo(userMap, String username) {
    Firestore.instance
        .collection("users")
        .document(username)
        .setData(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatroomID, messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatroomID)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addNotifications(String username, String chatRoomId, messageMap) {
    Firestore.instance
        .collection("users")
        .document(username)
        .collection("Notifications")
        .document(chatRoomId)
        .setData(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessagestoGroupChat(String chatroomID, messageMap) {
    Firestore.instance
        .collection("GroupChat")
        .document(chatroomID)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addUsertoGroup(String chatroomID, usermap, String username) {
    Firestore.instance
        .collection("GroupChat")
        .document(chatroomID)
        .collection("users")
        .document(username)
        .setData(usermap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addGroupToUser(String chatroomID, groupmap, String username) {
    Firestore.instance
        .collection("users")
        .document(username)
        .collection("Grps")
        .document(chatroomID)
        .setData(groupmap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatroomID) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .document(chatroomID)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getConversationMessagesfromGroup(String chatroomID) async {
    return await Firestore.instance
        .collection("GroupChat")
        .document(chatroomID)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  createChatRoom(String chatroomID, chatroomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatroomID)
        .setData(chatroomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChatRooms(String username) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }

  getAllUsersSnapshot() async {
    return await Firestore.instance.collection("users").snapshots();
  }

  getAllGroupsSnapshot() async {
    return await Firestore.instance.collection("GroupChat").snapshots();
  }

  getGroupChatRooms(String username) async {
    return await Firestore.instance
        .collection("GroupChat")
        .document("groupname")
        .collection("users")
        .where("name", isEqualTo: username)
        .snapshots();
  }

  usersPresentInGroup(String groupname) async {
    return await Firestore.instance
        .collection("GroupChat")
        .document(groupname)
        .collection("users")
        .getDocuments();
  }

  usersPresentInGroupSnpshots(String groupname) async {
    return await Firestore.instance
        .collection("GroupChat")
        .document(groupname)
        .collection("users")
        .snapshots();
  }

  notificationsSnapshot(String username) async {
    return await Firestore.instance
        .collection("users")
        .document(username)
        .collection("Notifications")
        .snapshots();
  }

  alertSnapshot(String username) async {
    return await Firestore.instance
        .collection("users")
        .document(username)
        .collection("Alerts")
        .snapshots();
  }

  groupsPresentForUser(String username) async {
    return await Firestore.instance
        .collection("users")
        .document(username)
        .collection("Grps")
        .snapshots();
  }

  createGroupChatRoom(String chatroomID, chatroomMap) {
    Firestore.instance
        .collection("GroupChat")
        .document(chatroomID)
        .setData(chatroomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  deletethegroup(String chatroomID) {
    Firestore.instance.collection("GroupChat").document(chatroomID).delete();
  }

  makehimAdmin(String chatroomID, String username) async {
    await Firestore.instance
        .collection("GroupChat")
        .document(chatroomID)
        .collection("users")
        .document(username)
        .updateData({"admin": true});
  }

  deleteUser(String chatroomID, String username) async {
    await Firestore.instance
        .collection("GroupChat")
        .document(chatroomID)
        .collection("users")
        .document(username)
        .delete();
  }

  deleteGroupFromUser(String chatroomID, String username) async {
    await Firestore.instance
        .collection("users")
        .document(username)
        .collection("Grps")
        .document(chatroomID)
        .delete();
  }

  deleteNotification(String chatroomID, String username) async {
    await Firestore.instance
        .collection("users")
        .document(username)
        .collection("Notifications")
        .document(chatroomID)
        .delete();
  }

  deleteAlert(String chatroomID, String username) async {
    await Firestore.instance
        .collection("users")
        .document(username)
        .collection("Alerts")
        .document(chatroomID)
        .delete();
  }

  addAlerts(String username, String sendinguser, messageMap) {
    Firestore.instance
        .collection("users")
        .document(username)
        .collection("Alerts")
        .document(sendinguser)
        .setData(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
