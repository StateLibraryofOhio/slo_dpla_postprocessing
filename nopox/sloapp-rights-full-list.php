<!--
    sloapp-set-full-list.php

    This simply lists every Rights URI which has been harvested.
    URIs will be individually hyperlinked to pages with lists of
    sets that contain records with that rights URI.
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

//$providerQuery = 'select name from provider order by name';

$rightsQuery = 'select distinct uri from setRights order by uri';
$rightsResult = $pdo->query($rightsQuery);

echo "<ul>";
while ($rightsRow = $rightsResult->fetch()) 
{
   $uriValue = htmlspecialchars($rightsRow['uri']);
   echo "<li><a href='/?action=list-rights&uri=" . $uriValue . "'>" . $uriValue . '</a></li>';
}
echo "</ul><em>Note:  Click on the edm:rights URI to find other sets also containing records with that rights URI.</em>";


// URL parms to handle sorting columns
//$sloappSetSort=$_GET['odnSetSort'];
//$sloappSetReverseSort=$_GET['d'];


//if ($sloappSetSort == '') {
//   $sortOption = 'order by description';
//} else {
//   $sortOption = 'order by ' . $sloappSetSort;
//}

//if ($sloappSetReverseSort == '') {
//   $sortDirection = '';
//   $otherSortDirection = '&d=1';
//} else {
//   $sortDirection = ' desc';
//   $otherSortDirection = '';
//}


//$sourceQuery = 'select * from source ' . $sortOption . $sortDirection;
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

