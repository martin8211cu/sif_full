<cfif isdefined("url.Generar")>
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">	
		Select 
			coalesce(e.CDCnombre, sn.SNnombre) as FAX01NDOC
			, id_direccionEnvio
			, hd.HDid
			, round( coalesce (Dtotal, 0.00) , 2) as Dtotal
			, hd.Icodigo
			, round( 
				coalesce (Dtotal, 0.00) 
					/ 
				( 1 + coalesce(Iporcentaje, 0) / 100) 
				, 2) 
			as Subtotal
			, round( coalesce (Dtotal, 0.00) , 2)
				-
				round( 
					coalesce (Dtotal, 0.00) 
						/ 
					( 1 + coalesce(Iporcentaje, 0) / 100) 
					, 2) 
			as Impuesto
			, coalesce(Iporcentaje, 0) as Iporcentaje
			, i.Idescripcion as Idescripcion
			, hd.Ocodigo
			, hd.SNcodigo
			, sn.SNnombre
			, sn.SNnumero
			, sn.SNidentificacion
			, hd.CCTcodigo
			, t.CCTdescripcion
			, Dfecha
			, Dvencimiento
			, ltrim(rtrim(e.CDCidentificacion))  as CDCidentificacion
			, ltrim(rtrim(e.CDCnombre)) as CDCnombre
			, hd.Ddocumento
		from HDocumentos hd
			inner join SNegocios sn 
				on sn.Ecodigo   = hd.Ecodigo 
				and sn.SNcodigo = hd.SNcodigo 
			
			inner join CCTransacciones t 
				on t.CCTcodigo = hd.CCTcodigo 
				and t.Ecodigo  = hd.Ecodigo 
			
			left outer join Impuestos i 
				on i.Ecodigo  = hd.Ecodigo 
				and i.Icodigo = hd.Icodigo 
			
			left outer join ClientesDetallistasCorp e 
				on e.CDCcodigo = hd.CDCcodigo 
							
		where hd.CCTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#"> 
			and hd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
				and hd.SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
			</cfif>
			and hd.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
			and hd.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
			<cfif isdefined('url.Ocodigo') and len(trim(url.Ocodigo)) NEQ 0>
				and hd.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
			</cfif>
			
			<cfif isdefined("url.DocIni") and len(trim(url.DocIni)) and isdefined("url.DocFin") and len(trim(url.DocFin))>
				and upper(hd.Ddocumento) >= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#url.DocIni#">)
				and upper(hd.Ddocumento) <= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#url.DocFin#">)
			<cfelseif isdefined("url.DocIni") and len(trim(url.DocIni))>
				and upper(hd.Ddocumento) >= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#url.DocIni#">)
			<cfelseif isdefined("url.DocFin") and len(trim(url.DocFin))> 
				and upper(hd.Ddocumento) <= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#url.DocFin#">)
			</cfif>
		 order by Ddocumento
	</cfquery>

	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
		<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
		<cfabort>
	</cfif>
	
	<!--- Busca nombre de la empresa --->
	 <cfquery name="rsEmpresa" datasource="#session.DSN#">			
		Select e.Enombre
			, e.id_direccion
			, e.Eidentificacion
			, d.direccion1
			, d.direccion2
			, e.Etelefono1
			, e.Etelefono2
			, d.codPostal
			, Pnombre
		from Empresa	e
			left outer join Direcciones d
				on d.id_direccion=e.id_direccion	
		
			left outer join Pais p
				on p.Ppais=d.Ppais
			
		where e.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigosdc#">
	</cfquery>
	
	<cfquery name="rsLeyenda" datasource="#session.DSN#">
		select 
			CCTDleyenda1,
			CCTD_CDCcodigo
		from CCTransaccionesD
		where Ecodigo  = #session.Ecodigo# 
 		 and CCTcodigo = '#url.CCTcodigo#'
	</cfquery>
	
	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	</cfif>

    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.genFactServRes"/>
	<cfelse>
	<cfreport format="#formatos#" template= "genFactServRes.cfr" query="rsReporte">				  
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Enombre" value="#rsEmpresa.Enombre#">
			<cfreportparam name="Eidentificacion" value="#rsEmpresa.Eidentificacion#">
			<cfreportparam name="direccion1" value="#rsEmpresa.direccion1#">
			<cfreportparam name="direccion2" value="#rsEmpresa.direccion2#">
			<cfreportparam name="Etelefono1" value="#rsEmpresa.Etelefono1#">
			<cfreportparam name="Etelefono2" value="#rsEmpresa.Etelefono2#">
			<cfreportparam name="codPostal" value="#rsEmpresa.codPostal#">
			<cfreportparam name="Pnombre" value="#rsEmpresa.Pnombre#">
		</cfif>
		<cfif isdefined("rsLeyenda") and len(trim(rsLeyenda.CCTDleyenda1))>
			<cfreportparam name="Leyenda" value="#rsLeyenda.CCTDleyenda1#">
		<cfelse>
			<cfreportparam name="Leyenda" value=" ">
		</cfif>
		<cfif isdefined("rsLeyenda") and len(trim(rsLeyenda.CCTD_CDCcodigo)) and rsLeyenda.CCTD_CDCcodigo eq 1>
			<cfreportparam name="Chk" value="#rsLeyenda.CCTD_CDCcodigo#">
		<cfelse>
			<cfreportparam name="Chk" value="0">
		</cfif>
		
	</cfreport> 
	</cfif>
</cfif>


