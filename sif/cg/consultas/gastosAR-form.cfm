<cfif NOT isDefined("form.Resumido")>
	<cfset form.Resumido = false>
<cfelseif isdefined("form.Resumido") AND form.Resumido EQ "ON">
	<cfset form.Resumido = true>
</cfif>

<cfif NOT isDefined("form.CorteMayor")>
	<cfset form.CorteMayor = false>
<cfelseif isDefined("form.CorteMayor") AND form.CorteMayor EQ "ON">
	<cfset form.CorteMayor = true>
</cfif>

<!---sif.Componentes.--->
	<cfinvoke returnvariable="datos1" component="sif.Componentes.CG_GastosResultadosAR" method="estadoResultados" 
		Ecodigo="#Session.Ecodigo#"
		periodo="#Form.periodo#"
		mes="#Form.mes#"
		nivel = "#form.Nivel#"
		CGARepid="#form.CGARepid#"
		CGARid="#form.CGARid#"
		moneda="#form.moneda#"
        resumido="#form.Resumido#"
        CorteMayor="#form.CorteMayor#" 
        >
	</cfinvoke>
	<cfquery name="datos" dbtype="query">
		select *
		from datos1
		where descrip is not null
	</cfquery>

	<cfif isdefined("form.CGARid") and len(trim(CGARid)) and form.CGARid GT 0>
		<cfquery name="area" datasource="#session.DSN#">
			select CGARdescripcion as descripcion
			from CGAreaResponsabilidad
			where CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGARid#">
		</cfquery>
	</cfif>

<cfset LvarIrA     = 'EstadoResutadosAR-filtro.cfm'>
<cfset LvarFileName = "GastosAreaResponsabilidad#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
				title="Detalle de Gastos por Area de Responsabilidad" 
				filename="#LvarFileName#"
				irA="#LvarIrA#"	>
				<cfif not isdefined("form.btnDownload")>
					<cf_templatecss>
				</cfif>	
<cfinclude template="gastosAR-formInc.cfm">