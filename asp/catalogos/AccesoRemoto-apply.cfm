<cfif StructKeyExists(form, 'submit-acceso')>
	
	<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
	<cfset data = Politicas.trae_parametros_cuenta(Session.Progreso.CEcodigo)>
	
	<cftransaction>
	
		<!--- Encabezado --->
		<cfparam name="form.ARnombre" default="Nuevo Perfil">
		<cfif Len(form.acceso)>
			<cfquery datasource="asp">
				update AccesoRemoto
				set ARnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ARnombre#">
				where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">
			</cfquery>
		<cfelse>
			<cfquery datasource="asp" name="AccesoRemotoInsert">
				insert into AccesoRemoto (CEcodigo, ARnombre)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.progreso.CEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ARnombre#">)
					<cf_dbidentity1 datasource="asp" name="AccesoRemotoInsert" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="AccesoRemotoInsert" verificar_transaccion="false">
			<cfset form.acceso = AccesoRemotoInsert.identity>
		</cfif>
		
		<!--- Horario --->
		<cfif data.auth.validar.horario>
			<cfquery datasource="asp">
				delete from AccesoHorario
				where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">
			</cfquery>
			<cfloop list="#form.horario#" index="unhora" delimiters=";">
				<cfquery datasource="asp">
					insert into AccesoHorario (acceso, dia, desde, hasta)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(unhora,1)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(unhora,2)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(unhora,3)#">)
				</cfquery>
			</cfloop>
		</cfif>
		
		<!--- Direcciones IP --->
		<cfif data.auth.validar.ip>
			<cfquery datasource="asp">
				delete from AccesoIP
				where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">
			</cfquery>
			<cfloop from="1" to="#ListLen(form.fieldnames) / 2#" index="num_ip">
				<cfset form.num_ip = num_ip>
				<cfif StructKeyExists(form, 'ipdesde' & num_ip) And Len(Trim(form['ipdesde' & num_ip]))>
					<cfparam name="form.iphasta#num_ip#" default="">
					<cfif Not Len(Trim(form['iphasta' & num_ip]))>
							<cfset form['iphasta' & num_ip] = form['ipdesde' & num_ip]>
					</cfif>
		
					<cfinvoke component="home.Componentes.NormalizarIP" method="NormalizarIP"
						direccion="#form['ipdesde' & num_ip]#" returnvariable="ipdesdeNormal"/>
						
					<cfinvoke component="home.Componentes.NormalizarIP" method="NormalizarIP"
						direccion="#form['iphasta' & num_ip]#" returnvariable="iphastaNormal"/>
		
					<cfquery datasource="asp">
						insert into AccesoIP (acceso, ipdesde, iphasta, ipdesdeNormal, iphastaNormal)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['ipdesde' & num_ip]#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['iphasta' & num_ip]#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ipdesdeNormal#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#iphastaNormal#">)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- Roles --->
		
		<cfquery datasource="asp" name="AccesoRol">
			select {fn concat( {fn concat( rtrim(SScodigo), '.' )} , rtrim(SRcodigo) )} as rol
			from AccesoRol
			where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">
		</cfquery>
		
		<cfparam name="form.rol" default="">
		<cfloop query="AccesoRol">
			<cfif Not ListFind(form.rol, AccesoRol.rol)>
				<cfquery datasource="asp">
					delete from AccesoRol
					where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListFirst(AccesoRol.rol , '.')#">
					  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListRest(AccesoRol.rol , '.')#">
				</cfquery>
			</cfif>
		</cfloop>
		
		<cfset rolesDB = ValueList(AccesoRol.rol)>
		<cfloop list="#form.rol#" index="unRol">
			<cfif Not ListFind(rolesDB, unrol)>
				<cfset form.unrol = unrol>
				<cfquery datasource="asp">
					insert into AccesoRol (acceso, SScodigo, SRcodigo)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListFirst(unrol , '.')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListRest(unrol , '.')#">)
				</cfquery>
			</cfif>
		</cfloop>
	
	</cftransaction>
	<!--- Regresar --->
	<cflocation url="CuentaAutentica.cfm?tab=acceso&acceso=#form.acceso#" addtoken="no">
<cfelseif StructKeyExists(form, 'eliminar-acceso')>
	<cftransaction>
		<cfquery datasource="asp">
			delete from AccesoHorario
			where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">
		</cfquery>
		<cfquery datasource="asp">
			delete from AccesoIP
			where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">
		</cfquery>
		<cfquery datasource="asp">
			delete from AccesoRol
			where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">
		</cfquery>
		<cfquery datasource="asp">
			delete from AccesoRemoto
			where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.acceso#">
		</cfquery>
	</cftransaction>
	<!--- Regresar --->
	<cflocation url="CuentaAutentica.cfm?tab=acceso" addtoken="no">
<cfelse>
	<cfthrow message="Error interno: sin botón">
</cfif>
