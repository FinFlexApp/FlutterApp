class LoginResponseDTO{
  final LoginDataDTO? loginData;
  final String message;

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json){
    if(json['data'] != null){
      var data = LoginDataDTO.fromJson(json['data']);
      return LoginResponseDTO(loginData: data, message: json['message']);
    }
    return LoginResponseDTO(message: json['message']);
  }

  LoginResponseDTO({this.loginData, required this.message});
}

class LoginDataDTO{
  final String email;
  final String password;
  final String token;
  final int userId;

  LoginDataDTO({required this.email, required this.password, required this.token, required this.userId});

  factory LoginDataDTO.fromJson(Map<String, dynamic> json) => LoginDataDTO(
    email: json['email'], 
    password: json['password'], 
    token: json['token'], 
    userId: json['user_id']);
}