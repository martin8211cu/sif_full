<!---=======Agrega o modifica un nuevo empleado. Pueden ser empleados activos, inactivos o que cambiaron de Centro Funcional=======--->
<cfcomponent>	
	
		<cfset fechaFin= CreateDateTime(6100, 01, 01, 23, 59, 59)>
		<cfset fechaCorte= DateAdd("d", -1, now())>
		<cfset AnoCorte=   DatePart("yyyy", fechaCorte)>
		<cfset MesCorte=   DatePart("m", fechaCorte)>
		<cfset DiaCorte=   DatePart("d", fechaCorte)>
		<cfset fechaCorte= CreateDateTime(AnoCorte, MesCorte, DiaCorte, 23, 59, 59)>	
	<cffunction name="AltaCambioEmpleadoCF"  access="public">
		<!---<cfargument name="IDENTIFICACION"    type="string"   required="yes">
		<cfargument name="NOMBRE"   	     type="string"   required="yes">
		<cfargument name="PRIMER_APELLIDO"   type="string"   required="no">
		<cfargument name="SEGUNDO_APELLIDO"  type="string"   required="no">
		<cfargument name="DEdireccion"       type="string"   required="no">
		<cfargument name="DEtelefono1"       type="string"   required="no">
		<cfargument name="DEemail"  		 type="string"   required="no">
		<cfargument name="DEcivil"  		 type="integer"  required="yes">
		<cfargument name="DEfechanac"   	 type="datetime" required="yes">
		<cfargument name="DEsexo"            type="string"   required="yes">
		<cfargument name="CENTRO_FUNCIONAL"  type="string"   required="yes">--->
		<cfargument name="consulta" 		type="query"   required="yes"><!--- La consulta que pase debe contener minimo los campos requeridos en las tablas DatosEmpleado y EmpleadoCFuncional --->
		<cfargument name="Conexion" 	    type="string"   required="no" default="#Session.Dsn#">
		<cfargument name="Ecodigo" 		    type="numeric"  required="no" default="#Session.Ecodigo#">
		<cfargument name="BMUsucodigo"      type="numeric"  required="no">		
		<!---<cfif not isdefined('Arguments.Conexion')>
			<cfset  Arguments.Conexion = #session.dsn#>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset  Arguments.Ecodigo = #session.Ecodigo#>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset  Arguments.BMUsucodigo = #session.Usucodigo#>
		</cfif>--->
		
		<!---<cfif Arguments.Ecodigo GT 0>
			<cfquery name="rsEcodigo" datasource="#Arguments.Conexion#">
				select Ereferencia
				from Empresa
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				  and Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!---- Si existe el Ecodigo en minisif ----->
			<cfif rsEcodigo.recordcount NEQ 0 and rsEcodigo.Ereferencia NEQ ''>
				<cfset Arguments.Ecodigo = rsEcodigo.Ereferencia>
			<cfelse>
				<cfthrow message="CM_InterfazDocumentos: El valor del par&aacute;metro EcodigoSDC es incorrecto o no corresponde con el Código de Empresa de la Sesion. Proceso Cancelado!">
			</cfif>
		</cfif>--->
		
		<cfif not isdefined("Request.CIM_EmpleadosCF.Initialized")>
			<cfset Request.CIM_EmpleadosCF.Initialized  = true>
			<cfset Request.CIM_EmpleadosCF.GvarConexion  = Session.Dsn>
			<cfset Request.CIM_EmpleadosCF.GvarEcodigo   = Session.Ecodigo>	
			<cfset Request.CIM_EmpleadosCF.GvarUsuario   = Session.Usuario>
			<cfset Request.CIM_EmpleadosCF.GvarUsucodigo = Session.Usucodigo>
		</cfif> 

