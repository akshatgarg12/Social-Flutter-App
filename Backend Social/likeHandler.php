<?php
if(isset($_POST['user_id']) && isset($_POST['post_id']) && isset($_POST['action'])){
    require('db.php');
    $user_id = mysqli_real_escape_string($conn, $_POST['user_id']);
     $post_id = mysqli_real_escape_string($conn, $_POST['post_id']);
     if($_POST['action']=='liked'){
    $sql = "INSERT INTO MobileLikes(user_id, post_id) VALUES('$user_id','$post_id')";
     }
     else if($_POST['action']=='unliked'){
         $sql = "DELETE FROM MobileLikes WHERE user_id = '$user_id' and post_id = '$post_id' ";
     }
    $result = mysqli_query($conn, $sql);
    if(!result){
        echo json_encode(404);
    }
}