<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBvendedor">

<cffunction name="hab_inhabilitarVendedor" output="false" returntype="void" access="remote">
  <cfargument name="Vid" type="numeric" required="Yes"  displayname="Vendedor">
  <cfargument name="Habilitado" type="boolean" required="Yes" displayname="Habilitado-Inhabilitado">
  
	<!---  Busqueda del Usucodigo de vendedor --->
	<cfquery name="rsUsucodigoVend" datasource="#session.dsn#">
		Select Usucodigo
		from UsuarioReferencia
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla='ISBvendedor'
			and llave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Vid#" null="#Len(Arguments.Vid) Is 0#">
	</cfquery>
	
	<cfif isdefined('rsUsucodigoVend') and rsUsucodigoVend.recordCount GT 0>
		<!---  Busqueda del Usucodigo del vendedor en UsuarioBloqueo --->
		<cfquery name="rsUsucodigoBloqueo" datasource="#session.dsn#">
			Select Usucodigo
			from UsuarioBloqueo
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsucodigoVend.Usucodigo#">
				and bloqueo=<cfqueryparam cfsqltype="cf_sql_timestamp" value="1-1-6100">
				and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>				
		<cfif isdefined('rsUsucodigoBloqueo') and rsUsucodigoBloqueo.recordCount EQ 0>
			<cfif Arguments.Habilitado EQ 0>	<!--- Inhabilitacion --->
				<!---  BLOQUEO DEL USUARIO Vendedor --->
				<cfquery datasource="#session.dsn#">
					insert into UsuarioBloqueo (Usucodigo, bloqueo, CEcodigo, fecha, razon, desbloqueado)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsucodigoVend.Usucodigo#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="1-1-6100">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="Vendedor inhabilitado/bloqueado por el saci">
						, 0)
			   </cfquery>								
			</cfif>
		<cfelse>
			<!---  BLOQUEO DEL USUARIO Vendedor --->
			<cfquery datasource="#session.dsn#">
				update UsuarioBloqueo
					set desbloqueado = <cfqueryparam cfsqltype="cf_sql_bit"   value="#Arguments.Habilitado#">
				where bloqueo   > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsUsucodigoVend.Usucodigo#">
				  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
					<cfif Arguments.Habilitado EQ 0>
						and desbloqueado = 1
					<cfelse>
						and desbloqueado = 0
					</cfif>				  
			</cfquery>										
		</cfif>
	</cfif>
	
	<!--- Se habilita o inhabilita el vendedor --->
	<cfquery datasource="#session.dsn#">
		update ISBvendedor
			set Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Vid#" null="#Len(Arguments.Vid) Is 0#">
	</cfquery>	
</cffunction>

