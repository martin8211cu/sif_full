
<cfset NumeroDistribuidor1 = "#NUM_DIST[1]#">
<cfset NumeroDistribuidor2 = "#NUM_DIST[2]#">
<cfset NumeroDistribuidor3 = "#NUM_DIST[3]#">
<cfset NumeroDistribuidor4 = "#NUM_DIST[4]#">
<cfset Folio1 = "#Folios[1]#">
<cfset Folio2 = "#Folios[2]#">
<cfset Folio3 = "#Folios[3]#">
<cfset Folio4 = "#Folios[4]#">




<cfoutput>

<cfset vsPath_R = "#ExpandPath( GetContextRoot() )#">
<cfif REFind('(cfmx)$',vsPath_R) gt 0> 
	<cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#"> 
<cfelse> 
	<cfset vsPath_R = "#vsPath_R#\">
</cfif>

<cfset pathF = "#vsPath_R#Enviar">
<cfif !DirectoryExists("#pathF#") >
	<cfset DirectoryCreate("#pathF#")>
</cfif>
<cfset pathF = "#pathF#\foliosPDF">
<cfif !DirectoryExists("#pathF#") >
	<cfset DirectoryCreate("#pathF#")>
</cfif>
<cfset pathF = "#pathF#\#currentFolder#">
<cfif !DirectoryExists("#pathF#") >
	<cfset DirectoryCreate("#pathF#")>
</cfif>
<cfset pathF2 = "#pathF#\barcode">
<cfif !DirectoryExists("#pathF2#") >
	<cfset DirectoryCreate("#pathF2#")>
</cfif>

<cfset Path = "../wwwroot/Enviar/foliosPDF/#currentFolder#/">
<cfset PathG = "../wwwroot/Enviar/foliosPDF/#currentFolder#/barcode/">
<cfset PathR = "../../../Enviar/foliosPDF/#currentFolder#/barcode/">

<cfdocument 
	format = "PDF"
	marginBottom = "0"
	marginLeft = "0"
	marginRight = "0"
	marginTop = "0"
	pageType = "legal"
	unit= "cm"
	filename = "#pathF#\p#Interation#.pdf"
	overwrite = "yes"
>

	<cfset font = "font-family: Verdana, Geneva, sans-serif;">
	<cfset size = "font-size: 11px;">
	<cfset letter = "#font# #size#">
	<cfset border = "border: 0px solid;">
	<cfset noBorder = "cellpadding='0' cellspacing='0'">
	<cfset lineHeight = "line-height: 30px;">
	
	<cfset componentPath = "crc.Componentes.CRCBarcodeGenerator">
	<cfset objBarcode = createObject("component","#componentPath#")>

<html>
	<head>
		<style>
			td {#letter# #border#}
			p {#lineHeight# }
		</style>
	</head>
<body style="#letter# background-image:url('images/ValesSmal.jpg');background-repeat: no-repeat;">

	<div style="#border# height: 190px;"> </div>
	<table #noborder# width="100%">
		<tr>
			<td colspan="2" align="right">
				<p>#NumeroDistribuidor1#&emsp;&emsp;</p>
			</td>
		</tr>
		<tr>
			<cfset BarcodeFolio1 = objBarcode.HTMLBarcodeTag(
						  Code="#Folio1#"
						, fileName="#Folio1#"
						, filePathGen="#PathG#"
						, filePathRead="#PathR#"
					)>
			<!--- <cfset BarcodeFolio1 = "<img src='../../crc/images/BarcodeFolio1.jpg' width='27%'>"> --->
			<td width ="50%" align="left">
				<cfif NumeroDistribuidor1 neq "">#BarcodeFolio1#</cfif>
			</td>
			<td width ="50%" align="right">
				<cfif NumeroDistribuidor1 neq "">#BarcodeFolio1#</cfif>
			</td>
		</tr>
	</table>
	<div style="#border# height: 67px;"> </div>
	<div style="#border# height: 190px;"> </div>
	<table #noborder# width="100%">
		<tr>
			<td colspan="2" align="right">
				<p>#NumeroDistribuidor2#&emsp;&emsp;</p>
			</td>
		</tr>
		<tr>
			<cfset BarcodeFolio2 = objBarcode.HTMLBarcodeTag(
						  Code="#Folio2#"
						, fileName="#Folio2#"
						, filePathGen="#PathG#"
						, filePathRead="#PathR#"
					)>
			<!--- <cfset BarcodeFolio2 = "<img src='../../crc/images/BarcodeFolio2.jpg' width='27%'>"> --->
			<td width ="50%" align="left">
				<cfif NumeroDistribuidor2 neq "">#BarcodeFolio2#</cfif>
			</td>
			<td width ="50%" align="right">
				<cfif NumeroDistribuidor2 neq "">#BarcodeFolio2#</cfif>
			</td>
		</tr>
	</table>
	<div style="#border# height: 67px;"> </div>
	<div style="#border# height: 195px;"> </div>
	<table #noborder# width="100%">
		<tr>
			<td colspan="2" align="right">
				<p>#NumeroDistribuidor3#&emsp;&emsp;</p>
			</td>
		</tr>
		<tr>
			<cfset BarcodeFolio3 = objBarcode.HTMLBarcodeTag(
						  Code="#Folio3#"
						, fileName="#Folio3#"
						, filePathGen="#PathG#"
						, filePathRead="#PathR#"
					)>
			<!--- <cfset BarcodeFolio3 = "<img src='../../crc/images/BarcodeFolio3.jpg' width='27%'>"> --->
			<td width ="50%" align="left">
				<cfif NumeroDistribuidor3 neq "">#BarcodeFolio3#</cfif>
			</td>
			<td width ="50%" align="right">
				<cfif NumeroDistribuidor3 neq "">#BarcodeFolio3#</cfif>
			</td>
		</tr>
	</table>
	<div style="#border# height: 67px;"> </div>
	<div style="#border# height: 195px;"> </div>
	<table #noborder# width="100%">
		<tr>
			<td colspan="2" align="right">
				<p>#NumeroDistribuidor4#&emsp;&emsp;</p>
			</td>
		</tr>
		<tr>
			<cfset BarcodeFolio4 = objBarcode.HTMLBarcodeTag(
						  Code="#Folio4#"
						, fileName="#Folio4#"
						, filePathGen="#PathG#"
						, filePathRead="#PathR#"
					)>
			<!--- <cfset BarcodeFolio4 = "<img src='../../crc/images/BarcodeFolio4.jpg' width='27%'>"> --->
			<td width ="50%" align="left">
				<cfif NumeroDistribuidor4 neq "">#BarcodeFolio4#</cfif>
			</td>
			<td width ="50%" align="right">
				<cfif NumeroDistribuidor4 neq "">#BarcodeFolio4#</cfif>
			</td>
		</tr>
	</table>
</body>

</html>

</cfdocument>

</cfoutput>

<cfif DirectoryExists("#pathF2#") >
	<cfdirectory action="delete" directory="#pathF2#" recurse="true">
</cfif>