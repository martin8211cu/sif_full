<cfcomponent hint="Ver SACI-03-H044.doc" extends="base">
	<cffunction name="aprobacionServicios" access="public" returntype="void">
		<cfargument name="origen" type="string" default="siic">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="serids" type="string" required="yes">
		<cfargument name="CUECUE" type="string" required="Yes">
		<cfargument name="paquete" type="string" required="yes">
		<cfargument name="fecha" type="string" required="yes" hint="formato yyyyMMdd">
		<cfargument name="accion" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H044', Arguments.login )>
		<cftry>
			<cfset sdfDatetime2 = CreateObject("java", "java.text.SimpleDateFormat").init('yyyyMMdd')>
			<cfset fecha_date = sdfDatetime2.parse(Arguments.fecha)>

			<cfset control_servicio( 'saci' )>
			<cfset LGnumero = getLGnumero(Arguments.login)>
					
			<cfset control_servicio( 'saci' )>
			<cftransaction>
				<cfset ISBlogin = getISBlogin(LGnumero)>
				<cfif ISBlogin.Habilitado neq 1>
					<cfthrow message="El login #Arguments.login# (#LGnumero#) debe estar habilitado para poderlo procesar" errorcode="QRY-0003">
				</cfif>
				<cfif ISBlogin.CINCAT neq Arguments.paquete>
					<cfthrow message="El login #Arguments.login# (#LGnumero#) no corresponde al paquete #Arguments.paquete#" errorcode="QRY-0003">
				</cfif>
				<cfif Arguments.accion is '2'>
					<cfquery datasource="#session.dsn#">
						update ISBcuenta
						set CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CUECUE#">
						, CTmodificacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.CTid#">
					</cfquery>
					<cfquery datasource="#session.dsn#">
						update ISBlogin
						set LGserids = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.serids)#" null="#not Len(Trim(Arguments.serids))#">
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LGnumero#">
					</cfquery>
				</cfif>
			
				<cfquery datasource="#session.dsn#" name="update_q">
					update ISBproducto
					set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfif Arguments.accion is '1'>
						CNfechaContrato = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_date#">,
						CTcondicion = '0'
					<cfelseif Arguments.accion is '2'>
						CNfechaAprobacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_date#">,
						CTidFactura = CTid,
						CTcondicion = '1'
					<cfelseif Arguments.accion is '3'>
						CNfechaAprobacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_date#">,
						CTcondicion = 'X'
					<cfelse>
						<cfthrow message="Accion inválida: '#Arguments.accion#'">
					</cfif>
					where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.Contratoid#">
					select @@rowcount as update_rowcount
				</cfquery>
				<cfif update_q.update_rowcount is 0>
					<cfset control_mensaje( 'ISB-0006', 'ISBproducto con CTid #ISBlogin.Contratoid#' )>
				</cfif>
				
				<!--- Anotación en la bitcora de login --->
				<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">
					<cfinvokeargument name="LGnumero" value="#LGnumero#">
					<cfinvokeargument name="LGlogin" value="#Arguments.login#">
					<cfinvokeargument name="BLautomatica" value="true">
					<cfinvokeargument name="BLobs" value="Asignación de LGserids y CUECUE por parte de SiiC">
					<cfinvokeargument name="BLfecha" value="#now()#">
				</cfinvoke>
			</cftransaction>
			
			<cfinvoke component="SSXS02" method="Cumplimiento"
				S02CON="#Arguments.S02CON#"
				EnviarHistorico="true"
				EnviarCumplimiento="false"/>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>