<cffunction name="hab_inhabVendXagente" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  <cfargument name="Habilitado" type="boolean" required="Yes" displayname="Habilitado-Inhabilitado">
  
	<!--- Lista de todos los vendedores asociados al agente --->
	<cfquery  name="rsVendedores" datasource="#session.dsn#">
		Select <cf_dbfunction name="to_char" args="Vid"> as Vid, Habilitado
		from ISBvendedor
		where AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
	</cfquery>  
  
	<cfif isdefined('rsVendedores') and rsVendedores.recordCount GT 0>
		<!--- Activacion e inhabilitacion de los usuarios SACI de los vendedores --->
		<cfif Arguments.Habilitado EQ 0>	
			<!--- Se seleccionan todos los vendedores con estado de Habilitado para su inhabilitacion --->
			<cfquery  name="rsVendedoresHabil" dbtype="query">
				Select Vid
				from rsVendedores
				where Habilitado=1
			</cfquery>
			<cfif isdefined('rsVendedoresHabil') and rsVendedoresHabil.recordCount GT 0>
				<!---  Busqueda del Usucodigo del todos los vendedores con estado de habilitado --->
				<cfquery name="rsUsucodigosVend" datasource="#session.dsn#">
					Select Usucodigo,llave
					from UsuarioReferencia
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
						and STabla='ISBvendedor'
						and llave in (#QuotedValueList(rsVendedoresHabil.Vid)#)
				</cfquery>
				<cfif isdefined('rsUsucodigosVend') and rsUsucodigosVend.recordCount GT 0>
					<!---  Busqueda de todos los Usucodigos de los vendedores asociados al agente seleccionado en UsuarioBloqueo --->
					<cfquery name="rsUsucodigosBloqueo" datasource="#session.dsn#">
						Select Usucodigo
						from UsuarioBloqueo
						where Usucodigo in (#ValueList(rsUsucodigosVend.Usucodigo)#)
							and bloqueo=<cfqueryparam cfsqltype="cf_sql_timestamp" value="1-1-6100">
							and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					</cfquery>				

					<cfif isdefined('rsUsucodigosBloqueo') and rsUsucodigosBloqueo.recordCount EQ 0>
						<cfloop query="rsVendedoresHabil">
							<!--- Se busca el Usucodigo del vendedor --->
							<cfquery name="rsUsucodigoUsuRef" dbtype="query">
								Select Usucodigo
								from rsUsucodigosVend
								where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVendedoresHabil.Vid#" null="#Len(rsVendedoresHabil.Vid) Is 0#">
							</cfquery>	
											
							<cfif isdefined('rsUsucodigoUsuRef') and rsUsucodigoUsuRef.recordCount GT 0>
								<!---  BLOQUEO DEL USUARIO Vendedor --->
								<cfquery datasource="#session.dsn#">
									insert into UsuarioBloqueo (Usucodigo, bloqueo, CEcodigo, fecha, razon, desbloqueado)
									values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsucodigoUsuRef.Usucodigo#">
										, <cfqueryparam cfsqltype="cf_sql_timestamp" value="1-1-6100">
										, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
										, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
										, <cfqueryparam cfsqltype="cf_sql_varchar" value="Vendedor inhabilitado/bloqueado por el saci">
										, 0)
							   </cfquery>								
							</cfif>
						</cfloop>
					<cfelse>
						<cfloop query="rsVendedoresHabil">
							<!--- Se busca el Usucodigo del vendedor en UsuarioReferencia --->
							<cfquery name="rsUsucodigoUsuRef" dbtype="query">
								Select Usucodigo
								from rsUsucodigosVend
								where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVendedoresHabil.Vid#" null="#Len(rsVendedoresHabil.Vid) Is 0#">
							</cfquery>
							
							<cfif isdefined('rsUsucodigoUsuRef') and rsUsucodigoUsuRef.recordCount GT 0>
								<!--- Se busca el Usucodigo del vendedor en UsuarioBloqueo --->
								<cfquery name="rsUsuRef" dbtype="query">
									Select Usucodigo
									from rsUsucodigosBloqueo
									where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsucodigoUsuRef.Usucodigo#" null="#Len(rsUsucodigoUsuRef.Usucodigo) Is 0#">
								</cfquery>	
								<cfif isdefined('rsUsuRef') and rsUsuRef.recordCount EQ 0>
									<!---  BLOQUEO DEL USUARIO Vendedor --->
									<cfquery datasource="#session.dsn#">
										insert into UsuarioBloqueo (Usucodigo, bloqueo, CEcodigo, fecha, razon, desbloqueado)
										values (
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsucodigoUsuRef.Usucodigo#">
											, <cfqueryparam cfsqltype="cf_sql_timestamp" value="1-1-6100">
											, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
											, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
											, <cfqueryparam cfsqltype="cf_sql_varchar" value="Vendedor inhabilitado/bloqueado por el saci">
											, 0)
								   </cfquery>								
								<cfelse>
									<!---  BLOQUEO DEL USUARIO Vendedor --->
									<cfquery datasource="#session.dsn#">
										update UsuarioBloqueo
										set desbloqueado = 0
										where bloqueo   > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
										  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsUsucodigoUsuRef.Usucodigo#">
										  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
										  and desbloqueado = 1
									</cfquery>										
								</cfif>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cfif>
		<cfelse>	<!--- habilita todos los usuarios SACI de todos los vendedores por agente 	--->
			<!--- Se seleccionan todos los vendedores con estado de Inhabilitado para su habilitacion --->
			<cfquery  name="rsVendedoresInhabil" dbtype="query">
				Select Vid
				from rsVendedores
				where Habilitado=0
			</cfquery>		
			
			<cfif isdefined('rsVendedoresInhabil') and rsVendedoresInhabil.recordCount GT 0>
				<!---  Busqueda del Usucodigo del todos los vendedores con estado de inhabilitado --->
				<cfquery name="rsUsucodigosVend" datasource="#session.dsn#">
					Select Usucodigo,llave
					from UsuarioReferencia
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
						and STabla='ISBvendedor'
						and llave in (#QuotedValueList(rsVendedoresInhabil.Vid)#)
				</cfquery>

				<cfif isdefined('rsUsucodigosVend') and rsUsucodigosVend.recordCount GT 0>
					<!---  Busqueda de todos los Usucodigos de los vendedores asociados al agente seleccionado en UsuarioBloqueo --->
					<cfquery name="rsUsucodigosBloqueo" datasource="#session.dsn#">
						Select Usucodigo
						from UsuarioBloqueo
						where Usucodigo in (#ValueList(rsUsucodigosVend.Usucodigo)#)
							and bloqueo=<cfqueryparam cfsqltype="cf_sql_timestamp" value="1-1-6100">
							and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					</cfquery>				

					<cfif isdefined('rsUsucodigosBloqueo') and rsUsucodigosBloqueo.recordCount GT 0>
						<cfloop query="rsVendedoresInhabil">
							<!--- Se busca el Usucodigo del vendedor en UsuarioReferencia --->
							<cfquery name="rsUsucodigoUsuRef" dbtype="query">
								Select Usucodigo
								from rsUsucodigosVend
								where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVendedoresInhabil.Vid#" null="#Len(rsVendedoresInhabil.Vid) Is 0#">
							</cfquery>	
							
							<cfif isdefined('rsUsucodigoUsuRef') and rsUsucodigoUsuRef.recordCount GT 0>
								<!--- Se busca el Usucodigo del vendedor --->
								<cfquery name="rsUsuRef" dbtype="query">
									Select Usucodigo
									from rsUsucodigosBloqueo
									where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsucodigoUsuRef.Usucodigo#" null="#Len(rsUsucodigoUsuRef.Usucodigo) Is 0#">
								</cfquery>	
								
								<cfif isdefined('rsUsuRef') and rsUsuRef.recordCount GT 0>
									<!---  DESBLOQUEO DEL USUARIO Vendedor, y por ser desbloqueo no se realiza el insert, solo update en UsuarioBloqueo --->
									<cfquery datasource="#session.dsn#">
										update UsuarioBloqueo
										set desbloqueado = 1
										where bloqueo   > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
										  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsUsuRef.Usucodigo#">
										  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
										  and desbloqueado = 0
									</cfquery>										
								</cfif>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cfif>
		</cfif>	
	</cfif>

	<!--- Se habilita o inhabilita todos los vendedores asociados al agente --->
	<cfquery datasource="#session.dsn#">
		update ISBvendedor
			set Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="Vid" type="numeric" required="Yes"  displayname="Vendedor">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Persona">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  <cfargument name="Vprincipal" type="boolean" required="Yes"  displayname="principal?">
  <cfargument name="Habilitado" type="boolean" required="Yes" displayname="Habilitado">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBvendedor"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="Vid"
						type1="numeric"
						value1="#Arguments.Vid#">
	</cfif>

	<cfquery datasource="#session.dsn#">
		update ISBvendedor
		set Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
		, AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		, Vprincipal = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Vprincipal#" null="#Len(Arguments.Vprincipal) Is 0#">
		
		, Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Vid#" null="#Len(Arguments.Vid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="Vid" type="numeric" required="Yes"  displayname="Vendedor">

	<cfquery datasource="#session.dsn#">
		delete ISBvendedor
		where Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Vid#" null="#Len(Arguments.Vid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Persona">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  <cfargument name="Vprincipal" type="boolean" required="No" default="false" displayname="principal?">
  <cfargument name="Habilitado" type="boolean" required="No" default="false" displayname="Habilitado">

	<cfquery name="rsAlta" datasource="#session.dsn#">
		insert into ISBvendedor (
			Pquien,
			AGid,
			Vprincipal,
			
			Habilitado,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Vprincipal#" null="#Len(Arguments.Vprincipal) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
		<cf_dbidentity1 conexion="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 conexion="#Session.DSN#" name="rsAlta" verificar_transaccion="false">
			
	<cfif isdefined("rsAlta.identity") and len(trim(rsAlta.identity))>
		<cfreturn rsAlta.identity>
	<cfelse>
		<cfset retorna = -1>
		<cfreturn retorna>
	</cfif>

</cffunction>

</cfcomponent>

