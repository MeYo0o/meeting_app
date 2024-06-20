import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:meeting_app/helper_methods/helper_methods.dart';
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

  // bool audioMuted = true;
  // bool videoMuted = true;
  // bool screenShareOn = false;
  List<String> participants = [];
  final _jitsiMeetPlugin = JitsiMeet();

  @override
  void initState() {
    super.initState();

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

  void startCaptureAudio() async {
    //* If not taking audio input

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
              ElevatedButton(
                onPressed: () => HelperMethods.join(
                  jitsiMeetPlugin: _jitsiMeetPlugin,
                  participants: participants,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Join'),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () =>
                    HelperMethods.hangUp(jitsiMeetPlugin: _jitsiMeetPlugin),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Hang Up'),
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

              // const SizedBox(height: 20),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text('Set Audio Muted'),
              //     Checkbox(
              //       value: audioMuted,
              //       onChanged: setAudioMuted,
              //     ),
              //   ],
              // ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text('Set Video Muted'),
              //     Checkbox(
              //       value: videoMuted,
              //       onChanged: setVideoMuted,
              //     ),
              //   ],
              // ),

              // TextButton(
              //   onPressed: sendEndpointTextMessage,
              //   child: const Text('Send Hey Endpoint Message To All'),
              // ),
              // Row(
              //   children: [
              //     const Text('Toggle Screen Share'),
              //     Checkbox(
              //       value: screenShareOn,
              //       onChanged: toggleScreenShare,
              //     ),
              //   ],
              // ),
              // TextButton(onPressed: openChat, child: const Text('Open Chat')),
              // TextButton(
              //   onPressed: sendChatMessage,
              //   child: const Text('Send Chat Message to All'),
              // ),
              // TextButton(onPressed: closeChat, child: const Text('Close Chat')),
              // TextButton(
              //   onPressed: retrieveParticipantsInfo,
              //   child: const Text('Retrieve Participants Info'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
