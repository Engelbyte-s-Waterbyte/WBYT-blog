<?php

require('auth.inc.php');

$target_dir = '../blog-post-assets/';
$imageFileType = strtolower(pathinfo($_FILES["file"]["name"],PATHINFO_EXTENSION));
$target_file = $target_dir . uniqid() . $imageFileType;
$uploadOk = 1;

if ($_FILES)

move_uploaded_file($_FILES["file"]["tmp_name"], $target_file);

die('File:' . $target_file);