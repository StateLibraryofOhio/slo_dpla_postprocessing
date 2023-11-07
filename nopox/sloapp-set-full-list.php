<!--
    sloapp-set-full-list.php

    This simply lists every set registered for harvesting.
    Sets will be individually hyperlinked to pages with 
    more details about that set.
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


// URL parm to handle sorting columns
$sloappSetSort=$_GET['odnSetSort'];

if ($sloappSetSort == '') {
   $sortOption = 'order by description';
} else {
   $sortOption = 'order by ' . $sloappSetSort;
}

//echo '<h1>Resume work here to add multiple sort options </h1>';

$sourceQuery = 'select * from source ' . $sortOption;

//echo '<h2>test  ' . $sourceQuery . '</h2>';


//$providerResult = $pdo->query($providerQuery);

$sourceResult = $pdo->query($sourceQuery);
// while ($Row = $providerResult->fetch())
//  {
  
//  echo '<li>' . htmlspecialchars($providerRow['name']) . '</li>';

//  $sourceQuery = "select * from source where providerName='" . $providerRow['name'] . "' order by description";
//  $sourceResult = $pdo->query($sourceQuery);
//echo '<p><a href="?action=set-add">Add a new dataset</a></p>';
echo '<table>';
echo '<tr><th><a href="/?action=collections&odnSetSort=description">Set name</a></th>
          <th><a href="/?action=collections&odnSetSort=providerName">Contributing organization</a></th>
          <th><a href="/?action=collections&odnSetSort=lastIngest">Last harvested</a></th>
          <th><a href="/?action=collections&odnSetSort=odnSet">ODN setSpec</a></th>
      </tr>';
  while ($sourceRow = $sourceResult->fetch())
  {
    echo '<tr>';
    echo '<td><a href="?action=set-detail&odnSet=' . htmlspecialchars($sourceRow['odnSet']) . '">' . htmlspecialchars($sourceRow['description']) . '</a></td>';
    echo '<td>' . htmlspecialchars($sourceRow['providerName']) . '</td>';
    $lastIngestDate = preg_split('/\s/', htmlspecialchars($sourceRow['lastIngest']));
    echo '<td class="td-displayDate">' . $lastIngestDate[0] . '</td>';
    echo '<td>' . htmlspecialchars($sourceRow['odnSet']) . '</td>';
    echo '</tr>';
  }
echo '</table>'; 
//}
?>

