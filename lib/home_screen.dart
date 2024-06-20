import 'dart:developer';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController messageController = TextEditingController();
  stt.SpeechToText speech = stt.SpeechToText();
  bool isTakingAudioInput = false;
  bool servicesAreEnabled = false;
  bool forceStopped = false;

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: '907e77c79df54774bf6dff976356ddb5',
      channelName: 'test',
      tempToken:
          '007eJxTYDj7QUFF+6jgzc3hFzb9nptxxIj33PS5f9Z/m/ur/9meeOubCgyWBuap5ubJ5pYpaaYm5uYmSWlmKWlpluZmxqZmKSlJpjwNJWkNgYwMNb7sLIwMEAjiszCUpBaXMDAAAE46Ihs=',
    ),
  );

  @override
  void initState() {
    super.initState();

    initAgora();
    startSTTServices();
  }

  void startSTTServices() async {
    servicesAreEnabled = await speech.initialize(
      onStatus: (status) {
        log('status: $status');
        if (status == 'done' && !forceStopped) {
          startCaptureAudio();
        }
      },
      onError: (errorNotification) {
        log('onError: $errorNotification');
      },
    );
  }

  void initAgora() async {
    await client.initialize();
  }

  void startCaptureAudio() async {
    if (servicesAreEnabled) {
      setState(() => isTakingAudioInput = true);

      speech.listen(
        onResult: (result) {
          messageController.text = result.recognizedWords;
        },
        listenFor: const Duration(minutes: 10),
      );
    } else {
      log('The user has denied the use of speech recognition.');
    }
  }

  void stopCaptureAudio() async {
    forceStopped = true;
    speech.stop();
    forceStopped = false;
    setState(() => isTakingAudioInput = false);
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //

              SizedBox(
                height: screenSize.height * 0.5,
                child: Stack(
                  children: [
                    AgoraVideoViewer(client: client),
                    AgoraVideoButtons(client: client),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed:
                    isTakingAudioInput ? stopCaptureAudio : startCaptureAudio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  !isTakingAudioInput
                      ? 'Start Capturing Audio'
                      : 'Stop Capturing Audio',
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onTapOutside: (event) => FocusScope.of(context).unfocus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
