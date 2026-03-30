<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 07 de febrero del 2006
	Motivo: Actualizacin de fuentes de educación a nuevos estndares de Pantallas y Componente de Listas.
 ---> 

<cfset Actividad = #ListToArray(Form.Actividad, '|')#>
<cfset Tipo = Actividad[1]>
<cfif Find('-', Tipo) NEQ 0>
	<cfset Tipo = #Mid(Tipo, 1, 1)#>
</cfif>
<cfset Componente = "">
<cfif ArrayLen(Actividad) GT 1>
	<cfset Componente = Trim(Actividad[2])>
</cfif>
<cfset params="Mconsecutivo="&form.Mconsecutivo>
<cfset pagina2 = "1">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined('form.Alta')>
		<cfquery name="rsMaxMPorden" datasource="#session.Edu.DSN#">
			select coalesce(max(MPorden),0) as MPorden
			from MateriaPrograma
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
			  and MPorden is not null
			  and MPleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">
		</cfquery>
		<cfquery name="rsMaxEMorden" datasource="#session.Edu.DSN#">
			select coalesce(max(EMorden),0) as EMorden
			from EvaluacionMateria
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
			  and EMorden is not null
			  and EMleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">
		</cfquery>
		<cfif rsMaxMPorden.MPorden GT rsMaxEMorden.EMorden>
			<cfset Lvar_MaxOrden = rsMaxMPorden.MPorden + 10>
		<cfelse>
			<cfset Lvar_MaxOrden = rsMaxEMorden.EMorden + 10>
		</cfif>
		<cftransaction>
			<cfif Tipo EQ 0>
				<cfquery name="rsInsertMP" datasource="#session.Edu.DSN#">
					insert MateriaPrograma(Mconsecutivo, PEcodigo, MPnombre, MPdescripcion, MPorden, MPduracion, MPleccion)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MPdescripcion#">,
							<cfif Len(Trim(Form.Secuencia)) GT 0>
								<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Secuencia#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_smallint" value="#Lvar_MaxOrden#">,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_float" value="#Form.MPduracion#">,
							<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">
						)
					<cf_dbidentity1 datasource="#session.Edu.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertMP">
				<cfset form.CodAct = rsInsertMP.identity>
			<cfelseif Tipo EQ 1 and Componente EQ "">
				<cfquery name="rsInsertEM" datasource="#session.Edu.DSN#">
					insert EvaluacionMateria(Mconsecutivo, PEcodigo, EMnombre, EVTcodigo, ECcodigo, EMorden, EMleccion)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nombre#">,
							<cfif Trim(Form.EVTcodigo) NEQ "-1">
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EVTcodigo#">,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECcodigo#">,
							<cfif Len(Trim(Form.Secuencia)) GT 0>
								<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Secuencia#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_smallint" value="#Lvar_MaxOrden#">,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">
						)
					<cf_dbidentity1 datasource="#session.Edu.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertEM">
				<cfset form.CodAct = rsInsertEM.identity>
			</cfif>
		</cftransaction>
		<cfquery name="rsPagina" datasource="#session.Edu.DSN#">
			select MPcodigo as CodAct,
				  0 as Tipo,
				  coalesce(MPleccion,0) as Leccion, 
				  coalesce(MPorden,0) as Secuencia
			from MateriaPrograma
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
			  and MPorden is not null
			<cfif isdefined('form.Filtro_Actividad') and LEN(TRIM(form.Filtro_Actividad))>
			  and upper(MPnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Actividad)#%">
			</cfif>
			<cfif isdefined('form.Filtro_Leccion') and form.Filtro_Leccion GT 0>
			  and MPleccion >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Leccion#">
			</cfif>
			<cfif isdefined('form.Filtro_Secuencia') and form.Filtro_Secuencia GT 0>
			  and MPorden >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Secuencia#">
			</cfif>
			union
			select EMcomponente as CodAct,
				  1 as Tipo, 
				 isnull(EMleccion,0) as Leccion, 
			     isnull(EMorden,0) as Secuencia
			from EvaluacionMateria
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
			  and EMorden is not null
			<cfif isdefined('form.Filtro_Actividad') and LEN(TRIM(form.Filtro_Actividad))>
			  and upper(EMnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Actividad)#%">
			</cfif>
			<cfif isdefined('form.Filtro_Leccion') and form.Filtro_Leccion GT 0>
			  and EMleccion >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Leccion#">
			</cfif>
			<cfif isdefined('form.Filtro_Secuencia') and form.Filtro_Secuencia GT 0>
			  and EMorden >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Secuencia#">
			</cfif>
			order by Leccion, Secuencia, Tipo
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.CodAct EQ form.CodAct>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset pagina2 = Ceiling(row / form.MaxRows)>
		<cfset params=params&"&CodAct="&form.CodAct>
	<cfelseif isdefined('form.Cambio')>
		<cfquery name="rsMaxMPorden" datasource="#session.Edu.DSN#">
			select coalesce(max(MPorden),0) as MPorden
			from MateriaPrograma
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
			  and MPorden is not null
			  and MPleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">
		</cfquery>
		<cfquery name="rsMaxEMorden" datasource="#session.Edu.DSN#">
			select coalesce(max(EMorden),0) as EMorden
			from EvaluacionMateria
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
			  and EMorden is not null
			  and EMleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">
		</cfquery>
		<cfif rsMaxMPorden.MPorden GT rsMaxEMorden.EMorden>
			<cfset Lvar_MaxOrden = rsMaxMPorden.MPorden + 10>
		<cfelse>
			<cfset Lvar_MaxOrden = rsMaxEMorden.EMorden + 10>
		</cfif>
		<cfif Tipo EQ 0>
			<cfquery name="rsUpdateMP" datasource="#session.Edu.DSN#">
				update MateriaPrograma
				   set MPleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">,
					   MPnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nombre#">,
					   MPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MPdescripcion#">,
					   MPduracion = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.MPduracion#">,
					   <cfif Len(Trim(Form.Secuencia)) GT 0>
					   MPorden = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Secuencia#">
					   <cfelse>
					   MPorden = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Lvar_MaxOrden#">
					   </cfif>
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
				  and MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Componente#">
			</cfquery>
		<cfelseif Tipo EQ 1>
			<cfquery name="rsUpdateEM" datasource="#session.Edu.DSN#">
				update EvaluacionMateria
				   set EMleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">,
					   EMnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nombre#">,
					   <cfif Trim(Form.EVTcodigo) NEQ "-1">
					   EVTcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EVTcodigo#">,
					   <cfelse>
					   EVTcodigo = null,
					   </cfif>
					   ECcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECcodigo#">,
					   <cfif Len(Trim(Form.Secuencia)) GT 0>
					   EMorden = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Secuencia#">
					   <cfelse>
					   EMorden = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Lvar_MaxOrden#">
					   </cfif>
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
				  and EMcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Componente#">
			</cfquery>
		</cfif>
		<cfquery name="rsPagina" datasource="#session.Edu.DSN#">
			select MPcodigo as CodAct,
				  0 as Tipo,
				  coalesce(MPleccion,0) as Leccion, 
				  coalesce(MPorden,0) as Secuencia
			from MateriaPrograma
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
			  and MPorden is not null
			<cfif isdefined('form.Filtro_Actividad') and LEN(TRIM(form.Filtro_Actividad))>
			  and upper(MPnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Actividad)#%">
			</cfif>
			<cfif isdefined('form.Filtro_Leccion') and form.Filtro_Leccion GT 0>
			  and MPleccion >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Leccion#">
			</cfif>
			<cfif isdefined('form.Filtro_Secuencia') and form.Filtro_Secuencia GT 0>
			  and MPorden >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Secuencia#">
			</cfif>
			union
			select EMcomponente as CodAct,
				  1 as Tipo, 
				 isnull(EMleccion,0) as Leccion, 
			     isnull(EMorden,0) as Secuencia
			from EvaluacionMateria
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
			  and EMorden is not null
			<cfif isdefined('form.Filtro_Actividad') and LEN(TRIM(form.Filtro_Actividad))>
			  and upper(EMnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.Filtro_Actividad)#%">
			</cfif>
			<cfif isdefined('form.Filtro_Leccion') and form.Filtro_Leccion GT 0>
			  and EMleccion >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Leccion#">
			</cfif>
			<cfif isdefined('form.Filtro_Secuencia') and form.Filtro_Secuencia GT 0>
			  and EMorden >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_Secuencia#">
			</cfif>
			order by Leccion, Secuencia, Tipo
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.CodAct EQ Componente>
					<cfset row = rsPagina.currentrow>
					<cfbreak>	
				</cfif>
			</cfloop>
		</cfif>
		<cfset pagina2 = Ceiling(row / form.MaxRows)>
		<cfset params=params&"&CodAct="&Componente>
	<cfelseif isdefined('form.Baja')>
		<cfif Tipo EQ 0>
			<cfquery name="rsDeleteMP" datasource="#session.Edu.DSN#">
				delete MateriaPrograma
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
				  and MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Componente#">
			</cfquery>
		<cfelseif Tipo EQ 1>
			<cfquery name="rsDeleteEM" datasource="#session.Edu.DSN#">
				delete EvaluacionMateria
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Filtro_PEcodigo#">
				  and EMcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Componente#">
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<cflocation url="Materias.cfm?Pagina2=#pagina2#&Pagina=#form.Pagina#&Tipo=#Tipo#&Filtro_Actividad=#Form.Filtro_Actividad#&Filtro_Leccion=#form.Filtro_Leccion#&Filtro_Secuencia=#form.Filtro_Secuencia#&Filtro_PEcodigo=#form.Filtro_PEcodigo#&Filtro_Mcodigo=#form.Filtro_Mcodigo#&Filtro_Melectiva=#form.Filtro_Melectiva#&Filtro_Mnombre=#form.Filtro_Mnombre#&Filtro_MTdescripcion=#form.Filtro_MTdescripcion#&FNcodigoC=#form.FNcodigoC#&FGcodigoC=#form.FGcodigoC#&HFiltro_Mcodigo=#form.Filtro_Mcodigo#&HFiltro_Melectiva=#form.Filtro_Melectiva#&HFiltro_Mnombre=#form.Filtro_Mnombre#&HFiltro_MTdescripcion=#form.Filtro_MTdescripcion#&Detalle=#form.Detalle#&#params#">