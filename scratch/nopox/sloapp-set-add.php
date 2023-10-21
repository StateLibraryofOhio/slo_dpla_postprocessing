<!--
    sloapp-set-add.php

    This is intended to create a new dataset in the application.
-->
<?php

require_once 'login.php';

echo '<h3>Welcome.  You can add a new dataset here.</h3>';

// connect using the login options from login.php
try 
{
    $pdo = new PDO($attr, $user, $pass, $opts);
}
catch ( PDOException $e)
{
    throw new PDOException($e->getMessage(), (int)$e->getCode());
}

echo <<<_EOF
<form action="" method="post">
  <h3>Data Set</h3> <br>
        oai-URL <input type="text" name="oai-url" size="">&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" value="Check Server"><br>
        OAI set (oaiSet) <input type="text" name="oai-set" size=""><br>
        metadata format <input type="text" name="metadata-format" size=""><br>
        schema version <input type="text" name="schema-version" size=""><br>
        schema <input type="text" name="schema" size=""><br>
        metadata namespace <input type="text" name="metadata namespace" size=""><br>
        export path <input type="text" name="" size="export path"><br>
        is sample? <input type="text" name="" size="is-sample"><br>
        
      <h3>Output</h3>
        Record set (odnSet) <input type="text" name="set" size=""><br>
        Description <input type="text" name="" size="description"><br>
        Tags (unused) <input type="text" name="" size="tags"><br>
        Transformations <input type="text" name="" size="transforms"><br>
      <br>
      <input type="submit" value="Add Set">
_EOF


?>

