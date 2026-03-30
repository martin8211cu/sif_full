
<!---
	Autor: Eduardo Gonzalez Sarabia
	Fecha: 28/06/2019
	Proceso: Regenera un complemento de pago en base a las tablas historicas.
 --->

<cfcomponent extends='rh.Componentes.GeneraCFDIs.SupportGeneraCFDI'>
	<cffunction name="generarCP" access="public" returntype="String">
		<cfargument name="IDDocCompensacion"  type="numeric"  required="yes">

		 <cf_foldersFacturacion name = "ruta">
		<!-- Querys AFGM-SPR CONTROL DE VERSIONES-->
        <cfquery name="rsVersion" datasource = "#Session.DSN#">
            select Pvalor 
            from Parametros
            where Pcodigo = '17200'
                and Ecodigo = #session.Ecodigo#
        </cfquery>

        <cfset version = "#rsVersion.Pvalor#">
        <!-- Fin Querys AFGM-SPR -->

		<cfquery name="rsTimbraPago" datasource="#session.dsn#">
			SELECT e.idDocCompensacion,
			       e.Ecodigo,
			       e.CCTcodigo,
			       e.DocCompensacion AS Pcodigo,
			       e.Mcodigo AS McodigoP,
			       e.SNcodigo,
			       hcc.Dtipocambio AS Ptipocambio,
			       cc.Dmonto AS Ptotal,
			       hcc.CCTcodigo AS Doc_CCTcodigo,
			       hcc.Ddocumento AS Ddocumento,
			       cc.Dmonto AS MontoPagoDoc,
			       cc.Dmonto AS DPmontodoc,
			       hcc.Dtipocambio,
			       cc.Dmonto AS DPtotal,
			       COALESCE(hcc.TimbreFiscal, ecc.TimbreFiscal) AS TimbreFiscal,
			       CASE
			           WHEN CONVERT(char, TblMb.Dfecha, 108) = '00:00:00' THEN LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, TblMb.Dfecha, 120))), 1, 10) + 'T12:00:00'))
			           ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, TblMb.Dfecha, 120))), 1, 10) + 'T' + CONVERT(char, TblMb.Dfecha, 108)))
			       END AS fechaAplicaPago,
			       LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, GETDATE(), 120))), 1, 10) + 'T' + CONVERT(char, GETDATE(), 108))) AS FechaEnc,
			       '17' AS CodTipoPago, /*Compensacion*/
			       1 CantPagos,
				   hcc.Ddocumento AS DocCxc
			FROM DocCompensacion e
			INNER JOIN DocCompensacionDCxC cc ON e.idDocCompensacion = cc.idDocCompensacion
			AND e.Ecodigo = cc.Ecodigo
			INNER JOIN HDocumentos hcc ON hcc.Ddocumento = cc.Ddocumento
			AND hcc.Ecodigo = cc.Ecodigo
			LEFT JOIN Documentos ecc ON ecc.Ddocumento = cc.Ddocumento
			AND ecc.Ecodigo = cc.Ecodigo
			INNER JOIN
			  (SELECT b.Dfecha,
			          b.Ecodigo,
			          b.Ddocumento
			   FROM BMovimientos b
			   INNER JOIN CCTransacciones t ON t.Ecodigo = b.Ecodigo
			   AND t.CCTcodigo = b.CCTcodigo
			   WHERE t.CCTtipo = 'C') TblMb ON TblMb.Ecodigo = e.Ecodigo
			AND e.DocCompensacion = TblMb.Ddocumento
			WHERE e.idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDDocCompensacion#">
			ORDER BY hcc.Ddocumento
		</cfquery>

		<cfif rsTimbraPago.RecordCount EQ 0>
			<cfabort showerror="No se pudo generar el Complemento de la Compensacion!">
		</cfif>


		<cfset SerieFolio   = FoliosCFDI(rsTimbraPago.CCTcodigo, rsTimbraPago.idDocCompensacion)>
        <cfset FolioDoc     = SerieFolio.Folio>
        <cfset SerieDoc     = SerieFolio.Serie>

		<cfquery name="getDatosCert" datasource="#session.dsn#">
			select * from RH_CFDI_Certificados
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>
        <cfset vsPath   = #getDatosCert.archivoKey#>
        <cfset vsPath_A = left(vsPath,2)>

         <cfif version eq '3.3'>
			<!--- Se manda traer componente que genera el XML --->
        	<cfset GeneraXML = createObject('component', 'rh.Componentes.GeneraCFDIs.XML33ComplementoCompensacion')> 
         <cfelseif version eq '4.0'>
             		<!--- Se manda traer componente que genera el XML --->
        	<cfset GeneraXML = createObject('component', 'rh.Componentes.GeneraCFDIs.XML20ComplementoCompensacion')>

         </cfif>



    	<!--- TIPO 2, APLICACION DE DOCUMENTOS --->
		<cfset reciboPagoCxC = 2>

		<cfif version eq '3.3'>
				<cfset xsltPath = "#GetDirectoryFromPath(GetCurrentTemplatePath())#\cadenaoriginal_3_3.xslt">
        <cfelseif version eq '4.0'>
				<cfset xsltPath = "#GetDirectoryFromPath(GetCurrentTemplatePath())#CadenaCFDIv4.0\cadenaoriginal_4_0.xslt">
         </cfif>


		<cftransaction>
			<cfif  reciboPagoCxC GT 0>
		        <cfset xml = GeneraXML.XML33ReciboPagoCFDI(rsTimbraPago, FolioDoc, SerieDoc, reciboPagoCxC)>
		        <cfset cadenaOriginal = GeneraCadenaOriginal(xml,xsltPath)>
		        <cfset sello = GeneraSelloDigital(cadenaOriginal)>
		        <cfset xml = Replace(xml,'Sello="."','Sello="#sello#"')>

				<!--- Se inserta XML --->
		        <cfquery datasource="#session.dsn#">
					insert into FA_CFDI_Emitido (Ecodigo, OImpresionID, Serie, Folio, CadenaOriginal, stsTimbre, DocPago, NombreDoctoGenerado)
			 			   values(#session.Ecodigo#, 0,'#SerieDoc#',#FolioDoc#,'#cadenaOriginal#',0, '#rsTimbraPago.Pcodigo#', '#SerieDoc##FolioDoc#_#rsTimbraPago.Pcodigo#')
		        </cfquery>

				<!--- Generacion de archivo XML --->
	            <cfset archivoXml = "#ruta#/xmlST/#SerieDoc##FolioDoc#_#TRIM(rsTimbraPago.Pcodigo)#.xml">

				 <CFFILE ACTION="WRITE" FILE="#archivoXml#" OUTPUT="#ToString(xml)#" charset="utf-8">
	             <!--- Timbrado de xml --->
	            <cfset xmlTimbrado = TimbraXML(xml,FolioDoc,-1,-1,-1,-1,rsTimbraPago.Pcodigo)>
           </cfif>
       </cftransaction>

		<cfreturn "#SerieDoc##FolioDoc#_#rsTimbraPago.Pcodigo#">
	</cffunction>
</cfcomponent>