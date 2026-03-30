<!--- Revisar que cache no sea usado por una cuenta con cache unico --->
<cfquery name="rsCacheUnico" datasource="#session.DSN#">
	select rtrim(es.sistema) as sistema
	from EmpresaID es, CuentaClienteEmpresarial cce, Empresa e
	where es.Ecodigo = e.Ecodigo
	  and e.cliente_empresarial = cce.cliente_empresarial
	  and cce.cache_empresarial = convert(bit,1)
	  and es.nombre_cache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_cache#">
	  and cce.cliente_empresarial != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
</cfquery>

<cfif rsCacheUnico.RecordCount gt 0>
	<cfset error = 1 >
</cfif>

<!--- DEFAULT ASUME QUE NO REQUIERE CONSECUTIVO --->
<cfset usaConsecutivo = false >

<cfif not isdefined("error") >
	<!--- Proceso exclusivo para SIF, RH, EDU, SED, ME --->
	<cftry>
		<cfif not isdefined("error") and ListFind('SIF,RH,ME,EDU,SED', trim(Ucase(form.sistema)), ',') neq 0 >
	
			<!--- CALCULA CONSECUTIVO DE EMPRESAID --->
			<cfset usaConsecutivo = true >
			<cfquery name="rsConsecutivo" datasource="#session.DSN#">
				select max(consecutivo)+1 as consecutivo from EmpresaID
			</cfquery>
			<cfset consecutivo = rsConsecutivo.consecutivo >
	
			<!--- setea los valores de las tablas --->
			<cfset tabla = '' >
			<cfset campo = '1'>
	
			<!---Campos de las tablas donde va a insertar --->
			<cfif ListFind('SIF,RH,ME', trim(Ucase(form.sistema)), ',') neq 0 >
				<cfset tabla = 'Empresas' >
				<cfset campo = 'Ecodigo' >
			<cfelseif trim(UCase(form.sistema)) eq 'EDU'>
				<cfset tabla = "CentroEducativo" >
				<cfset campo = "CEcodigo">
			<cfelseif trim(UCase(form.sistema)) eq 'SED'>
				<cfset tabla = "CentroEducativo" >
				<cfset campo = "Ecodigo">
			</cfif>
		
			<!--- valida la existencia de las tablas para el cache dado --->
			<cfquery name="rsExisteTabla" datasource="#trim(form.nombre_cache)#">
				select id from sysobjects where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tabla#">
			</cfquery>
			<cfif rsExisteTabla.RecordCount eq 0 >
				<cfset error = 2 > <!--- "mensajeError" value="No existen tablas correspondientes en el cache especificado"/> --->
			</cfif>
		
			<cfif not isdefined("error")>
				<cfset consecutivo_existe = true >
				
				<!--- VALIDA QUE EL CONSECUTIVO NO EXISTA EN SIF, RH, ME, EDU, SED --->
				<cfloop condition = "consecutivo_existe">
					<cfset sql = "select " & campo & " from " & tabla & " where " & campo & " = " & consecutivo >
					<cfquery name="rsDatos" datasource="#form.nombre_cache#">
						#PreserveSingleQuotes(sql)#
					</cfquery>

					<!--- VALIDA LA EXISTENCIA DEL CONSECUTIVO --->
					<cfif rsDatos.RecordCount gt 0 >
						<cfset consecutivo = consecutivo + 1 >
					<cfelse>
						<cfset consecutivo_existe = false >
					</cfif>
				</cfloop>
		
				<!--- RECUPERA LOS DATOS DE LA EMPRESA --->
				<cfquery name="rsDatosEmpresa" datasource="#session.DSN#">
					select e.nombre_comercial, u.Usucuenta, u.Usucodigo, u.Ulocalizacion, e.cliente_empresarial
					from Empresa e, Usuario u
					where e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo2#">
					  and e.Usucodigo = u.Usucodigo
					  and e.Ulocalizacion = u.Ulocalizacion
				</cfquery>
					
				<cfif ListFind('SIF,RH,ME', trim(Ucase(form.sistema)), ',') neq 0 >
	
					<!--- valida que SIF, RH y ME  para una misma empresa, tengan el mismo consecutivo
						  Esto me evita que se generen varias empresas: una para sif, otra para rh 	y otra para ME
					 --->
					<cfquery name="rsExisteEmpresa" datasource="#form.nombre_cache#">
						select Ecodigo
						from Empresas 
						where EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo2#">
					</cfquery>
					
					<cfif not isdefined("error")>
						<cfif rsExisteEmpresa.RecordCount gt 0 >
							<cfset consecutivo = rsExisteEmpresa.Ecodigo >
						<cfelse>
							<cfquery name="insert_empresa" datasource="#form.nombre_cache#">
								declare @Mcodigo numeric
								select @Mcodigo=min(Mcodigo)  
								  from Monedas
								 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">
								if @Mcodigo is null
								BEGIN
								  insert into Monedas (Ecodigo, Mnombre, Msimbolo, Miso4217)
								  select <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">,
								  		 Mnombre, Msimbolo, Miso4217
								    from sdc..Moneda
								  select @Mcodigo=min(Mcodigo)  
								    from Monedas
 								   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">
								END
								
 								insert Empresas(Ecodigo, Mcodigo, Edescripcion, Elocalizacion, Ecache, Usucodigo, Ulocalizacion, cliente_empresarial, EcodigoSDC )
								values( <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">,
										@Mcodigo, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosEmpresa.nombre_comercial#" >, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosEmpresa.Ulocalizacion#">, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_cache#">, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpresa.Usucodigo#" >, 
										<cfqueryparam cfsqltype="cf_sql_char"    value="#rsDatosEmpresa.Ulocalizacion#" >, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosEmpresa.cliente_empresarial#" >,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo2#">
									  ) 

 							</cfquery>
						</cfif>
					</cfif>
	
				<cfelseif trim(Ucase(form.sistema)) eq 'EDU'>
					<cfquery name="insert_educativo" datasource="#form.nombre_cache#">
						update CentroEducativo
						set CEnombre   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosEmpresa.nombre_comercial#" >
						where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">
						if @@rowcount = 0 begin
							declare @Ccodigo numeric(18), @Scodigo numeric(18)
							
							insert Calendario(CTcodigo, Cnombre, Cicono)
							values (5, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosEmpresa.nombre_comercial#" >, 'NO')
							select @Ccodigo = @@identity, @Scodigo = null
							
							set identity_insert CentroEducativo on
							insert CentroEducativo (CEcodigo, CEnombre, CEdireccion, CEtelefono, Ccodigo, Scodigo)
							values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">, 
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosEmpresa.nombre_comercial#" >, 
									 '-dir-', 
									 '-tel-',
									 @Ccodigo, 
									 @Scodigo
								   )
							set identity_insert CentroEducativo off
						end
					</cfquery>	
	
				<cfelseif trim(Ucase(form.sistema)) eq 'SED'>
					<cfquery name="insert_universidad" datasource="#form.nombre_cache#">
						update CentroEducativo
						set Enombre   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosEmpresa.nombre_comercial#" >
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">
						if @@rowcount = 0 begin
							insert CentroEducativo (Ecodigo, Enombre, Eactivo )
							values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">, 
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosEmpresa.nombre_comercial#" >,
									 1
								   )
						end
					</cfquery>	
				</cfif>
			</cfif>
		</cfif>
	<cfcatch type="any">
		<cfset error = 3 > <!--- el cache dado por el usuario no corresponde a base de datos de SIF, RH, ME --->
	</cfcatch>
	</cftry>

	<cfif not isdefined("error")>
		<!--- MODIFICA EL CACHE EN SDC, ESTO SE HACE PARA TODOS LOS SISTEMAS--->
		<cfquery name="rsUpdate" datasource="#session.DSN#">
			update EmpresaID
			  set nombre_cache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_cache#">
			  <cfif usaConsecutivo >
				  ,consecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#consecutivo#">
			  </cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo2#">
			  and sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#form.sistema#">
		</cfquery>
	</cfif>
</cfif>	

<cfoutput>
<form action="CuentaPrincipal_tabs.cfm" method="post" name="sql">
	<cfif isdefined("error")><input type="hidden" name="sql_error" value="#error#"></cfif>
	<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#">
	<input type="hidden" name="Ecodigo2" value="#form.Ecodigo2#">
	<input type="hidden" name="sdcSistema" value="#form.sistema#">
	<input type="hidden" name="nombre_cache" value="#form.nombre_cache#">
</form>
</cfoutput>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>