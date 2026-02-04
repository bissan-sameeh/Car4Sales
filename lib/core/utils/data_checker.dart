class DataChecker{

  passwordValidator(String value){
    print(value);
    if(value.isEmpty){
      return "Password is required !";
    }else if(value.length <6){
      return "Password should be at least 6 character";
    } else if (!RegExp("(?=.*?[0-9])(?=.*?[A-Za-z])(?=.*[^0-9A-Za-z]).+")
        .hasMatch(value)){
      return "Password must contain at least one character (a-z)/(A-Z) or digit!";

    }
    else{
      return null;
    }
  }
}