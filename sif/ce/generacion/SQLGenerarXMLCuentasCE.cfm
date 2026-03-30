<cfset validaMapeo = createobject("component","sif.ce.Componentes.ValidacionMapeo")>

<cfset LvarAction = 'GenerarXMLCuentasCE.cfm'>
<cfset varGEid = -1>
<cfif isdefined("url.GE")>
	<cfset LvarAction = '../../ce/GrupoEmpresas/generacion/GenerarXMLCuentasCE.cfm'>
	<cfset varGEid = url.GE>
</cfif>

<cfif isdefined("Form.friltrar")>
    <cfset filtro=''>
	<cfif #Form.selectMes# neq '0'>
		<cfset filtro = #filtro# & " and Mes = '#Form.selectMes#'">
	</cfif>
	<cfif #Form.selectPeriodo# neq '0'>
		<cfset filtro = #filtro# & " and Anio = '#Form.selectPeriodo#'">
	</cfif>
	<cfif #Form.CAgrupador# neq ''>
		<cfset filtro = #filtro# & " and cex.CAgrupador = '#Form.CAgrupador#'">
	</cfif>
</cfif>
<cfsilent>

<cfif isdefined("Form.Generar") and trim(Form.Generar) NEQ "">

	<cfset CadenaOriginalE = "">

	<cfquery name="catalogo" datasource="#Session.DSN#">
		SELECT Id_XMLEnc, Version, Rfc, TotalCtas, Mes, Anio,Sello,CodCertificado,Certificado
		FROM CEXMLEncabezadoCuentas
		WHERE CAgrupador = '#Form.CAgrupadorC#'
			AND Version = '#Form.VersionC#'
			AND Mes = '#Form.MesC#' AND Anio = #Form.AnioC#
			and Ecodigo = #Session.Ecodigo#
			AND GEid = #varGEid#
	</cfquery>

	<cfquery name="ctas" datasource="#Session.DSN#">
	   SELECT CodAgrup, NumCta, Descripcion, SubCtaDe, (Nivel + 1) as Nivel , Natur FROM CEXMLDetalleCuentas WHERE Id_XMLEnc = #catalogo.Id_XMLEnc# <!--- ORDER BY NumCta --->
    </cfquery>
    <!---SML. 13012015 Inicio. Modificacion en la estructura del XML--->
    <cfset xmlCatCuentas = XmlNew()>
    <cfset xmlCatCuentas.XmlRoot = XmlElemNew(xmlCatCuentas,"catalogocuentas:Catalogo")>
