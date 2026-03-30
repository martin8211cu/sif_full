<cfcomponent>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfif not isdefined("Request.CM_InterfazClasifArticulos.Initialized")>
			<!--- <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces"> --->
			<cfset Request.CM_InterfazClasifArticulos.Initialized = true>
			<cfset Request.CM_InterfazClasifArticulos.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazClasifArticulos.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CM_InterfazClasifArticulos.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazClasifArticulos.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>
	<!--- 1.2 changeContext: Cambia los valores de las variables globales del componente. --->
	<cffunction name="changeContext" access="public" returntype="boolean">
		<cfargument name="Conexion" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfset Request.CM_InterfazClasifArticulos.GvarConexion = Arguments.Conexion>
		<cfset Request.CM_InterfazClasifArticulos.GvarEcodigo = Arguments.Ecodigo>	
		<cfset Request.CM_InterfazClasifArticulos.GvarUsucodigo = Arguments.Usucodigo>
		<cfset Request.CM_InterfazClasifArticulos.GvarFecha = Arguments.Fecha>	
		<cfreturn true>
	</cffunction>
	
	<!--- 2 Métodos de control de los procesos de este componente (Estos son los métodos públicos) --->
	<!--- 2.1 Lee la BD de la Interfáz y realiza las acciones pendientes. --->
	<cffunction name="run" access="public" returntype="boolean">	
		<!--- 2.1.1 Inicializa el componente. --->
		<cfif not isdefined("Request.CM_InterfazClasifArticulos.Initialized")>
			<cfinvoke component="sif.Componentes.CM_InterfazClasifArticulos" method="init"/>
		</cfif>
		<!--- 2.1.2 Lectura de la base de datos de interfaz filtrado por empresa definida en el contexto del componente.
			Aquí nos vamos a encontrar 2 posibles acciones: alta o baja o cambio.
		 --->
<!--- 		<cftransaction isolation="read_uncommitted"> --->

			<cfset rsIE.Imodo = 'A'>
