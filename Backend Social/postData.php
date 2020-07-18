<?php
require('db.php');

$author = $_POST['author'] ?? '';
$title = $_POST['title'] ?? '';
$body = $_POST['body'] ?? '';
$photo_url = $_POST['photo_url'] ??'';
$author  = mysqli_real_escape_string($conn,$author);
$title  = mysqli_real_escape_string($conn,$title);
$body  = mysqli_real_escape_string($conn,$body);
$photo_url  = mysqli_real_escape_string($conn,$photo_url);
$sql = "INSERT INTO MobileBlogs(author,title,body,photo_url) VALUES('$author','$title','$body','$photo_url')";
$result = mysqli_query($conn, $sql);
if($result){
  $msg = "success";
  mysqli_close($conn);
}
else{ 
  $msg = "failed";
}
echo json_encode($msg);
