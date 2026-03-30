<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="data" datasource="#session.DSN#">
	select 	a.CCTcodigo, 
			b.Dtref, 
			a.Ddocumento, 
			b.Ddocref, 
			a.SNcodigo,  
			s.SNnumero, 
			s.SNidentificacion, 
			s.SNnombre, 
			b.Dfecha , 
			b.Dvencimiento, 
			s.Mcodigo, 
			b.Dtotal as Monto, 
			b.Dsaldo, 
			o.Oficodigo,
			m.Miso4217 as moneda, 
			s.SNnumero #_Cat# ' - ' #_Cat# s.SNnombre #_Cat# '   ' #_Cat# '(' #_Cat#s.SNidentificacion #_Cat# ')'  as socio
				
	from RCBitacora a
	
	inner join Documentos b
	on b.Ecodigo = a.Ecodigo	
	and b.CCTcodigo = a.CCTcodigo
	and b.Ddocumento = a.Ddocumento
	
	inner join SNegocios s
	  on s.Ecodigo = a.Ecodigo
	 and s.SNcodigo = a.SNcodigo
	
	inner join Oficinas o
	  on o.Ecodigo = b.Ecodigo
	  and o.Ocodigo = b.Ocodigo	
	
	inner join Monedas m
	  on b.Ecodigo = m.Ecodigo
	  and b.Mcodigo = m.Mcodigo
	
	inner join CCTransacciones t
	  on t.Ecodigo   = a.Ecodigo
	  and t.CCTcodigo  = a.CCTcodigo
				
	where a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif isdefined("url.CcuentaNueva") and len(trim(url.CcuentaNueva)) and url.CcuentaNueva neq 0 >
		and a.Cuenta_Nueva = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CcuentaNueva#">
	</cfif>

	<cfif isdefined("url.CcuentaAnt") and len(trim(url.CcuentaAnt)) and url.CcuentaAnt neq 0 >
		and a.Cuenta_Anterior = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CcuentaAnt#">
	</cfif>

	and a.RCBestado = 0
</cfquery>

<cfquery name="rsCuentaAnt" datasource="#session.DSN#">
	select Cformato, Cdescripcion
	from CContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CcuentaAnt#">
</cfquery>
<cfquery name="rsCuentaNueva" datasource="#session.DSN#">
	select Cformato, Cdescripcion
	from CContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CcuentaNueva#">
</cfquery>

<cfset params = '&SNcodigo=#url.SNcodigo#&CcuentaAnt=#url.CcuentaAnt#&CcuentaNueva=#url.CcuentaNueva#' >
<cf_rhimprime datos="/sif/cc/operacion/reclasificacionCuentas-consulta.cfm" paramsuri="#params#">

<table cellpadding="2" cellspacing="0" border="0" width="95%" align="center">
	<cfoutput>
	<tr style="font-weight:bold">
	  <td align="center" >#session.Enombre#</td>
	</tr>
	<tr style="font-weight:bold">
	  <td align="center" >Consulta de Documentos de Reclasificaci&oacute;n.</td>
	</tr>
	<tr>
		<td align="center" ><strong>Cuenta Anterior:</strong>&nbsp;<cfif len(trim(rsCuentaAnt.Cdescripcion)) >#trim(rsCuentaAnt.Cformato)# - #rsCuentaAnt.Cdescripcion#<cfelse>Todas</cfif></td>
	</tr>
	<tr>
		<td align="center" ><strong>Cuenta Nueva:</strong>&nbsp;<cfif len(trim(rsCuentaNueva.Cdescripcion)) >#trim(rsCuentaNueva.Cformato)# - #rsCuentaNueva.Cdescripcion#<cfelse>Todas</cfif></td>
	</tr>
	</cfoutput>

	<tr><td>
		<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pLista"
			query="#data#"
			desplegar="CCTcodigo, Ddocumento,  Dfecha, DVencimiento, Moneda, monto, Oficodigo"
			etiquetas="Tipo Transacci&oacute;n, Documento,  Fecha Doc, Fecha Venc., Moneda, Monto, Oficina"
			formatos="S, S,  D, D, S, M, S"
			align="left, left,  center, center, center, right, right"
			showlink="false"
			maxrows="0"
			pageindex=""
			ira=""/>
	</td></tr>
	<tr><td align="center">--- Fin del Reporte ---</td></tr>  

</table>	

<cfabort>