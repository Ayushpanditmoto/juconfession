abstract class VideoCallState {}

class VideoCallInitial extends VideoCallState {}

class VideoCallLoading extends VideoCallState {}

class VideoCallSuccess extends VideoCallState {
  final String roomName;
  VideoCallSuccess(this.roomName);
}

class VideoCallDisconnected extends VideoCallState {}

class VideoCallError extends VideoCallState {
  final String message;

  VideoCallError(this.message);
}
