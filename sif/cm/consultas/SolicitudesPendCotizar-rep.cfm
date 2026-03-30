<cfif not isdefined("url.formato") >
	<cfset tipoformato = "flashpaper">
<cfelse>
	<cfset tipoformato = #url.formato#>
</cfif>

<cfif not isdefined('url.CMCcodigo1') or len(trim(url.CMCcodigo1)) eq 0 >
	<cfset url.CMCcodigo1 = '0' >
</cfif>
<cfif not isdefined('url.CMCcodigo2') or len(trim(url.CMCcodigo2)) eq 0>
	<cfset url.CMCcodigo2 = '0000000000' >
</cfif>

<cfif compare(url.CMCcodigo1, url.CMCcodigo2) eq 1 >
	<cfset tmp = url.CMCcodigo1 >
	<cfset url.CMCcodigo1 = url.CMCcodigo2 >
	<cfset url.CMCcodigo2 = tmp >
	
	<cfset tmp = url.CMCid1 >
	<cfset url.CMCid1 = url.CMCid2 >
	<cfset url.CMCid2 = tmp >
	
	<cfset tmp = url.CMCnombre1 >
	<cfset url.CMCnombre1 = url.CMCnombre2 >
	<cfset url.CMCnombre2 = tmp >

</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsReporte" datasource="#session.DSN#">
	select 	a.ESnumero, 
		b.CFcodigo,
		rtrim(b.CFcodigo)#_Cat#' - '#_Cat#b.CFdescripcion as CentroFunc,  
		c.CMSnombre,
		a.ESobservacion,
		d.CMTSdescripcion,
		case when a.ESestado = 0 then 'Pendiente' 
			 when a.ESestado = 10 then 'En Trámite Aprobación'
			 when a.ESestado = 20 then 'Lista para Procesar'
				 when a.ESestado = 30 then 'En Proceso Compra'
			 when a.ESestado = 40 then 'Parcialmente Surtida'
				 when a.ESestado = 50 then 'Surtida'
				 when a.ESestado = 60 then 'Cancelada' 
			 end as ESestado,
		a.ESfecha,
		a.EStotalest,
		case when g.CMEtipo = 'A' then (select coalesce(Cla.Cdescripcion,'--') 
						from Clasificaciones Cla 
						where g.Ccodigo = Cla.Ccodigo 
							and g.Ecodigo = Cla.Ecodigo) 
			 when g.CMEtipo = 'S' then (select coalesce(CCo.CCdescripcion,'--') 
						from CConceptos CCo 
						where g.CCid = CCo.CCid 
							and g.Ecodigo = CCo.Ecodigo) 
			 when g.CMEtipo = 'F' then (select coalesce(ACa.ACdescripcion#_Cat#'/'#_Cat#ACl.ACdescripcion,'--')
						from ACategoria ACa, AClasificacion ACl
						where ACa.ACcodigo = g.ACcodigo
							and ACa.Ecodigo = g.Ecodigo
							and ACl.Ecodigo	= g.Ecodigo 
							and ACl.ACcodigo = g.ACcodigo
							and ACl.ACid = g.ACid)
			 else null 
		end as Desc_Especializacion
	from ESolicitudCompraCM a
		inner join CFuncional b 
			on b.CFid = a.CFid
		inner join CMSolicitantes c
			on c.CMSid = a.CMSid
		inner join CMTiposSolicitud d
			on d.Ecodigo = a.Ecodigo
			and d.CMTScodigo = a.CMTScodigo
		left outer join CMCompradores f
			on f.CMCid = a.CMCid
		left outer join CMEspecializacionTSCF g
			on g.CMElinea = a.CMElinea
	where a.Ecodigo = #session.Ecodigo#
		<cfif isdefined('url.CMCcodigo1') and url.CMCcodigo1 GTE 0 and isdefined('url.CMCcodigo2') and url.CMCcodigo2 GTE 0>
			and coalesce(f.CMCcodigo,'0') between '#url.CMCcodigo1#' and '#url.CMCcodigo2#'
		</cfif>
		and a.ESfecha between 
		
			<cfif isDefined("url.fdesde") and len(trim(url.fdesde)) NEQ 0>
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fdesde)#">
			<cfelseif isDefined("url.fdesde") and len(trim(url.fdesde)) EQ 0>
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime('01/01/1900')#">
			</cfif>
			and
			<cfif isDefined("url.fhasta") and len(trim(url.fhasta)) NEQ 0>
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fhasta)#">
			<cfelseif isDefined("url.fhasta") and len(trim(url.fhasta)) EQ 0>
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime('01/01/9999')#">
			</cfif>
		and a.ESestado <> 60 
	order by a.CFid
</cfquery>

<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	<cfset typeRep = 1>
	<cfif tipoformato EQ "pdf">
		<cfset typeRep = 2>
	</cfif>
	<cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = typeRep
		fileName = "cm.consultas.Listado_Solicitudes"
		headers = "empresa:#session.enombre#"/>
<cfelse>
<cfreport format="#tipoformato#" query="rsReporte" template="Reportes/Listado_Solicitudes.cfr">
	
	<cfreportparam name="Ecodigo"   value="#session.Ecodigo#">
	<cfreportparam name="enombre"   value="#session.enombre#">

			
	<!--- Envia el Código del Comprador - CMCcodigo --->
	<cfif isDefined("url.CMCcodigo1") and len(trim(url.CMCcodigo1)) NEQ 0>
		<cfreportparam name="CMCcodigo1"   value="#url.CMCcodigo1#">
	<cfelseif isDefined("url.CMCcodigo1") and len(trim(url.CMCcodigo1)) EQ 0>
		<cfreportparam name="CMCcodigo1"   value="0">
	</cfif>

	<cfif isDefined("url.CMCcodigo2") and len(trim(url.CMCcodigo2)) NEQ 0>
		<cfreportparam name="CMCcodigo2"   value="#url.CMCcodigo2#">
	<cfelseif isDefined("url.CMCcodigo2") and len(trim(url.CMCcodigo2)) EQ 0>
		<cfreportparam name="CMCcodigo2"   value="0000000000">
	</cfif>
</cfreport>
</cfif>