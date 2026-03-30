<cfinclude  template="formDescargaXMLSATD-query.cfm">
<cfset dateNow = LSdateFormat(Now(),'ddmmyyyy')>
<cf_foldersFacturacion name = "ruta">
<cfset vsPath_A = ruta>
<cfset rutaDirTmp = '#vsPath_A#/DescargasXMLZip'>



	<cfloop  query="rsXML">

		<cftry>
			<!--- Lee el xml desde la tabla--->
			<cfset myXML = xmlParse(#XML#)>

			<!--- Crea archivo xml y lo guarda en un directorio temporal--->
			<cffile action="write" file= "#rutaDirTmp#/#UUID#.xml" output="#myXML#">

			<cfcatch type="any">
				<cfset error = true>
				<cfset number_error = 1>
			</cfcatch> 
		</cftry>
	
	</cfloop>
	
	<!--- Crea el Zip en el directorio temporal--->
	<cfzip file= "#rutaDirTmp#/#dateNow#FacturasXML.zip" action= "zip" source= "#rutaDirTmp#/" filter="*.xml" >

	<!--- Elimina los XML guardados en el directorio temporal--->
    <cfloop query="rsXML">
        <cffile action="delete" file="#rutaDirTmp#/#UUID#.xml" >
    </cfloop>

	<!--- Obtiene el cuerpo del zip con los xml guardados--->
	<CFHEADER NAME="Content-Disposition" VALUE="attachment;filename=#dateNow#FacturasXML.zip">

    <!--- Descarga el zip desde el navegador, y elimina el archivo zip en el directorio temporal--->
	<cfcontent Deletefile="yes" file="#rutaDirTmp#/#dateNow#FacturasXML.zip" type="application/zip" reset="yes">
	
	





