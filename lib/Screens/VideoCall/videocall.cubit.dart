import 'package:flutter_bloc/flutter_bloc.dart';
import '../VideoCall/videocall.state.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  VideoCallCubit() : super(VideoCallInitial()) {
    initial();
  }

  void joinRoom(String roomName) {
    emit(VideoCallLoading());
    try {
      emit(VideoCallSuccess(roomName));
    } catch (e) {
      error(e.toString());
    }
  }

  void leaveRoom() {
    emit(VideoCallLoading());
    emit(VideoCallDisconnected());
  }

  void initial() {
    emit(VideoCallLoading());
    emit(VideoCallDisconnected());
  }

  void error(String message) {
    emit(VideoCallLoading());
    emit(VideoCallError(message));
  }
}
