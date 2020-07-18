<?php
if(isset($_POST['user_id']) && isset($_POST['attribute']) && isset($_POST['value']) ){
    require('db.php');
    $user_id = mysqli_real_escape_string($conn, $_POST['user_id']);
    $value = mysqli_real_escape_string($conn, $_POST['value']);
     if($_POST['attribute'] == 'profile_pic'){
         $sql = "UPDATE MobileUsers SET profile_pic = '$value'  WHERE id ='$user_id'";
     }
     else if($_POST['attribute'] == 'bio'){
        $sql = "UPDATE MobileUsers SET bio = '$value'  WHERE  id ='$user_id'";
     }
     else{
         exit();
     }
     $result = mysqli_query($conn,$sql);
     if($result){
      echo json_encode(200);
      exit();
     }
     else{
       echo json_encode(400);
       exit();
     }
}