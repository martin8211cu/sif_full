<!---
	Creado por: Ana Villavicencio
	Fecha: 03 de enero del 2006
	Motivo: Nuevo reporte de Empleados por Rango de Salarios
--->
<cfif isdefined("Url.SalarioD") and not isdefined("Form.SalarioD")>
	<cfparam name="Form.SalarioD" default="#Url.SalarioD#">
</cfif>
<cfif isdefined("Url.SalarioH") and not isdefined("Form.SalarioH")>
	<cfparam name="Form.SalarioH" default="#Url.SalarioH#">
</cfif>
<cfif isdefined("Url.FechaD") and not isdefined("Form.FechaD")>
	<cfparam name="Form.FechaD" default="#Url.FechaD#">
</cfif>
<cfif isdefined("Url.FechaH") and not isdefined("Form.FechaH")>
	<cfparam name="Form.FechaH" default="#Url.FechaH#">
</cfif>
<cfif isdefined("Url.Corte") and not isdefined("Form.Corte")>
	<cfif url.Corte eq ''>	
		<cfparam name="Form.Corte" default="0">
	<cfelse>
		<cfparam name="Form.Corte" default="#Url.Corte#">
	</cfif>
</cfif>
<cfif isdefined("Url.formato") and not isdefined("Form.formato")>
	<cfparam name="Form.formato" default="#Url.formato#">
<cfelse >
	<cfparam name="Form.formato" default="flashpaper">
</cfif>

<cfquery name="rsReporte" datasource="#Session.DSN#">
	select DEidentificacion, de.DEapellido1 || ' ' || de.DEapellido2 || ', ' || de.DEnombre as nombre, LTsalario
		<cfif form.corte NEQ 0>
		,
		floor(LTsalario/<cfqueryparam cfsqltype="cf_sql_float" value="#form.Corte#">)*<cfqueryparam cfsqltype="cf_sql_float" value="#form.Corte#"> as corte
		<cfelse>
		,0 as corte
		</cfif>
	from LineaTiempo lt
		inner join RHPlazas p
		   on lt.RHPid = p.RHPid
		  and lt.Ecodigo = p.Ecodigo
	      and getdate() between LTdesde and LThasta 
		inner join CFuncional cf
		   on p.CFid = cf.CFid
		  and p.Ecodigo = cf.Ecodigo
		inner join DatosEmpleado de
		   on lt.DEid = de.DEid
	where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("form.SalarioD") and len(trim(form.SalarioD)) 
		and isdefined("form.SalarioH") and len(trim(form.SalarioH))>
	  and lt.LTsalario between <cfqueryparam cfsqltype="cf_sql_money" value="#Form.SalarioD#"> 
	  	and <cfqueryparam cfsqltype="cf_sql_money" value="#Form.SalarioH#">
	<cfelseif isdefined("form.SalarioD") and len(trim(form.SalarioD))>
		and lt.LTsalario >= <cfqueryparam cfsqltype="cf_sql_money" value="#Form.SalarioD#"> 
	<cfelseif isdefined("form.SalarioH") and len(trim(form.SalarioH))>	
		and lt.LTsalario <= <cfqueryparam cfsqltype="cf_sql_money" value="#Form.SalarioH#"> 
	</cfif>	
	order by corte, nombre, LTsalario
</cfquery>

<!---<cf_dump var="#rsReporte#"> ---> 
<cfif isdefined("rsReporte") AND rsReporte.RecordCount NEQ 0>
	<cfreport format="#Form.formato#" template= "ListaEmpRangoSal.cfr" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#Session.Enombre#">
		<cfif isdefined('Form.Corte') and LEN(TRIM(form.Corte))>
		<cfreportparam name="Corte" value="#form.Corte#">
		</cfif>
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