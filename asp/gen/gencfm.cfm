<cfinclude template="env.cfm" >
<cfinvoke component="metadata" method="tabla_struct" pdm="#session.pdm.file#" tabla="#url.code#" returnvariable="metadata">

<!--- Generar el CFM para mostrar el formulario --->
<cfsavecontent variable="genForm"><cfinclude template="gen-form.cfm"></cfsavecontent>

<!--- Generar el CFM para mostrar la lista e incluir el formulario --->
<cfsavecontent variable="genList"><cfinclude template="gen-list.cfm"></cfsavecontent>

<!--- Generar el CFM para aplicar cambios --->
<cfsavecontent variable="genApply"><cfinclude template="gen-apply.cfm"></cfsavecontent>

<!--- Generar el CFC del componente --->
<cfsavecontent variable="genCfc"><cfinclude template="gen-cfc.cfm"></cfsavecontent>

<!--- Generar el CFM para descargar campos image.  Requiere de funciones definidas en gen-cfc.cfm --->
<cfsavecontent variable="genDownload"><cfinclude template="gen-download.cfm"></cfsavecontent>

<!--- path extrae la ruta para generar el programa --->
<cfset path = ExpandPath( session.pdm.path )>

<!---
	El BOM es 0xfeff , pero en UTF-8 se ve como ef bb bf
--->
<cfset Byte_Order_Marker = BinaryDecode('efbbbf', 'Hex')>
<cffile action="write" file="#path#/#url.code#.cfm"       output="#Byte_Order_Marker#"  mode="644" >
<cffile action="write" file="#path#/#url.code#-form.cfm"  output="#Byte_Order_Marker#"  mode="644" >
<cffile action="write" file="#path#/#url.code#-apply.cfm" output="#Byte_Order_Marker#" mode="644" >
<cffile action="write" file="#path#/#url.code#.cfc" output="#Byte_Order_Marker#" mode="644" >
<cffile action="write" file="#path#/#url.code#-download.cfm" output="#Byte_Order_Marker#" mode="644" >

<cffile action="append" file="#path#/#url.code#.cfm"       output="#genList#"  mode="644" charset="utf-8">
<cffile action="append" file="#path#/#url.code#-form.cfm"  output="#genForm#"  mode="644" charset="utf-8">
<cffile action="append" file="#path#/#url.code#-apply.cfm" output="#genApply#" mode="644" charset="utf-8">
<cffile action="append" file="#path#/#url.code#.cfc" output="#genCfc#" mode="644" charset="utf-8">
<cffile action="append" file="#path#/#url.code#-download.cfm" output="#genDownload#" mode="644" charset="utf-8">

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
	<tr><td>
		<a href="/cfmx#session.pdm.path#/#url.code#.cfc" target="_blank">
		#url.code#.cfc</a>: #Len(genCfc)# chars
		</td></tr>
	<tr><td>
		<a href="/cfmx#session.pdm.path#/#url.code#-download.cfm" target="_blank">
		#url.code#-download.cfm</a>: #Len(genDownload)# chars
		</td></tr>
</table>
</cfoutput>