<!--
    sloapp-transform-detail.php

    This is intended to provide full details about a
    metadata transformation.

    Details will be drawn from multiple tables, and 
    will (eventually) include associated contacts,
    the datasets contributed by the site, details 
    from the provider table (some of which may only
    have been relevant to the REPOX code), etc.
-->
<?php

//
// sloapp-org-detail.php
//

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

//$providerQuery = 'select name from provider order by name';

$metadataTransformationQuery = 'select * from metadataTransformation where odnSet="' . htmlspecialchars($sloappSet)  . '"';

//$providerResult = $pdo->query($providerQuery);

$metadataTransformationResult = $pdo->query($metadataTransformationQuery);
// while ($Row = $providerResult->fetch())
//  {
  
//  echo '<li>' . htmlspecialchars($providerRow['name']) . '</li>';

//  $sourceQuery = "select * from source where providerName='" . $providerRow['name'] . "' order by description";
//  $sourceResult = $pdo->query($sourceQuery);
echo '<h3>Transform details</h3>';
while ($metadataTransformationRow = $metadataTransformationResult->fetch())
{
    echo '<p>editable:         ' . htmlspecialchars($metadataTransformationRow['editable']) . '</p>';
    echo '<p>version:  ' . htmlspecialchars($metadataTransformationRow['version']) . '</p>';
    echo '<p>odnSet:      ' . htmlspecialchars($metadataTransformationRow['odnSet']) . '</p>';
    echo '<p>localkey:     ' . htmlspecialchars($metadataTransformationRow['localkey']) . '</p>';
    echo '<p>description:  ' . htmlspecialchars($metadataTransformationRow['description']) . '</p>';
    echo '<p>sourceFormat:  ' . htmlspecialchars($metadataTransformationRow['sourceFormat']) . '</p>';
    echo '<p>destinationFormat:  ' . htmlspecialchars($metadataTransformationRow['destinationFormat']) . '</p>';
    echo '<p>stylesheet:  ' . htmlspecialchars($metadataTransformationRow['stylesheet']) . '</p>';
    echo '<p>sourceSchema:  ' . htmlspecialchars($metadataTransformationRow['sourceSchema']) . '</p>';
    echo '<p>destSchema:  ' . htmlspecialchars($metadataTransformationRow['destSchema']) . '</p>';
    echo '<p>destNamespace:  ' . htmlspecialchars($metadataTransformationRow['destNamespace']) . '</p>';


    // $sourceQuery = 'select * from source where providerName="' . htmlspecialchars($providerRow['name'])  . '" order by description';
}
//}
?>
<br>



