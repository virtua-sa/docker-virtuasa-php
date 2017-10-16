<?php
$path=dirname(dirname(__FILE__));
echo $path == "/data" ? "S" : "F";
echo file_get_contents("$path/read.txt") == "OK" ? "S" : "F";
echo file_put_contents("$path/write.txt", "OK") !== false ? "S" : "F";
echo file_get_contents("$path/write.txt") == "OK" ? "S" : "F";
echo unlink("$path/write.txt") === true ? "S" : "F";