<!--- 		</cftransaction> --->
		<!--- 2.1.3 Actualizacion de la base datos de SIF--->
		<cftransaction> 
			<!--- Ciclo --->
				<cfif rsIE.Imodo EQ 'A'>
					<!--- Alta de un articulo --->
					<cfinvoke 
						method="Alta_ClasifArticulos" 
						Ccodigopadre = "45"
						Ccodigoclas = "133"
						Cdescripcion = "13"
						cuentac = "13"/>		
				<cfelseif rsIE.Imodo EQ 'B'>		
					<!--- El baja esta pendiente de definir --->
				<cfelseif rsIE.Imodo EQ 'C'>
					<!--- Cambio de un articulo --->
					<cfinvoke 
						method="Cambio_ClasifArticulos" 
						Ccodigo = "64"
						Ccodigopadre = "45"
						Ccodigoclas = "133"
						Cdescripcion = "13"
						cuentac = "13"/>				
				</cfif>
			<!--- /Ciclo --->
			
			<cftransaction action="rollback"/>
			
		</cftransaction>
		<!--- 2.1.4 Actualización de la base de datos de Interfaz --->
		<cftransaction>
			<!--- Ciclo --->
			<!--- ?#$% --->
			<!--- ?#$% --->
			<!--- /Ciclo --->
		</cftransaction>
		<cfreturn true>
	</cffunction>
	
	<!--- 3 Métodos para lectura de la base de datos de interfaz --->
	
	<!--- 4 Métodos para actualizar la base de datos de SIF --->
	<!--- 4.1 Alta de una clasificacion articulo validando la integridad de los datos de entrada.
		Respeta las siguientes reglas:
			* Ccodigo= Que no exista ese valor en la tabla Clasificaciones
			* Ccodigopadre= Puede ser nulo, y si no lo es hay que validar que exista en la tabla de Clasificaciones
						y que no posea el ultimo nivel de la clasificacion.		
	--->
							
	<cffunction name="Alta_ClasifArticulos" access="public" returntype="boolean">
		<cfargument name="Ccodigopadre" type="string" required="false">
		<cfargument name="Ccodigoclas" type="string" required="true">
		<cfargument name="Cdescripcion" type="string" required="true">
		<cfargument name="cuentac" type="string" required="true">
		
		<cfset newCodClasif = getCcodigoALTA_vIntegridad()>

		<!--- Alta --->
		<cfquery datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
			insert INTO Clasificaciones 
				(Ecodigo, Ccodigo, Ccodigopadre, CAid, Ccodigoclas, Cdescripcion, Cpath, Cnivel, Ccomision, Ctexto, Cbanner, cuentac, BMUsucodigo)
			values (							
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#newCodClasif#">
				<cfif isdefined('Arguments.Ccodigopadre') and Arguments.Ccodigopadre NEQ ''>
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#getCcodigopadre_vIntegridad(Arguments.Ccodigopadre,'Alta_ClasifArticulos')#">
				<cfelse>
					, null
				</cfif>
				, null
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getCcodigoclas_vIntegridad(Arguments.Ccodigoclas,'A','Alta_ClasifArticulos')#">
 				, <cfqueryparam cfsqltype="cf_sql_char" value="#getCdescripcion_vIntegridad(Arguments.Cdescripcion,'Alta_ClasifArticulos')#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getCpath_vIntegridad(Arguments.Ccodigopadre,Arguments.Ccodigoclas,'Alta_ClasifArticulos')#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getCnivel_vIntegridad(Arguments.Ccodigopadre,'Alta_ClasifArticulos')#">
				, 0
				, null
				, null
				<cfif isdefined('Arguments.cuentac') and Arguments.cuentac NEQ ''>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentac#">
				<cfelse>
					, null
				</cfif>
				, null
				)
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="Baja_ClasifArticulos" access="public" returntype="boolean">
		<cfargument name="Ccodigoclas" type="string" required="true">

		<!--- Baja --->
		<cfquery name="rsPadres" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
			Select count(Ccodigo) as cantClasif
			from Clasificaciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
				and Ccodigopadre = <cfqueryparam cfsqltype="cf_sql_integer" value="#getCcodigo_vIntegridad(Arguments.Ccodigoclas,'Baja_ClasifArticulos')#">
		</cfquery>
		
		<cfif isdefined('rsPadres') and rsPadres.cantClasif GT 0>
			<cfthrow message="Error en la funcion Baja_ClasifArticulos, la clasificacion del articulo no se permite borrar porque es padre de otras clasificaciones de articulos. Proceso Cancelado!">		
		<cfelse>
			<cfquery name="rsArtic" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
				Select count (cl.Ccodigo) as cantArt
				from Clasificaciones cl
					 inner join Articulos a
						on a.Ecodigo=cl.Ecodigo
							and a.Ccodigo=cl.Ccodigo
				where cl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
					and Cnivel = (
								Select (<cf_dbfunction name="to_number" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#" args="Pvalor"> - 1)
								from Parametros
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
									and Pcodigo=530
							)
					and Ccodigoclas=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ccodigoclas#">
			</cfquery>		
			
			<cfif isdefined('rsArtic') and rsArtic.cantArt GT 0>
				<cfthrow message="Error en la funcion Baja_ClasifArticulos, la clasificacion del articulo no se permite borrar porque posee articulos asociados. Proceso Cancelado!">		
			<cfelse>
				<cfquery name="rsPadres" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
					delete Clasificaciones
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
						and Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getCcodigo_vIntegridad(Arguments.Ccodigoclas,'Baja_ClasifArticulos')#">
				</cfquery>		
			</cfif>		
		</cfif>
		
		<cfreturn true>
	</cffunction>	
	
	
	<cffunction name="Cambio_ClasifArticulos" access="public" returntype="boolean">
		<cfargument name="Ccodigo" type="string" required="true">
		<cfargument name="Ccodigopadre" type="string" required="false">
		<cfargument name="Ccodigoclas" type="string" required="true">
		<cfargument name="Cdescripcion" type="string" required="true">
		<cfargument name="cuentac" type="string" required="true">

		<!--- Cambio --->
		<cfquery datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
			update Clasificaciones set
				<cfif isdefined('Arguments.Ccodigopadre') and Arguments.Ccodigopadre NEQ ''>
					Ccodigopadre=<cfqueryparam cfsqltype="cf_sql_integer" value="#getCcodigopadre_vIntegridad(Arguments.Ccodigopadre,'Cambio_ClasifArticulos')#">
				<cfelse>
					Ccodigopadre=null
				</cfif>
				, Cdescripcion=<cfqueryparam cfsqltype="cf_sql_char" value="#getCdescripcion_vIntegridad(Arguments.Cdescripcion,'Cambio_ClasifArticulos')#">
				, Cpath=<cfqueryparam cfsqltype="cf_sql_char" value="#getCpath_vIntegridad(Arguments.Ccodigopadre,Arguments.Ccodigo,'Cambio_ClasifArticulos')#">
				, Cnivel=<cfqueryparam cfsqltype="cf_sql_char" value="#getCnivel_vIntegridad(Arguments.Ccodigopadre,'Cambio_ClasifArticulos')#">
				<cfif isdefined('Arguments.cuentac') and Arguments.cuentac NEQ ''>
					, cuentac=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentac#">
				<cfelse>
					, cuentac=null
				</cfif>				
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
				and Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getCcodigo_vIntegridad(Arguments.Ccodigo,'Cambio_ClasifArticulos')#">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<!--- Inicio de las funciones para validacion de Integridad --->	

	<!--- Validacion del codigo de la Clasificacion --->	
	<cffunction access="private" name="getCcodigoALTA_vIntegridad" output="false" returntype="string">
		<cfquery name="rsconsecutivo" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
			select coalesce(max(Ccodigo),0) as codigo
			from Clasificaciones
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
		</cfquery>
		<cfset consecutivo = 1>
		<cfif rsconsecutivo.recordcount gt 0 and len(trim(rsconsecutivo.codigo))>
			<cfset consecutivo = rsconsecutivo.codigo + 1>
		</cfif>

		<cfreturn consecutivo>
	</cffunction>	

	<!--- Validacion del codigo del padre --->		
	<cffunction access="private" name="getCcodigopadre_vIntegridad" output="false" returntype="numeric">
		<cfargument name="Ccodigopadre" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfquery name="rsClasif" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
			Select Ccodigo, Cnivel
			from Clasificaciones
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
				and Ccodigoclas=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ccodigopadre#">
		</cfquery>
		
		<cfif rsClasif.recordCount EQ 0>
			<cfthrow message="El valor de la clasificacion padre del articulo (Ccodigopadre) pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">
		<cfelse>
			<cfquery name="rsParam" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
				Select Pcodigo,Pvalor
				from Parametros
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
					and Pcodigo=530
			</cfquery>
			
			<cfif isdefined('rsParam') and rsParam.recordCount GT 0>
				<cfset nivelParam = rsParam.Pvalor - 1>
				
				<cfif rsClasif.Cnivel GTE nivelParam>
					<cfthrow message="La clasificacion del articulo pasado a la función #Arguments.InvokerName# posee un nivel de clasificacion mayor o igual al ultimo, lo cual no es permitido. Proceso Cancelado!">				
				</cfif>
			<cfelse>
				<cfthrow message="El valor del parámetro Pcodigo=530 de la tabla Parametros no se encuentra definido. Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfreturn rsClasif.Ccodigo>
	</cffunction>		
	
	<!--- Validacion de la descripcion de la clasificacion del articulo la cual es requerida --->	
	<cffunction access="private" name="getCdescripcion_vIntegridad" output="false" returntype="string">
		<cfargument name="Cdescripcion" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfif isdefined('Arguments.Cdescripcion') and Arguments.Cdescripcion EQ ''>
			<cfthrow message="El valor de la descripcion de la clasificacion del articulo (Cdescripcion) es requerido. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.Cdescripcion>
	</cffunction>			
	
	<!--- Validacion del campo Ccodigo el cual se graba en el campo Ccodigoclas en minisif es requerida --->	
	<cffunction access="private" name="getCcodigoclas_vIntegridad" output="false" returntype="string">
		<cfargument name="Ccodigoclas" required="yes" type="string">
		<cfargument name="Modo" required="yes" type="string">		
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfset codClas = "">

		<cfquery name="rs" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
			select Ccodigoclas
			from Clasificaciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
			and Ccodigoclas = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ccodigoclas#">
		</cfquery>

		<cfif isdefined('rs') and rs.recordCount GT 0 and Arguments.Modo EQ 'A'>
			<cfthrow message="Error, la clasificacion del articulo pasada a la función #Arguments.InvokerName# ya existe en la tabla para la empresa #Request.CM_InterfazClasifArticulos.GvarEcodigo#. Proceso Cancelado!">
		<cfelseif isdefined('rs') and rs.recordCount EQ 0 and Arguments.Modo EQ 'A'>
			<cfset codClas = Arguments.Ccodigoclas>
		</cfif>
		
		<cfreturn codClas>
	</cffunction>				
	
	<!--- Validacion del campo Cpath --->	
	<cffunction access="private" name="getCpath_vIntegridad" output="false" returntype="string">
		<cfargument name="Ccodigopadre" required="yes" type="string">
		<cfargument name="Ccodigoclas" required="yes" type="string">		
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfset path  = RepeatString("*", 5-len(trim(Arguments.Ccodigoclas)) ) & "#trim(Arguments.Ccodigoclas)#" >
		<cfif isdefined("arguments.Ccodigopadre") and len(trim(arguments.Ccodigopadre))>
			<cfquery name="_datos" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
				select Cnivel, Cpath
				from Clasificaciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
				and Ccodigoclas = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ccodigopadre#">
			</cfquery>

			<cfif isdefined('_datos') and _datos.recordCount GT 0>
				<cfset path  = trim(_datos.Cpath) & "/" & trim(path) >
			<cfelse>
				<cfset path  = 'null'>
			</cfif>
		</cfif>
		<cfreturn path>
	</cffunction>				

	<!--- Validacion del Nivel --->
	<cffunction name="_nivel" returntype="boolean">
		<cfargument name="nivel" required="yes" type="numeric">
		<cfquery name="data" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
			select coalesce(Pvalor, '1') as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
			and Pcodigo = 530
		</cfquery>
	
		<cfif (nivel+1) gt data.Pvalor>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>		
	
	<!--- Validacion del campo Cnivel --->	
	<cffunction access="private" name="getCnivel_vIntegridad" output="false" returntype="string">
		<cfargument name="Ccodigopadre" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfset nivel = 0 >
		
		<cfif isdefined("arguments.Ccodigopadre") and len(trim(arguments.Ccodigopadre))>
			<cfquery name="_datos" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
				select Cnivel
				from Clasificaciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
				and Ccodigoclas = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ccodigopadre#">
			</cfquery>

			<cfif isdefined('_datos') and _datos.recordCount GT 0>
				<cfset nivel = _datos.Cnivel + 1>
			</cfif>

			<cfif not _nivel(nivel) >
				<cfthrow detail="Ha excedido el nivel maximo para la Clasificación de Articulos.">
			</cfif>
		</cfif>
		<cfreturn nivel>
	</cffunction>				

	<!--- Validacion del codigo de la Clasificacion --->	
	<cffunction access="private" name="getCcodigo_vIntegridad" output="false" returntype="numeric">
		<cfargument name="Ccodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfquery name="rsClasif" datasource="#Request.CM_InterfazClasifArticulos.GvarConexion#">
			Select Ccodigo
			from Clasificaciones
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClasifArticulos.GvarEcodigo#">
				and Ccodigoclas=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ccodigo#">
		</cfquery>

		<cfif isdefined('rsClasif') and rsClasif.recordCount EQ 0>
			<cfthrow message="La clasificacion del articulo pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">						
		</cfif>
		
		<cfreturn rsClasif.Ccodigo>
	</cffunction>
		
</cfcomponent>