<!---
	Creado por: Ana Villavicencio
	Fecha: 02 de enero del 2006
	Motivo: Nuevo reporte de Vacaciones por empleado
--->

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.DEidentificacion") and not isdefined("Form.DEidentificacion")>
	<cfparam name="Form.DEidentificacion" default="#Url.DEidentificacion#">
</cfif>
<cfif isdefined("Url.NTIcodigo") and not isdefined("Form.NTIcodigo")>
	<cfparam name="Form.NTIcodigo" default="#Url.NTIcodigo#">
</cfif>
<cfif isdefined("Url.NombreEmp") and not isdefined("Form.NombreEmp")>
	<cfparam name="Form.NombreEmp" default="#Url.NombreEmp#">
</cfif>
<cfif isdefined("Url.DEid1") and not isdefined("Form.DEid1")>
	<cfparam name="Form.DEid1" default="#Url.DEid1#">
</cfif>
<cfif isdefined("Url.DEidentificacion1") and not isdefined("Form.DEidentificacion1")>
	<cfparam name="Form.DEidentificacion1" default="#Url.DEidentificacion1#">
</cfif>
<cfif isdefined("Url.NTIcodigo1") and not isdefined("Form.NTIcodigo1")>
	<cfparam name="Form.NTIcodigo1" default="#Url.NTIcodigo#1">
</cfif>
<cfif isdefined("Url.NombreEmp1") and not isdefined("Form.NombreEmp1")>
	<cfparam name="Form.NombreEmp1" default="#Url.NombreEmp1#">
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

<cfif isdefined("Url.formato") and not isdefined("Form.formato")>
	<cfparam name="Form.formato" default="#Url.formato#">
<cfelse >
	<cfparam name="Form.formato" default="flashpaper">
</cfif>

<cfquery name="rsReporte" datasource="#Session.DSN#">
	select  a.DEid,
		<cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif> as DEidentificacion,
		<cfif isdefined('form.Nombre1')>
		{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )}  as nombre,
		<cfelseif isdefined('form.Nombre2')>
		{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre,
		</cfif>
		{fn concat({fn concat(rtrim(b.RHTcodigo) , ' - ' )},  b.RHTdesc )} as Accion,
		a.DLfvigencia as Vigencia,
		a.DLffin as Finalizacion,
		case b.RHTcomportam 
			when 1 then '<cf_translate key="LB_Nombramiento">Nombramiento</cf_translate>' 
			when 2 then '<cf_translate key="LB_Cese">Cese</cf_translate>'
			when 3 then '<cf_translate key="LB_Vacaciones">Vacaciones</cf_translate>'
			when 4 then '<cf_translate key="LB_Permiso">Permiso</cf_translate>'
			when 5 then '<cf_translate key="LB_Incapacidad">Incapacidad</cf_translate>'
			when 6 then '<cf_translate key="LB_Cambio">Cambio</cf_translate>'
			when 7 then '<cf_translate key="LB_Anulacion">Anulación</cf_translate>'
			when 8 then '<cf_translate key="LB_Aumento">Aumento</cf_translate>'
			when 9 then '<cf_translate key="LB_CambioDeEmpresa">Cambio de Empresa</cf_translate>'
			else ''
		end as Comportamiento,
		a.DLsalario,
		c.RHPdescripcion,
		d.RHPdescpuesto					  
	 from DLaboralesEmpleado a  
	inner join DatosEmpleado de
	   on a.DEid = de.DEid
	   and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	inner join RHTipoAccion b
	   on a.RHTid = b.RHTid
	inner join RHPlazas c
	   on a.RHPid = c.RHPid 
	inner join RHPuestos d 
	   on c.RHPpuesto = d.RHPcodigo
	  and c.Ecodigo = d.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

	<!--- esta definido el uso del id de tarjeta en session --->
		<cfif isdefined("form.DEidentificacion") and len(trim(form.DEidentificacion)) 
			and isdefined("form.DEidentificacion1") and len(trim(form.DEidentificacion1))>
			  and <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif> between 
			  <cfif form.DEidentificacion GT form.DEidentificacion>
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion1#"> 
				and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">
			  <cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#"> 
				and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion1#">
			</cfif>
		<cfelseif isdefined("form.DEidentificacion") and len(trim(form.DEidentificacion))>
			and <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif> >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#"> 
		<cfelseif isdefined("form.DEidentificacion") and len(trim(form.DEidentificacion))>	
			and <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif> <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion1#"> 
		</cfif>

	<cfif isdefined('form.orden')>
		<cfif form.orden EQ 1>
			order by <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif>, Vigencia
		<cfelse>
			order by nombre, Vigencia
		</cfif>
	</cfif>
</cfquery>
<!--- <cf_dump var="#rsReporte#"> --->
<cfif isdefined("rsReporte") AND rsReporte.RecordCount NEQ 0>
	<cfreport format="#Form.formato#" template= "HistorialLaboralEmp.cfr" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#Session.Enombre#">
		<cfif isdefined("Form.formato") and Len(Trim(Form.formato))>
			<cfreportparam name="formato" value="#Form.formato#">
		</cfif>
	</cfreport>
</cfif>