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

$sloappProvider=$_GET['provider'];

$providerQuery = 'select * from provider where name="' . htmlspecialchars($sloappProvider)  . '"';
$providerResult = $pdo->query($providerQuery);

while ($providerRow = $providerResult->fetch())
{
    echo '<h2>' . htmlspecialchars($providerRow['name']) . '</h2>';
    //echo '<p>description:  ' . htmlspecialchars($providerRow['description']) . '</p>';
    //echo '<p>idRepox:      ' . htmlspecialchars($providerRow['idRepox']) . '</p>';
    //echo '<p>localkey:     ' . htmlspecialchars($providerRow['localkey']) . '</p>';
    $sourceQuery = 'select * from source where providerName="' . htmlspecialchars($providerRow['name'])  . '" order by description';
}

?>


<h3>Misc. organization details:</h3>
<ul>
<?php

// get a count of all sets submitted by this organization
$countSetsByProviderQuery = 'select count(*) from source where providerName="' . htmlspecialchars($sloappProvider)  . '"';
$countSetsByProviderResult = $pdo->query($countSetsByProviderQuery);
$countSetsByProviderNumber = $countSetsByProviderResult->fetch();

echo "<li>Total number of sets submitted:   " . $countSetsByProviderNumber['count(*)'] . "</li>";


// find and display recordcount of the largest set, if there's more than 1 set
if ( $countSetsByProviderNumber['count(*)'] > 1 ) {
  $biggestSetByProviderQuery = 'select max(recordCount) from recordcount where odnSet in (select odnSet from source where providerName="' . htmlspecialchars($sloappProvider)  . '")';
  $biggestSetByProviderResult = $pdo->query($biggestSetByProviderQuery);
  $biggestSetByProviderNumber = $biggestSetByProviderResult->fetch();
  echo "<li>Largest set:  " . number_format($biggestSetByProviderNumber['max(recordCount)']);
  // get the set description from the source table in a somewhat backwards fashion, and
  // one that's prone to failure if multiple sets have the same recordcount
  $biggestSetByProviderNameQuery = 'select description from source where odnSet=(select odnSet from recordcount where recordCount="' . $biggestSetByProviderNumber['max(recordCount)'] . ' limit 1")';
  $biggestSetByProviderNameResult = $pdo->query($biggestSetByProviderNameQuery);
  $biggestSetByProviderNameRow = $biggestSetByProviderNameResult->fetch();
  echo ' records  ("' . $biggestSetByProviderNameRow['description']  . '")</em></li>';
}


// get a count of all records submitted by this organization
$countRecordsByProviderQuery = 'select sum(recordCount) from recordcount where odnSet in (select odnSet from source where providerName="' . htmlspecialchars($sloappProvider)  . '")';
$countRecordsByProviderResult = $pdo->query($countRecordsByProviderQuery);
$countRecordsByProviderNumber = $countRecordsByProviderResult->fetch();

echo "<li>Total number of records submitted:  " . number_format($countRecordsByProviderNumber['sum(recordCount)'])  . "</li>";

?>
</ul>

<h3>Submitted sets:</h3>

<?php
$sourceResult = $pdo->query($sourceQuery);

echo '<table>';
echo '<th>Set Name</th><th>Record Count</th><th>Last Harvested</th><th>ODN setSpec</th></th>';
  while ($sourceRow = $sourceResult->fetch())
  {
    echo '<tr>';
    echo '<td><a href="?action=set-detail&odnSet=' . htmlspecialchars($sourceRow['odnSet']) . '">' . htmlspecialchars($sourceRow['description']) . '</a></td>';

    $setRecordcountQuery = 'select * from recordcount where odnSet="' . htmlspecialchars($sourceRow['odnSet']) . '"';
    $setRecordcountResult = $pdo->query($setRecordcountQuery);
    $setRecordcountResultAsArray =  $setRecordcountResult->fetch();
    echo '<td>' . number_format(htmlspecialchars($setRecordcountResultAsArray['recordCount'])) . '</td>';
    //echo '<td>' . htmlspecialchars($sourceRow['providerName']) . '</td>';
    $lastIngestDate = preg_split('/\s/', htmlspecialchars($sourceRow['lastIngest']));
    echo '<td class="td-displayDate">' . $lastIngestDate[0] . '</td>';
    echo '<td>' . htmlspecialchars($sourceRow['odnSet']) . '</td>';
    echo '</tr>';
  }
echo '</table>';

?>


<!-- There are currently no "Contacts" in REPOX, because (as far as I can tell) it's
     not possible to add them -- or display them -- in the REPOX UI.

     Leaving this here as a reminder that the table is in place in MySQL to hold the
     Contact data, although I think it needs to have one or two columns added to it
     in order to improve the joins between it and the provider table (and others?)

     Note when adding Contacts:  Do we want to allow Contacts who are not tied to a
     current site?  "Alumni" who worked on site and moved on, perhaps?

     Also, record type of contacts?  Cataloger vs. technical vs. management?
 -->
<h3>Site contacts:</h3>
<p>Not yet implemented.  Sorry.</p>
<br>

