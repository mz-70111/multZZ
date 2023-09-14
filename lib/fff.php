<?php

$servername = "192.168.30.8";
$username = "mz";
$password = "mzrootmz";
$database="mz_db01";

$mysqli = new mysqli($servername, $username, $password,$database);
if($mysqli->connect_error){
echo json_encode("cennection error");
} else {

    $customquery = $_POST["customquery"];
    if ($customquery != null) {
        $mysqli->query($customquery);
        if ($mysqli->error) {
            echo json_encode(array("status" => $mysqli->error));
        } else {
            echo json_encode(array("status" => "done"));
        }
    }
}
$mysqli->close();