<!---     <cfset xmlCatCuentas.xmlRoot.XmlAttributes["xmlns:contelec_td"] = "www.sat.gob.mx/esquemas/ContabilidadE/1_3/CatalogosParaEsqContE"> --->
	<cfset xmlCatCuentas.xmlRoot.XmlAttributes["xmlns:catalogocuentas"] ="http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/CatalogoCuentas">
	<cfset xmlCatCuentas.xmlRoot.XmlAttributes["xmlns:xsi"]="http://www.w3.org/2001/XMLSchema-instance">
	<cfset xmlCatCuentas.xmlRoot.XmlAttributes["xsi:schemaLocation"]="http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/CatalogoCuentas http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/CatalogoCuentas/CatalogoCuentas_1_3.xsd">
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["Version"] = "1.3" >
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["RFC"] = "#replace(catalogo.Rfc,'-','','all')#" >
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["Mes"] = "#catalogo.Mes#" >
    <cfset xmlCatCuentas.xmlRoot.XmlAttributes["Anio"] = "#catalogo.Anio#" >

	<cfif isdefined("Form.chk_Bal")>
		<cfset CadenaOriginalE = "1.1|#catalogo.Rfc#|#catalogo.Mes#|#catalogo.Anio#">
	</cfif>
	<cfset CadenaOriginalD = "">
		<cfset vquot = '"'>
    	<cfloop query="ctas">
   			<cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow] = XmlElemNew(xmlCatCuentas,"catalogocuentas:Ctas")>
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["CodAgrup"] = "#ctas.CodAgrup#" >
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["NumCta"] = "#Trim(ctas.NumCta)#" >
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["Desc"] = "#XMLFormat(validaMapeo.CleanHighAscii(ctas.Descripcion))#">
			<cfif len(Trim(ctas.SubCtaDe)) GT 0>
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["SubCtaDe"] = "#Trim(ctas.SubCtaDe)#" >
			</cfif>
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["Nivel"] = "#ctas.Nivel#" >
            <cfset xmlCatCuentas.Catalogo.XmlChildren[currentrow].XmlAttributes["Natur"] = "#ctas.Natur#" >
			<cfif isdefined("Form.chk_Bal")>
				<cfset CadenaOriginalD = "#ctas.CodAgrup#|#Trim(ctas.NumCta)#|#XmlFormat(validaMapeo.CleanHighAscii(ctas.Descripcion))#|#Trim(ctas.SubCtaDe)#|#ctas.Nivel#|#ctas.Natur#">
			</cfif>
    	</cfloop>


	<cfif isdefined("Form.chk_Bal")>
		<cfset cadenaR = "#CadenaOriginalE#|#CadenaOriginalD#">
		<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs" method="GeneraSelloDigital" returnvariable="vSello">
			<cfinvokeargument name="cadenaOriginal"   value="||#XmlFormat(validaMapeo.CleanHighAscii(cadenaR))#||">
		    <cfinvokeargument name="archivoKey"   value="#Form.key_Bal#">
		    <cfinvokeargument name="clave"   value="#Form.psw_Bal#">
		</cfinvoke>

		<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs" method="ObtenerCertificado" returnvariable="vCertificado">
			<cfinvokeargument name="archivoCer"   value="#Form.cer_Bal#">
		</cfinvoke>

		<cfset xmlCatCuentas.xmlRoot.XmlAttributes["Sello"] = "#vSello#">
		<cfset xmlCatCuentas.xmlRoot.XmlAttributes["noCertificado"] = "#vCertificado.getSerialNumber()#">
		<cfset xmlCatCuentas.xmlRoot.XmlAttributes["Certificado"] = "#vCertificado.getCertificado()#">
	<cfelse>
		<cfif len(trim(catalogo.Sello))><cfset xmlBalComp.xmlRoot.XmlAttributes["Sello"] = "#trim(catalogo.Sello)#"></cfif>
		<cfif len(trim(catalogo.CodCertificado))><cfset xmlBalComp.xmlRoot.XmlAttributes["noCertificado"] = "#trim(catalogo.CodCertificado)#"></cfif>
		<cfif len(trim(catalogo.Certificado))><cfset xmlBalComp.xmlRoot.XmlAttributes["Certificado"] = "#trim(catalogo.Certificado)#"></cfif>
	</cfif>

	<!--- MANEJO DE XML A ZIP --->
	 <cfset strPath = ExpandPath( "./" ) />
	 <cfset strFileName = "#catalogo.Rfc##Form.AnioC##Form.MesC#CT.xml"/>
	 <cfset strFileNameZip = "#catalogo.Rfc##Form.AnioC##Form.MesC#CT.zip"/>

	 <cfset XMLText=ToString(xmlCatCuentas)>
	 <!---guarda xml temporal --->
	 <cffile action="write" file="#strPath##strFileName#" output="#xmlCatCuentas#">

	 <!---crea el zip y lo guarda temporal --->
	 <cfzip action="zip" source="#strPath##strFileName#" file="#strPath##strFileNameZip#"/>

	 <!--- ELIMINACION DE ARCHIVO xml--->
 	 <cfif FileExists("#strPath##strFileName#")>
		<cffile action = "delete" file = "#strPath##strFileName#">
	 </cfif>

	 <cfquery datasource="#Session.DSN#">
		UPDATE CEXMLEncabezadoCuentas
		SET Status = 'Generado',
			UsucodigoModifica = #session.Usucodigo#,
			FechaModificacion = SYSDATETIME()
		<cfif isdefined("Form.chk_Bal")>
			,Sello = '#vSello#'
		 	,CodCertificado = '#vCertificado.getSerialNumber()#'
			,Certificado = '#vCertificado.getCertificado()#'
		</cfif>
		WHERE CAgrupador = '#Form.CAgrupadorC#' AND Version = '#Form.VersionC#' AND Mes = '#Form.MesC#' AND Anio = #Form.AnioC#
			and Ecodigo = #Session.Ecodigo#
			AND GEid = #varGEid#
	 </cfquery>

   	<!--- SE MANDA A PANTALLA PARA DESCARGARSE --->
	 <cfheader name="Content-Disposition" value="inline; filename=#strFileNameZip#">
	 <cfcontent type="application/x-zip-compressed" file="#strPath##strFileNameZip#" deletefile="yes">

    <!---SML. 13012015 Final. Modificacion en la estructura del XML--->
</cfif>
</cfsilent>
<cfif isdefined("Form.Generar") or trim(Form.Generar) EQ "1" or isdefined("Form.friltrar")>
	<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql" id="sql">
	    <cfoutput>
		    <cfif isdefined("Form.friltrar")>
		        <input type="hidden" name="filtro" value="#filtro#">
		        <input type="hidden" name="Mes" value="#Form.selectMes#">
		        <input type="hidden" name="Periodo" value="#Form.selectPeriodo#">
		        <input type="hidden" name="Id_Agrupador" value="#Form.Id_Agrupador#">
                <input type="hidden" name="CAgrupador" value="#Form.CAgrupador#">
                <input type="hidden" name="Descripcion" value="#Form.Descripcion#">
            </cfif>
	    </cfoutput>
    </form>
</cfif>



<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.getElementById("sql").submit();</script>
</body>
</HTML>