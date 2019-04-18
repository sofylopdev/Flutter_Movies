import 'package:json_annotation/json_annotation.dart';

part 'thumbs_vimeo.g.dart';

@JsonSerializable()
class ThumbsVimeo {
  int id;
  String title;
  String description;
  String url;
  String upload_date;
  int user_id;
  String user_name;
  String user_url;
  String user_portrait_small;
  String user_portrait_medium;
  String user_portrait_large;
  String user_portrait_huge;
  int stats_number_of_likes;
  int stats_number_of_plays;
  int stats_number_of_comments;
  int duration;
  int width;
  int height;
  String tags;
  String embed_privacy;

  String thumbnail_large;
  String thumbnail_medium;
  String thumbnail_small;


  ThumbsVimeo(this.id, this.title, this.description, this.url, this.upload_date,
      this.user_id, this.user_name, this.user_url, this.user_portrait_small,
      this.user_portrait_medium, this.user_portrait_large,
      this.user_portrait_huge, this.stats_number_of_likes,
      this.stats_number_of_plays, this.stats_number_of_comments, this.duration,
      this.width, this.height, this.tags, this.embed_privacy,
      this.thumbnail_large, this.thumbnail_medium,
      this.thumbnail_small);

  factory ThumbsVimeo.fromJson(Map json) =>
      _$ThumbsVimeoFromJson(json);

  Map toJson() => _$ThumbsVimeoToJson(this);

  String get thumbnailLarge => thumbnail_large;

  String get thumbnailMedium => thumbnail_medium;

  String get thumbnailSmall => thumbnail_small;
}
