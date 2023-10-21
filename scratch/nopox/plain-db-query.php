<html>

<head><title>This is dataProvider2.php</title></head>
<body>


<a id="mylink" href="http://felinet.org">Felinet</a><br>

<script>
  url = mylink.href
  document.write('The URL is ' + url + '<br><br>')
</script>

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

$providerQuery = 'select name from provider';

#$sourceQuery = 'select * from source order by providerName,description';

$providerResult = $pdo->query($providerQuery);

#$sourceResult = $pdo->query($sourceQuery);

echo '<table>';
echo '<tr><td>Name</td><td>OAI Source</td><td>Export path</td><td>OAI set</td><td>metadataFormat</td></tr>';
while ($providerRow = $providerResult->fetch())
{
  echo '<tr><td bgcolor="lightblue" colspan="10">' . htmlspecialchars($providerRow['name']) . '</td></tr>';

  $sourceQuery = "select * from source where providerName='" . $providerRow['name'] . "' order by description";
  $sourceResult = $pdo->query($sourceQuery);

  while ($sourceRow = $sourceResult->fetch())
  {
    echo '<tr>';
    echo '<td>' . htmlspecialchars($sourceRow['description']) . '</td>';
    echo '<td>' . htmlspecialchars($sourceRow['oaiSource']) . '</td>';
    echo '<td>' . htmlspecialchars($sourceRow['exportDirPath']) . '</td>';
    echo '<td>' . htmlspecialchars($sourceRow['oaiSet']) . '</td>';
    echo '<td>' . htmlspecialchars($sourceRow['metadataFormat']) . '</td>';
    echo '</tr>';

  }
  echo '<tr><td colspan="10">&nbsp;</td></tr>';
}
echo '</table>';
?>

</body></html>
