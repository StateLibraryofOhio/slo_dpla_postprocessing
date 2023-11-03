<!--
    sloapp-set-detail.php

This file is intended to display the details about a 
specific harvestable set.

-->

<?php
//echo "<p>This is the content for the sloapp-set-detail.php file.</p>";
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

while ($sourceRow = $sourceResult->fetch())
{
    $providerName = htmlspecialchars($sourceRow['providerName']);
    $description =  htmlspecialchars($sourceRow['description']);
    $metadataPrefix = htmlspecialchars($sourceRow['metadataPrefix']);
    $originalMetadataPrefix = htmlspecialchars($sourceRow['metadataPrefix']);
    $odnSet = htmlspecialchars($sourceRow['odnSet']);
    $oaiSource = htmlspecialchars($sourceRow['oaiSource']);
    $oaiSet = htmlspecialchars($sourceRow['oaiSet']);
    $sourceSchema = htmlspecialchars($sourceRow['sourceSchema']);
    $lastIngest =  htmlspecialchars($sourceRow['lastIngest']);
    $status = htmlspecialchars($sourceRow['status']);
    $typeOfSource = htmlspecialchars($sourceRow['typeOfSource']);
    $sourcesDirPath = htmlspecialchars($sourceRow['sourcesDirPath']);
    $retrieveStrategy =  htmlspecialchars($sourceRow['retrieveStrategy']);
    $splitRecordsRecordXPath = htmlspecialchars($sourceRow['splitRecordsRecordXPath']);

//    $sourceQuery = 'select * from source where providerName="' . htmlspecialchars($providerRow['name'])  . '" order by description';
}
//}
?>

<br>

<h3>Collection details</h3>
<table>
<tr><td width="125">Provider</td>  <td><?php echo $providerName ?></td> </tr>
<tr><td>Set name</td>  <td><?php echo $description ?></td> </tr>
<tr><td>ODN setSpec</td>  <td><?php echo $odnSet ?></td></tr>
</table>
<?php
    echo "<table><tr><td>";
?>

<h3>Record Counts</h3>
<ul>
<li>Total records available to DPLA (eliminate deleted and filtered records)</li>
<li>Number of records available for DPLA IIIF/WikiMedia participation</li>



<?php

$recordcountQuery = 'select * from recordcount where odnSet="' . htmlspecialchars($sloappSet)  . '"';

//$providerResult = $pdo->query($providerQuery);

$recordcountResult = $pdo->query($recordcountQuery);

while ($recordcountRow = $recordcountResult->fetch())
{
    $totalRecordsIncludingDeleted = htmlspecialchars($recordcountRow['recordCount']);
    echo '<li>With dels:  ' . $totalRecordsIncludingDeleted . '</li>';
    $deletedRecords              =  htmlspecialchars($recordcountRow['deletedRecords']);
    echo '<li>Deletes:  ' . $deletedRecords . '</li>';
    echo '<li>Undeleted:  ' . $totalRecordsIncludingDeleted-$deletedRecords . '</li>';
}
?>
</ul>



<h3>Harvested Files</h3>

<ul>
<?php

//  $sourceQuery = 'select metadataPrefix from source where odnSet="' . htmlspecialchars($sloappSet)  . '"';
//  $sourceResult = $pdo->query($sourceQuery);


  $rawHarvestFile = 'datasets/raw/' . $sloappSet . '-raw-' . $originalMetadataPrefix . '.xml';
  if (file_exists($rawHarvestFile)) {
      echo "<li><a href=\"$rawHarvestFile\">Original, unmodified OAI-PMH contribution</a></li>";
  } else {
      echo "<li>No unmodified OAI-PMH file.  Never harvested?</li>";
  }

  $archiveFile = 'datasets/archivized/' . $sloappSet . '-odn-' . $originalMetadataPrefix . '.xml';
  if (file_exists($archiveFile)) {
      echo "<li><a href=\"$archiveFile\">OAI-Archival version</a></li>";
  } else {
      echo "<li>No archive file.  Never harvested?</li>";
  }

  $stagingFile = 'datasets/staging/' . $sloappSet . '.xml';
  if (file_exists($stagingFile)) {
      echo "<li><a href=\"$stagingFile\">Set-transformed version</a></li>";
  } else {
      echo "<li>No staging file.  Set transform not created?</li>";
  }

  $readyForIngestFile = 'datasets/ready/' . $sloappSet . '.xml';
  if (file_exists($readyForIngestFile)) {
      echo "<li><a href=\"$readyForIngestFile\">DPLA Submission</a></li>";
  } else {
      echo "<li>No files ready for upload to DPLA.</li>";
  }

?>
</ul>




<?php 
$oldTasksQuery = 'select * from oldTasks where odnSet="' . htmlspecialchars($sloappSet)  . '" order by oldTaskTime limit 1';
$oldTasksResult = $pdo->query($oldTasksQuery);

echo '<h3><div align="right">You need to resume working at this point</div></h3>';
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


