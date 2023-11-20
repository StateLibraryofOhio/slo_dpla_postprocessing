<!--
    sloapp-org-detail.php

    This is intended to provide full details about a
    specific orgnization.

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


$providerQuery = 'select name from provider order by name';
$providerResult = $pdo->query($providerQuery);
echo "<table border=1>";
while ($providerRow = $providerResult->fetch())
{
    echo '<tr>';
    echo '<td>' . htmlspecialchars($providerRow['name']) . '</td>';
    $countSetsByProviderQuery = 'select count(*) from source where providerName="' . htmlspecialchars($providerRow['name'])  . '"';
    $countSetsByProviderResult = $pdo->query($countSetsByProviderQuery);
    $countSetsByProviderNumber = $countSetsByProviderResult->fetch();

    echo '<td>' . $countSetsByProviderNumber['count(*)'] . '</td>';
    echo '</tr>';
}

?>
</table>

