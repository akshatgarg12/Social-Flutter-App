<?php
if(isset($_POST['user_id']) && isset($_POST['attribute'])){
    require('db.php');
    $user_id = mysqli_real_escape_string($conn, $_POST['user_id']);
     if($_POST['attribute'] == 'liked'){
         $sql = "SELECT post_id FROM MobileLikes WHERE user_id='$user_id'";
     }
     else if($_POST['attribute'] == 'saved'){
         $sql = "SELECT post_id FROM MobileSaved WHERE user_id='$user_id'";
     }
     else{
         exit();
     }
     $result = mysqli_query($conn,$sql);
     $post_ids = mysqli_fetch_all($result, MYSQLI_ASSOC);
    $ids = array();
    foreach($post_ids as $post_id){
        $ids[] = $post_id['post_id'];
    }
    $ids = join(', ', $ids);
    $sql = "SELECT * FROM MobileBlogs WHERE id in ($ids)";
    $result = mysqli_query($conn,$sql);
    $posts = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($posts);
    exit();
}
