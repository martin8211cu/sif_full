<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		b.Ecodigo, 
		e.Edescripcion,
		b.Ecodigo, 
		b.CPTcodigo, 
		c.CPTdescripcion, 
		case when c.CPTtipo = 'D' then 'Débito' when c.CPTtipo = 'C' then 'Crédito' end as tipo, 
		b.Ddocumento, 
		<cf_dbfunction name="to_sdateDMY"	args="b.Dfecha"> as Dfecha, 
		b.BMtref, 
		BMdocref,
		o.Odescripcion, 
		b.SNcodigo, 
		s.SNnombre, 
		b.Mcodigo, 
		m.Mnombre, 
		b.Dtotal,
		<cf_dbfunction name="now"> as fecha_hora,
		b.Dtotal*Dtipocambio as Dtotalloc, 
		Dtipocambio,
		b.SNcodigo, 
		s.SNnumero,
		b.Rcodigo, 
		coalesce(r.Rporcentaje, 0) as Rporcentaje
	
	from BMovimientosCxP b
		inner join CPTransacciones c
		on  c.Ecodigo   = b.Ecodigo
	    and c.CPTcodigo = b.CPTcodigo
		
		inner join Oficinas o
		on  o.Ecodigo = b.Ecodigo
	  	and o.Ocodigo = b.Ocodigo
		
		inner join SNegocios s
		on  s.Ecodigo  = b.Ecodigo
	  	and s.SNcodigo = b.SNcodigo
		
		inner join Monedas m
		on b.Mcodigo = m.Mcodigo
		
		inner join Empresas e
		on e.Ecodigo = b.Ecodigo
		
		left outer join Retenciones r
		on  r.Ecodigo = b.Ecodigo
	  	and r.Rcodigo = b.Rcodigo
	
	where b.Ecodigo = #session.Ecodigo#
	  and b.Dfecha >= coalesce(<cf_dbfunction name="to_datetime" args="'#url.fechaIni#'">,b.Dfecha) 
	  <cfif isdefined("url.Documento") and len(trim(url.Documento)) NEQ 0> 
		and ( upper(b.Ddocumento) like '%#Ucase(url.Documento)#%' or upper(BMdocref) like '%#Ucase(url.Documento)#%' or '#url.Documento#' = 'Todos')
	  </cfif>	  
	  <cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) NEQ 0> 
		and ( b.SNcodigo   = #url.SNcodigo#   or #url.SNcodigo# = -1)
	  </cfif>
	  <cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo)) NEQ 0> 
		and ( b.CPTcodigo  like '%#url.CPTcodigo#%' or '#url.CPTcodigo#' = '-1')
	  </cfif>
	  and c.CPTpago = 0
	  and b.CPTcodigo = b.CPTRcodigo
	  and b.Ddocumento = b.DRdocumento
	order by b.SNcodigo, b.Mcodigo, b.CPTcodigo, b.Dfecha desc
</cfquery>

<cfif isdefined("url.formato") and len(trim(url.Formato)) and url.Formato EQ 1>
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
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and ( formatos neq "flashpaper" and formatos neq "pdf" )>
	  <cfset typeRep = 1>
	  <!--- <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif> --->
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		  isLink = False 
		  typeReport = #typeRep#
		  fileName = "cp.consultas.reportes.RFacturasCP"/>
<cfelse>
	<cfreport format="#formatos#" template= "RFacturasCP.cfr" query="#rsReporte#">
		<cfreportparam name="fechaIni" value="#dateformat(url.fechaIni, 'dd/mm/yyyy')#">
		<cfreportparam name="Ddocumento" value="#url.Documento#">
	</cfreport>	
</cfif>