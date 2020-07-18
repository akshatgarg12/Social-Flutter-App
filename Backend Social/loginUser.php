<?php
    if(isset($_POST['password']) && isset($_POST['uid'])){
  $uid = htmlspecialchars($_POST['uid']) ?? '  ';
  $password = htmlspecialchars($_POST['password']) ?? ' ';
  $sql = "SELECT * FROM MobileUsers WHERE username='$uid' or email = '$uid'";
  require "../config/db.php";
  $result = mysqli_query($conn,$sql);
  $userData = mysqli_fetch_all($result,MYSQLI_ASSOC);
  $data = array("status"=>200);
  if(!empty($userData)){
    $pass= $userData[0]['password'];
    if(password_verify($password, $pass)){
        $data['status'] =200;
        $data['user_id'] = $userData[0]['id'];
        echo json_encode($data);
        exit();
    }
    else{
        $data['status'] = 401;
        echo json_encode($data);
    }
  }
  else{
      $data['status'] = 402;
      echo json_encode($data);
  }
  }
?>