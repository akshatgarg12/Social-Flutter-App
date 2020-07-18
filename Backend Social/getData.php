<?php
require_once('db.php');
if(isset($_POST['author'])){
    $author = mysqli_real_escape_string($conn,$_POST['author']);
    $sql = "SELECT * FROM MobileBlogs WHERE author ='$author'";
}
else{
$sql = "SELECT * FROM MobileBlogs";
}
$result = mysqli_query($conn, $sql);
$row = mysqli_num_rows($result);
if($row){
  $data = mysqli_fetch_all($result,MYSQLI_ASSOC);
  echo json_encode($data);
  exit();
}
