<!--
    sloapp-orgs.php

    This simply enumerates every organization contributing
    records to DPLA via ODN.
    
    Organizations will be individually hyperlinked to pages
    with more details about the organization.
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

$providerQuery = 'select * from provider order by name';

#$sourceQuery = 'select * from source order by providerName,description';

$providerResult = $pdo->query($providerQuery);

#$sourceResult = $pdo->query($sourceQuery);
echo "<ul>";
while ($providerRow = $providerResult->fetch())
    {
    echo '<li><a href="./?action=org-detail&provider=' . htmlspecialchars($providerRow['name']) . '">' . htmlspecialchars($providerRow['name']) . '</a></li>';


//  $sourceQuery = "select * from source where providerName='" . $providerRow['name'] . "' order by description";
//  $sourceResult = $pdo->query($sourceQuery);

//  while ($sourceRow = $sourceResult->fetch())
//  {
//    echo '<tr>';
//    echo '<td>' . htmlspecialchars($sourceRow['description']) . '</td>';
//    echo '<td>' . htmlspecialchars($sourceRow['oaiSource']) . '</td>';
//    echo '<td>' . htmlspecialchars($sourceRow['exportDirPath']) . '</td>';
//    echo '<td>' . htmlspecialchars($sourceRow['oaiSet']) . '</td>';
//    echo '<td>' . htmlspecialchars($sourceRow['metadataFormat']) . '</td>';
//    echo '</tr>';

  
}
?>

