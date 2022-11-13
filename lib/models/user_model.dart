

class UserModel
{
  String? uId;
  String? name;
  String? email;
  String? phone;
  String? bio;
  String? image;
  String? cover;
  bool? isEmailVerified;

  UserModel({
    this.uId,
    this.name,
    this.email,
    this.phone,
    this.bio,
    this.image,
    this.cover,
    this.isEmailVerified,
  });

  UserModel.fromJson(Map<String, dynamic> json)
  {
    uId   = json['uId'];
    name  = json['name'];
    email = json['email'];
    phone = json['phone'];
    bio   = json['bio'];
    image = json['image'];
    cover = json['cover'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'uId'  : uId,
      'name' : name,
      'email': email,
      'phone': phone,
      'bio'  : bio,
      'image': image,
      'cover': cover,
      'isEmailVerified': isEmailVerified,
    };
  }

}