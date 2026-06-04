import 'package:flutter/material.dart';
// Menggunakan package resmi Google Gemini v0.5.0 yang mendukung Gemini 2.5
import 'package:google_generative_ai/google_generative_ai.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  bool isLoading = false;

  // API KEY GEMINI BARU
  final String apiKey = "AIzaSyA_eTlpy-vct0HgHRvN2IaFbELTaxaoim8";
  
  // Inisialisasi model dan session dari Google Generative AI SDK
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  @override
  void initState() {
    super.initState();
    // Inisialisasi model Gemini 2.5 Flash
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        "Kamu adalah AI khusus Mobile Legends Bang Bang (MLBB). "
        "Jawab hanya tentang MLBB seperti hero, build item, emblem, meta, gameplay, rank, draft pick, dan turnamen. "
        "Jika ada yang bertanya di luar MLBB, tolak dengan sopan dan ingatkan mereka bahwa kamu adalah asisten MLBB."
      ),
    );

    // Membuka session chat kosong
    _chatSession = _model.startChat();
  }

  // =========================
  // SEND MESSAGE (FIXED FOR v0.5.0)
  // =========================
 Future<void> sendMessage(String text) async {
  if (text.trim().isEmpty) return;

  if (!mounted) return;

  setState(() {
    messages.add({
      "role": "user",
      "text": text,
    });
    isLoading = true;
  });

  _controller.clear();

  try {

    final response =
        await _chatSession.sendMessage(
      Content.text(text),
    );

    if (!mounted) return;

    setState(() {
      messages.add({
        "role": "ai",
        "text":
            response.text ??
            "AI sedang tidak merespon.",
      });
    });

  } catch (e) {

    if (!mounted) return;

    setState(() {
      messages.add({
        "role": "ai",
        "text":
            "Terjadi error koneksi.\n\nDetail: $e",
      });
    });

  } finally {

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }
}

  // =========================
  // CHAT BUBBLE
  // =========================
  Widget buildMessage(Map<String, dynamic> msg) {
    bool isUser = msg["role"] == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
                  colors: [
                    Color(0xFF102A43),
                    Color(0xFF243B53),
                  ],
                )
              : const LinearGradient(
                  colors: [
                    Colors.white,
                    Color(0xFFF7F9FC),
                  ],
                ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Text(
          msg["text"],
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            height: 1.4,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // =========================
  // HERO QUICK BUTTON
  // =========================
  Widget heroSuggestion(String hero) {
    return GestureDetector(
      onTap: () {
        sendMessage("Build terbaik hero $hero");
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF102A43),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            hero,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // UI MAIN BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          "MLBB AI Assistant",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF102A43),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // HERO LIST (SUGGESTIONS)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                heroSuggestion("Hayabusa"),
                heroSuggestion("Fanny"),
                heroSuggestion("Granger"),
                heroSuggestion("Julian"),
                heroSuggestion("Ling"),
                heroSuggestion("Moskov"),
                heroSuggestion("Beatrix"),
              ],
            ),
          ),

          // CHAT MESSAGES LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),

          // LOADING INDICATOR
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF102A43)),
              ),
            ),

          // INPUT FIELD
          Container(
            padding: const EdgeInsets.all(14),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Tanya AI tentang MLBB...",
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (value) {
                      sendMessage(value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF102A43),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}