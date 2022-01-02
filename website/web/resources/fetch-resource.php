<?php

$allowed = ["projects.json", "blog-posts.json", "team-members.json"];
if (!in_array($_GET["resource"], $allowed)) {
    die();
}

header('Cache-Control: private,max-age=30');
header('Content-Type: application/json');

$json = file_get_contents($_GET["resource"]);
echo $json;