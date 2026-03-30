<cfset validaMapeo = createobject("component","sif.ce.Componentes.ValidacionMapeo")>


<cfset varGEid = -1>
<cfif isdefined("url.GE")>
	<cfset LvarAction = '../../ce/GrupoEmpresas/generacion/GenerarXMLCuentasCE.cfm'>
	<cfset varGEid = url.GE>
</cfif>

<cfquery name="catalogo" datasource="#Session.DSN#">
	SELECT Id_XMLEnc, Version, Rfc, TotalCtas, Mes, Anio
	FROM CEXMLEncabezadoCuentas
	WHERE CAgrupador = '#Form.CAgrupadorC#' AND Version = '#Form.VersionC#' AND Mes = '#Form.MesC#' AND Anio = #Form.AnioC#
		AND GEid = #varGEid#
		and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="ctas" datasource="#Session.DSN#">
    SELECT CodAgrup, NumCta, Descripcion, SubCtaDe, (Nivel + 1) as Nivel, Natur FROM CEXMLDetalleCuentas WHERE Id_XMLEnc = #catalogo.Id_XMLEnc#
			and Ecodigo = #Session.Ecodigo# ORDER BY NumCta
</cfquery>

<!---SML. 14012015 Inicio. Modificacion en la estructura del XML--->
	<cfset xmlCatCuentas = XmlNew()>
    <cfset xmlCatCuentas.XmlRoot = XmlElemNew(xmlCatCuentas,"Catalogo")>
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["xmlns:contelec_td"] = "www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogosParaEsqContE">
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance">
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["xmlns"] ="www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas">
	<cfset xmlCatCuentas.xmlRoot.XmlAttributes["xsi:schemaLocation"] ="www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas http://www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas/CatalogoCuentas_1_1.xsd">
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["Version"] = "#catalogo.Version#" >
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["RFC"] = "#catalogo.Rfc#" >
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["Mes"] = "#catalogo.Mes#" >
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["Anio"] = "#catalogo.Anio#" >

    	<cfloop query="ctas">
   			<cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow] = XmlElemNew(xmlCatCuentas,"Ctas")>
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["CodAgrup"] = "#ctas.CodAgrup#" >
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["NumCta"] = "#Trim(ctas.NumCta)#" >
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["Desc"] = "#XMLFormat(validaMapeo.CleanHighAscii(ctas.Descripcion))#">
			<cfif len(Trim(ctas.SubCtaDe)) GT 0>
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["SubCtaDe"] = "#Trim(ctas.SubCtaDe)#" >
			</cfif>
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["Nivel"] = "#ctas.Nivel#" >
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["Natur"] = "#ctas.Natur#" >
    	</cfloop>


	<!--- MANEJO DE XML A ZIP --->
	 <cfset strPath = ExpandPath( "./" ) />
	 <cfset strFileName = "#catalogo.Rfc##Form.AnioC##Form.MesC#CT.xml"/>
	 <cfset strFileNameZip = "#catalogo.Rfc##Form.AnioC##Form.MesC#CT.zip"/>

	 <cfset XMLText=ToString(xmlCatCuentas)>
	 <!---guarda xml temporal --->
	 <cffile action="write" file="#strPath##strFileName#" output="#XMLText#">

	 <!---crea el zip y lo guarda temporal --->
	 <cfzip action="zip" source="#strPath##strFileName#" file="#strPath##strFileNameZip#"/>

	<!--- ELIMINACION DE ARCHIVO xml--->
 	<cfif FileExists("#strPath##strFileName#")>
		<cffile action = "delete" file = "#strPath##strFileName#">
	</cfif>

   	<!--- SE MANDA A PANTALLA PARA DESCARGARSE --->
	 <cfheader name="Content-Disposition" value="inline; filename=#strFileNameZip#">
	 <cfcontent type="application/x-zip-compressed" file="#strPath##strFileNameZip#" deletefile="yes">

    <!---SML. 14012015 Final. Modificacion en la estructura del XML--->
