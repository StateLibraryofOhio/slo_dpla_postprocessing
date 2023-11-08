<!--
    sloapp-list-by-rights.php

    This is intended to list all of the datasets that include 
    a given right URI.

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


//echo '<h1>Resume work here to add multiple sort options </h1>';
$URI = $_GET['uri'];
$uriQuery = "select odnSet from setRights where uri='" . htmlspecialchars($URI) . "'";
//echo "<p>" . $uriQuery . "</p>";
$uriResult = $pdo->query($uriQuery);

echo "<h4>" . $URI . "</h4><ul>";
while ($uriRow = $uriResult->fetch()) {
    $cleanOdnSet = htmlspecialchars($uriRow['odnSet']);
    $sourceQuery = "select * from source where odnSet='" . $cleanOdnSet . "'";
    $sourceResult = $pdo->query($sourceQuery);
    while ($sourceRow = $sourceResult->fetch())
    {
        $providerName = htmlspecialchars($sourceRow['providerName']);
        $setDescription = htmlspecialchars($sourceRow['description']);
    }
    echo "<li><a href='/?action=set-detail&odnSet=" . $cleanOdnSet . "'>" . $setDescription . '</a> (' .
             $cleanOdnSet . ') :: ' . 
             "<a href='/?action=org-detail&provider=" . $providerName . "'>" . $providerName . '</a>' .
         "</li>";
}
echo "</ul>";

//echo '<p>' . $uriQuery . '</p>';


//echo '<h2>test  ' . $sourceQuery . '</h2>';


//$providerResult = $pdo->query($providerQuery);

//$sourceResult = $pdo->query($sourceQuery);
// while ($Row = $providerResult->fetch())
//  {
  
//  echo '<li>' . htmlspecialchars($providerRow['name']) . '</li>';

//  $sourceQuery = "select * from source where providerName='" . $providerRow['name'] . "' order by description";
//  $sourceResult = $pdo->query($sourceQuery);
//echo '<p><a href="?action=set-add">Add a new dataset</a></p>';
//echo '<table>';
//echo '<tr><th><a href="/?action=collections&odnSetSort=description' . $otherSortDirection . '">Set name</a></th>
//          <th><a href="/?action=collections&odnSetSort=providerName' . $otherSortDirection . '">Contributing organization</a></th>
//          <th><a href="/?action=collections&odnSetSort=lastIngest' . $otherSortDirection . '">Last harvested</a></th>
//          <th><a href="/?action=collections&odnSetSort=odnSet' . $otherSortDirection . '">ODN setSpec</a></th>
//      </tr>';
//  while ($sourceRow = $sourceResult->fetch())
//  {
//    echo '<tr>';
//    echo '<td><a href="?action=set-detail&odnSet=' . htmlspecialchars($sourceRow['odnSet']) . '">' . htmlspecialchars($sourceRow['description']) . '</a></td>';
//    echo '<td>' . htmlspecialchars($sourceRow['providerName']) . '</td>';
//    $lastIngestDate = preg_split('/\s/', htmlspecialchars($sourceRow['lastIngest']));
//    echo '<td class="td-displayDate">' . $lastIngestDate[0] . '</td>';
//    echo '<td>' . htmlspecialchars($sourceRow['odnSet']) . '</td>';
//    echo '</tr>';
//  }
//echo '</table>'; 
//}
?>
