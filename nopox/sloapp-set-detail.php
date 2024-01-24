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
    $sourceCMS = htmlspecialchars($sourceRow['sourceCMS']);
    $iiifParticipant = htmlspecialchars($sourceRow['iiifParticipant']);
}
?>

<br>

<h3><?php echo $description ?></h3>
<table>
<tr><td width="125">Provider</td>  <td><?php echo $providerName ?></td></tr>
<tr><td>OAI setSpec</td>  <td><?php echo $oaiSet ?></td></tr>
<tr><td>ODN setSpec</td>  <td><?php echo $odnSet ?></td></tr>
<tr><td>Host CMS</td>  <td> <?php echo $sourceCMS ?> </td></tr>
<tr><td>WikiMedia</td><td>
<?php if ( $iiifParticipant == 'n' ) 
  {
    echo "This set is not flagged to contribute records to WikiMedia";
  } else {
    echo "This set is flagged to contribute records to WikiMedia";  
  }
?>
</td></tr>
</table>


<h4>Record Counts</h4>
<ul>

<?php

$recordcountQuery = 'select * from recordcount where odnSet="' . htmlspecialchars($sloappSet)  . '"';
$recordcountResult = $pdo->query($recordcountQuery);

while ($recordcountRow = $recordcountResult->fetch())
{
    $iiifViable = htmlspecialchars($recordcountRow['iiifViable']);
    if ( $iiifViable == '' ) { $iiifViable = 0; }
    echo '<li>IIIF-eligible records (by edm:rights):  ' .  number_format($iiifViable) . '</li>';

    $totalRecordsIncludingDeleted = htmlspecialchars($recordcountRow['recordCount']);
    if ( $totalRecordsIncludingDeleted == '' ) { $totalRecordsIncludingDeleted = 0; }
    echo '<li>Full count, including deleted records:  ' . number_format($totalRecordsIncludingDeleted) . '</li>';

    $deletedRecords = htmlspecialchars($recordcountRow['deletedRecords']);
    if ( $deletedRecords == '' ) { $deletedRecords = 0; }
    echo '<li>Deleted records:  ' . number_format($deletedRecords) . '</li>';

    echo '<li>Non-deleted records:  ' . number_format($totalRecordsIncludingDeleted-$deletedRecords) . '</li>';
}
?>
</ul>

<h4>Rights associated with this set</h4>
<ul>
<?php
    $rightsQuery = "select uri from setRights where odnSet='" . $odnSet . "'";
    $rightsResult = $pdo->query($rightsQuery);
    while ($rightsRow = $rightsResult->fetch())
    {
        $thisURI = htmlspecialchars($rightsRow['uri']);
        echo '<li><a href="/?action=list-rights&uri=' . $thisURI . '">' . $thisURI . '</a></li>';
    }
?>
</ul>
<em>Note:  Click on the edm:rights URI to find other sets also containing records with that rights URI.</em>


<h4>Harvested Files</h4>

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

  $readyForIngestFile = 'datasets/ingest/' . $sloappSet . '.xml';
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
?>

<h4>Harvest History:</h4>
<ul>

<?php

$sloappSet=$_GET['odnSet'];

$oldTasksQuery = 'select * from oldTasks where odnSet="' . $odnSet  . '" order by oldTaskTime desc';
$oldTasksResult = $pdo->query($oldTasksQuery);

while ($oldTasksRow = $oldTasksResult->fetch())
{
    $oldTaskTime = htmlspecialchars($oldTasksRow['oldTaskTime']);
    $oldTaskFullCount = htmlspecialchars($oldTasksRow['records']);
    //$totalRecordsIncludingDeleted = htmlspecialchars($recordcountRow['recordCount']);
    //echo '<li>With dels:  ' . $totalRecordsIncludingDeleted . '</li>';
    //$deletedRecords              =  htmlspecialchars($recordcountRow['deletedRecords']);
    //echo '<li>Deletes:  ' . $deletedRecords . '</li>';
    //echo '<tr><td>' . $oldTaskTime . '</td><td>' . $oldTaskFullCount . '</td></tr>';
    echo '<li>' . $oldTaskTime . ' -- ' . number_format($oldTaskFullCount) . ' records';
}
?>
</ul>
<em>Note:  old harvest entry counts migrated from REPOX contain "deleted records", while the post-REPOX entries only count records that are viable for DPLA ingest...not "deleted" records, records without required fields, records that have been explicitly removed from the DPLA feed, etc.</em>

<?php

?>

<br>
<br>


