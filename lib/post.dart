// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
    Post({
        required this.name,
        required this.profilePic,
        required this.location,
        required this.post,
        required this.likes,
        required this.comments,
    });

    String name;
    String profilePic;
    String location;
    String post;
    int likes;
    int comments;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        name: json["name"],
        profilePic: json["profile_pic"],
        location: json["location"],
        post: json["post"],
        likes: json["likes"],
        comments: json["comments"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "profile_pic": profilePic,
        "location": location,
        "post": post,
        "likes": likes,
        "comments": comments,
    };
}
