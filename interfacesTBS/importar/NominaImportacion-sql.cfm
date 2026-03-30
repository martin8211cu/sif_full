<!--- 1. Obtiene el encabezado de las Nominas--->
<cfquery name="rsEncabezado" datasource="#session.DSN#">
	select distinct PMI_GL_COD_EJEC,PMI_GL_DESCRIPCION,PMI_GL_FECHA_EMISI,PMI_GL_CANCELACION,Ecodigo
	from #table_name#
</cfquery>


<cfloop query ="rsEncabezado">
	<cfquery datasource="sifinterfaces">
		delete from PS_PMI_GL_DET_NOM
		where PMI_GL_COD_EJEC = '#rsEncabezado.PMI_GL_COD_EJEC#'
	</cfquery>
	
	<cfquery datasource="sifinterfaces">
		delete from PS_PMI_GL_HEADER
		where PMI_GL_COD_EJEC = '#rsEncabezado.PMI_GL_COD_EJEC#'
	</cfquery>	
</cfloop>

<cfset i = 1>
<cfloop query ="rsEncabezado">
	<!---Inserta el encabezado de la Nomina en una tabla temporal--->
	<cfquery datasource="sifinterfaces">
		insert into PS_PMI_GL_HEADER(PMI_GL_COD_EJEC, PMI_GL_DESCRIPCION, PMI_GL_FECHA_EMISI, PMI_GL_CANCELACION, Ecodigo)
		values ('#rsEncabezado.PMI_GL_COD_EJEC#', '#rsEncabezado.PMI_GL_DESCRIPCION#', '#rsEncabezado.PMI_GL_FECHA_EMISI#',
			'#rsEncabezado.PMI_GL_CANCELACION#', #rsEncabezado.Ecodigo#)
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsDetalle">
		select PMI_GL_COD_EJEC, PMI_GL_RUBRO, PMI_GL_SUBRUBRO, PMI_GL_EMPLEADO, PMI_GL_DESCRIPCION_COD, PMI_GL_TIPO,
		PMI_GL_IMPORTE, PMI_GL_CTRO_COSTOS, PMI_GL_CUENTA, PMI_MONEDA, PMI_FORMA_PAGO, PMI_GL_COMPLEMENTO, Ecodigo
		from #table_name#
		where PMI_GL_COD_EJEC = '#rsEncabezado.PMI_GL_COD_EJEC#'
	</cfquery>

	<cfloop query="rsDetalle">
		<!---Inserta los detalles de la Nómina en una tabla temporal--->
		<cfquery datasource="sifinterfaces">
			insert into PS_PMI_GL_DET_NOM(PMI_GL_COD_EJEC, PMI_GL_LINEA, PMI_GL_RUBRO, PMI_GL_SUBRUBRO, PMI_GL_EMPLEADO, PMI_GL_DESCRIPCION,
										  PMI_GL_TIPO, PMI_GL_IMPORTE, PMI_GL_CTRO_COSTOS, PMI_GL_CUENTA, PMI_MONEDA, PMI_FORMA_PAGO, PMI_GL_COMPLEMENTO,
										  Ecodigo)
			values ('#rsDetalle.PMI_GL_COD_EJEC#',
					#i#,
					<cfif isdefined("rsDetalle.PMI_GL_RUBRO") and len(trim(rsDetalle.PMI_GL_RUBRO)) GT 0 and rsDetalle.PMI_GL_RUBRO GT 0  >
						#rsDetalle.PMI_GL_RUBRO#,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("rsDetalle.PMI_GL_SUBRUBRO") and len(trim(rsDetalle.PMI_GL_SUBRUBRO)) and rsDetalle.PMI_GL_SUBRUBRO GT 0>
						#rsDetalle.PMI_GL_SUBRUBRO#,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("rsDetalle.PMI_GL_EMPLEADO") and rsDetalle.PMI_GL_EMPLEADO NEQ '' >
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalle.PMI_GL_EMPLEADO#">,
					<cfelse>
						null,
					</cfif>
					'#rsDetalle.PMI_GL_DESCRIPCION_COD#',
					'#rsDetalle.PMI_GL_TIPO#',
					<cfif isdefined("rsDetalle.PMI_GL_IMPORTE") and rsDetalle.PMI_GL_IMPORTE NEQ ''>
						#rsDetalle.PMI_GL_IMPORTE#,
					<cfelse>
						0,
					</cfif>
					<cfif isdefined("rsDetalle.PMI_GL_CTRO_COSTOS") and rsDetalle.PMI_GL_CTRO_COSTOS NEQ ''>
						'#rsDetalle.PMI_GL_CTRO_COSTOS#',
					<cfelse>
						null,
					</cfif>
					ltrim(rtrim('#rsDetalle.PMI_GL_CUENTA#')),
					'#rsDetalle.PMI_MONEDA#',
					#rsDetalle.PMI_FORMA_PAGO#,
					<cfif isdefined("rsDetalle.PMI_GL_COMPLEMENTO") and rsDetalle.PMI_GL_COMPLEMENTO NEQ ''>
						'#rsDetalle.PMI_GL_COMPLEMENTO#'
					<cfelse>
						null
					</cfif>,
					#rsDetalle.Ecodigo#)
		</cfquery>
		<cfset i = i + 1>
	</cfloop>
</cfloop>
