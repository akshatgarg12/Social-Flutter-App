<?php
require('db.php');
if(isset($_POST['id'])){
    $id = mysqli_real_escape_string($conn, $_POST['id']);
    $sql = "SELECT * FROM MobileUsers WHERE id = '$id'";
    $result = mysqli_query($conn,$sql);
    $data = mysqli_fetch_all($result,MYSQLI_ASSOC);
    echo json_encode($data);
}