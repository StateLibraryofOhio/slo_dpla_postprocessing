<!-- login.php 
     Provides login capability for the PHP application to the 
     MySQL back-end database
 -->
<?php
    $host = 'localhost';
    $data = 'slo_aggregator';
    $user = 'pkukla';
    $pass = 'boris..';
    $chrs = 'utf8mb4';
    $attr = "mysql:host=$host;dbname=$data;charset=$chrs";
    $opts =
    [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ];

?>
