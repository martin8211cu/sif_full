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
<cfif isdefined("Url.Nombre1") and not isdefined("Form.Nombre1")>
	<cfparam name="Form.Nombre1" default="#Url.Nombre1#">
</cfif>
<cfif isdefined("Url.Nombre2") and not isdefined("Form.Nombre2")>
	<cfparam name="Form.Nombre2" default="#Url.Nombre2#">
</cfif>
<cfif isdefined("Url.Orden") and not isdefined("Form.Orden")>
	<cfparam name="Form.Orden" default="#Url.Orden#">
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
	select DEidentificacion, 
		<cfif isdefined('form.Nombre1')>
		{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )} as nombre,
		<cfelseif isdefined('form.Nombre2')>
		{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre,
		</cfif>
		DLTmonto as LTsalario <!---SML Modificacion para que solo considere el Sueldo Mensual--->
		<cfif form.corte NEQ 0>
		,
		floor(DLTmonto/<cfqueryparam cfsqltype="cf_sql_float" value="#form.Corte#">)*<cfqueryparam cfsqltype="cf_sql_float" value="#form.Corte#"> as corte
		<cfelse>
		,0 as corte
		</cfif>
        from LineaTiempo lt
        <!---SML Modificacion para que solo considere el Sueldo Mensual--->
    	inner join DLineaTiempo dl on dl.LTid = lt.LTid 
        inner join ComponentesSalariales cs on cs.CSid = dl.CSid
        	and cs.CSsalariobase = 1 
		<!---SML Modificacion para que solo considere el Sueldo Mensual--->
		inner join RHPlazas p
		   on lt.RHPid = p.RHPid
		  and lt.Ecodigo = p.Ecodigo
	      and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta 
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
	<cfif isdefined('form.orden')>
		<cfif form.orden EQ 1>
			order by corte,de.DEidentificacion, LTsalario
		<cfelse>
			order by corte,nombre, LTsalario
		</cfif>
	</cfif>
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
		<tr><td>------------------  <cf_translate  key="LB_NoHayDatosRelacionados">No hay datos relacionados</cf_translate> ------------------</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</cfif>