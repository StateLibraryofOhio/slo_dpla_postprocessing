<!--
    sloapp-transform-full-list.php

    This simply lists every XSLT tranform registered 
    in the system.
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

$metadataTransformationQuery = 'select * from metadataTransformation order by description';

//$providerResult = $pdo->query($providerQuery);

$metadataTransformationResult = $pdo->query($metadataTransformationQuery);
// while ($Row = $providerResult->fetch())
//  {
  
//  echo '<li>' . htmlspecialchars($providerRow['name']) . '</li>';

//  $sourceQuery = "select * from source where providerName='" . $providerRow['name'] . "' order by description";
//  $sourceResult = $pdo->query($sourceQuery);
echo '<table>';
  while ($metadataTransformationRow = $metadataTransformationResult->fetch())
  {
    echo '<tr>';
    echo '<td><a href="?action=transform-detail&odnSet=' . htmlspecialchars($metadataTransformationRow['odnSet']) . '">' . htmlspecialchars($metadataTransformationRow['description']) . '</a></td>';
    echo '<td>' . htmlspecialchars($metadataTransformationRow['sourceFormat']) . ' | ';
    echo htmlspecialchars($metadataTransformationRow['destinationFormat']) . '</td>';
    echo '<td><a href="?action=transform-detail&odnSet=' . htmlspecialchars($metadataTransformationRow['odnSet']) . '">' . htmlspecialchars($metadataTransformationRow['stylesheet']) . '</a></td>';
    echo '</tr>';
  }
echo '</table>'; 
//}
?>

