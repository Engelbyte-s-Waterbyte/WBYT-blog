<?php

$users = json_decode(file_get_contents("../../users.json"));

$username = $_POST["username"];
$password = $_POST["password"];

$user = null;
foreach ($users as $fileUser) {
    if ($fileUser->username == $username and $fileUser->password == $password) {
        $user = $fileUser;
        break;
    }
}
if ($user == null) {
    die('Authentication Failed');
}
