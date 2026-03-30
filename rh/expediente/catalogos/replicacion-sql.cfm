<cfif isdefined("Form.Alta")>
	
	<!--- 1. Pone una referencia del empleado recien insertado, en la tabla DatosEmpleadoCorp.	   --->
	<cftransaction>
	
	<cfquery name="rsConsecutivo" datasource="#session.DSN#">
		select coalesce(max(DEidcorp), 0) + 1 as consecutivo
		from DatosEmpleadoCorp
	</cfquery>
	<cfset vNewEmplCorp = rsConsecutivo.consecutivo >
	
	<cfquery name="rsDEidCorp" datasource="#session.DSN#">
		insert into DatosEmpleadoCorp(	DEidcorp,
										DEid, 
										Ecodigo, 
										BMfechaalta, 
										BMUsucodigo )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmplCorp#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update DatosEmpleado
		set DEidcorp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmplCorp#">
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">
	</cfquery>
	
	</cftransaction>
		
	<!--- 2. Recupera las compañias de la cuenta empresarial, excepto la empresa donde estoy. Inserta los empleados  --->
	<cfquery name="rsEmpresas" datasource="#session.DSN#" >
		select e.Ecodigo, e.EcodigoSDC, e.Mcodigo
		from Empresas e
		where e.Ecodigo <> <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and e.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		and e.EcodigoSDC is not null
		and exists (  select 1
					  from Empresa
					  where Ecodigo = e.EcodigoSDC )
	</cfquery>

	<cfloop query="rsEmpresas">
		<cfset vEcodigo_sdc = rsEmpresas.EcodigoSDC > 
		<cftransaction>
		<cfquery name="ABC_datosEmpl" datasource="#Session.DSN#">
			insert into DatosEmpleado 
				(Ecodigo, NTIcodigo, DEidentificacion, 
				DEnombre, DEapellido1, DEapellido2, 
				Mcodigo, CBcc, DEdireccion, 
				DEtelefono1,DEtelefono2,DEemail,
				DEcivil, DEfechanac, 
				DEsexo, DEobs1, DEobs2, DEobs3, 
				DEdato1, DEdato2, DEdato3, DEdato4, DEdato5, DEinfo1, DEinfo2, DEinfo3,Usucodigo,Ulocalizacion,
				Bid, DEtarjeta
				<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>	
					, DEpassword
				</cfif>, Ppais,
				CBTcodigo, 
				DEcuenta
				)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEnombre#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido2#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.Mcodigo#">,
				'*',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdireccion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEemail#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEcivil#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.DEfechanac)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEsexo#">,
				<cfif isdefined('form.DEobs1')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs1#" null="#Len(Trim(Form.DEobs1)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEobs2')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs2#" null="#Len(Trim(Form.DEobs2)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEobs3')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs3#" null="#Len(Trim(Form.DEobs3)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEdato1')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato1#" null="#Len(Trim(Form.DEdato1)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEdato2')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato2#" null="#Len(Trim(Form.DEdato2)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEdato3')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato3#" null="#Len(Trim(Form.DEdato3)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEdato4')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato4#" null="#Len(Trim(Form.DEdato4)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEdato5')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdato5#" null="#Len(Trim(Form.DEdato5)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEinfo1')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo1#" null="#Len(Trim(Form.DEinfo1)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEinfo2')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo2#" null="#Len(Trim(Form.DEinfo2)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.DEinfo3')>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEinfo3#" null="#Len(Trim(Form.DEinfo3)) EQ 0#">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
				null,
				<cfif isdefined('Form.DEtarjeta') and Len(Trim(Form.DEtarjeta))>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtarjeta#">
				<cfelse>
					null
				</cfif>
				<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.DEpassword)#">
				</cfif>
	
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#"> 
	
				, <cfif isdefined("form.CBTcodigo") and len(trim(form.CBTcodigo))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBTcodigo#">								
				<cfelse>
					null
				</cfif>
	
				,null
				
			)
			<cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_datosEmpl">
		<cfset vNewEmpl2 = ABC_datosEmpl.identity>
	
		<!--- Foto del empleado --->
		<cfif isdefined("Form.rutafoto") and form.rutafoto NEQ "">
			<cfquery name="ABC_empleadosImagen" datasource="#Session.DSN#">
				insert into RHImagenEmpleado(DEid, foto)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl2#">, 
				<cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">
				)
			</cfquery>
		</cfif>
	
		<cfquery name="rsDEidCorp" datasource="#session.DSN#">
			insert into DatosEmpleadoCorp(	DEidcorp,
											DEid, 
											Ecodigo, 
											BMfechaalta, 
											BMUsucodigo )
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmplCorp#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl2#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			update DatosEmpleado
			set DEidcorp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmplCorp#">
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl2#">
		</cfquery>
		</cftransaction>
		
		<!--- Inserta registro en UsuarioReferencia --->
		<cfset ref = sec.insUsuarioRef(usuario, vEcodigo_sdc, 'DatosEmpleado', vNewEmpl2) >
		<cfset rolIns = sec.insUsuarioRol(usuario, vEcodigo_sdc, 'RH', 'AUTO')>		
		<cfset rolIns = sec.insUsuarioRol(usuario, vEcodigo_sdc, 'RH', 'ALUMNO')>		
		<!---
		<CFTRY>
		<cfif len(trim(vEcodigo_sdc))>
			<cfset ref = sec.insUsuarioRef(usuario, vEcodigo_sdc, 'DatosEmpleado', vNewEmpl2) >
		</cfif>
		<cfcatch type="any">
				<cfoutput>
					Usuario: #vEcodigo_sdc#<br />
					Ecodigo SDC: #vEcodigo_sdc#<br />
				</cfoutput>
			<CFABORT>
		</cfcatch>
		</CFTRY> 
		--->
		
	</cfloop>


