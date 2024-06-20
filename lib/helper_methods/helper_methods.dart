import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class HelperMethods {
  static Future<void> join({
    required JitsiMeet jitsiMeetPlugin,
    required List<String> participants,
  }) async {
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
    await jitsiMeetPlugin.join(options, listener);
  }

  static hangUp({required JitsiMeet jitsiMeetPlugin}) async {
    await jitsiMeetPlugin.hangUp();
  }

  // static setAudioMuted(bool? muted) async {
  //   var a = await _jitsiMeetPlugin.setAudioMuted(muted!);
  //   debugPrint('$a');
  //   setState(() {
  //     audioMuted = muted;
  //   });
  // }

  // static setVideoMuted(bool? muted) async {
  //   var a = await _jitsiMeetPlugin.setVideoMuted(muted!);
  //   debugPrint('$a');
  //   setState(() {
  //     videoMuted = muted;
  //   });
  // }

  // static sendEndpointTextMessage() async {
  //   var a = await _jitsiMeetPlugin.sendEndpointTextMessage(message: 'HEY');
  //   debugPrint('$a');

  //   for (var p in participants) {
  //     var b =
  //         await _jitsiMeetPlugin.sendEndpointTextMessage(to: p, message: 'HEY');
  //     debugPrint('$b');
  //   }
  // }

  // static toggleScreenShare(bool? enabled) async {
  //   await _jitsiMeetPlugin.toggleScreenShare(enabled!);

  //   setState(() {
  //     screenShareOn = enabled;
  //   });
  // }

  // static openChat() async {
  //   await _jitsiMeetPlugin.openChat();
  // }

  // static sendChatMessage() async {
  //   var a = await _jitsiMeetPlugin.sendChatMessage(message: 'HEY1');
  //   debugPrint('$a');

  //   for (var p in participants) {
  //     a = await _jitsiMeetPlugin.sendChatMessage(to: p, message: 'HEY2');
  //     debugPrint('$a');
  //   }
  // }

  // static closeChat() async {
  //   await _jitsiMeetPlugin.closeChat();
  // }

  // static retrieveParticipantsInfo() async {
  //   var a = await _jitsiMeetPlugin.retrieveParticipantsInfo();
  //   debugPrint('$a');
  // }
}
