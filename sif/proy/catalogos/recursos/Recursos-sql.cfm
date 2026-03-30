<cfif not isdefined("form.nuevo")>
	<cfif isdefined("form.alta")>
		<cfquery name="rsValidaAlta" datasource="#session.dsn#">
			select 1 
			from PRJRecurso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and UPPER(PRJRcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCASE(form.PRJRcodigo)#">
		</cfquery>
		<cfif rsValidaAlta.RecordCount gt 0>
			<cf_errorCode	code = "50566" msg = "El código que intenta insertar ya existe! Proceso Cancelado!">
		</cfif>
		<cfif form.PRJtipoRecurso eq 2>
			<cfquery name="rsUnidad" datasource="#session.dsn#">
				select Ucodigo
				from Articulos
				where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
			</cfquery>
		</cfif>
		<cfquery name="rsAlta" datasource="#session.dsn#">
			insert into PRJRecurso
			(Ucodigo, PRJRcodigo, PRJRdescripcion, PRJtipoRecurso, Ecodigo, RHPcodigo, Aid, Cid)
			values(
				<cfif form.PRJtipoRecurso eq 2><cfqueryparam cfsqltype="cf_sql_char" value="#rsUnidad.Ucodigo#"><cfelse><cfqueryparam cfsqltype="cf_sql_char" value="#form.Ucodigo#"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.PRJRcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.PRJRdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.PRJtipoRecurso#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#" null="#len(trim(form.RHPcodigo)) eq 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#" null="#len(trim(form.Aid)) eq 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#" null="#len(trim(form.Cid)) eq 0#">
			)
		</cfquery>
		<cfquery name="rsPRJparametros" datasource="#session.dsn#">
			select PCEcatidRecurso 
			from PRJparametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsPRJparametros.RecordCount>
			<cfquery name="rsAltaPCDCatalogo" datasource="#session.dsn#">
				insert into PCDCatalogo
				(PCEcatid,PCEcatidref,Ecodigo,PCDactivo,PCDvalor,PCDdescripcion,Usucodigo,Ulocalizacion)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPRJparametros.PCEcatidRecurso#">,
					null, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">, 1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRJRcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRJRdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">, '00'
				)
			</cfquery>
		</cfif>
	<cfelseif isdefined("form.cambio")>
		<cf_dbtimestamp
			 datasource="#session.dsn#"
			 table="PRJRecurso"
			 redirect="Recursos.cfm"
			 timestamp="#form.ts_rversion#"
			 field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
			 field2="PRJRid" type2="numeric" value2="#form.PRJRid#">
		<cfquery name="rsValidaAlta" datasource="#session.dsn#">
			select 1 
			from PRJRecurso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and UPPER(PRJRcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCASE(form.PRJRcodigo)#">
			and UPPER(PRJRcodigo) <> <cfqueryparam cfsqltype="cf_sql_char" value="#UCASE(form.hid_PRJRcodigo)#">
		</cfquery>
		<cfif rsValidaAlta.RecordCount gt 0>
			<cf_errorCode	code = "50566" msg = "El código que intenta insertar ya existe! Proceso Cancelado!">
		</cfif>
		<cfif form.PRJtipoRecurso eq 2>
			<cfquery name="rsUnidad" datasource="#session.dsn#">
				select Ucodigo
				from Articulos
				where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
			</cfquery>
		</cfif>
		<cfquery name="rsCambio" datasource="#session.dsn#">
			update PRJRecurso
				set Ucodigo = <cfif form.PRJtipoRecurso eq 2><cfqueryparam cfsqltype="cf_sql_char" value="#rsUnidad.Ucodigo#"><cfelse><cfqueryparam cfsqltype="cf_sql_char" value="#form.Ucodigo#"></cfif>, 
				PRJRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PRJRcodigo#">, 
				PRJRdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PRJRdescripcion#">, 
				PRJtipoRecurso = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PRJtipoRecurso#">, 
				RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#" null="#len(trim(form.RHPcodigo)) eq 0#">, 
				Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#" null="#len(trim(form.Aid)) eq 0#">, 
				Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#" null="#len(trim(form.Cid)) eq 0#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and PRJRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJRid#">
		</cfquery>
		<cfquery name="rsPRJparametros" datasource="#session.dsn#">
			select PCEcatidRecurso 
			from PRJparametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsPRJparametros.RecordCount>
			<cfquery name="rsAltaPCDCatalogo" datasource="#session.dsn#">
				update PCDCatalogo
					set PCDvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PRJRcodigo#">,
					PCDdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PRJRdescripcion#">,
					Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPRJparametros.PCEcatidRecurso#">
					and PCDvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.hid_PRJRcodigo#">
			</cfquery>
		</cfif>
	<cfelseif isdefined("form.baja")>
		<cfquery name="rsBaja" datasource="#session.dsn#">
			delete PRJRecurso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and PRJRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJRid#">
		</cfquery>
		<cfquery name="rsPRJparametros" datasource="#session.dsn#">
			select PCEcatidRecurso 
			from PRJparametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsPRJparametros.RecordCount>
			<cfquery name="rsAltaPCDCatalogo" datasource="#session.dsn#">
				delete PCDCatalogo
				where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPRJparametros.PCEcatidRecurso#">
					and PCDvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.hid_PRJRcodigo#">
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<cfset retornar = "">
<cfif isdefined("form.PRJRid") and len(trim(form.PRJRid)) and isdefined("form.cambio")><cfset agregar = "PRJRid=" & form.PRJRid><cfset retornar = retornar & iif(len(trim(retornar)),DE("&"),DE("?")) & agregar></cfif>
<cfif isdefined("form.PAGENUM") and len(trim(form.PAGENUM))><cfset agregar = "PAGENUM=" & form.PAGENUM><cfset retornar = retornar & iif(len(trim(retornar)),DE("&"),DE("?")) & agregar></cfif>
<cflocation url="Recursos.cfm#retornar#">

