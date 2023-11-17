<!--
    sloapp-list-providers-by-CMS.php

    This is intended as a brief report showing which providers
    are using which Content Management Systems.

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


$sourceQuery = 'select distinct providerName, sourceCMS from source order by providerName, sourceCMS';
$sourceResult = $pdo->query($sourceQuery);
echo "<table border=1>";
while ($sourceRow = $sourceResult->fetch())
{
    echo '<tr>';
    echo '<td>' . htmlspecialchars($sourceRow['providerName']) . '</td>';
    echo '<td>' . htmlspecialchars($sourceRow['sourceCMS']) . '</td>';
    echo '</tr>';
}

?>
</table>

