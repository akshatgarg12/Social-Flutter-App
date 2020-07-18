<?php
if(isset($_POST['user_id']) && isset($_POST['post_id'])  && isset($_POST['attribute'])){
     require('db.php');
    $user_id = mysqli_real_escape_string($conn, $_POST['user_id']);
     $post_id = mysqli_real_escape_string($conn, $_POST['post_id']);
     $return = array("status"=>0);
     if($_POST['attribute'] == 'like'){
         $sql = "SELECT * FROM MobileLikes WHERE user_id='$user_id' and post_id = '$post_id'";
     }
     else if($_POST['attribute'] == 'save'){
         $sql = "SELECT * FROM MobileSaved WHERE user_id='$user_id' and post_id = '$post_id'";
     }
     $result = mysqli_query($conn,$sql);
     if(mysqli_num_rows($result)==1){
         $return['status']=1;
         echo json_encode($return);
         exit();
     }
     else {echo json_encode($return); exit();}
}