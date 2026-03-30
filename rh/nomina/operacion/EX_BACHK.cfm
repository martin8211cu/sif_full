<cfparam name="url.Bid" 		default="0" >
<cfparam name="url.EcodigoASP" 	default="#session.EcodigoSDC#" >
<cfparam name="url.ERNid" 	 	default="0" >

<cf_dbtemp name="Datos" returnvariable="Datos" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="Datos" 	type="char(220)"  	mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="data_tmp" returnvariable="datos_temp" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="DEid" 		 	type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="cedula" 		 type="char(10)"  	mandatory="no">
	<cf_dbtempcol name="nombre" 		 type="char(30)"  	mandatory="no">
	<cf_dbtempcol name="TipoCuenta"		 type="char(50)"	mandatory="no">
	<cf_dbtempcol name="Cuenta" 		 type="char(20)"	mandatory="no">
	<cf_dbtempcol name="monto"			 type="varchar(15)"	mandatory="no">	
</cf_dbtemp>

<!--- recupera la cedula juridica de la empresa (campo Eidentificacion de la vista Empresa ) --->
<cfquery name="rs_empresacedula" datasource="#session.DSN#">
	select Enombre, Eidentificacion
	from Empresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
<cfset cedula_juridica = mid(rs_empresacedula.Eidentificacion, 1, 20) >
<cfset empresa = mid(rs_empresacedula.Enombre, 1, 20) >

<cfquery datasource="#session.DSN#">
	insert into #datos_temp#(	DEid,
								cedula, 
								nombre, 
								TipoCuenta, 
								Cuenta, 
								monto
						    )

	<cfif isdefined("Application.dsinfo") and Application.dsinfo[session.dsn].type is 'oracle'>
		select case b.CBTcodigo when 0 then 'Cuenta Universal' else 'Cuenta de Ahorro' end as TipoCuenta, 
					DEcuenta as Cuenta, DRNliquido as Monto, 
					case when length(de.DEapellido1 || ' ' || de.DEapellido2 || ' ' || de.DEnombre) > 30 then substring(de.DEapellido1 || ' ' || de.DEapellido2 || ' ' || de.DEnombre, 1, 30) else de.DEapellido1 || ' ' || de.DEapellido2 || ' ' || de.DEnombre end as nombre
	<cfelse>
		select case b.CBTcodigo when 0 then 'Cuenta Universal' else 'Cuenta de Ahorro' end as TipoCuenta, 
					DEcuenta as Cuenta, DRNliquido as Monto, 
				case when char_length(de.DEapellido1 + ' ' + de.DEapellido2 + ' ' + de.DEnombre) > 30 then substring(de.DEapellido1 + ' ' + de.DEapellido2 + ' ' + de.DEnombre, 1, 30) else de.DEapellido1 + ' ' || de.DEapellido2 + ' ' + de.DEnombre end as nombre
	</cfif>
	from DRNomina a, DatosEmpleado b
	where a.DEid = b.DEid
	  and a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
</cfquery>

<!--- quita los caracteres que no son letras ni digitos del nombre del empleado --->
<!--- no encontre la forma de hacerlo en base de datos, por eso el ciclo --->
<cfquery name="rs_nombre" datasource="#session.DSN#">
	select DEid, nombre from #datos_temp#
</cfquery>
<cfloop query="rs_nombre">
	<cfset nombre_nuevo = lcase(rs_nombre.nombre) >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"á","a","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"é","e","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"í","i","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ó","o","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ú","u","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ñ","n","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ä","a","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ë","e","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ï","i","ALL") >			
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ö","o","ALL") >
	<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"ü","u","ALL") >		
	
	<cfset nombre_nuevo = REReplaceNoCase(nombre_nuevo,"[^A-Za-z0-9 ]","","ALL") >
	<cfset nombre_nuevo = ucase(nombre_nuevo) >	
	<cfquery datasource="#session.DSN#">
		update #datos_temp#
		set nombre = <cfqueryparam cfsqltype="cf_sql_char" value="#nombre_nuevo#">
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nombre.DEid#">
	</cfquery>
</cfloop>

<cfif isdefined("Application.dsinfo") and Application.dsinfo[session.dsn].type is 'oracle'>
	<cfquery name="ERR" datasource="#session.DSN#" >
		select 	TipoCuenta ||
				Cuenta ||
				Monto  ||
				Nombre
		from #datos_temp#
	</cfquery>
<cfelse>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 	TipoCuenta +
				Cuenta +
				Monto  +
				Nombre
		from #datos_temp#
	</cfquery>
</cfif>
