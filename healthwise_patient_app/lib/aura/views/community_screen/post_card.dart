import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/utils.dart';
import '../../models/user.dart' as model;
import '../../resources/firestore_methods.dart';
import '../../resources/user_provider.dart';
import 'comments_screen.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('patientPosts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.Patient user = Provider.of<UserProvider>(context).getUser!;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                Hero(
                  tag: 'profile_${widget.snap['postId']}',
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'] ?? user.photoUrl,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['isAnonymous']
                              ? 'Anonymous'
                              : widget.snap['username'] ?? user.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'] == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map(
                                      (e) => InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                        onTap: () {
                                          deletePost(widget.snap['postId']);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container(),
              ],
            ),
          ),
          // Post Content
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                widget.snap['postId'],
                user.uid ?? '',
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                widget.snap['postUrl'] != null &&
                        widget.snap['postUrl'].isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.8,
                        width: double.infinity,
                        child: Image.network(
                          widget.snap['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          widget.snap['description'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border),
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                      widget.snap['postId'],
                      user.uid ?? '',
                      widget.snap['likes'],
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      postId: widget.snap['postId'],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: widget.snap['isAnonymous']
                              ? 'Anonymous'
                              : widget.snap['username'] ?? user.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (widget.snap['postUrl'] != null)
                          TextSpan(text: ' ${widget.snap['description']}'),
                      ],
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: (){
                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>SimplificationScreen(originalString: widget.snap['description'])));
                //   },
                //   child: Text("Explain this text")),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snap['postId'],
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
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
