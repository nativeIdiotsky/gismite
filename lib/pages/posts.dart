import 'package:flutter/material.dart';

class Posts extends StatelessWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
        ),
        body: const PostsForm(),
      ),
    );
  }
}

class PostsForm extends StatelessWidget {
  const PostsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildPost(
            icon: Icons.face,
            name: 'King Frances L. Luna',
            date: 'August 11, 2024',
            description: 'Wow baha na kaayo diri samay ano guys'),
        buildPost(
            icon: Icons.face_2,
            name: 'Andy Abanto Jr.',
            date: 'August 11, 2024',
            description: 'Baha na jud kaayo'),
        buildPost(
            icon: Icons.face_3,
            name: 'Markjil Saytas',
            date: 'August 11, 2024',
            description:
                'Diri sad samay sapa guys nag saka na ang tubig, need najud nato mag bakwit')
      ],
    );
  }

  Widget buildPost(
      {required IconData icon,
      required String name,
      required String date,
      required String description}) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(name),
                ],
              ),
              const Spacer(),
              Text(date),
              const SizedBox(width: 5),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                description,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
