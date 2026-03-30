<cfquery name="rsCheck1" datasource="#session.DSN#">
	select count(1) as check1
	from #table_name# a, DatosEmpleado d
	where DEidentificacion = identificacion 
	and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfset Vcheck1 = rsCheck1.check1>

<cftransaction>
	<cfif Vcheck1 LT 1>
		<cfquery datasource="#session.DSN#">
			insert INTO DatosEmpleado 
					(Ecodigo, Usucodigo, Ulocalizacion, DEnombre, 
					 DEapellido1, DEapellido2, NTIcodigo, DEidentificacion, 
					 DEcivil, DEfechanac, DEsexo, DEdireccion, Bid, CBcc, 
					 Mcodigo, DEtelefono1, DEtelefono2, DEemail, DEtarjeta, 
					 DEcantdep, DEsistema) 
			select <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				   '00', nombre, apellido1, apellido2, tipo_id, identificacion, civil, 
				   fecha_nac, sexo, direccion, banco, cuenta, moneda, 
				   telefono1, telefono2, correo, tarjeta, 0 , 1
			from #table_name#
		</cfquery>
	<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			select 'Datos ya existen', DEnombre, DEapellido1, DEapellido2, DEidentificacion
			from DatosEmpleado, #table_name# 
			where DEidentificacion = identificacion
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>
</cftransaction>