The files in this directory are intended to be used to add edm:preview
values to the metadata harvested from America's Packard Museum (APM).

APM is a bizarre case.  They don't know how to put the URL for the
edm:preview into their OAI-PMH feed, so they're putting this URL
into their public-facing pages, instead.  As a result, getting the
edm:preview values into their metadata is a multi-step process.

The normal procedure for edm:preview values is to harvest metadata
via OAI-PMH, parse the metadata via XSLT, and from that parsed data
dump the edm:preview URL into <edm:preview> tags in the DPLA output.

In the case of APM, we instead do the following:

1.  Harvest the OAI-PMH metadata
2.  Setup the XSLT and map the other fields as appropriate
3.  For each record harvested, download the HTML listed in the
    record's edm:isShownAt value
4.  Parse the downloaded HTML and find the edm:preview URL
5.  Insert the newly-discovered edm:preview metadata into the
    XML we created in step 2, above
6.  Manually copy the updated XML files to $SLODATA_STAGING

There's undoubtedly a way to put the edm:preview metadata into the
OAI-PMH output, but APM is using Omeka (not CONTENTdm, where this
is done automatically) and they cannot figure out how to get the
edm:preview metadata into the OAI-PMH feed.  </dcterms:facepalm>


