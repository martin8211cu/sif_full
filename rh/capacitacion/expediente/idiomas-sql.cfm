
<!----- valida que exista el registro para el empleado---->
<cfquery datasource="#session.dsn#" name="rsValida">
	select count(1) as valor from DatosOferentes where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>
 
<cfif not rsValida.valor>
	<cfquery datasource="#session.dsn#" name="rs">
		insert into DatosOferentes (DEid, Ecodigo,NTIcodigo,RHOidentificacion,RHOnombre,RHOcivil,RHOsexo,RHOapellido1,RHOapellido2,RHOtelefono1,RHOtelefono2,RHOemail,RHOfechanac)
		select DEid, Ecodigo, NTIcodigo, DEidentificacion, DEnombre, DEcivil, DEsexo, DEapellido1, DEapellido2, DEtelefono1,DEtelefono1,DEemail,DEfechanac
		from DatosEmpleado
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>

<cfif isdefined('LvarAutog') and LvarAutog eq 1 >
	<cfset destino = "../autogestion.cfm?o=10&tab=10" >
<cfelseif isdefined("form.fromExpediente")>
	<cfset destino = "expediente.cfm?DEid=#form.DEid#&tab=13">
<cfelseif isdefined("fromAprobacionCV")>
	<cfset destino = "AprobacionCV.cfm?DEid=#form.DEid#&tab=6">
<cfelse>
	<cfset destino = "idiomas.cfm?DEid=#form.DEid#" >	
</cfif>
 
<cfquery name="ABC_datosOferente" datasource="#Session.DSN#">
	update DatosOferentes set
		RHOLengOral1 	= <cfif isdefined("form.RHOLengOral1") and len(trim(form.RHOLengOral1))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral1#"><cfelse>null</cfif>
		,RHOLengOral2 	= <cfif isdefined("form.RHOLengOral2") and len(trim(form.RHOLengOral2))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral2#"><cfelse>null</cfif>
		,RHOLengOral3 	= <cfif isdefined("form.RHOLengOral3") and len(trim(form.RHOLengOral3))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral3#"><cfelse>null</cfif>
		,RHOLengOral4 	= <cfif isdefined("form.RHOLengOral4") and len(trim(form.RHOLengOral4))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral4#"><cfelse>null</cfif>
		,RHOLengOral5 	= <cfif isdefined("form.RHOLengOral5") and len(trim(form.RHOLengOral5))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengOral5#"><cfelse>null</cfif>	
		,RHOLengEscr1 	= <cfif isdefined("form.RHOLengEscr1") and len(trim(form.RHOLengEscr1))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr1#"><cfelse>null</cfif>
		,RHOLengEscr2 	= <cfif isdefined("form.RHOLengEscr2") and len(trim(form.RHOLengEscr2))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr2#"><cfelse>null</cfif>
		,RHOLengEscr3 	= <cfif isdefined("form.RHOLengEscr3") and len(trim(form.RHOLengEscr3))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr3#"><cfelse>null</cfif>
		,RHOLengEscr4 	= <cfif isdefined("form.RHOLengEscr4") and len(trim(form.RHOLengEscr4))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr4#"><cfelse>null</cfif>
		,RHOLengEscr5 	= <cfif isdefined("form.RHOLengEscr5") and len(trim(form.RHOLengEscr5))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengEscr5#"><cfelse>null</cfif>
		,RHOLengLect1 	= <cfif isdefined("form.RHOLengLect1") and len(trim(form.RHOLengLect1))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect1#"><cfelse>null</cfif>
		,RHOLengLect2 	= <cfif isdefined("form.RHOLengLect2") and len(trim(form.RHOLengLect2))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect2#"><cfelse>null</cfif>
		,RHOLengLect3 	= <cfif isdefined("form.RHOLengLect3") and len(trim(form.RHOLengLect3))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect3#"><cfelse>null</cfif>
		,RHOLengLect4 	= <cfif isdefined("form.RHOLengLect4") and len(trim(form.RHOLengLect4))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect4#"><cfelse>null</cfif>	
		,RHOLengLect5 	= <cfif isdefined("form.RHOLengLect5") and len(trim(form.RHOLengLect5))> <cfqueryparam cfsqltype="cf_sql_float" value="#form.RHOLengLect5#"><cfelse>null</cfif>
		,RHOIdioma1 	= <cfif isdefined("form.RHOidioma1")   and len(trim(form.RHOidioma1))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOidioma1#"><cfelse>null</cfif>
		,RHOIdioma2 	= <cfif isdefined("form.RHOidioma2")   and len(trim(form.RHOidioma2))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOidioma2#"><cfelse>null</cfif>
		,RHOIdioma3 	= <cfif isdefined("form.RHOidioma3")   and len(trim(form.RHOidioma3))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOidioma3#"><cfelse>null</cfif>
		,RHOIdioma4 	= <cfif isdefined("form.RHOIdioma4")   and len(trim(form.RHOIdioma4))> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOIdioma4#"><cfelse>null</cfif>
		,RHOOtroIdioma5 = <cfif isdefined("form.RHOOtroIdioma5") and len(trim(form.RHOOtroIdioma5))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOOtroIdioma5#"><cfelse>null</cfif>
		,RHOMonedaPrt   = <cfif isdefined("form.RHOMonedaPrt") 	and len(trim(form.RHOMonedaPrt))> <cfqueryparam cfsqltype="cf_sql_char"    value="#form.RHOMonedaPrt#"><cfelse>null</cfif>				
		<cfif not isdefined ('form.btnGuardar') and not(isdefined ('LvarAutog') and LvarAutog eq 1)><!---- solo se puede modificar desde capacitacion---->
			,RHOidiomaAprobado   = <cfif isdefined("form.btnAprobar")>1<cfelse>0</cfif>				
		</cfif>
	where DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cflocation url="#destino#">