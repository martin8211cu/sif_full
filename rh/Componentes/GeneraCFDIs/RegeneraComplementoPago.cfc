
<!---
	Autor: Eduardo Gonzalez Sarabia
	Fecha: 24/09/2018
	Proceso: Regenera un complemento de pago en base a las tablas historicas.
 --->

<cfcomponent extends='rh.Componentes.GeneraCFDIs.SupportGeneraCFDI'>
	<cffunction name="regenerarCP" access="public" returntype="String">
		<cfargument name="Ddocumento"  type="String"  required="yes">

		<cfquery name="rsTimbraPago" datasource="#session.dsn#">
			SELECT ef.Ecodigo,
		           ef.CCTcodigo,
		           LTRIM(RTRIM(ef.Ddocumento)) AS Pcodigo,
		           ef.Mcodigo AS McodigoP,
		           ef.SNcodigo,
		           ef.EFtipocambio AS Ptipocambio,
		           COALESCE(df.ImpSaldoInsoluto,0) AS Ptotal,
		           df.CCTRcodigo AS Doc_CCTcodigo,
		           df.DRdocumento AS Ddocumento,
		           df.DFmonto AS MontoPagoDoc,
		           df.DFmontodoc AS DPmontodoc,
		           df.DFtipocambio AS DPtipocambio,
		           df.DFtotal AS DPtotal,
		           CASE
		               WHEN CONVERT(char, TblMb.Dfecha, 108) = '00:00:00' THEN LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, TblMb.Dfecha, 120))), 1, 10) + 'T12:00:00'))
		               ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, TblMb.Dfecha, 120))), 1, 10) + 'T' + CONVERT(char, TblMb.Dfecha, 108)))
		           END AS fechaAplicaPago,
		           LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, GETDATE(), 120))), 1, 10) + 'T' + CONVERT(char, GETDATE(), 108))) AS FechaEnc,
		           ef.CodTipoPago,
		           hd.TimbreFiscal,
		           df.NumParcialidad AS CantPagos
		       FROM HEFavor ef
		       INNER JOIN HDFavor df ON ef.Ecodigo = df.Ecodigo
		       AND ef.CCTcodigo = df.CCTcodigo
		       AND ef.Ddocumento = df.Ddocumento
		       INNER JOIN
		       (SELECT b.Dfecha,
		               b.Ecodigo,
		               b.DRdocumento
		       FROM BMovimientos b
		       INNER JOIN CCTransacciones t ON t.Ecodigo = b.Ecodigo
		       AND t.CCTcodigo = b.CCTcodigo
			   AND b.CCTcodigo = CCTRcodigo
		       WHERE t.CCTtipo = 'C') TblMb ON TblMb.Ecodigo = ef.Ecodigo
		       AND df.Ddocumento = TblMb.DRdocumento
		       INNER JOIN
		       (SELECT bm.DRdocumento,
		               bm.Ecodigo,
		               bm.SNcodigo,
		               SUM(CASE
							  WHEN cct.CCTcodigo = 'RE' AND bm.CCTRcodigo <> bm.CCTcodigo THEN 1
							  ELSE 0
		                   END) CantPagos,
		               SUM(CASE
		  						WHEN cct.CCTtipo = 'C' AND bm.CCTRcodigo <> bm.CCTcodigo THEN bm.Dtotal * -1
								WHEN cct.CCTtipo = 'D' THEN bm.Dtotal
		                   END) Dsaldo
		       FROM BMovimientos bm
		       INNER JOIN CCTransacciones cct ON bm.CCTcodigo = cct.CCTcodigo
		       AND bm.Ecodigo = cct.Ecodigo
		       GROUP BY bm.DRdocumento,
		                   bm.Ecodigo,
		                   bm.SNcodigo) fd ON df.Ecodigo = fd.Ecodigo
		       AND fd.SNcodigo = df.SNcodigo
		       AND fd.DRdocumento = df.DRdocumento
		       LEFT JOIN HDocumentos hd ON df.Ecodigo = hd.Ecodigo
		       AND df.CCTRcodigo = hd.CCTcodigo
		       AND hd.SNcodigo = df.SNcodigo
		       AND hd.Ddocumento = df.DRdocumento
		       AND ef.Cancelado = 0
		       WHERE ef.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		       AND ef.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">
		       ORDER BY df.DRdocumento
		</cfquery>


		<cfset SerieFolio   = FoliosCFDI(rsTimbraPago.CCTcodigo)>
        <cfset FolioDoc     = SerieFolio.numDoc>
        <cfset SerieDoc     = SerieFolio.Serie>

		<cfquery name="getDatosCert" datasource="#session.dsn#">
			select * from RH_CFDI_Certificados
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>
        <cfset vsPath   = #getDatosCert.archivoKey#>
        <cfset vsPath_A = left(vsPath,2)>

        <cfset GeneraXML = createObject('component', 'rh.Componentes.GeneraCFDIs.XML33ReciboPago-R')>

    	<!--- TIPO 2, APLICACION DE DOCUMENTOS --->
		<cfset reciboPagoCxC = 2>
		<cfset xsltPath = "#GetDirectoryFromPath(GetCurrentTemplatePath())#\cadenaoriginal_3_3.xslt">

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
	            <cfset archivoXml = #vsPath_A#&"\Enviar\xmlST\#SerieDoc##FolioDoc#_#rsTimbraPago.Pcodigo#.xml">
	             <CFFILE ACTION="WRITE" FILE="#archivoXml#" OUTPUT="#ToString(xml)#" charset="utf-8">
	             <!--- Timbrado de xml --->
	            <cfset xmlTimbrado = TimbraXML(xml,FolioDoc,-1,-1,-1,-1,rsTimbraPago.Pcodigo)>

           </cfif>
       </cftransaction>

		<cfreturn "#SerieDoc##FolioDoc#_#rsTimbraPago.Pcodigo#">
	</cffunction>
</cfcomponent>