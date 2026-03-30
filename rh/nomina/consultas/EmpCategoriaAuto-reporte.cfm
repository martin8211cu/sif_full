<!---
	Creado por: Ana Villavicencio
	Fecha: 10 de enero del 2006
	Motivo: Nuevo reporte de Empleados por Categoria Autorizada
--->


<cfif isdefined("Url.FechaD") and not isdefined("Form.FechaD")>
	<cfparam name="Form.FechaD" default="#Url.FechaD#">
</cfif>
<cfif isdefined("Url.FechaH") and not isdefined("Form.FechaH")>
	<cfparam name="Form.FechaH" default="#Url.FechaH#">
</cfif>
<cfif isdefined("Url.Nombre1") and not isdefined("Form.Nombre1")>
	<cfparam name="Form.Nombre1" default="#Url.Nombre1#">
</cfif>
<cfif isdefined("Url.Nombre2") and not isdefined("Form.Nombre2")>
	<cfparam name="Form.Nombre2" default="#Url.Nombre2#">
</cfif>
<cfif isdefined("Url.Orden") and not isdefined("Form.Orden")>
	<cfparam name="Form.Orden" default="#Url.Orden#">
</cfif>
<cfif isdefined("Url.RHCid0") and not isdefined("Form.RHCid0")>
	<cfparam name="Form.RHCid0" default="#Url.RHCid0#">
</cfif>
<cfif isdefined("Url.RHCid1") and not isdefined("Form.RHCid1")>
	<cfparam name="Form.RHCid1" default="#Url.RHCid1#">
</cfif>
<cfif isdefined("Url.formato") and not isdefined("Form.formato")>
	<cfparam name="Form.formato" default="#Url.formato#">
<cfelse >
	<cfparam name="Form.formato" default="flashpaper">
</cfif>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Indefinido"
Default="Indefinido"
returnvariable="LB_Indefinido"/>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		c.RHCid,
		dl.DLfvigencia as fdesde, 
	    case when dl.DLffin is null then '#TRIM(LB_Indefinido)#' when dl.DLffin = '61000101' then '#TRIM(LB_Indefinido)#' else <cf_dbfunction name="date_format" args="dl.DLffin,DD-MM-YYYY"> end as fhasta, 
		c.RHCcodigo,
		dl.RHCPlinea,
		RHCdescripcion, 
		RHTTdescripcion, 
		dl.DEid,
		<cfif isdefined('form.Nombre1')>
			{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )}  as nombre,
		<cfelseif isdefined('form.Nombre2')>
			{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as nombre,
		</cfif>
		de.DEidentificacion
	from DLaboralesEmpleado dl
	inner join RHCategoriasPuesto cp
	   on dl.Ecodigo = cp.Ecodigo
	  and dl.RHCPlinea is not null
	  and dl.RHCPlinea = cp.RHCPlinea
	inner join DatosEmpleado de
	   on dl.Ecodigo = de.Ecodigo
	  and dl.DEid = de.DEid
	inner join RHCategoria c
	   on cp.Ecodigo = c.Ecodigo
	  and cp.RHCid = c.RHCid 
	inner join RHTTablaSalarial ts
	   on cp.Ecodigo = ts.Ecodigo 
	  and cp.RHTTid = ts.RHTTid
	where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	<cfif isdefined('form.FechaD') and LEN(TRIM(form.FechaD)) and isdefined('form.FechaH') and LEN(TRIM(form.FechaH)) >
	  and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaD)#"> 
	  					 and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaH)#">
	<cfelseif isdefined('form.FechaD') and LEN(TRIM(form.FechaD))>
	  and dl.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaD)#"> 
	<cfelseif isdefined('form.FechaH') and LEN(TRIM(form.FechaH))>
	  and dl.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaH)#"> 
	</cfif>
	<cfif isdefined('form.RHCid0') and LEN(TRIM(form.RHCid0)) and isdefined('form.RHCid0') and LEN(TRIM(form.RHCid0)) >
		<cfif form.RHCid0 GT form.RHCid1>
	  		and c.RHCid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid1#"> 
	  					 and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid0#">
		<cfelse>
			and c.RHCid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid0#"> 
	  					 and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid1#">
		</cfif>
	<cfelseif isdefined('form.RHCid0') and LEN(TRIM(form.RHCid0))>
	  and c.RHCid >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid0#"> 
	<cfelseif isdefined('form.RHCid1') and LEN(TRIM(form.RHCid1))>
	  and c.RHCid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid1#"> 
	</cfif>
	<cfif isdefined('form.orden')>
		<cfif form.orden EQ 1>
			order by c.RHCcodigo, de.DEidentificacion
		<cfelse>
			order by c.RHCcodigo, nombre
		</cfif>
	</cfif>
</cfquery>
<!---  
<cfdump var="#form#">
<cf_dump var="#rsReporte#">--->


<cfif isdefined("rsReporte") AND rsReporte.RecordCount NEQ 0>
	<cfreport format="#Form.formato#" template= "EmpCategoriaAuto.cfr" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#Session.Enombre#">
		<cfreportparam name="FechaD" value="#form.FechaD#">
		<cfreportparam name="FechaH" value="#form.FechaH#">
		<cfif isdefined("Form.formato") and Len(Trim(Form.formato))>
			<cfreportparam name="formato" value="#Form.formato#">
		<cfelse>
			<cfreportparam name="formato" value="0">
		</cfif>
	</cfreport>
<cfelse>
	<table width="40%" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr><td>------------------  No hay datos relacionados ------------------</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</cfif>