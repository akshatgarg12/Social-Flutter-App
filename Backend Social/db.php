<?php
  $conn = mysqli_connect("localhost", "id14272209_akshat", "iRK+AnmQJ^3vTVj7" ,"id14272209_social");
  if(!$conn){
    echo "connection problem" . mysqli_errn($conn);
  }
  else{
    // echo "connection successful.";
  }
?>