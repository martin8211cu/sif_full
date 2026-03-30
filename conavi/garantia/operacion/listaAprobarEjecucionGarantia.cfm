<cfparam name="modo" default="ALTA">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Aprobración Garantías en Ejecución" skin="#Session.Preferences.Skin#">
<cfquery name="rsGarantias" datasource="#session.dsn#">
	select  d.COLGid, d.COLGEstado, a.COEGid, a.COEGReciboGarantia, case when a.COEGTipoGarantia = 1 then 'Participación' else 'Complimiento' end as tipoGarantia, b.Mnombre, a.COEGMontoTotal
		,a.COEGReciboGarantia, c.SNnombre, a.COEGVersion, a.COEGPersonaEntrega, a.COEGIdentificacion, case when a.COEGContratoAsociado = 'N' then  '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'  else  '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' end as COEGContratoAsociado
	from COLiberaGarantia d
		inner join COHEGarantia a
			inner join Monedas b
				on b.Mcodigo = a.Mcodigo
			left join SNegocios c
				on c.SNid = a.SNid
		on a.COEGid = d.COEGid and a.COEGVersion = d.COEGVersion
	where d.COLGEstado = 2 <!---  Estado Enviada a aprobar --->
		  and d.COLGTipoMovimiento = 2 <!--- Tipo Ejecución --->
		and d.Ecodigo = #session.Ecodigo#
		<cfif isdefined('form.filtros_COEGReciboGarantia') and len(trim(form.filtros_COEGReciboGarantia))>
		and a.COEGReciboGarantia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.filtros_COEGReciboGarantia,',','','ALL')#">
		</cfif>
		<cfif isdefined('form.filtro_SNnombre') and len(trim(form.filtro_SNnombre))>
		and lower(c.SNnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_SNnombre)#%">
		</cfif>
		<cfif isdefined('form.filtro_tipoGarantia') and len(trim(form.filtro_tipoGarantia)) and form.filtro_tipoGarantia neq -1>
		and a.COEGTipoGarantia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.filtro_tipoGarantia#">
		</cfif>
		<cfif isdefined('form.filtros_COEGVersion') and len(trim(form.filtros_COEGVersion))>
		and a.COEGVersion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.filtros_COEGVersion,',','','ALL')#">
		</cfif>
		<cfif isdefined('form.filtros_COEGMontoTotal') and len(trim(form.filtros_COEGMontoTotal))>
		and a.COEGMontoTotal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.filtros_COEGMontoTotal,',','','ALL')#">
		</cfif>
		<cfif isdefined('form.filtro_Mnombre') and len(trim(form.filtro_Mnombre)) and form.filtro_Mnombre neq -1>
		and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtro_Mnombre#">
		</cfif>
		<cfif isdefined('form.filtro_COEGPersonaEntrega') and len(trim(form.filtro_COEGPersonaEntrega))>
		and lower(a.COEGPersonaEntrega) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_COEGPersonaEntrega)#%">
		</cfif>
		<cfif isdefined('form.filtro_COEGIdentificacion') and len(trim(form.filtro_COEGIdentificacion))>
		and lower(a.COEGIdentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_COEGIdentificacion)#%">
		</cfif>	
		<cfif isdefined('form.filtro_COEGContratoAsociado') and len(trim(form.filtro_COEGContratoAsociado))>
		and lower(a.COEGContratoAsociado) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_COEGContratoAsociado)#%">
		</cfif>
	order by a.COEGReciboGarantia DESC, a.COEGVersion DESC
</cfquery>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select -1 as value, '-- todos --' as description, 0 as ord from dual
	union
	select Mcodigo as value, Mnombre as description, 1 as ord
	from Monedas
	where Ecodigo = #Session.Ecodigo#
	order by ord,description
</cfquery>
<cfquery name="rsTipoGarantia" datasource="#Session.DSN#">
	select -1 as value, '-- todos --' as description, 0 as ord from dual
	union
	select 1 as value, 'Participación' as description, 1 as ord from dual
	union
	select 2 as value, 'Cumplimiento' as description, 1 as ord from dual
	order by ord,description
</cfquery> 
<cfquery name="rsCOEGContratoAsociado" datasource="#Session.DSN#">
	select '' as value, '-- todos --' as description, 0 as ord from dual
	union
	select 'S' as value, 'Si' as description, 1 as ord from dual
	union
	select 'N' as value, 'No' as description, 1 as ord from dual
	order by ord,description
</cfquery> 
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">		        
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsGarantias#" 
				conexion="#session.dsn#"
				desplegar="COEGReciboGarantia, SNnombre, COEGPersonaEntrega, COEGIdentificacion, tipoGarantia, COEGVersion, COEGMontoTotal, Mnombre, COEGContratoAsociado"
				etiquetas="Recibo Garantía, Proveedor, Persona Entrega, Identificación, Tipo Garantía, Versión, Monto, Moneda, Asoc Contr"
				formatos="I, S, S, S, S, I, M, S, S"
				mostrar_filtro="true"
				align="right, left, left, left, left, right, right, left, center"
				ira="aprobarEjecucionGarantia.cfm"
				checkboxes="N"
				rsMnombre="#rsMonedas#"
				rstipoGarantia="#rsTipoGarantia#"
				rsCOEGContratoAsociado='#rsCOEGContratoAsociado#'
				keys="COLGid">
			</cfinvoke>
		</td> 
	</tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>