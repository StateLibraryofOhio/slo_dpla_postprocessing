<!--
    sloapp-list-iiif-counts.php

    This is intended to provide a basic report about
    which sets have records that qualify for WikiMedia
    inclusion, and how many such records are available
    in that set.

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

echo "<p>Sets with a <span style='background-color:#add8e6'>blue background</span> ARE contributing records to the WikiMedia project</p>";
//$recordcountQuery = "select * from recordcount where odnSet in (select odnSet from source where iiifParticipant != 'y') and iiifViable != '0' order by odnSet";

$recordcountQuery = "select * from recordcount where iiifViable != '0' order by odnSet";
$recordcountResult = $pdo->query($recordcountQuery);
echo "<table border=1>
      <th>Data Provider</th><th>Set name</th><th>Full Count</th><th>Eligible for WikiMedia</th></tr>";
while ($recordcountRow = $recordcountResult->fetch())
{
    $sourceQuery  = "select * from source where odnSet='" . htmlspecialchars($recordcountRow['odnSet']) . "'";
    $sourceResult = $pdo->query($sourceQuery);
    $sourceRow = $sourceResult->fetch();
    $rowHighlight = '';
    if ( htmlspecialchars($sourceRow['iiifParticipant']) == 'y' ) {
        $rowHighlight = 'style="background-color:#add8e6"';
    }
    echo '<tr ' . $rowHighlight   . '>';
    echo '<td>' . htmlspecialchars($sourceRow['providerName']) . '</td>';
    echo '<td>' . htmlspecialchars($sourceRow['description']) . '</td>';
    echo '<td>' . number_format(htmlspecialchars($recordcountRow['recordCount'])) . '</td>';
    echo '<td>' . number_format(htmlspecialchars($recordcountRow['iiifViable'])) . '</td>';
    echo '</tr>';
}

?>
</table>

