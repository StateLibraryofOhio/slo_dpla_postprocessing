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
    echo '<p>metadataPrefix: ' . htmlspecialchars($sourceRow['metadataFormat']) . '</p>';
    echo '<p>odnSet:         ' . htmlspecialchars($sourceRow['odnSet']) . '</p>';
    echo '<p>oaiSource:      ' . htmlspecialchars($sourceRow['oaiSource']) . '</p>';
    echo '<p>oaiSet:         ' . htmlspecialchars($sourceRow['oaiSet']) . '</p>';
    echo '<p>sourceSchema:   ' . htmlspecialchars($sourceRow['sourceSchema']) . '</p>';
    echo '<p>lastIngest:     ' . htmlspecialchars($sourceRow['lastIngest']) . '</p>';
    echo '<p>status:         ' . htmlspecialchars($sourceRow['status']) . '</p>';
    echo '<p>typeOfSource:   ' . htmlspecialchars($sourceRow['typeOfSource']) . '</p>';
    echo '<p>exportDirPath:  ' . htmlspecialchars($sourceRow['exportDirPath']) . '</p>';
    echo '<p>recordIdPolicyType: ' . htmlspecialchars($sourceRow['recordIdPolicyType']) . '</p>';
    echo '<p>sourcesDirPath: ' . htmlspecialchars($sourceRow['sourcesDirPath']) . '</p>';
    echo '<p>retrieveStrategy: ' . htmlspecialchars($sourceRow['retrieveStrategy']) . '</p>';
    echo '<p>fileExtract: ' . htmlspecialchars($sourceRow['fileExtract']) . '</p>';
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

$recordcountQuery = 'select * from recordcount where dataSourceId="' . htmlspecialchars($sloappSet)  . '"';

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
//$oldTasksQuery = 'select * from oldTasks where dataSourceSet="' .  . '"';

?>

<br>
<br>

