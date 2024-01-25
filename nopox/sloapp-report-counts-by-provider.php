<!--
    sloapp-reports-by-provider.php

    This is intended to provide a basic report about
    the number of records submitted by each provider.

    The report is based around queries that use the 
    odnSet's prefix as the indicator of which provider
    submitted the data.

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

$distinctOdnSetPrefixQuery = "select distinct substring_index(odnSet, '_', 1) as tmpPrefix from recordcount order by odnSet";
$distinctOdnSetPrefixResult = $pdo->query($distinctOdnSetPrefixQuery);

echo "<table border=1>
      <tr><th>Data Provider</th><th>Submitted Records</th></tr>";
while ($distinctOdnSetPrefixRow = $distinctOdnSetPrefixResult->fetch())
{
    $odnPrefix=htmlspecialchars($distinctOdnSetPrefixRow['tmpPrefix']);

    $prefixCountContributionQuery = "select format(sum(recordCount), 0) as tmpCount from recordcount where odnSet like '" . htmlspecialchars($distinctOdnSetPrefixRow['tmpPrefix']) . "_%'" ;
    $prefixCountContributionResult = $pdo->query($prefixCountContributionQuery);

    $contributorNameQuery = "select name from provider where odnPrefix='" . $odnPrefix . "';";
    $contributorNameResult = $pdo->query($contributorNameQuery);
    $contributorNameRow = $contributorNameResult->fetch();
    $contributorName = htmlspecialchars($contributorNameRow['name']);

    while ($prefixCountContributionRow = $prefixCountContributionResult->fetch()) {
        $contributorTotalCount=htmlspecialchars($prefixCountContributionRow['tmpCount']);
    }
    echo "<tr><td>" . $contributorName . "</td><td align='right'>" . $contributorTotalCount . "</td></tr>";
}
?>
</table>
<p>boris!</p>
