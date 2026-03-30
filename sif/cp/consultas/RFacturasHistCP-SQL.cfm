<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Debito 	= t.Translate('LB_Debito','Débito')>
<cfset LB_Credito	= t.Translate('LB_Credito','Crédito')>

<cf_dbfunction name="now" returnvariable="hoy">
<cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) NEQ 0> 
	<cfset LvarfechaIniLabel = #lsparsedatetime(url.fechaIni)#>
<cfelse>
	<cfset LvarfechaIniLabel = #lsparsedatetime(1900/01/01)#>
</cfif>

<cfif isdefined("url.fechaFin") and len(trim(url.fechaFin)) NEQ 0> 
	<cfset LvarfechaFinLabel=#lsparsedatetime(url.fechaFin)#>
<cfelse>
	<cfset LvarfechaFinLabel= #hoy#>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		b.Ecodigo, 
		e.Edescripcion, 
		b.Ecodigo, 
		b.CPTcodigo as CCTcodigo, 
		c.CPTdescripcion as CCTdescripcion, 
		case when c.CPTtipo = 'D' then '#LB_Debito#' when c.CPTtipo = 'C' then '#LB_Credito#' end as tipo, 
		b.Ddocumento, 
		<cf_dbfunction name="to_sdateDMY"	args="b.Dfecha"> as Dfecha, 
		b.BMtref, 
		BMdocref,
		o.Odescripcion, 
		b.SNcodigo, 
		s.SNnumero,
		s.SNnombre, 
		b.Mcodigo, 
		m.Mnombre, 
		b.Dtotal,
		#hoy# as fecha_hora,
		round(b.Dtotal * b.Dtipocambio,2) as Dtotalloc, 
		Dtipocambio,
		b.SNcodigo
	from BMovimientosCxP b
		inner join CPTransacciones c
			on b.Ecodigo = c.Ecodigo
			and b.CPTcodigo = c.CPTcodigo
		inner join Oficinas o
			on b.Ecodigo = o.Ecodigo
			and b.Ocodigo = o.Ocodigo
		inner join SNegocios s
			on b.Ecodigo = s.Ecodigo
			and b.SNcodigo = s.SNcodigo
		inner join Monedas m
			on b.Mcodigo = m.Mcodigo
		inner join Empresas e
			on b.Ecodigo = e.Ecodigo
	where b.Ecodigo = #session.Ecodigo#
		<cfif isdefined("url.Documento") and len(trim(url.Documento)) NEQ 0> 
		  and ( b.Ddocumento like '%#Ucase(url.Documento)#%' or BMdocref like '%#Ucase(url.Documento)#%' or '#url.Documento#' = 'Todos')
		</cfif>	  
		<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) NEQ 0> 
			and ( b.SNcodigo   = #url.SNcodigo#   or #url.SNcodigo# = -1)
		</cfif>
		 
		<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo)) NEQ 0> 
			 and ( b.CPTcodigo  like '%#url.CPTcodigo#%' or '#url.CPTcodigo#' = '-1')
		</cfif>
		  
		  and ( b.Dfecha    >= #LvarfechaIniLabel# and b.Dfecha <= #LvarfechaFinLabel#)
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

<cfset TIT_RepHistxDoc 	= t.Translate('TIT_RepHistxDoc','Reporte de Histórico por Documento')>
<cfset LB_DelSoc	= t.Translate('LB_DelSoc','Del socio')>
<cfset LB_HastaFec	= t.Translate('LB_HastaFec','Hasta  la fecha')>
<cfset LB_DocSimil	= t.Translate('LB_DocSimil','Documentos similares a')>
<cfset LB_Socio		= t.Translate('LB_Socio','Socio')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Tipo 		= t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_MontOrig	= t.Translate('LB_MontOrig','Monto Original')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Tipo_de_Cambio = t.Translate('LB_Tipo_de_Cambio','Tipo de Cambio','/sif/generales.xml')>
<cfset LB_MontLocal	= t.Translate('LB_MontOrig','Monto Local')>
<cfset LB_SaldxMon	= t.Translate('LB_SaldxMon','Saldo Total por Moneda')>
<cfset LB_STotxMonL	= t.Translate('LB_STotxMonL','Saldo Total del Cliente en Moneda Local')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>

<cfif rsReporte.recordcount GT 0>
    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and ( formatos neq "flashpaper" and formatos neq "pdf" )>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.RFacturasHistCP"
		headers = "empresa:#rsEmpresa.Edescripcion#"/>
	<cfelse>
		<cfreport format="#formatos#" template= "RFacturasHistCP.cfr" query="#rsReporte#">
			<cfreportparam name="fechaIniLabel" value="#dateformat(url.fechaIni, 'dd/mm/yyyy')#">
			<cfreportparam name="Ddocumento" value="#url.Documento#">
			<cfreportparam name="LB_Fecha" value="#LB_Fecha#">
			<cfreportparam name="TIT_RepHistxDoc" value="#TIT_RepHistxDoc#">
			<cfreportparam name="LB_DelSoc" value="#LB_DelSoc#">
			<cfreportparam name="LB_HastaFec" value="#LB_HastaFec#">
			<cfreportparam name="LB_DocSimil" value="#LB_DocSimil#">
			<cfreportparam name="LB_Socio" value="#LB_Socio#">
			<cfreportparam name="LB_Moneda" value="#LB_Moneda#">
			<cfreportparam name="LB_Tipo" value="#LB_Tipo#">
			<cfreportparam name="LB_MontOrig" value="#LB_MontOrig#">
			<cfreportparam name="LB_Tipo_de_Cambio" value="#LB_Tipo_de_Cambio#">
			<cfreportparam name="LB_MontLocal" value="#LB_MontLocal#">
			<cfreportparam name="LB_SaldxMon" value="#LB_SaldxMon#">
			<cfreportparam name="LB_Documento" value="#LB_Documento#">
			<cfreportparam name="LB_STotxMonL" value="#LB_STotxMonL#">
		</cfreport>	
	</cfif>
<cfelse>
<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
       	<cfset MSG_SinReg = t.Translate('MSG_SinReg','NO SE ENCONTRARON REGISTROS QUE CUMPLAN CON EL CRITERIO DE BÚSQUEDA')>
		<th scope="col"> <title="*** #MSG_SinReg# *** "></title></th>
	  </tr>
</table>
</cfif>
