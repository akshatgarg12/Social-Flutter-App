<?php
  require '../config/db.php';
  if(isset($_POST['username']) && isset($_POST['email']) && isset($_POST['password'])){
  $username  = htmlspecialchars($_POST['username']) ?? ' ';
  $email  = htmlspecialchars($_POST['email']) ?? ' ';
  $password  =htmlspecialchars($_POST['password'])?? ' ';
  // username validations
  // $username = mysqli_real_escape_string($username);
  $sql = "SELECT * FROM MobileUsers WHERE username='$username'";
  $result = mysqli_query($conn, $sql);
  if(empty($username)){
    echo json_encode(406);
    $errors['username']='err';
    exit();
  }
  else if(!preg_match("/^[A-Za-z][A-Za-z0-9]{5,31}$/",$username)){
    echo json_encode(402);
    $errors['username']='err';
    exit();
  }
  else if(mysqli_num_rows($result)){
     echo json_encode(403);
     $errors['username']='err';
    exit();
  }
  // email valid
  // $email = mysqli_real_escape_string($email);
  $sql = "SELECT * FROM MobileUsers WHERE email='$email'";
  $result = mysqli_query($conn, $sql);
  if(empty($email)){
    echo json_encode(406);
    $errors['email']='err';
    exit();
  }
  else if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
  echo json_encode(402);
  $errors['email']='err';
    exit();
} 
  else if(mysqli_num_rows($result)){
    echo json_encode(403);
    $errors['email']='err';
    exit();
  }
  // password
  if(empty($password)){
    echo json_encode(406);
    $errors['password']='err';
    exit();
  }
  else if(strlen($password)<8){
    echo json_encode(401);
     $errors['password']='err';
    exit();
  }
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    $sql = "INSERT INTO MobileUsers(username,email,password) VALUES('$username','$email','$hashed_password')";
    $result = mysqli_query($conn,$sql);
    if($result){
     echo json_encode(200);
     exit();
    }
     else{
     echo json_encode(500);
     exit();
    }
  }
  
  