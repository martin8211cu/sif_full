<!---
	Busca el responsable definido en el CF de un usuario:
--->
<cffunction name="ResponsableCF_usuario" access="public" output="false" returntype="numeric">
	<cfargument name="Usucodigo" type="numeric" required="yes">
	<cfset LvarCFid = CF_usuario(Arguments.Usucodigo)>
	<cfreturn responsable_cf(LvarCFid)>
</cffunction>

<!---
	Busca el CF de un usuario:
	Depende del parámetro 3500:
		USU:		en UsuarioCFuncional
		EMP:		en EmpleadoCFuncional
		"":			RH:
			Primero,	si es empleado y está nombrado: 		busca en LineaTiempo
			sino, 		si es empleado y lo están nombrando: 	busca en RHAcciones
--->
<cffunction name="CF_usuario" access="public" output="false" returntype="numeric">
	<cfargument name="Usucodigo" type="numeric" required="yes">

	<cfquery name="rsSQL" datasource="#session.DSN#">
		select Pvalor 
		  from Parametros 
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		   and Pcodigo=3500
	</cfquery>
	<cfset LvarTipoUsuCF = trim(rsSQL.Pvalor)>

	<cfset cf = QueryNew('CFpk,CFpkresp,CFboss')>

	<cfif LvarTipoUsuCF EQ "USU">
		<cfquery datasource="#session.dsn#" name="cf">
			select 	cf.CFid, cf.CFidresp, 
					case 
						when cf.CFuresponsable = #session.Usucodigo# then 1
						else 0
					end as CFboss
			  from UsuarioCFuncional cfu
				inner join CFuncional cf on cf.CFid = cfu.CFid
			 where cfu.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and cfu.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
	<cfelseif LvarTipoUsuCF EQ "EMP">
		<cfquery datasource="#session.dsn#" name="infousuario" maxrows="1">
			select b.llave
			from UsuarioReferencia b
			where b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			  and b.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
		</cfquery>
		<cfif Len(infousuario.llave)>
			<cfquery datasource="#session.dsn#" name="cf">
				select 	cf.CFid, cf.CFidresp, 
						case 
							when cf.CFuresponsable = #session.Usucodigo# then 1
							else 0
						end as CFboss
				  from EmpleadoCFuncional eaf
					inner join DatosEmpleado e		on e.DEid = eaf.DEid 
					inner join CFuncional cf		on cf.CFid = eaf.CFid
				 where eaf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and eaf.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#infousuario.llave#">
				   and <cf_dbfunction name="today"> between ECFdesde and ECFhasta
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="infousuario" maxrows="1">
			select b.llave
			from UsuarioReferencia b
			where b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			  and b.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
		</cfquery>
		<cfif Len(infousuario.llave)>
			<!--- si el usuario es un empleado y ya esta nombrado--->
			<cfquery datasource="#session.dsn#" name="cf">
				select 	cf.CFid, cf.CFidresp, 
						case 
							when coalesce(cf.CFuresponsable,-2) = #session.Usucodigo# then 1
							when lt.RHPid = cf.RHPid then 1
							else 0
						end as CFboss
				from LineaTiempo lt
					inner join RHPlazas pl
						on pl.RHPid = lt.RHPid
						and pl.Ecodigo = lt.Ecodigo
					inner join CFuncional cf
						on cf.CFid = pl.CFid
				where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#infousuario.llave#">
				  and <cf_dbfunction name="now"> between lt.LTdesde and lt.LThasta
			</cfquery>
	
			<cfif not cf.recordcount>
				<!--- si el usuario es un empleado y lo estan nombrando (NO TIENE LT)--->
				<cfquery datasource="#session.dsn#" name="cf">
					select 	cf.CFid, cf.CFidresp, 
							case 
								when coalesce(cf.CFuresponsable,-2) = #session.Usucodigo# then 1
								when Accion.RHPid = cf.RHPid then 1
								else 0
							end as CFboss
					from RHAcciones Accion
					join RHPlazas pl
						 on pl.RHPid = Accion.RHPid
						and pl.Ecodigo = Accion.Ecodigo
					join RHTipoAccion p
						on p.RHTid=Accion.RHTid
						and RHTcomportam  =1
					join CFuncional cf
						on cf.CFid = pl.CFid
					where Accion.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Accion.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#infousuario.llave#">
					  and <cf_dbfunction name="now"> between Accion.DLfvigencia and coalesce(Accion.DLffin,<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(6100,1,1)#">)
					  and Accion.RHAlinea = (select max(b.RHAlinea) from RHAcciones b where b.DEid = Accion.DEid)
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	
	<cfreturn cf.CFid>
</cffunction>

<!---
	Busca el Responsable definido en un CF:
		Busca el Usuario Responsable (plaza o responsable)
--->
<cffunction name="responsable_cf" access="public" output="false" returntype="numeric">
	<cfargument name="CFid" type="numeric" required="yes">
	
	<!--- Busca la plaza responsable --->
	<cfquery datasource="#session.dsn#" name="buscar_cf">
		select cf.Ecodigo, CFuresponsable, lt.DEid as DEid_jefe
		from CFuncional cf
			left join RHPlazas pl
				on cf.RHPid = pl.RHPid
			left join LineaTiempo lt
				on lt.RHPid = pl.RHPid
				and <cf_dbfunction name="now"> between LTdesde and LThasta
		where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
		  and cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfif buscar_cf.CFuresponsable NEQ "">
		<cfreturn buscar_cf.CFuresponsable>
	<cfelseif buscar_cf.DEid_jefe NEQ "">
		<cfquery datasource="#session.dsn#" name="buscar_cf">
			select ur.Usucodigo
			  from UsuarioReferencia ur
			 where ur.llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#buscar_cf.DEid_jefe#">
			   and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			   and ur.STabla = 'DatosEmpleado'
		</cfquery>
		<cfif buscar_cf.Usucodigo NEQ "">
			<cfreturn buscar_cf.Usucodigo>
		<cfelse>
			<cfreturn 0>
		</cfif>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>
