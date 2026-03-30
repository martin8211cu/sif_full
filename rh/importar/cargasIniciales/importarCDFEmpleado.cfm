
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>

	<cfquery datasource="#session.DSN#" name="datos">
		select 	identificacion,	identificacionfamiliar,	nombre,
				apellido1,apellido2,tipoidentificacion,
				parentezco,fechanacimiento,	sexo,
				direccion,#session.Ecodigo#
		from #table_name#		
	</cfquery>
	<cfset currentrow=0>
 <cftransaction>
	<cfloop query="datos">
		<cfset currentrow=currentrow+1>
			<cfquery datasource="#session.DSN#" name="Existe">

				select  CDRHHDEidentificacion, CDRHHFEidentificacion, CDRHHFEnombre, 
												CDRHHFEapellido1, CDRHHFEapellido2, CDRHHNTIcodigo, 
												CDRHHPid, CDRHHFEfnac, CDRHHFEsexo, 
												CDRHHFEdir, Ecodigo from CDRHHFEmpleado 
					where CDRHHDEidentificacion = '#identificacion#'
					and Ecodigo = #session.Ecodigo#
					and CDRHHFEidentificacion = #identificacionfamiliar#
			</cfquery>

		<cfif Existe.recordcount GT 0>

			<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
				insert into #errores# (Error)
		     	 values ('Error. El codigo del Empleado (#existe.CDRHHFEnombre# #existe.CDRHHFEapellido1#) YA Existe en catalogo de Empleados,el Error se genero en la  linea 
		     	 	#currentrow#')
			</cfquery>

		<cfelse>

			<cfquery datasource="#session.DSN#">
				insert into CDRHHFEmpleado (CDRHHDEidentificacion, CDRHHFEidentificacion, CDRHHFEnombre, 
									CDRHHFEapellido1, CDRHHFEapellido2, CDRHHNTIcodigo, 
									CDRHHPid, CDRHHFEfnac, CDRHHFEsexo, 
									CDRHHFEdir,Ecodigo
									)								
				values 		('#identificacion#',#identificacionfamiliar#,'#nombre#',
							'#apellido1#','#apellido2#','#tipoidentificacion#',
							#parentezco#,'#fechanacimiento#','#sexo#',
							'#direccion#',#session.Ecodigo#)
			</cfquery>
		</cfif>
	</cfloop>

		<cfquery name="rsErrores" datasource="#session.DSN#">
	    	select count(1) as cantidad
	    	from #errores#
	    </cfquery>

    <cfif rsErrores.cantidad GT 0>
    	<cfquery name="ERR" datasource="#session.DSN#">
    		select Error as MSG
    		from #errores#
    		group by Error
    	</cfquery>
    	<cfreturn>
 	</cfif>

	<cftransaction action="commit"/>
</cftransaction>


<!--- se quito estos campos por que solo aplica a costa rica


CDRHHAplicaCredFiscal, CDRHHCDcodigo, 
									CDRHHFechadesdeAplica, CDRHHFechahastaAplica

 --->