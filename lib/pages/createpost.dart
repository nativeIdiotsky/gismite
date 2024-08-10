import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePost extends StatelessWidget {
  const CreatePost({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Post',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
        ),
        body: const BodyForm(),
      ),
    );
  }
}

class BodyForm extends StatefulWidget {
  const BodyForm({super.key});

  @override
  _BodyFormState createState() => _BodyFormState();
}

class _BodyFormState extends State<BodyForm> {
  File? _image;
  final TextEditingController _controller = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: _image == null
              ? const Text('No image selected.')
              : Image.file(_image!, height: 200),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Take Photo'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Choose from Gallery'),
              ),
            ],
          ),
        ),
        const Center(
          child: Text('GPS MAP'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 50.0, // minimum height
              maxHeight: 200.0, // maximum height
            ),
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // no limit on number of lines
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type something here...',
                  ),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(2),
                child:
                    ElevatedButton(onPressed: () => (), child: Text('Submit')),
              ),
              Padding(
                padding: EdgeInsets.all(2),
                child:
                    ElevatedButton(onPressed: () => (), child: Text('Cancel')),
              )
            ],
          ),
        ),
      ],
    );
  }
}
