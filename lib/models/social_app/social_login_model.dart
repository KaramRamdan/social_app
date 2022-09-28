class SocialUserModel {
  String? name;
  String? email;
  String? phone;
  String? image;
  String? cover;
  String? uId;
  String? bio;
  bool? isEmailVerified;

  SocialUserModel({
    this.uId,
    this.email,
    this.name,
    this.bio,
    this.image,
    this.cover,
    this.phone,
    this.isEmailVerified
});

  SocialUserModel.fromJson(Map<String, dynamic>json){
    email=json['email'];
    name=json['name'];
    phone=json['phone'];
    uId=json['uId'];
    image=json['image'];
    cover=json['cover'];
    bio=json['bio'];
    isEmailVerified=json['isEmailVerified'];
  }
  Map<String,dynamic>toMap(){
    return{
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
      'image':image,
      'cover':cover,
      'bio':bio,
      'isEmailVerified':isEmailVerified,
    };
  }
}