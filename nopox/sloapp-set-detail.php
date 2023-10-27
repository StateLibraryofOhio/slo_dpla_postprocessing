<!--
    sloapp-set-detail.php

This file is intended to display the details about a 
specific harvestable set.

-->
<?php
echo "<p>This is the content for the sloapp-set-detail.php file.</p>";
?>


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

$sloappSet=$_GET['odnSet'];
$sourceQuery = 'select * from source where odnSet="' . htmlspecialchars($sloappSet)  . '"';
$sourceResult = $pdo->query($sourceQuery);

echo '<h3>Collection details</h3>';
while ($sourceRow = $sourceResult->fetch())
{
    echo '<p>providerName:   ' . htmlspecialchars($sourceRow['providerName']) . '</p>';
    echo '<p>description:    ' . htmlspecialchars($sourceRow['description']) . '</p>';
    echo '<p>metadataPrefix: ' . htmlspecialchars($sourceRow['metadataPrefix']) . '</p>';
    $originalMetadataPrefix = htmlspecialchars($sourceRow['metadataPrefix']);
    echo '<p>odnSet:         ' . htmlspecialchars($sourceRow['odnSet']) . '</p>';
    echo '<p>oaiSource:      ' . htmlspecialchars($sourceRow['oaiSource']) . '</p>';
    echo '<p>oaiSet:         ' . htmlspecialchars($sourceRow['oaiSet']) . '</p>';
    echo '<p>sourceSchema:   ' . htmlspecialchars($sourceRow['sourceSchema']) . '</p>';
    echo '<p>lastIngest:     ' . htmlspecialchars($sourceRow['lastIngest']) . '</p>';
    echo '<p>status:         ' . htmlspecialchars($sourceRow['status']) . '</p>';
    echo '<p>typeOfSource:   ' . htmlspecialchars($sourceRow['typeOfSource']) . '</p>';
    echo '<p>sourcesDirPath: ' . htmlspecialchars($sourceRow['sourcesDirPath']) . '</p>';
    echo '<p>retrieveStrategy: ' . htmlspecialchars($sourceRow['retrieveStrategy']) . '</p>';
    echo '<p>splitRecordsRecordXPath: ' . htmlspecialchars($sourceRow['splitRecordsRecordXPath']) . '</p>';

//    $sourceQuery = 'select * from source where providerName="' . htmlspecialchars($providerRow['name'])  . '" order by description';
}
//}
?>
<br>

<h3>Record Counts</h3>
<ul>
<li>Total records available to DPLA (eliminate deleted records; in a few cases, restrict records further)</li>
<li>Number of records available for DPLA IIIF/WikiMedia participation</li>
</ul>

<?php

$recordcountQuery = 'select * from recordcount where odnSet="' . htmlspecialchars($sloappSet)  . '"';

//$providerResult = $pdo->query($providerQuery);

$recordcountResult = $pdo->query($recordcountQuery);

while ($recordcountRow = $recordcountResult->fetch())
{
    $totalRecordsIncludingDeleted = htmlspecialchars($recordcountRow['recordCount']);
    echo '<h2>With dels:  ' . $totalRecordsIncludingDeleted . '</h2>';
    $deletedRecords              =  htmlspecialchars($recordcountRow['deletedRecords']);
    echo '<h2>Deletes:  ' . $deletedRecords . '</h2>';
    echo '<h2>Undeleted:  ' . $totalRecordsIncludingDeleted-$deletedRecords . '</h2>';
}

?>
<br>

<h3>Harvested Files</h3>

<?php

//  $sourceQuery = 'select metadataPrefix from source where odnSet="' . htmlspecialchars($sloappSet)  . '"';
//  $sourceResult = $pdo->query($sourceQuery);


  $rawHarvestFile = 'datasets/raw/' . $sloappSet . '-raw-' . $originalMetadataPrefix . '.xml';
  if (file_exists($rawHarvestFile)) {
      echo "<h3><a href=\"$rawHarvestFile\">Original, unmodified OAI-PMH contribution</a></h3>";
  } else {
      echo "<h3>No unmodified OAI-PMH file.  Never harvested?</h3><br>";
  }


  $archiveFile = 'datasets/archivized/' . $sloappSet . '-odn-' . $originalMetadataPrefix . '.xml';
  if (file_exists($archiveFile)) {
      echo "<h3><a href=\"$archiveFile\">OAI-Archival version</a></h3>";
  } else {
      echo "<h3>No archive file.  Never harvested?</h3><br>";
  }

  $readyForIngestFile = 'datasets/ready/' . $sloappSet . '.xml';
  if (file_exists($readyForIngestFile)) {
      echo "<h3><a href=\"$readyForIngestFile\">DPLA Submission</a></h3>";
  } else {
      echo "<h3>No files ready for upload to DPLA.</h3><br>";
  }


?>


<h3>Harvest History:</h3>

<?php

$sloappSet=$_GET['odnSet'];

$sourceQuery = 'select * from source where odnSet="' . htmlspecialchars($sloappSet)  . '"';
$sourceResult = $pdo->query($sourceQuery);

$sourceRow = $sourceResult->fetch();

//echo '<h3>maitai ' . htmlspecialchars($sourceRow['oaiSet']) . ' snowball</h3>';
$oaiSet=htmlspecialchars($sourceRow['oaiSet']);

echo '<h3>Collection details</h3>';
//$oneRow = $sourceResult->fetch();
//echo '<h2>Menchi-fluff ' . htmlspecialchars($oneRow['oaiSet']) . ' xyzzy ' . '</h2>';
//$oldTasksQuery = 'select * from oldTasks where odnSet="' .  . '"';

?>

<br>
<br>