<!--- Seleccionar el codigo del banco --->
		<cfquery name="rsBanco" datasource="#Request.CIM_EmpleadosCF.GvarConexion#">
			select coalesce(min(Bid),-1) as Bid
			from Bancos
			where Ecodigo=  #Session.Ecodigo# 
		</cfquery>
		<cfquery name="rsMoneda" datasource="#Request.CIM_EmpleadosCF.GvarConexion#">
			select Mcodigo, EcodigoSDC
			from Empresas
 			where Ecodigo=  #Session.Ecodigo# 
		</cfquery>
		<cfquery name="rsPais" datasource="#Request.CIM_EmpleadosCF.GvarConexion#">
			select Ppais
			from Empresa e
				inner join Direcciones d
					on d.id_direccion=e.id_direccion
			where Ecodigo = #rsMoneda.EcodigoSDC#
		</cfquery>	
		<cftransaction>
		<!---Inserta los Empleados que no existen--->
	
		<cfloop query="Arguments.consulta">
			<!---EMPLEADOS QUE NO EXISTEN--->
			<cfif Arguments.consulta.marca EQ 0>
				<cfquery name="rsAltaNewEmplCF" datasource="#Request.CIM_EmpleadosCF.GvarConexion#">				
					insert into DatosEmpleado (Ecodigo, Bid, NTIcodigo, DEidentificacion, DEnombre, DEapellido1, DEapellido2,
						 CBcc, Mcodigo, DEtelefono1, DEemail, 
						 DEcivil, DEfechanac, DEsexo, DEcantdep, Usucodigo, Ulocalizacion, DEsistema, Ppais, BMUsucodigo)
					values( #Session.Ecodigo#, #rsBanco.Bid#, 
	<cfqueryparam cfsqltype="cf_sql_char"    value="#Arguments.consulta.NTIcodigo#">, 				    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEidentificacion#">, 
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEnombre#">, 
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEapellido1#">, 
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEapellido2#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEidentificacion#">, #rsMoneda.Mcodigo#, 
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEtelefono1#">, 
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEemail#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.consulta.DEcivil#">, coalesce(	    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.consulta.DEfechanac#">,<cf_dbfunction name="now">), 
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEsexo#">, 0, #Session.Usucodigo#, '00', 1, '#rsPais.Ppais#', #Session.Usucodigo#)				
				<cf_dbidentity1>
				</cfquery>
				
				<cf_dbidentity2 name="rsAltaNewEmplCF">
				<!---Crea la Linea del Tiempo para los Empleados que no existen---> 	
						
				<cfquery datasource="#Request.CIM_EmpleadosCF.GvarConexion#">
					insert into EmpleadoCFuncional (DEid, Ecodigo, CFid, ECFdesde, ECFhasta, BMUsucodigo)
					select #rsAltaNewEmplCF.identity#, #Session.Ecodigo#, cf.CFid, <cf_dbfunction name="now">, #fechaFin#, #Session.Usucodigo#
					from DatosEmpleado de							
						inner join CFuncional cf
							on de.Ecodigo = cf.Ecodigo
						   and cf.CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.CFcodigo#"> 
					where cf.Ecodigo = #Session.Ecodigo#
						and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEidentificacion#"> = de.DEidentificacion
				</cfquery>				
			</cfif><!---EMPLEADOS QUE NO EXISTEN--->
			
			<!---EMPLEADOS QUE EXISTEN--->
			<cfif Arguments.consulta.marca EQ 1>
			
				<!---Crea una linea de Tiempo para los Empleados que existen pero no tienen linea de tiempo--->
				<cfquery datasource="#Request.CIM_EmpleadosCF.GvarConexion#">
					insert into EmpleadoCFuncional (DEid, Ecodigo, CFid, ECFdesde, ECFhasta, BMUsucodigo)
					select de.DEid, #Session.Ecodigo#, CFid, <cf_dbfunction name="now">, #fechaFin#, #Session.Usucodigo#
					from DatosEmpleado de
						inner join CFuncional cf
							on de.Ecodigo = cf.Ecodigo
						   and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.CFcodigo#"> = cf.CFcodigo
					where <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEidentificacion#"> = de.DEidentificacion
					and de.Ecodigo = #Session.Ecodigo#
					and de.DEid not in (select ecf.DEid 
											from EmpleadoCFuncional ecf
											 where ecf.Ecodigo = de.Ecodigo
											 and <cf_dbfunction name="now"> between ECFdesde and ECFhasta)				 			  
				</cfquery>
				
				<!--- Crea linea de tiempo para los empledos que existen pero tienen Centro Funcional Diferente  --->
			   <cfquery datasource="#Request.CIM_EmpleadosCF.GvarConexion#">
					insert into EmpleadoCFuncional (DEid, Ecodigo, CFid, ECFdesde, ECFhasta, BMUsucodigo)
					select de.DEid, #Session.Ecodigo#, cf.CFid, <cf_dbfunction name="now">, #fechaFin#, #Session.Usucodigo#
					from DatosEmpleado de
						 inner join CFuncional cf
						  on de.Ecodigo = cf.Ecodigo	
						 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.CFcodigo#"> = cf.CFcodigo
					where <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEidentificacion#"> = de.DEidentificacion
					  <!---and de.Ecodigo = #Session.Ecodigo#--->
					  and cf.CFid != 
							(	select ecf.CFid 
								from EmpleadoCFuncional ecf
								where ecf.DEid = de.DEid
								  <!---and ecf.Ecodigo = de.Ecodigo--->
								  and <cf_dbfunction name="now"> between ecf.ECFdesde and ecf.ECFhasta
							  )
				</cfquery>
				
				<!--- Corta la linea para los empledos que existen pero tienen Centro Funcional Diferente--->  
				<cfquery datasource="#Request.CIM_EmpleadosCF.GvarConexion#">
					update EmpleadoCFuncional 
						set ECFhasta = #fechaCorte#
					where exists ( select 1 
									  from DatosEmpleado de										
									   inner join CFuncional cf 
										   on de.Ecodigo = cf.Ecodigo
										  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.CFcodigo#"> = cf.CFcodigo
									where <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEidentificacion#"> = de.DEidentificacion
									 <!---and de.Ecodigo = #Session.Ecodigo#--->
									 and de.DEid = EmpleadoCFuncional.DEid
									 and cf.CFid != EmpleadoCFuncional.CFid	
								  )
										   
					and <cf_dbfunction name="now"> between ECFdesde and ECFhasta
					and Ecodigo = #Session.Ecodigo#
				</cfquery>
				
				
			<!---8- Actualiza los datos del los Empleado que ya existen --->
				<cfquery datasource="#Request.CIM_EmpleadosCF.GvarConexion#">
					update DatosEmpleado set
						DEnombre 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEnombre#">, 
						DEapellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEapellido1#">, 
						DEapellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEapellido2#">, 
						DEtelefono1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEtelefono1#">,  
						DEemail 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEemail#">, 
						DEcivil 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.consulta.DEcivil#">, 
						DEfechanac 	= <cfqueryparam cfsqltype="cf_sql_date"    value="#Arguments.consulta.DEfechanac#">, 
						DEsexo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEsexo#">,
						BMUsucodigo = #session.Usucodigo#
					where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.consulta.DEidentificacion#">
					  and Ecodigo = #Session.Ecodigo#
				</cfquery>			
			</cfif><!---EMPLEADOS QUE EXISTEN--->			
		</cfloop>		
	
		</cftransaction>		
		
	</cffunction>	
</cfcomponent>