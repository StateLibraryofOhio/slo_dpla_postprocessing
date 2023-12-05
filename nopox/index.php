<!DOCTYPE html>
<html>
<!--
index.php

This application will be used as a UI for work related to
DPLA harvesting by the Ohio Digital Network.

This file will perform a variety of actions based on the 
parameters that are sent in the URL used to retrieve it.

e.g   http://servername/index.php?action=home

-->

<head>
  <title>Ohio Digital Network metadata management</title>
  <style>@import url('nopox.css')</style>
</head>
<body>
<!-- 

-->
<?php include "sloapp-header.php"?>
<?php include "sloapp-base-application.php"?>

<?php 
    $sloappAction=$_GET['action'];

    if ($sloappAction == "home") {
       include "sloapp-home.php";
    }
    elseif ($sloappAction == "orgs") {
       include "sloapp-orgs.php";
    }
    elseif ($sloappAction == "org-detail") {
       $sloappProvider=$_GET['provider'];
       include "sloapp-org-detail.php";
    }
    elseif ($sloappAction == "collections") {
       include "sloapp-set-full-list.php";
    }
    elseif ($sloappAction == "set-detail") {
       include "sloapp-set-detail.php";
    }
    elseif ($sloappAction == "set-add") {
       include "sloapp-set-add.php";
    }
    elseif ($sloappAction == "reports") {
       include "sloapp-reports.php";
    }
    elseif ($sloappAction == "transforms") {
       include "sloapp-transform-full-list.php";
    }
    elseif ($sloappAction == "transform-detail") {
       $sloappTransform=$_GET['transform'];
       include "sloapp-transform-detail.php";
    }
    elseif ($sloappAction == "notYet") {
       include "sloapp-notYet.php";
    }
    elseif ($sloappAction=="list-rights") {
       include "sloapp-list-by-rights.php";
    }
    elseif ($sloappAction=="list-all-rights") {
       include "sloapp-rights-full-list.php";
    }
    elseif ($sloappAction=="list-harvests") {
       include "sloapp-list-harvests.php";
    }
    elseif ($sloappAction=="count-sets-by-org") {
       include "sloapp-list-set-counts-by-org.php";
    }
    elseif ($sloappAction=="list-providers-by-cms") {
       include "sloapp-list-providers-by-CMS.php";
    }
    elseif ($sloappAction=="list-iiif-counts") {
       include "sloapp-list-iiif-counts.php";
    }
    elseif ($sloappAction=="doc-base") {
       include "doc/doc-base.php";
    }
    else {
       include "sloapp-home.php";
       error_log("Unknown directive received: " . $sloappAction . ";  Redirecting to home tab");
    }
?>

<?php include "sloapp-footer.php"?>
</body>
</html>
