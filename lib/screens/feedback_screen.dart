import 'package:flutter/material.dart';

import '../services/database_helper.dart';
import '../services/session_manager.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() =>
      _FeedbackScreenState();
}

class _FeedbackScreenState
    extends State<FeedbackScreen> {

  final DatabaseHelper db =
      DatabaseHelper();

  final TextEditingController
      commentController =
      TextEditingController();

  double rating = 5;

  List<Map<String, dynamic>> savedComments = [];

  final List<Map<String, dynamic>> comments = [

    {
      "name": "Rizky",
      "rating": 5,
      "comment":
          "Top up cepat dan tampilannya keren banget 🔥"
    },

    {
      "name": "Andi",
      "rating": 5,
      "comment":
          "Diamond langsung masuk, mantap 👍"
    },

    {
      "name": "Siti",
      "rating": 4,
      "comment":
          "Quiz nya seru, jadi bisa dapet coin gratis 😍"
    },

    {
      "name": "Budi",
      "rating": 5,
      "comment":
          "Lebih murah dari kantin kampus 😆"
    },

    {
      "name": "Fajar",
      "rating": 5,
      "comment":
          "Login biometrik keren banget."
    },

    {
      "name": "Doni",
      "rating": 4,
      "comment":
          "Awalnya cuma coba-coba, sekarang jadi langganan 😂"
    },

    {
      "name": "Yanto",
      "rating": 5,
      "comment":
          "Dompet menangis tapi rank naik 😭🤣"
    },

    {
      "name": "Player Mythic",
      "rating": 5,
      "comment":
          "Diamond habis, semangat push rank juga habis."
    },
  ];

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {

    final result =
        await db.getFeedbacks();

    setState(() {
      savedComments = result;
    });
  }

  Future<void> addComment() async {

    if (commentController.text.trim().isEmpty) {
      return;
    }

    String name =
        await SessionManager.getName()
            ?? "User";

    String nim =
        await SessionManager.getNim()
            ?? "-";

    await db.saveFeedback(
      name: name,
      nim: nim,
      rating: rating.toInt(),
      comment:
          commentController.text.trim(),
    );

    commentController.clear();

    await loadComments();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Komentar berhasil ditambahkan",
        ),
      ),
    );
  }

  Widget buildStars(int total) {

    return Row(
      children: List.generate(
        total,
        (index) => const Icon(
          Icons.star,
          color: Colors.amber,
          size: 18,
        ),
      ),
    );
  }

  Widget buildCommentCard(
      Map<String, dynamic> item) {

    return Card(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            item["name"]
                .toString()[0]
                .toUpperCase(),
          ),
        ),

        title: Text(
          item["name"],
        ),

        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            if (item.containsKey("nim"))
              Text(
                "NIM : ${item["nim"]}",
              ),

            buildStars(
              item["rating"],
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              item["comment"],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Komentar & Masukan",
        ),
      ),

      body: Column(
        children: [

          Container(
            padding:
                const EdgeInsets.all(
              15,
            ),

            child: Column(
              children: [

                const Text(
                  "Berikan Rating",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Slider(
                  value: rating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label:
                      rating.toString(),

                  onChanged: (value) {

                    setState(() {
                      rating = value;
                    });
                  },
                ),

                TextField(
                  controller:
                      commentController,

                  maxLines: 3,

                  decoration:
                      const InputDecoration(
                    hintText:
                        "Tulis komentar...",
                    border:
                        OutlineInputBorder(),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                SizedBox(
                  width:
                      double.infinity,

                  child:
                      ElevatedButton(
                    onPressed:
                        addComment,

                    child:
                        const Text(
                      "KIRIM KOMENTAR",
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          const Padding(
            padding:
                EdgeInsets.all(10),

            child: Text(
              "Komentar Pengguna",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: ListView(
              children: [

                // Komentar Dummy
                ...comments.map(
                  (item) =>
                      buildCommentCard(
                    item,
                  ),
                ),

                // Komentar User
                ...savedComments.map(
                  (item) =>
                      buildCommentCard(
                    item,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}