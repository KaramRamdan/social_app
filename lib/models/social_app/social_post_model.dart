class SocialPostModel {
  String? name;
  String? image;
  String? uId;
  String? dateTime;
  String? text;
  String? postImage;

  SocialPostModel({
    this.uId,
    this.name,
    this.image,
    this.dateTime,
    this.text,
    this.postImage,
});

  SocialPostModel.fromJson(Map<String, dynamic>json){
    name=json['name'];
    uId=json['uId'];
    image=json['image'];
    dateTime=json['dateTime'];
    text=json['text'];
    postImage=json['postImage'];
  }
  Map<String,dynamic>toMap(){
    return{
      'name':name,
      'uId':uId,
      'image':image,
      'dateTime':dateTime,
      'text':text,
      'postImage':postImage,
    };
  }
}