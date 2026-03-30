<cfif isDefined("form.botonsel") and len(trim(form.botonsel))>
	<cfif form.botonsel eq "Cambio">
	
		<!--- Verifica si existe el empleado en la empresa actual --->
		<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#">
			select 1
			from DatosEmpleado
			where NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">
			  and upper(DEidentificacion) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(form.DEidentificacion))#"> 
			  and upper(DEidentificacion) <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(form.DEidentificacionL))#"> 
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=<strong>El Empleado ya existe con esa identificacion.</strong>" addtoken="no">
			<cfabort> 
		<cfelse>

			<cftransaction>			
				<cfquery name="updDE" datasource="#Session.DSN#">
					update DatosEmpleado					
					set DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">,
						NTIcodigo		 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.NTIcodigo#">,
						DEnombre		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEnombre#">,
						DEapellido1		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido1#">,
						DEapellido2		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido2#">,
						Mcodigo			 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
						DEdireccion		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdireccion#">,
						DEtelefono1		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono1#">,
						DEtelefono2		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono2#">,
						DEemail			 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEemail#">,
						DEcivil			 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEcivil#">,
						DEfechanac		 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DEfechanac)#">,
						DEsexo			 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DEsexo#">,
						Usucodigo		 = #session.Usucodigo#,
						BMUsucodigo		 = #session.Usucodigo#,
						<cfif isdefined("form.chkFirma")>
							DEdato1      = 'SI'
						<cfelse>
							DEdato1      = 'NO'
						</cfif>,
						isAbogado = <cfif form.COB_ABG eq 'abogado'> 1 <cfelse> 0 </cfif>,
						isCobrador = <cfif form.COB_ABG eq 'cobrador'> 1 <cfelse> 0 </cfif>,
						<cfif form.porcientocobranza1 eq ''><cfset form.porcientocobranza1 = 0></cfif>
						<cfif form.porcientocobranza2 eq ''><cfset form.porcientocobranza2 = 0></cfif>
						PorcentajeCobranzaAntes = <cfqueryparam cfsqltype="cf_sql_money" value=#form.porcientocobranza1#>,
						PorcentajeCobranzaDespues = <cfqueryparam cfsqltype="cf_sql_money" value=#form.porcientocobranza2#>
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and DEid	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">				  
				</cfquery>
			</cftransaction>		
		</cfif>
			
	<cfelseif form.botonsel eq "Alta">	
		<!--- Verifica si existe el empleado en la empresa actual --->
		<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#">
			select 1
			from DatosEmpleado
			where NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">
			  and upper(DEidentificacion) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(form.DEidentificacion))#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=<strong>El Empleado ya existe con esa identificacion.</strong>" addtoken="no">
			<cfabort> 
		<cfelse>
			<cftransaction>
				<cfquery name="insDE" datasource="#Session.DSN#">
					insert into DatosEmpleado (
						Ecodigo, DEidentificacion, NTIcodigo, DEnombre,	DEapellido1,
						DEapellido2, Mcodigo, CBcc,	DEdireccion, DEtelefono1,
						DEtelefono2, DEemail, DEcivil, DEfechanac, DEsexo,
						Usucodigo, BMUsucodigo, DEdato1, isAbogado, isCobrador, PorcentajeCobranzaAntes, PorcentajeCobranzaDespues)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">,
						<cfqueryparam cfsqltype="cf_sql_char"    value="#form.NTIcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEnombre#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido2#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
						' ',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdireccion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono2#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEemail#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEcivil#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DEfechanac)#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.DEsexo#">,
						#session.Usucodigo#,
						#session.Usucodigo#,
						<cfif isdefined("form.chkFirma")>
							'SI'
						<cfelse>
							'NO'
						</cfif>,
						<cfif isdefined('form.Cob_Abg')> <cfif  form.COB_ABG eq 'abogado'> 1 <cfelse> 0 </cfif> <cfelse> 0 </cfif>,
						<cfif isdefined('form.Cob_Abg')> <cfif  form.COB_ABG eq 'cobrador'> 1 <cfelse> 0 </cfif> <cfelse> 0 </cfif>,
						<cfif form.porcientocobranza1 eq ''><cfset form.porcientocobranza1=0></cfif>
						<cfif form.porcientocobranza2 eq ''><cfset form.porcientocobranza2=0></cfif>
						<cfqueryparam cfsqltype="cf_sql_money" value=#form.porcientocobranza1#>,
						<cfqueryparam cfsqltype="cf_sql_money" value=#form.porcientocobranza2#>
						)
					<cf_dbidentity1 datasource="#Session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="insDE">
				<cfset form.DEid = insDE.identity>		
				
			</cftransaction>		
		</cfif>		

	<cfelseif form.botonsel eq "Baja">
		<cftransaction>	
			<!--- Verifica si el empleado tiene alguna línea de tiempo asociada --->
			<cfquery name="rsExisteEmpleadoCF" datasource="#Session.DSN#">
				select 1
				from EmpleadoCFuncional
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">				  
			</cfquery>
			
			<cfif rsExisteEmpleadoCF.recordCount GT 0>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=<strong>El Empleado no puede eliminarse por tener una o varias lineas de tiempo asociadas.</strong>" addtoken="no">
				<cfabort> 
			<cfelse>
				<cfquery name="updECF" datasource="#Session.DSN#">
					delete from DatosEmpleado
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">				  
				</cfquery>
			</cfif>
		</cftransaction>
		<cflocation url="empleadosCF-form.cfm?btnNuevo=NUEVO">
		
	<cfelseif form.botonsel eq "Lista">
		<cflocation url="empleadosCF.cfm">
		<cfabort>

	<cfelseif form.botonsel eq "Nuevo">
		<cflocation url="empleadosCF-form.cfm?btnNuevo=NUEVO">
		<cfabort>
	</cfif>
</cfif>
			
<cfif isDefined("form.DEid")>
	<cflocation url="empleadosCF-form.cfm?DEid=#form.DEid#">
<cfelse>
	<cflocation url="empleadosCF-form.cfm">
</cfif>