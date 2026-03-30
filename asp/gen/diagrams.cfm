<cfinclude template="env.cfm">
<cfinvoke component="metadata" method="load_pdm" returnvariable="xml" pdm="#session.pdm.file#" />
<cfsavecontent variable="xsl"><cfinclude template="diagrams.xsl.cfm"></cfsavecontent>
<cfoutput>#XMLTransform(xml, xsl)#</cfoutput>
