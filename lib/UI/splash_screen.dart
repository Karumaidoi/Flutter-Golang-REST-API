import 'package:anime/API_SERVICE/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model_animal.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<List<Animal>> mydata;
  String name = '';
  String description = '';
  String image = '';

  String newName = '';
  String newDescription = '';
  String newImage = '';

  @override
  void initState() {
    mydata = getData();
    super.initState();
  }

  Future<List<Animal>> getData() async {
    var data = await Network.getData();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal'),
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: Column(
                          children: [
                            CupertinoTextField(
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                              placeholder: 'Enter Name',
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            CupertinoTextField(
                              onChanged: (val) {
                                setState(() {
                                  description = val;
                                });
                              },
                              placeholder: 'Description',
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            CupertinoTextField(
                              onChanged: (val) {
                                image = val;
                              },
                              placeholder: "Image",
                            )
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () async {
                                var response = await Network.createPost(
                                    name, description, image);
                                setState(() {
                                  mydata = getData();
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ok'))
                        ],
                      );
                    });
              },
              child: const Text('Post')),
        ],
      ),
      body: FutureBuilder<List<Animal>>(
          future: mydata,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              content: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CupertinoTextField(
                                    placeholder: "Name",
                                    onChanged: (val) {
                                      setState(() {
                                        newName = val;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CupertinoTextField(
                                    placeholder: "Description",
                                    onChanged: (val) {
                                      setState(() {
                                        newDescription = val;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CupertinoTextField(
                                    onChanged: (val) {
                                      newImage = val;
                                    },
                                    placeholder: "Image",
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () async {
                                      await Network.updatePost(
                                          snapshot.data![index].id,
                                          newName,
                                          newDescription,
                                          newImage);
                                      setState(() {
                                        mydata = getData();
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'))
                              ],
                            );
                          });
                    },
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data![index].image),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text(
                                      "Are you sure you want to delete?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Network.deletePost(
                                            snapshot.data![index].id);
                                        setState(() {
                                          mydata = getData();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Ok"),
                                    )
                                  ],
                                );
                              });
                        },
                        icon: const Icon(CupertinoIcons.trash)),
                    title: Text(snapshot.data![index].name),
                    subtitle: Column(
                      children: [
                        Text(snapshot.data![index].about),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          height: 260.0,
                          width: MediaQuery.of(context).size.width * 1.0,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image:
                                      NetworkImage(snapshot.data![index].image),
                                  fit: BoxFit.cover)),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String name;
  final String about;
  final String image;
  final String id;
  const PostWidget({
    Key? key,
    required this.name,
    required this.about,
    required this.image,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image),
      ),
      trailing: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("Are you sure you want to delete?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          var res = await Network.deletePost(id);
                          print(res.statusCode);
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok"),
                      )
                    ],
                  );
                });
          },
          icon: const Icon(CupertinoIcons.trash)),
      title: Text(name),
      subtitle: Column(
        children: [
          Text(about),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            height: 260.0,
            width: MediaQuery.of(context).size.width * 1.0,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
