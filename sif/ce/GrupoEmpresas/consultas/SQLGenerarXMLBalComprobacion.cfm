<cfset validaMapeo = createobject("component","sif.ce.Componentes.ValidacionMapeo")>

<cfif isdefined("chk")>
	<cfset LvarDet 		= #ListToArray(form.chk, "|", true)#>
	<cfset CEBalanzaId 	= LvarDet[1]>
	<cfset CEBperiodo 	= LvarDet[2]>
	<cfset CEBmes 		= LvarDet[3]>
 <cfelse>
	<cfset CEBalanzaId = #Form.CEBalanzaIdC#>
	<cfset CEBperiodo = #Form.CEBperiodoC#>
	<cfset CEBmes = #Form.CEBmesC#>
</cfif>


<cfinvoke component="sif.ce.Componentes.BalComprobacionCE" method="BalCompSAT" returnvariable="rsReporte">
	<cfinvokeargument name="idBalComp"   value="#CEBalanzaId#">
    <cfinvokeargument name="Periodo"   value="#CEBperiodo#">
    <cfinvokeargument name="Mes"   value="#CEBmes#">
</cfinvoke>

<cfquery name="rfc" datasource="#Session.DSN#">
	SELECT Eidentificacion FROM Empresa WHERE Ereferencia = #Session.Ecodigo#
</cfquery>

<cfif #CEBmes# eq "1" >
	<cfset CEBmes = '01'>
<cfelseif #CEBmes# eq "2">
	<cfset CEBmes = '02'>
<cfelseif #CEBmes# eq "3">
	<cfset CEBmes = '03'>
<cfelseif #CEBmes# eq "4">
	<cfset CEBmes = '04'>
<cfelseif #CEBmes# eq "5">
	<cfset CEBmes = '05'>
<cfelseif #CEBmes# eq "6">
	<cfset CEBmes = '06'>
<cfelseif #CEBmes# eq "7">
	<cfset CEBmes = '07'>
<cfelseif #CEBmes# eq "8">
	<cfset CEBmes = '08'>
<cfelseif #CEBmes# eq "9">
	<cfset CEBmes = '09'>
</cfif>

	<cfset CadenaOriginalE = "">
