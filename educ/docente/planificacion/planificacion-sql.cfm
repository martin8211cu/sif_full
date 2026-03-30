<cfset modo = "ALTA">

<cftransaction>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_Evaluacion" datasource="#Session.DSN#">
				insert CursoEvaluacion (CEcodigo, PEcodigo, Ccodigo, CEVnombre, CEVdescripcion, CEVpeso, CEVtipoPeso, CEVtipoCalificacion, CEVpuntosMax, CEVunidadMin, CEVredondeo, TEcodigo, CEVfechaPlan, CEVfechaReal, CEVestado)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CEVnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CEVdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVpeso#" null="#Form.CEVtipoPeso EQ 'A'#" scale="2">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CEVtipoPeso#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CEVtipoCalificacion#">,
					<cfif Form.CEVtipoCalificacion EQ '2'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVpuntosMax#" scale="2">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVunidadMin#" scale="2">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVredondeo#" scale="3">,
						null,
					<cfelseif Form.CEVtipoCalificacion EQ '1'>
						100,0.01,0,null,
					<cfelseif Form.CEVtipoCalificacion EQ 'T'>
						null,null,null,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEcodigo#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateFormat(Form.CEVfechaPlan,'YYYYMMDD')#">,
					<cfif isdefined("Form.CEVfechaReal") and Len(Trim(Form.CEVfechaReal)) NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateFormat(Form.CEVfechaReal,'YYYYMMDD')#">, 
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.CEVestado#">
				)
			</cfquery>
			
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_Evaluacion" datasource="#Session.DSN#">
				delete CursoEvaluacion
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
				  and CEVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVcodigo#">
			</cfquery>
			
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_Evaluacion" datasource="#Session.DSN#">
				update CursoEvaluacion
				   set CEVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CEVnombre#">,
				       CEVdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CEVdescripcion#">,
					   CEVpeso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVpeso#" null="#Form.CEVtipoPeso EQ 'A'#" scale="2">,
					   CEVtipoPeso = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CEVtipoPeso#">,
					   CEVtipoCalificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CEVtipoCalificacion#">,
					<cfif Form.CEVtipoCalificacion EQ '2'>
					   CEVpuntosMax = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVpuntosMax#" scale="2">,
					   CEVunidadMin = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVunidadMin#" scale="2">,
					   CEVredondeo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVredondeo#" scale="3">,
					   TEcodigo = null,
					<cfelseif Form.CEVtipoCalificacion EQ '1'>
					   CEVpuntosMax = 100,
					   CEVunidadMin = 0.01,
					   CEVredondeo = 0,
					   TEcodigo = null,
					<cfelseif Form.CEVtipoCalificacion EQ 'T'>
					   CEVpuntosMax = null,
					   CEVunidadMin = null,
					   CEVredondeo = null,
					   TEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEcodigo#">,
					</cfif>
					   CEVfechaPlan = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateFormat(Form.CEVfechaPlan,'YYYYMMDD')#">,
					<cfif isdefined("Form.CEVfechaReal") and Len(Trim(Form.CEVfechaReal)) NEQ 0>
					   CEVfechaReal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSdateFormat(Form.CEVfechaReal,'YYYYMMDD')#">,
					<cfelse>
					   CEVfechaReal = null,
					</cfif>
					   CEVestado = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.CEVestado#">
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				  and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
				  and CEVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEVcodigo#">
			</cfquery>
			
			<cfset modo = "CAMBIO">
		</cfif>

		<cfquery name="updEvaluaciones" datasource="#Session.DSN#">
			-- Asegurarse que la suma de Manuales sea menor que 100 
			-- si no: convertir todas las evaluaciones a automáticas
			declare @manuales numeric

			select @manuales = isnull(sum(CEVpeso), 0)
			from CursoEvaluacion
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
			and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			and CEVtipoPeso = 'M'
			
			if @manuales is not null and @manuales >= 100 begin
				update CursoEvaluacion
				set CEVtipoPeso = 'A'
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
				and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			end
			
			-- Asegurarse que haya al menos una evaluacion automática
			-- si no: convertir todas las evaluaciones a automáticas
			if not exists ( select 1
							from CursoEvaluacion
							where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
							and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
							and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
							and CEVtipoPeso = 'A'
			) begin
				update CursoEvaluacion
				set CEVtipoPeso = 'A'
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
				and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			end
			
			if exists (
				select 1
				from CursoEvaluacion
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
				and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			) begin
				-- Calcula: PorcentajeAutomatico = (100-TotalManuales) / CantidadAutomaticos
				update CursoEvaluacion
				   set CEVpeso = convert(numeric(5,2), 
									(100.0 -
										(select isnull(sum(CEVpeso),0)
										from CursoEvaluacion
										where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
										and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
										and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
										and CEVtipoPeso = 'M')
									)
									/
									(select count(1)
									from CursoEvaluacion
									where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
									and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
									and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
									and CEVtipoPeso = 'A')
								)
				from CursoEvaluacion
				where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
				and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
				and CEVtipoPeso = 'A'
	
				-- Ajusta: PorcentajeDelUltimoAutomatico + (100 - TotalTodos)
				update CursoEvaluacion
				   set CEVpeso = CEVpeso +
								(100.0 - 
									(select sum(CEVpeso)
									from CursoEvaluacion
									where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
									and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
									and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">)
								 )
				from CursoEvaluacion
				where CEVcodigo = ( select max(CEVcodigo)
									from CursoEvaluacion
									where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
									and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
									and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
									and CEVtipoPeso = 'A')
			end
		</cfquery>
			
	<cfcatch type="any">
		<cfinclude template="/educ/errorpages/BDerror.cfm">
		<cfabort>
		
	</cfcatch>
	</cftry>
</cftransaction>

<cfoutput>
	<HTML>
	<head>
	</head>
	<body>
		<form name="frmEvaluaciones" action="planificacion.cfm" method="post">
			<cfif isdefined("Form.Ccodigo") and Len(Trim(Form.Ccodigo)) NEQ 0>
				<input type="hidden" name="Ccodigo" value="#Form.Ccodigo#">
			</cfif>
			<cfif isdefined("Form.PEcodigo") and Len(Trim(Form.PEcodigo)) NEQ 0>
				<input type="hidden" name="PEcodigo" value="#Form.PEcodigo#">
			</cfif>
			<cfif isdefined("Form.CEcodigo") and Len(Trim(Form.CEcodigo)) NEQ 0>
				<input type="hidden" name="CEcodigo" value="#Form.CEcodigo#">
			</cfif>
			<cfif isdefined("Form.Alta") or isdefined("Form.Nuevo")>
				<input type="hidden" name="btnNuevo" value="Nuevo">
			</cfif>

			<cfif isdefined("Form.Cambio") and isdefined('form.CEVcodigo') and form.CEVcodigo NEQ ''>
				<input name="CEVcodigo" type="hidden" value="#form.CEVcodigo#">
			</cfif>
		</form>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
</cfoutput>