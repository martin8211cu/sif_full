<cffunction name="getCentrosFuncionalesDependientes" returntype="string">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfargument name="Ecodigo" type="numeric" default="#Session.Ecodigo#">
	<cfset resultado = "">
	<cfquery name="rs#Arguments.cfid#" datasource="#session.dsn#">
		select CFid, CFidresp
		from CFuncional
		where CFidresp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cfid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfif Evaluate("rs#Arguments.cfid#").recordCount>
		<cfloop query="rs#Arguments.cfid#">
			<cfset resultado = resultado & Iif(Len(Trim(resultado)), DE(","), DE("")) & getCentrosFuncionalesDependientes(Evaluate("rs#Arguments.cfid#").CFid)>
		</cfloop>
		<cfreturn ("" & Arguments.cfid & "," & resultado)>
	<cfelse>
		<cfreturn ("" & Arguments.cfid)>
	</cfif>
</cffunction>

<!--- Modo ALTA de Centros Funcionales --->
<cfif isdefined("Form.btnAgregarCF") and isdefined("Form.CFid") and Len(Trim(Form.CFid))>

	<!--- Chequear que el centro funcional no haya sido insertado anteriormente --->
	<cfquery name="chkExists" datasource="#Session.DSN#">
		select 1
		from RHASalarialUbicaciones
		where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
	</cfquery>

	<cfif not chkExists.recordCount>
		<cftransaction>
			<cfquery name="insASalarialUbicaciones" datasource="#Session.DSN#">
				insert into RHASalarialUbicaciones (RHASid, CFid, Ecodigo, RHASUdependecias, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfif isdefined("Form.chkDependencias")>
						1,
					<cfelse>
						0,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
			<!--- Si el Centro Funcional incluye dependencias entonces hay que agregarlas --->
			<!---
				Se cambio el algoritmo para obtener las dependencias
			<cfif isdefined("Form.chkDependencias")>
				<cfset centros = getCentrosFuncionalesDependientes(Form.CFid)>
				<cfloop list="#centros#" index="item" delimiters=",">
					<cfquery name="insASalarialUbicaciones" datasource="#Session.DSN#">
						insert into RHASalarialUbicaciones (RHASid, CFid, Ecodigo, RHASUdependecias, BMUsucodigo)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						)
					</cfquery>
				</cfloop>
			</cfif>
			--->
			<cfif isdefined("Form.chkDependencias")>
				<cfquery name="rsCF" datasource="#Session.DSN#">
					select CFpath
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
				</cfquery>
				<cfquery name="insASalarialUbicaciones" datasource="#Session.DSN#">
					insert into RHASalarialUbicaciones (RHASid, CFid, Ecodigo, RHASUdependecias, BMUsucodigo)
					select
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">, 
						CFid,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						0,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(rsCF.CFpath)#/%">
				</cfquery>
			</cfif>
		</cftransaction>
		
	</cfif>

<!--- Modo ALTA de Oficina / Departamento --->
<cfelseif isdefined("Form.btnAgregarOD") and isdefined("Form.Ocodigo") and Len(Trim(Form.Ocodigo)) and isdefined("Form.Dcodigo") and Len(Trim(Form.Dcodigo))>

	<!--- Chequear que el centro funcional no haya sido insertado anteriormente --->
	<cfquery name="chkExists" datasource="#Session.DSN#">
		select 1
		from RHASalarialUbicaciones
		where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
		and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
	</cfquery>

	<cfif not chkExists.recordCount>
		<cfquery name="insASalarialUbicaciones" datasource="#Session.DSN#">
			insert into RHASalarialUbicaciones (RHASid, Ocodigo, Dcodigo, Ecodigo, RHASUdependecias, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
		</cfquery>
	</cfif>

<!--- Modo BAJA Centro Funcional --->
<cfelseif isdefined('form.CentroF') and isdefined('form.chk')>
	<cfset Lista_CFid = ListToArray(Replace(Form.chk,' ', '', 'all'),',')>
	<cfloop index="i" from="1" to="#ArrayLen(Lista_CFid)#">
		<cfset Lvar_CFid = Lista_CFid[i]>
		<cfquery name="delASalarialPuestos" datasource="#Session.DSN#">
			delete from RHASalarialUbicaciones
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CFid#">
		</cfquery>
	</cfloop>
	
<!--- Modo BAJA Oficina / Departmento --->
<cfelseif isdefined('form.Depto') and isdefined('form.chk')>
	<cfset Lista_Depto = ListToArray(Replace(Form.chk,' ', '', 'all'),',')>
	<cfloop index="i" from="1" to="#ArrayLen(Lista_Depto)#">
		<cfset Lvar_Ofic = ListGetAt(Lista_Depto[i],1,'|')>
		<cfset Lvar_Depto = ListGetAt(Lista_Depto[i],2,'|')>
		<cfquery name="delASalarialPuestos" datasource="#Session.DSN#">
			delete from RHASalarialUbicaciones
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Ofic#">
			and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Depto#">
		</cfquery>
	</cfloop>
</cfif>