<!---SML. 15012015 Inicio. Modificacion en la estructura del XML--->
	<cfset xmlBalComp = XmlNew()>
    <cfset xmlBalComp.XmlRoot = XmlElemNew(xmlBalComp,"BCE:Balanza")>
	<cfset xmlBalComp.xmlRoot.XmlAttributes["xmlns:BCE"]="http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/BalanzaComprobacion">
	<cfset xmlBalComp.xmlRoot.XmlAttributes["xmlns:xsi"]="http://www.w3.org/2001/XMLSchema-instance">
	<cfset xmlBalComp.xmlRoot.XmlAttributes["xsi:schemaLocation"]="http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/BalanzaComprobacion http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/BalanzaComprobacion/BalanzaComprobacion_1_3.xsd">
    <cfset xmlBalComp.xmlRoot.XmlAttributes["Version"] = "1.3" >
    <cfset xmlBalComp.xmlRoot.XmlAttributes["RFC"] = "#replace(rfc.Eidentificacion,'-','','all')#" >
    <cfset xmlBalComp.xmlRoot.XmlAttributes["Mes"] = "#CEBmes#" >
    <cfset xmlBalComp.xmlRoot.XmlAttributes["Anio"] = "#CEBperiodo#" >
    <cfset xmlBalComp.xmlRoot.XmlAttributes["TipoEnvio"] = "#Trim(rsReporte.CEBTipo)#">
	<cfset xmlBalComp.xmlRoot.XmlAttributes["FechaModBal"] = "#DateFormat(rsReporte.FechaGenera,'yyyy-mm-dd')#">

	<cfif isdefined("Form.chk_Bal")>
		<cfset CadenaOriginalE = "1.1|#rfc.Eidentificacion#|#CEBmes#|#CEBperiodo#|#Trim(rsReporte.CEBTipo)#|#DateFormat(rsReporte.FechaGenera,'yyyy-mm-dd')#">
	</cfif>
	<cfset CadenaOriginalD = "">
	<cfset vquot = '"'>
    <cfloop query="rsReporte">
   			<cfset xmlBalComp.Balanza.XmlChildren[currentrow] = XmlElemNew(xmlBalComp,"BCE:Ctas")>
            <cfset xmlBalComp.Balanza.XmlChildren[currentrow].XmlAttributes["NumCta"] = "#Trim(rsReporte.FORMATO)#" >
            <cfset xmlBalComp.Balanza.XmlChildren[currentrow].XmlAttributes["SaldoIni"] = "#NumberFormat(rsReporte.SALDOINI,'.00')#" >
            <cfset xmlBalComp.Balanza.XmlChildren[currentrow].XmlAttributes["Debe"] = "#NumberFormat(rsReporte.DEBITOS,'.00')#">
            <cfset xmlBalComp.Balanza.XmlChildren[currentrow].XmlAttributes["Haber"] = "#NumberFormat(rsReporte.CREDITOS,'.00')#" >
            <cfset xmlBalComp.Balanza.XmlChildren[currentrow].XmlAttributes["SaldoFin"] = "#NumberFormat(rsReporte.SALDOFIN,'.00')#" >
			<cfif isdefined("Form.chk_Bal")>
				<cfset CadenaOriginalD = "#CadenaOriginalD#|#Trim(rsReporte.FORMATO)#|#NumberFormat(rsReporte.SALDOINI,'.00')#|#NumberFormat(rsReporte.DEBITOS,'.00')#|#NumberFormat(rsReporte.CREDITOS,'.00')#|#NumberFormat(rsReporte.SALDOFIN,'.00')#">
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
		<cfset xmlBalComp.xmlRoot.XmlAttributes["Sello"] = "#vSello#">
		<cfset xmlBalComp.xmlRoot.XmlAttributes["noCertificado"] = "#vCertificado.getSerialNumber()#">
		<cfset xmlBalComp.xmlRoot.XmlAttributes["Certificado"] = "#vCertificado.getCertificado()#">
	<cfelse>
		<cfif len(trim(rsReporte.Sello))><cfset xmlBalComp.xmlRoot.XmlAttributes["Sello"] = "#trim(rsReporte.Sello)#"></cfif>
		<cfif len(trim(rsReporte.CodCertificado))><cfset xmlBalComp.xmlRoot.XmlAttributes["noCertificado"] = "#trim(rsReporte.CodCertificado)#"></cfif>
		<cfif len(trim(rsReporte.Certificado))><cfset xmlBalComp.xmlRoot.XmlAttributes["Certificado"] = "#trim(rsReporte.Certificado)#"></cfif>
	</cfif>

    <!--- MANEJO DE XML A ZIP --->
	 <cfset strPath = ExpandPath( "./" ) />
	 <cfset strFileName = "#rfc.Eidentificacion##CEBperiodo##CEBmes#B#Trim(rsReporte.CEBTipo)#.xml"/>
	 <cfset strFileNameZip = "#rfc.Eidentificacion##CEBperiodo##CEBmes#B#Trim(rsReporte.CEBTipo)#.zip"/>

	 <cfset XMLText=ToString(xmlBalComp)>
	 <!---guarda xml temporal --->
	 <cffile action="write" file="#strPath##strFileName#" output="#xmlBalComp#">

	 <!---crea el zip y lo guarda temporal --->
	 <cfzip action="zip" source="#strPath##strFileName#" file="#strPath##strFileNameZip#"/>

     <!--- ELIMINACION DE ARCHIVO xml--->
 	 <cfif FileExists("#strPath##strFileName#")>
		<cffile action = "delete" file = "#strPath##strFileName#">
	 </cfif>

     <cfquery datasource="#Session.DSN#">
		UPDATE CEBalanzaSAT
			SET CEBestatus = 2
		<cfif isdefined("Form.chk_Bal")>
			,Sello = '#vSello#'
		 	,CodCertificado = '#vCertificado.getSerialNumber()#'
			,Certificado = '#vCertificado.getCertificado()#'
		</cfif>
		WHERE CEBalanzaId = #CEBalanzaId# AND CEBperiodo = #CEBperiodo# AND CEBmes = #CEBmes#
			and GEid = (SELECT  GEid FROM AnexoGEmpresaDet where Ecodigo = #Session.Ecodigo#)
	 </cfquery>

   	<!--- SE MANDA A PANTALLA PARA DESCARGARSE --->
	 <cfheader name="Content-Disposition" value="inline; filename=#strFileNameZip#">
	 <cfcontent type="application/x-zip-compressed" file="#strPath##strFileNameZip#" deletefile="yes">

<!---SML. 15012015 Fin. Modificacion en la estructura del XML--->


