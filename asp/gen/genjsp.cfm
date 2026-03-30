<cfinclude template="env.cfm" >
<cfinvoke component="metadata" method="tabla_struct" pdm="#session.pdm.file#" tabla="#url.code#" returnvariable="metadata">



<!--- Generar el JSP para mostrar el formulario --->
<cfsavecontent variable="genForm"><cfinclude template="genjsp-formcfm.cfm"></cfsavecontent>

<!--- Generar el JSP para mostrar la lista e incluir el formulario --->
<cfsavecontent variable="genList"><cfinclude template="genjsp-listcfm.cfm"></cfsavecontent>

<!--- Generar el JSP para aplicar cambios --->
<cfsavecontent variable="genApply"><cfinclude template="genjsp-apply.cfm"></cfsavecontent>

<!---
<cfoutput><xmp>#genApply#</xmp></cfoutput>
<cfabort>
--->

<!--- path extrae la ruta para generar el programa --->
<cfset path = ExpandPath( session.pdm.path )>

<cffile action="write" file="#path#/#url.code#.cfm"       output="#genList#"  mode="644">
<cffile action="write" file="#path#/#url.code#-form.cfm"  output="#genForm#"  mode="644">
<cffile action="write" file="#path#/#url.code#-apply.cfm" output="#genApply#" mode="644">

<cfoutput><table style="border:solid 1px">
	<tr><td>
		<a href="/cfmx#session.pdm.path#/#url.code#.cfm" target="_blank">
		#url.code#.cfm</a>: #Len(genList)# bytes
	</td></tr>
	<tr><td>
		<a href="/cfmx#session.pdm.path#/#url.code#-form.cfm" target="_blank">
		#url.code#-form.cfm</a>: #Len(genForm)# chars
		</td></tr>
	<tr><td>
		<a href="/cfmx#session.pdm.path#/#url.code#-apply.cfm" target="_blank">
		#url.code#-apply.cfm</a>: #Len(genApply)# chars
		</td></tr>
</table>
</cfoutput>