<cfset Actividad = #ListToArray(Form.Actividad, '|')#>
<cfset Tipo = Actividad[1]>
<cfset Componente = "">
<cfif ArrayLen(Actividad) GT 1>
	<cfset Componente = Trim(Actividad[2])>
</cfif>
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_Nivel" datasource="#Session.DSN#">
				declare @cont smallint, @cont1 smallint, @cont2 smallint

				select @cont1 = isnull(max(MPorden),0)
				from MateriaPrograma
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				and MPorden != null
				and MPleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">
				select @cont2 = isnull(max(EMorden),0)
				from EvaluacionMateria
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				and EMorden != null
				and EMleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">

				if @cont1 > @cont2 select @cont = @cont1 + 10 else select @cont = @cont2 + 10
				<cfif Tipo EQ 0>
					insert MateriaPrograma(Mconsecutivo, PEcodigo, MPnombre, MPdescripcion, MPorden, MPduracion, MPleccion)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nombre#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MPdescripcion#">,
						<cfif Len(Trim(Form.Secuencia)) GT 0>
							<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Secuencia#">,
						<cfelse>
							@cont,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.MPduracion#">,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">
					)
				<cfelseif Tipo EQ 1 and Componente EQ "">
					insert EvaluacionMateria(Mconsecutivo, PEcodigo, EMnombre, EVTcodigo, ECcodigo, EMorden, EMleccion)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">,
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
							@cont,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">
					)
				<!---
				<cfelse>
					update EvaluacionMateria
					set EMleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">,
					    EMnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nombre#">, 
						<cfif Len(Trim(Form.Secuencia)) GT 0>
							EMorden = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Secuencia#">
						<cfelse>
							EMorden = @cont
						</cfif>
					where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
					and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
					and EMcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Componente#">
				--->
				</cfif>
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_Nivel" datasource="#Session.DSN#">
				<cfif Tipo EQ 0>
					delete MateriaPrograma
					where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
					and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
					and MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Componente#">
				<cfelseif Tipo EQ 1>
					delete EvaluacionMateria
					where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
					and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
					and EMcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Componente#">
				</cfif>
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_Nivel" datasource="#Session.DSN#">
				declare @cont smallint, @cont1 smallint, @cont2 smallint

				select @cont1 = isnull(max(MPorden),0)
				from MateriaPrograma
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				and MPorden != null
				and MPleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">
				select @cont2 = isnull(max(EMorden),0)
				from EvaluacionMateria
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				and EMorden != null
				and EMleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">

				if @cont1 > @cont2 select @cont = @cont1 + 10 else select @cont = @cont2 + 10
				<cfif Tipo EQ 0>
					update MateriaPrograma
					   set MPleccion = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Leccion#">,
					       MPnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Nombre#">,
						   MPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MPdescripcion#">,
						   MPduracion = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.MPduracion#">,
						   <cfif Len(Trim(Form.Secuencia)) GT 0>
						   MPorden = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Secuencia#">
						   <cfelse>
						   MPorden = @cont
						   </cfif>
					where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
					and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
					and MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Componente#">
				<cfelseif Tipo EQ 1>
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
						   EMorden = @cont
						   </cfif>
					where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
					and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
					and EMcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Componente#">
				</cfif>
			</cfquery>
		    <cfset modo="CAMBIO">
		</cfif>
		<cfif Tipo EQ 1>
			<cfquery datasource="#Session.DSN#" name="rsUpdPorcentajes">
				update EvaluacionMateria
				set EMporcentaje = convert(numeric(6,2), 100.0 / ( select count(*)
				from EvaluacionMateria e
				where e.ECcodigo = EvaluacionMateria.ECcodigo
				and e.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				and e.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				))
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				
				update EvaluacionMateria
				set EMporcentaje = EMporcentaje +
				(100.0 - (select sum(EMporcentaje)
				from EvaluacionMateria e
				where e.ECcodigo = EvaluacionMateria.ECcodigo
				and e.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				and e.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				)
				)
				where EMcomponente = (select max(EMcomponente)
				from EvaluacionMateria e
				where e.ECcodigo = EvaluacionMateria.ECcodigo
				and e.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				and e.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				)
			</cfquery>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../recurso/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="MateriaDetalle.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Mconsecutivo" type="hidden" value="<cfif isdefined("Form.Mconsecutivo")><cfoutput>#Form.Mconsecutivo#</cfoutput></cfif>">
	<input name="PEcodigo" type="hidden" value="<cfif isdefined("Form.PEcodigo")><cfoutput>#Form.PEcodigo#</cfoutput></cfif>">
	<cfif isdefined("modo") and modo NEQ "ALTA">
		<input name="Tipo" type="hidden" value="<cfoutput>#Tipo#</cfoutput>">
		<input name="CodAct" type="hidden" value="<cfoutput>#Componente#</cfoutput>">
	</cfif>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
