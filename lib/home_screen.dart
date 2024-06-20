import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
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

  bool audioMuted = true;
  bool videoMuted = true;
  bool screenShareOn = false;
  List<String> participants = [];
  final _jitsiMeetPlugin = JitsiMeet();

  @override
  void initState() {
    super.initState();

    startSTTServices();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void startSTTServices() async {
    servicesAreEnabled = await speech.initialize(
      onStatus: (status) {
        log('status: $status');
      },
      onError: (errorNotification) {
        log('onError: $errorNotification');
      },
    );
  }

  Future<void> join() async {
    var options = JitsiMeetConferenceOptions(
      room: 'ClinicalHallsPassAround',
      configOverrides: {
        'startWithAudioMuted': true,
        'startWithVideoMuted': true,
      },
      featureFlags: {
        FeatureFlags.addPeopleEnabled: true,
        FeatureFlags.welcomePageEnabled: true,
        FeatureFlags.preJoinPageEnabled: true,
        FeatureFlags.unsafeRoomWarningEnabled: true,
        FeatureFlags.resolution: FeatureFlagVideoResolutions.resolution720p,
        FeatureFlags.audioFocusDisabled: true,
        FeatureFlags.audioMuteButtonEnabled: true,
        FeatureFlags.audioOnlyButtonEnabled: true,
        FeatureFlags.calenderEnabled: true,
        FeatureFlags.callIntegrationEnabled: true,
        FeatureFlags.carModeEnabled: true,
        FeatureFlags.closeCaptionsEnabled: true,
        FeatureFlags.conferenceTimerEnabled: true,
        FeatureFlags.chatEnabled: true,
        FeatureFlags.filmstripEnabled: true,
        FeatureFlags.fullScreenEnabled: true,
        FeatureFlags.helpButtonEnabled: true,
        FeatureFlags.inviteEnabled: true,
        FeatureFlags.androidScreenSharingEnabled: true,
        FeatureFlags.speakerStatsEnabled: true,
        FeatureFlags.kickOutEnabled: true,
        FeatureFlags.liveStreamingEnabled: true,
        FeatureFlags.lobbyModeEnabled: true,
        FeatureFlags.meetingNameEnabled: true,
        FeatureFlags.meetingPasswordEnabled: true,
        FeatureFlags.notificationEnabled: true,
        FeatureFlags.overflowMenuEnabled: true,
        FeatureFlags.pipEnabled: true,
        FeatureFlags.pipWhileScreenSharingEnabled: true,
        FeatureFlags.preJoinPageHideDisplayName: true,
        FeatureFlags.raiseHandEnabled: true,
        FeatureFlags.reactionsEnabled: true,
        FeatureFlags.recordingEnabled: true,
        FeatureFlags.replaceParticipant: true,
        FeatureFlags.securityOptionEnabled: true,
        FeatureFlags.serverUrlChangeEnabled: true,
        FeatureFlags.settingsEnabled: true,
        FeatureFlags.tileViewEnabled: true,
        FeatureFlags.videoMuteEnabled: true,
        FeatureFlags.videoShareEnabled: true,
        FeatureFlags.toolboxEnabled: true,
        FeatureFlags.iosRecordingEnabled: true,
        FeatureFlags.iosScreenSharingEnabled: true,
        FeatureFlags.toolboxAlwaysVisible: true,
      },
      userInfo: JitsiMeetUserInfo(
        displayName: 'Fresh-Start Company',
        email: 'fresh-start-dev@gmail.com',
        avatar:
            'https://media.licdn.com/dms/image/D4D03AQEGmEfbRTuvNQ/profile-displayphoto-shrink_800_800/0/1712652884077?e=1720051200&v=beta&t=EJ_g-czNv7V_E2h9KxkDxFXbh0LsYGZaemqdi7TMEWE',
      ),
    );

    var listener = JitsiMeetEventListener(
      conferenceJoined: (url) {
        debugPrint('conferenceJoined: url: $url');
      },
      conferenceTerminated: (url, error) {
        debugPrint('conferenceTerminated: url: $url, error: $error');
      },
      conferenceWillJoin: (url) {
        debugPrint('conferenceWillJoin: url: $url');
      },
      participantJoined: (email, name, role, participantId) {
        debugPrint(
          'participantJoined: email: $email, name: $name, role: $role, '
          'participantId: $participantId',
        );
        participants.add(participantId!);
      },
      participantLeft: (participantId) {
        debugPrint('participantLeft: participantId: $participantId');
      },
      audioMutedChanged: (muted) {
        debugPrint('audioMutedChanged: isMuted: $muted');
      },
      videoMutedChanged: (muted) {
        debugPrint('videoMutedChanged: isMuted: $muted');
      },
      endpointTextMessageReceived: (senderId, message) {
        debugPrint(
          'endpointTextMessageReceived: senderId: $senderId, message: $message',
        );
      },
      screenShareToggled: (participantId, sharing) {
        debugPrint(
          'screenShareToggled: participantId: $participantId, '
          'isSharing: $sharing',
        );
      },
      chatMessageReceived: (senderId, message, isPrivate, timestamp) {
        debugPrint(
          'chatMessageReceived: senderId: $senderId, message: $message, '
          'isPrivate: $isPrivate, timestamp: $timestamp',
        );
      },
      chatToggled: (isOpen) => debugPrint('chatToggled: isOpen: $isOpen'),
      participantsInfoRetrieved: (participantsInfo) {
        debugPrint(
          'participantsInfoRetrieved: participantsInfo: $participantsInfo, ',
        );
      },
      readyToClose: () {
        debugPrint('readyToClose');
      },
    );
    await _jitsiMeetPlugin.join(options, listener);
  }

  hangUp() async {
    await _jitsiMeetPlugin.hangUp();
  }

  setAudioMuted(bool? muted) async {
    var a = await _jitsiMeetPlugin.setAudioMuted(muted!);
    debugPrint('$a');
    setState(() {
      audioMuted = muted;
    });
  }

  setVideoMuted(bool? muted) async {
    var a = await _jitsiMeetPlugin.setVideoMuted(muted!);
    debugPrint('$a');
    setState(() {
      videoMuted = muted;
    });
  }

  sendEndpointTextMessage() async {
    var a = await _jitsiMeetPlugin.sendEndpointTextMessage(message: 'HEY');
    debugPrint('$a');

    for (var p in participants) {
      var b =
          await _jitsiMeetPlugin.sendEndpointTextMessage(to: p, message: 'HEY');
      debugPrint('$b');
    }
  }

  toggleScreenShare(bool? enabled) async {
    await _jitsiMeetPlugin.toggleScreenShare(enabled!);

    setState(() {
      screenShareOn = enabled;
    });
  }

  openChat() async {
    await _jitsiMeetPlugin.openChat();
  }

  sendChatMessage() async {
    var a = await _jitsiMeetPlugin.sendChatMessage(message: 'HEY1');
    debugPrint('$a');

    for (var p in participants) {
      a = await _jitsiMeetPlugin.sendChatMessage(to: p, message: 'HEY2');
      debugPrint('$a');
    }
  }

  closeChat() async {
    await _jitsiMeetPlugin.closeChat();
  }

  retrieveParticipantsInfo() async {
    var a = await _jitsiMeetPlugin.retrieveParticipantsInfo();
    debugPrint('$a');
  }

  void startCaptureAudio() async {
    //* If not taking audio input

    if (servicesAreEnabled) {
      setState(() => isTakingAudioInput = true);

      speech.listen(
        onResult: (result) {
          messageController.text = result.recognizedWords;
        },
      );
    } else {
      log('The user has denied the use of speech recognition.');
    }
  }

  void stopCaptureAudio() async {
    speech.stop();
    setState(() => isTakingAudioInput = false);
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
                onPressed: join,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Join'),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: hangUp,
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

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Set Audio Muted'),
                  Checkbox(
                    value: audioMuted,
                    onChanged: setAudioMuted,
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Set Video Muted'),
                  Checkbox(
                    value: videoMuted,
                    onChanged: setVideoMuted,
                  ),
                ],
              ),

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