<cfelseif isdefined("Form.Cambio")>
	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		select DEid
		from DatosEmpleadoCorp
		where DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and DEidcorp in ( select DEidcorp
						  from DatosEmpleadoCorp
						  where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> )
	</cfquery>
	
	<cfloop query="rsEmpleados">
		<cfquery datasource="#Session.DSN#">
				update DatosEmpleado set
					NTIcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.NTIcodigo#">,
					DEidentificacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">,
					DEnombre 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEnombre#">,								
					DEapellido1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido1#">,								
					DEapellido2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido2#">,								
					DEdireccion 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdireccion#">,																
					DEtelefono1			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono1#">,
					DEtelefono2			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono2#">,
					DEemail				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEemail#">,
					DEcivil 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEcivil#">,								
					DEfechanac 			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.DEfechanac)#">,
					DEsexo 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEsexo#">,
					DEtarjeta			= <cfif isdefined('Form.DEtarjeta') and Len(Trim(Form.DEtarjeta))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtarjeta#"><cfelse>null</cfif>
					<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>
						,DEpassword 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.DEpassword)#">
					</cfif>
					<cfif isdefined('form.DEobs1')>
						,DEobs1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs1#" null="#Len(Trim(Form.DEobs1)) EQ 0#">
					</cfif>								
					<cfif isdefined('form.DEobs2')>
						,DEobs2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs2#" null="#Len(Trim(Form.DEobs2)) EQ 0#">
					</cfif>								
					<cfif isdefined('form.DEobs3')>
						,DEobs3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs3#" null="#Len(Trim(Form.DEobs3)) EQ 0#">
					</cfif>
					<cfif isdefined('form.DEdato1')>
						,DEdato1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato1#" null="#Len(Trim(Form.DEdato1)) EQ 0#">
					</cfif>								
					<cfif isdefined('form.DEdato2')>
						,DEdato2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato2#" null="#Len(Trim(Form.DEdato2)) EQ 0#">
					</cfif>								
					<cfif isdefined('form.DEdato3')>
						,DEdato3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato3#" null="#Len(Trim(Form.DEdato3)) EQ 0#">
					</cfif>								
					<cfif isdefined('form.DEdato4')>
						,DEdato4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato4#" null="#Len(Trim(Form.DEdato4)) EQ 0#">
					</cfif>
					<cfif isdefined('form.DEdato5')>
						,DEdato5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato5#" null="#Len(Trim(Form.DEdato5)) EQ 0#">
					</cfif>
					<cfif isdefined('form.DEinfo1')>
						,DEinfo1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo1#" null="#Len(Trim(Form.DEinfo1)) EQ 0#">
					</cfif>
					<cfif isdefined('form.DEinfo2')>
						,DEinfo2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo2#" null="#Len(Trim(Form.DEinfo2)) EQ 0#">
					</cfif>
					<cfif isdefined('form.DEinfo3')>
						,DEinfo3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo3#" null="#Len(Trim(Form.DEinfo3)) EQ 0#">
					</cfif>
					, Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">
					, CBTcodigo = <cfif isdefined ("form.CBTcodigo") and len(trim(form.CBTcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBTcodigo#"><cfelse>null</cfif>
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleados.DEid#">
		</cfquery>
	</cfloop>
</cfif>