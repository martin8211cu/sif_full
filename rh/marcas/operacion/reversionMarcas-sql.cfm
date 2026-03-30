<cfset params = ''>
<cfif isdefined("form.FDEid") and len(trim(form.FDEid))>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "FDEid=" & Form.FDEid>
</cfif>
<cfif isdefined("form.Filtro_Fecha") and len(trim(form.Filtro_Fecha))>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "Filtro_Fecha=" & Form.Filtro_Fecha>
</cfif>
<cfif isdefined("form.Filtro_FechasMayores") and len(trim(form.Filtro_FechasMayores))>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "Filtro_FechasMayores=" & Form.Filtro_FechasMayores>
</cfif>
<cfif isdefined('form.Filtro_Identificacion') and LEN(TRIM(form.Filtro_Identificacion))>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "Filtro_Identificacion=" & Form.Filtro_Identificacion>
</cfif>
<cfif isdefined('form.Filtro_NombreCompleto') and LEN(TRIM(form.Filtro_NombreCompleto))>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "Filtro_NombreCompleto=" & Form.Filtro_NombreCompleto>
</cfif>
<cfif isdefined('form.Filtro_ImgPermiso') and form.Filtro_ImgPermiso NEQ -1>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "Filtro_ImgPermiso=" & Form.Filtro_ImgPermiso>
</cfif>
<cfif isdefined('form.Filtro_ImgFeriado') and form.Filtro_ImgFeriado NEQ -1>
	<cfset params = params & Iif(Len(Trim(params)) NEQ 0, DE("&"), DE("")) & "Filtro_ImgFeriado=" & Form.Filtro_ImgPermiso>
</cfif>

<!--- Función de Actualización de Incidencias --->
<cffunction access="private" name="funcIncidencias">
	<cfargument name="arg_Iid" 	type="numeric" 	required="yes">
	<cfargument name="arg_Valor" type="numeric" required="yes">
	<cfinvoke 
		component="rh.Componentes.RH_Incidencias" 
		method="Incrementar" 
		iid="#arg_Iid#" 
		ivalor="#arg_Valor#">
</cffunction>

<!--- Función de Reversión de Un Grupo de Marcas --->
<cffunction access="private" name="reversarGrupo">
	<cfargument name="CAMid" required="True" type="Numeric">
	<!---	Proceso de Reversión de Marcas
			DELETE from Incidencias
			DELETE from RHCMDia 
			UPDATE RHCMCalculoAcumMarcas
			INSERT INTO RHControlMarcas FROM RHHControlMarcas --->
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 	CAMhniid, CAMhriid, CAMheaiid, CAMhebiid, CAMferiid,
				CAMcanthorasreb, CAMcanthorasjornada, CAMcanthorasextA, 
				CAMcanthorasextB, CAMmontoferiado
		from RHCMCalculoAcumMarcas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
	</cfquery>
	<cftransaction>
		<cfif rsDatos.RecordCount NEQ 0>
			<cfif rsDatos.CAMcanthorasreb GT 0 and len(trim(rsDatos.CAMhriid)) GT 0>
				<cfset funcIncidencias(rsDatos.CAMhriid,-rsDatos.CAMcanthorasreb)>
			</cfif>
			<cfif rsDatos.CAMcanthorasjornada GT 0 and len(trim(rsDatos.CAMhniid)) GT 0>
				<cfset funcIncidencias(rsDatos.CAMhniid,-rsDatos.CAMcanthorasjornada)>
			</cfif>
			<cfif rsDatos.CAMcanthorasextA GT 0 and len(trim(rsDatos.CAMheaiid)) GT 0>
				<cfset funcIncidencias(rsDatos.CAMheaiid,-rsDatos.CAMcanthorasextA)>
			</cfif>
			<cfif rsDatos.CAMcanthorasextB GT 0 and len(trim(rsDatos.CAMhebiid)) GT 0>
				<cfset funcIncidencias(rsDatos.CAMhebiid,-rsDatos.CAMcanthorasextB)>
			</cfif>
			<cfif rsDatos.CAMmontoferiado GT 0 and len(trim(rsDatos.CAMferiid)) GT 0>
				<cfset funcIncidencias(rsDatos.CAMferiid,-rsDatos.CAMmontoferiado)>
			</cfif>
		</cfif>
		<cfquery datasource="#session.DSN#">
			insert into RHControlMarcas(Ecodigo, DEid, 
										RHASid, fechahorareloj, tipomarca, 
										justificacion, fechahoraautorizado, usuarioautor, 
										fechahoramarca, RHJid, RHPJid, 
										RHCMhoraplan, ttoleranciaantes, ttoleranciadesp, 
										numlote, canthoras, BMUsucodigo, BMfecha)
			select 	Ecodigo, DEid, 
					RHASid, fechahorareloj, tipomarca, 
					justificacion, fechahoraautorizado, usuarioautor, 
					fechahoramarca, RHJid, RHPJid, 
					RHCMhoraplan, ttoleranciaantes, ttoleranciadesp, 
					numlote, canthoras, BMUsucodigo, BMfecha
			from RHHControlMarcas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
		</cfquery>	
		<cfquery datasource="#session.DSN#">
			delete from RHHControlMarcas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
		</cfquery>
		<!---Cambiar estado del registro procesado de la tabla de RHCMCalculoAcumMarcas ---->
		<cfquery datasource="#session.DSN#">
			update RHCMCalculoAcumMarcas
			set CAMestado = 'P'
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CAMid#">
		</cfquery>
	</cftransaction>
</cffunction>

<!--- Definición del Comportamiento --->
<cfif isdefined("form.btnfiltrar")>
<cfelseif isdefined("form.btnlimpiar")>
<cfelseif isdefined("form.btnreversar")>
	<cfif isdefined("form.chk")>
		<cfloop list="#form.chk#" index="CAMid">
			<cfinvoke method="reversarGrupo" camid="#CAMid#">
		</cfloop>
	</cfif>
<cfelseif isdefined("form.btnreversar_masivo")>
	<cfinclude template="reversionMarcas-consulta.cfm">
	<cfloop query="rsLista">
		<cfinvoke method="reversarGrupo" camid="#CAMid#">
	</cfloop>
</cfif>
<!--- Redirect al Form con los parámetros definidos --->
<cflocation url="reversionMarcas.cfm?1=1&#params#">