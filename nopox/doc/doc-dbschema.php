<p>The database schema was derived from the REPOX configuration.  REPOX worked very differently, but the underlying idea is similar.</p>

<p>Some of the tables / fields listed below are unused.  This is due to the fact that some underlying functionality is not implemented, but having that functionality might be useful and the REPOX-derived structure could help with an implementation, should we choose to pursue it.</p>

<h3>dataSourceState</h3>

<p>This table is intended for use in locking a dataset during a harvest to ensure that multiple harvests of the same dataset aren't running concurrently.  Given that I'm the only user, this isn't a major issue, and I have no plans to implement this functionality in the near future.</p>

<br>


<h3>metadataSchemaVersions</h3>

<p>This table is intended for use in keeping track of the metadata schemas.  This functionality was far more important in REPOX than in this application, and I'm unlikely to implement something similar in the near term, if at all.</p>

<br>


<h3>metadataSchemas</h3>

<p>This table is used for keeping track of details about metadata schemas.  The OAI-PMH harvest requires that you provide a metadataPrefix as part of the harvest (e.g. "oai_qdc", "qdc", "oclc_dc") and this table allows us to get the URI which corresponds to these metadataPrefixes.  This information is used when working with the raw/archivized data.</p>

<br>


<h3>metadataTransformation</h3>

<p>This table is used to store details about the dataset which are used in the XSLT base transform to make the incoming metadata comply with the standards that ODN has for submitted data.</p>

<br>



<h3>oldTasks</h3>

<p>Harvests of the contributors' datasets result in log entries being added to this table to list the date/time of the harvest, number of records harvested.</p>

<br>


<h3>provider</h3>

<p>Organizations that contribute collections for harvesting are listed in this table.</p>

<br>


<h3>providerContact</h3>

<p>This table is not currently used.  It was created with the intention of keeping track of folks at various sites, but given that Penelope tends to work with the users and data-entry for this app is all SQL-based and not web-based, I'm not sure whether/how to implement this.</p>

<br>


<h3>recordcount</h3>

<p>This table is used</p>

<br>


<h3>scheduledTasks</h3>

<p></p>

<br>


<h3>setRights</h3>

<p></p>

<br>


<h3>source</h3>

<p></p>

<br>


<h3>username</h3>

<p></p>

<br>


