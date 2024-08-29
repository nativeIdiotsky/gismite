import 'package:flutter/material.dart';
import 'message.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  void removeMessage(Message message) {
    _messages.remove(message);
    notifyListeners();
  }
}
