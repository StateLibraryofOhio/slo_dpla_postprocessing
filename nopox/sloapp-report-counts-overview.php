<!--
    sloapp-report-counts-overview.php

    This is intended to provide a basic report about
    the number of records submitted by each provider,
    the largest collection, the largest provider, and
    the total number of sets being harvested.

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

# note:  These potentially contain records without rights values

$totalRecordCountIncludingRightslessQuery = 'select sum(recordCount-deletedRecords) as nonDeletedRecords from recordcount';
$totalRecordCountIncludingRightslessResult = $pdo->query($totalRecordCountIncludingRightslessQuery);

$totalRecordCountIncludingRightslessRow = $totalRecordCountIncludingRightslessResult->fetch();
$totalRecordCountIncludingRightsless = $totalRecordCountIncludingRightslessRow['nonDeletedRecords'];

echo "<em>(Note that the numbers listed here may include records without rights values, with the exception of IIIF counts, which by definition must have edm:rights metadata.)</em></p>";


echo "<p>Grand total of all records from all collections:  " . number_format($totalRecordCountIncludingRightsless) . "</p>";


# determine how many records contain IIIF data and are enrolled in the
# wikimedia project.
# by definition, these all contain rights values
$totalIiifCountQuery = "select sum(iiifViable) as iiifCount from recordcount where odnSet in (select odnSet from source where iiifParticipant='y')";
$totalIiifCountResult = $pdo->query($totalIiifCountQuery);
$totalIiifCount = $totalIiifCountResult->fetch();

echo "<p>Records that include IIIF metadata:  " . number_format($totalIiifCount['iiifCount']) . "</p>" ;


# determine which is the largest collection

$largestCollectionQuery = 'select odnSet, recordCount-deletedRecords as size from recordcount order by size desc';
$largestCollectionResult = $pdo->query($largestCollectionQuery);
$largestCollection = $largestCollectionResult->fetch();

$largestCollectionOdnSet = $largestCollection['odnSet'];
$largestCollectionSize = $largestCollection['size'];

$setDetailsQuery = "select description, providerName from source where odnSet='" . $largestCollectionOdnSet . "'";
$setDetailsResult = $pdo->query($setDetailsQuery);
$setDetailsRow = $setDetailsResult->fetch();
$setDetailsName = $setDetailsRow['description'];
$setDetailsProviderName = $setDetailsRow['providerName'];

echo "<p>Largest collection contributed:</p>";
echo "<ul>";
echo "<li>$setDetailsName</li>";
echo "<li>" . number_format($largestCollectionSize) . " records</li>";
echo "<li>by " . $setDetailsProviderName . "</li>";
echo "</ul>";



$checkval = 0;
$checkorg = '';

$distinctOdnSetPrefixQuery = "select distinct substring_index(odnSet, '_', 1) as tmpPrefix from recordcount order by odnSet";
$distinctOdnSetPrefixResult = $pdo->query($distinctOdnSetPrefixQuery);

while ($distinctOdnSetPrefixRow = $distinctOdnSetPrefixResult->fetch())
{
    $odnPrefix=htmlspecialchars($distinctOdnSetPrefixRow['tmpPrefix']);

    $prefixCountContributionQuery = "select sum(recordCount) as tmpCount from recordcount where odnSet like '" . $distinctOdnSetPrefixRow['tmpPrefix'] . "_%'" ;
    $prefixCountContributionResult = $pdo->query($prefixCountContributionQuery);
    while ($prefixCountContributionRow = $prefixCountContributionResult->fetch()) {
        $contributorTotalCount=htmlspecialchars($prefixCountContributionRow['tmpCount']);
    }

    if (intval($contributorTotalCount) >= intval($checkval)) {
        $checkval = $contributorTotalCount;
        $checkorg = $odnPrefix;
    }
}

$providerNameQuery = "select providerName from source where odnSet like '" . $checkorg . "_%'";
$providerNameResult = $pdo->query($providerNameQuery);
$providerNameRow = $providerNameResult->fetch();
$providerName = $providerNameRow['providerName'];
echo "<p>Biggest contributor:  <ul><li>" . $providerName . "</li><li>" . number_format($checkval) . " records.</li></ul>";


# how many providers?
$providerCountQuery = "select count(*) as providerCount from provider";
$providerCountResult = $pdo->query($providerCountQuery);
$providerCountRow = $providerCountResult->fetch();
$providerCount = $providerCountRow['providerCount'];
echo "<p>There are " . $providerCount . " providers in the system.</p><br>";


# enumerate the number of records per provider for all providers

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
