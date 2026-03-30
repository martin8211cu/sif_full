<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<cfif isdefined("Url.CPPid") and Len(Trim(Url.CPPid))>
	<cfparam name="Form.CPPid" default="#Url.CPPid#">
<cfelse>
	<cfparam name="Form.CPPid" default="-1">
</cfif>
<cfif isdefined("Url.chkCancelados")>
	<cfset form.chkCancelados = 1>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.CPPid") and Len(Trim(Form.CPPid)) and Form.CPPid NEQ -1>
	<cfset filtro = filtro & " and a.CPPid = " & Form.CPPid>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPPid=" & Form.CPPid>
</cfif>
<cfquery name="rsMontoOrigen" datasource="#Session.DSN#">
	select coalesce(sum(CPDDmonto),0) as MontoOrigen
	from CPDocumentoE a
		inner join CPDocumentoD b
			on b.CPDEid = a.CPDEid
	where a.Ecodigo = #Session.Ecodigo#
		and a.CPDEtipoDocumento = 'T'
		and a.CPDEaplicado = 0
		and a.CPDEenAprobacion = 1
		and b.CPDDtipo = -1
	<cfif isdefined("form.CPPid") and Len(Trim(form.CPPid)) and form.CPPid NEQ -1>
			and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			<cfset navegacion = navegacion & iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPPid=" & form.CPPid>
	</cfif>
</cfquery>

<cfquery name="rsMontoDestino" datasource="#Session.DSN#">
	select coalesce(sum(CPDDmonto),0) as MontoDestino
	from CPDocumentoE a
		inner join CPDocumentoD b
			on b.CPDEid = a.CPDEid
	where a.Ecodigo = #Session.Ecodigo#
		and a.CPDEtipoDocumento = 'T'
		and a.CPDEaplicado = 0
		and a.CPDEenAprobacion = 1
		and b.CPDDtipo = 1
	<cfif isdefined("form.CPPid") and Len(Trim(form.CPPid)) and form.CPPid NEQ -1>
			and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			<cfset navegacion = navegacion & iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPPid=" & form.CPPid>
	</cfif>
</cfquery>

<cfquery name="rsListaTraslados" datasource="#Session.DSN#">
	select a.CPPid, 
		'Variacion PCG del periodo ' #_Cat#  case c.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end #_Cat# ': '
		#_Cat# <cf_dbfunction name="to_sdateDMY" args="max(c.CPPfechaDesde)"> #_Cat# ' - ' #_Cat# 
		<cf_dbfunction name="to_sdateDMY" args="max(c.CPPfechaHasta)"> as PeriodoPres,
		#rsMontoOrigen.MontoOrigen# as MontoOrigen,
		#rsMontoDestino.MontoDestino# as MontoDestino,
		min(a.CPDEfechaDocumento) as fecha
	from CPDocumentoE a
		inner join CPresupuestoPeriodo c
			on c.CPPid = a.CPPid
	where a.Ecodigo = #Session.Ecodigo#
		and a.CPDEtipoDocumento = 'T'
		and a.CPDEaplicado = 0
		and a.CPDEenAprobacion = 1
		and exists(select 1 from CPDocumentoD d where d.CPDEid = a.CPDEid and d.PCGDid is not null)
		and exists(select 1 from CPDocumentoA c, CPSeguridadUsuario s
				 where c.CPDEid		= a.CPDEid
				   and c.UsucodigoAprueba is null
				   and s.Ecodigo	= #session.Ecodigo#
				   and s.CFid		= c.CFid
				   and s.Usucodigo	= #session.Usucodigo#
				   and s.CPSUaprobacion	= 1)
	<cfif isdefined("form.CPPid") and Len(Trim(form.CPPid)) and form.CPPid NEQ -1>
			and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			<cfset navegacion = navegacion & iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPPid=" & form.CPPid>
	</cfif>
	group by a.CPPid,c.CPPtipoPeriodo
</cfquery>
<cf_templateheader title="Estimación de Presupuesto">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Estimación de Fuentes de Financiamiento y Egresos">

<form name="filtroAcciones" method="post" action="traslado-sql.cfm">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro"><tr> 
		<td class="fileLabel">Per&iacute;odo del Presupuesto</td>
		<td class="fileLabel">&nbsp;</td>
	</tr>
	<tr>
		<td><cf_cboCPPid IncluirTodos="true" value="#Form.CPPid#" CPPestado="1"></td>
		<td align="center"><input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar"></td>
	</tr></table>
</form>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center"><tr>
	<td>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsListaTraslados#"/>
			<cfinvokeargument name="desplegar" value="PeriodoPres, fecha, MontoOrigen, MontoDestino"/>
			<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Fecha, Total Origen, Total Destino"/>
			<cfinvokeargument name="formatos" value="V,D,M,M"/>
			<cfinvokeargument name="align" value="left, center, right, right"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="formName" value="listaTraslado"/>
			<cfinvokeargument name="keys" value="CPPid"/>
			<cfinvokeargument name="irA" value="traslado-form.cfm"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="PageIndex" value="1"/>
		</cfinvoke>		
	</td>
</tr></table>
	<cf_web_portlet_end>
<cf_templatefooter>