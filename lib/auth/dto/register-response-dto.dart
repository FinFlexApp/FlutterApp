class RegisterResponseDTO{
  final RegisterDataDTO? registerData;
  //final String? error;
  final String message;
  

  factory RegisterResponseDTO.fromJson(Map<String, dynamic> json){
    if(json['data'] != null){
      var data = RegisterDataDTO.fromJson(json['data']);
      return RegisterResponseDTO(registerData: data, message: json['message']);
    }
    return RegisterResponseDTO(message: json['message']);
  }

  RegisterResponseDTO({this.registerData, required this.message});
}

class RegisterDataDTO{
  final String email;
  final String firstName;
  final String nickName;
  final String password;
  final String surName;

  RegisterDataDTO({required this.email, required this.firstName, required this.surName, required this.nickName, required this.password});

  factory RegisterDataDTO.fromJson(Map<String, dynamic> json) => RegisterDataDTO(
    email: json['email'], 
    firstName: json['firstname'],
    surName: json['surname'],
    nickName: json['nickname'],
    password: json['password']
    );
}