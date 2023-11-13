<!--
    sloapp-list-harvests.php

    This is intended to list all harvests of all datasets

-->

<?php

require_once 'login.php';


// connect using the login options from login.php
try 
{
    $pdo = new PDO($attr, $user, $pass, $opts);
}
catch ( PDOException $e)
{
    throw new PDOException($e->getMessage(), (int)$e->getCode());
}

$oldTasksQuery = "select odnSet, oldTaskTime from oldTasks order by oldTaskTime desc";
$oldTasksResult = $pdo->query($oldTasksQuery);

echo "<h4>Harvest history</h4>";
echo "<table border='1'";
while ($oldTasksRow = $oldTasksResult->fetch()) {
    $cleanOdnSet = htmlspecialchars($oldTasksRow['odnSet']);
    $cleanOldTaskTime = htmlspecialchars($oldTasksRow['oldTaskTime']);
    echo "<tr><td>" . $cleanOdnSet . "</td><td>" . $cleanOldTaskTime . "</td>";
    $sourceQuery = "select providerName, description from source where odnSet='" . $cleanOdnSet . "'";
//    echo "<h3>" . $sourceQuery . "</h3>";
    $sourceResult = $pdo->query($sourceQuery);
    $xyzzy=$sourceResult->rowCount();
    if ( $xyzzy ) {
      while ($sourceRow = $sourceResult->fetch()) {
         $setDescription = htmlspecialchars($sourceRow['description']);
         echo "<td>" . $setDescription . "</td>";
         $setProvider = htmlspecialchars($sourceRow['providerName']);
         echo "<td>" . $setProvider . "</td>";
      }
    } else {
      echo "<td>deleted set</td><td>deleted set</td>";
//    while ($sourceRow = $sourceResult->fetch()) {
//        $setDescription = htmlspecialchars($sourceRow['description']);
//        echo "<td>" . $setDescription . "</td>";
//        $setProvider = htmlspecialchars($sourceRow['providerName']);
//    }
    }
    echo "</tr>";
}
echo "</table>";
//$URI = $_GET['uri'];
//$uriQuery = "select odnSet from setRights where uri='" . htmlspecialchars($URI) . "'";
//$uriResult = $pdo->query($uriQuery);

//echo "<h4>" . $URI . "</h4><ul>";
//while ($uriRow = $uriResult->fetch()) {
//    $cleanOdnSet = htmlspecialchars($uriRow['odnSet']);
//    $sourceQuery = "select * from source where odnSet='" . $cleanOdnSet . "'";
//    $sourceResult = $pdo->query($sourceQuery);
//    while ($sourceRow = $sourceResult->fetch())
//    {
//        $providerName = htmlspecialchars($sourceRow['providerName']);
//        $setDescription = htmlspecialchars($sourceRow['description']);
//    }
//    echo "<li><a href='/?action=set-detail&odnSet=" . $cleanOdnSet . "'>" . $setDescription . '</a> (' .
//             $cleanOdnSet . ') :: ' . 
//             "<a href='/?action=org-detail&provider=" . $providerName . "'>" . $providerName . '</a>' .
//         "</li>";
//}
//echo "</ul><em>Note:  Click on the edm:rights URI to find other sets also containing records with that rights URI.</em>";

?>
