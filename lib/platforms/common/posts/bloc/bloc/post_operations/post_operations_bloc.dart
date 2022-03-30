
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_operations/post_operations_event.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_operations/post_operations_state.dart';
import 'package:flutter_eb/platforms/common/posts/repo/post_repository.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class PostOperationsBloc extends Bloc<PostOperationsEvent, PostOperationsState> {
  final PostRepository postRepository;

  PostOperationsBloc(this.postRepository) : super(PostOperationsLoadedState());

  @override
  Stream<PostOperationsState> mapEventToState(
      PostOperationsEvent event,
      ) async* {
    if(event is DeletePostEvent) {
      yield LoadingPostDeleteOperationsState();
      try {
        await deletePost(event.postId);
        yield DeletePostOperationsState(isDeleted: true);
      }
      catch(e){
        yield DeletePostOperationsState(isDeleted: false);
      }
    }
  }

  Future<void> deletePost(String postId)async{
    this.postRepository.deletePost(postId);
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
