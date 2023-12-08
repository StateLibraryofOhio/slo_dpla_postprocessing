<h3>Creating XSLT files for a dataset</h3>

<p>Data is retrieved from a remote provider's server.  When received, the XML may contain the metadata in any variety of elements.  The metadata needs to be pulled from the XML we've received, and put into a new XML format that adheres to the <a href="https://ohiodigitalnetwork.org/contributors/getting-started/map/">Ohio Digital Network's mappings</a>.  The transmogrification from the sending format to the ODN format is accomplished by running the "archivized" XML through an XSLT stylesheet.</p>

<p>Every dataset has at least one XSLT stylesheet.  This XSLT will perform the aforementioned transmogrification, making the incoming data conform to our standard.</p>

<p>A few datasets have an additional XSLT stylesheet.  This secondary XSLT file will be run against the data after it has been transformed to meet the ODN standard, and it will "filter" additional records from the set, if needed.  For a few datasets, additional restrictions on the records are needed.  OSU, for example, has submitted a dataset in which records with the following settings must be removed from the batch before upload to DPLA:<p>

<ul>
  <li>dcterms:creator == "Michaels, Larry R."</li>
  <li>dcterms:type == "Sound"</li>
  <li>dcterms:contributor == "Cervantes Saavedra, Miguel de, 1547-1616"</li>
</ul>

<p>Thus, in addition to the "base" XSLT for OSU which makes their data conform to our standard, a subsequent XSLT file is used to completely remove the records with these values from the dataset as it's prepared for upload.</p>

<p>Generally speaking this second "filter" transform isn't needed, as most submitted datasets are intended to be completely uploaded to DPLA.</p>

<hr>

<p>The starting point for an XSLT transform is the file $SLODPLA_LIB/00_STARTINGPOINT-COLL.xsl.  When you use the "addset.sh" script to create a new set in the system, that XSLT file will be copied to the system's "$SLODPLA_LIB/bySet/base-transform" directory (being renamed appropriately in the process.)  You will then need to customize that newly-created file.</p>

<p>At an absolute minimum, you MUST change at least the following settings in the file:</p>

<ul>
  <li>THIS_PROVIDER_NAME - The name of the organization contributing the data</li>
  <li>THIS_COLLECTION_NAME - The name of the collection being contributed</li>
</ul>


<p>You will probably need to do more than this.</p>


<hr>

<p>The base XSLT transforms all contain a line which reads:</p>

<p>&nbsp;&nbsp;&nbsp;&nbsp; xsl:include href="odn_templates.xsl"</p>

<p>This loads the default rules for the mappings, which are found in the $SLODPLA_LIB/bySet/base-transform/odn_templates.xsl file.  These default rules are applied whenever an apply-templates rule has a "mode" of "odn".</p>

<p>If we decide that we like most of the rules loaded from odn_templates.xsl, but we wish to override the template for the dc:title mapping, then we can change the "mode" to something unique (I use the odnSet value for the set as the XSLT "mode", thereby ensuring that it'll be unique among sets) and create a new template in the set-specific XSLT stylesheet with that local "mode" value.</p>

<p>If you are altering the default behavior for an element, then it's often easiest to copy the code from the odn_templates.xsl file into your set-specific XSLT file for use as a starting point.</p>



<hr>

<p>If you are not working with a CONTENTdm server, then you will probably need to update the section of the file which reads:</p>

<p>&nbsp;&nbsp;&nbsp;&nbsp;   xsl:template match="//oai_qdc:qualifieddc"</p>

<p>The default value is fine for CONTENTdm (our most commonly-used CMS) but other systems may structure their XML slightly differently.</p>

<p>If this is not setup correctly, then the transformed data will contain no records.  That "match" statement is basically saying "Search through the XML file for any XML entities named 'oai_qdc:qualifieddc' and perform the following operations on their contents."</p>

<p>If you examine the raw (or archivized) output for any CONTENTdm server's OAI-PMH output, you'll find that the "metadata" elements contain "oai_qdc:qualifieddc" elements which, in turn, contain the actual metadata we want to harvest.  In comparison, if you examine the output from Case Western's server, you'll see that the "metadata" elements contain "oai_dc:dc" elements, instead, and the XSLT would need to be edited to match those elements, instead.</p>

<p>Additionally, if the server is not running CONTENTdm, then you will need to alter the default behavior of the dc:identifier XSLT transform.  The default rules create edm:preview values based on the dc:identifier value; This produces a valid value for a CONTENTdm server, but not for other servers.</p>



<hr>

<p>Check all of the XML elements being sent in the XML you're working with; Are they handled by your XSLT?  If there are XML elements that aren't handled, it can leave your XML a mangled mess, with metadata not enclosed in XML tags.</p>

<p>Hint:  Use "xmllint --format" to ensure formatting is OK.  Output from "xmllint --format" should dump XML to screen (or file) with one element per line, but the formatting breaks if the XML isn't valid.  If there are adjoining greater-than and less-than characters, then that's an indication that there are XML elements on the same line and something is wrong.</p>

<hr>

<p>Check the transformed XML for empty elements and remove any you find via your XSLT.  The elements are probably empty because there are values with subfields (semicolon-delimited) and one or more fields have a trailing semicolon, which in conjunction with a "tokenize()" function, is resulting in their creation.</p>


<hr>

<p>Check all included metadata:  Are there subfields (probably semicolon-delimited) that must be broken out into separate XML elements?</p>

<hr>

<p>Check the metadata for HTML.  It's ugly, and should be removed when it can be done easily.  The characters have been changed to html entities such as &amp;amp; and be relatively easily spotted by grepping for semicolons (although there's a lot of other stuff that comes up which isn't HTML).</p>

<hr>

<p>Ensure that every record has a value for all required fields.  In particular, edm:rights, edm:isShownAt.</p>

<p>If there are records without edm:rights URIs, then you should send the edm:isShownAt values for all affected records to Penelope so that the contributor can update the records with these details.  Having the edm:isShownAt values for the affected records makes it easy for the provider to find and fix the records.</p>

<p>You can get the edm:isShownAt values from a transformed dataset via XSLT:<p>

<p>&nbsp;&nbsp;&nbsp;&nbsp;java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/show-rightsless.xsl -s:INPUT.xml | sort | uniq<p>

<hr>

<p>Ensure that date values such as "1989-01-05T08:00:00Z" are changed to something more eye-friendly like "1989-01-05"</p>

<hr>





























