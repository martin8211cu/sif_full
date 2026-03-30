<!---*******************************************
*******Sistema de Educación*********************
*******Administración de Centros de Estudio*****
*******Periodo de Evaluación********************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->
<!---*******************************************
*******Registro de Cambios Realizados***********
*******Modificación No:*************************
*******Realizada por:***************************
*******Detalle de la Modificación:**************
********************************************--->

<cfset params="">
<cfset paramss="">
<cfif isdefined("form.PEcodigo") and len(trim(form.PEcodigo))>
	<cfset paramss="&PEcodigo="&form.PEcodigo>
</cfif>
<cfset Request.Error.Url = "PeriodoEvaluacion.cfm?Pagina=#Form.Pagina#&Filtro_PEdescripcion=#Form.Filtro_PEdescripcion#&Filtro_PEorden=#Form.Filtro_PEorden#&HFiltro_PEdescripcion=#Form.Filtro_PEdescripcion#&HFiltro_PEorden=#Form.Filtro_PEorden##params##paramss#">
<cfif isdefined("form.Alta")>
	<cfquery name="rsValida" datasource="#Session.Edu.DSN#">
		SELECT 1 
		FROM Nivel a, PeriodoEvaluacion b  
		WHERE Upper(rtrim(ltrim(b.PEdescripcion))) = <cfqueryparam value="#Ucase(rtrim(ltrim(form.PEdescripcion)))#" cfsqltype="cf_sql_varchar">
		  AND a.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
		  AND a.Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
		  AND a.Ncodigo = b.Ncodigo
	</cfquery>
	<cfif rsValida.recordcount>
		<cfthrow message="Error, La Descripción ya existe para el Nivel, Proceso Cancelado"/>
	</cfif>
	<cfquery name="rsPEorden" datasource="#Session.Edu.DSN#">
	 	SELECT isnull(max(c.PEorden),0)+10 as PEorden
	 	FROM Nivel b, PeriodoEvaluacion c
	 	WHERE c.Ncodigo 	= <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
	   	  AND b.CEcodigo 	= <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
	   	  AND b.Ncodigo 	= c.Ncodigo
	</cfquery>
	<cftransaction>
	<cfquery name="rsInsert" datasource="#Session.Edu.DSN#">
		insert PeriodoEvaluacion ( Ncodigo, PEdescripcion, PEorden )
		values( <cfqueryparam value="#form.Ncodigo#"       cfsqltype="cf_sql_numeric">, 
				<cfqueryparam value="#form.PEdescripcion#" cfsqltype="cf_sql_varchar">,
				<cfif len(trim(Form.PEorden)) NEQ 0>
					<cfqueryparam value="#Form.PEorden#" cfsqltype="cf_sql_integer">
				<cfelse>
					<cfqueryparam value="#rsPEorden.PEorden#" cfsqltype="cf_sql_integer">
				</cfif>
			  )
		<cf_dbidentity1 datasource="#Session.Edu.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#Session.Edu.DSN#" name="rsInsert">
	</cftransaction>
	<cfset params=params&"&PEcodigo="&rsInsert.Identity>
<cfelseif isdefined("form.Baja")>
	<cfquery name="rsDelete" datasource="#Session.Edu.DSN#">
		delete from PeriodoVigente
		where PEevaluacion = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
		delete PeriodoEvaluacion
		where PEcodigo = <cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
<cfelseif isdefined("form.Cambio")>
	<cfquery name="rsValida" datasource="#Session.Edu.DSN#">
		SELECT 1 
		FROM Nivel a, PeriodoEvaluacion b  
		WHERE Upper(rtrim(ltrim(b.PEdescripcion))) = <cfqueryparam value="#Ucase(rtrim(ltrim(form.PEdescripcion)))#" cfsqltype="cf_sql_varchar">
		  AND a.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
		  AND a.Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
		  AND a.Ncodigo = b.Ncodigo
		  AND b.PEcodigo <> <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif rsValida.recordcount>
		<cfthrow message="Error, La Descripción ya existe para el Nivel, Proceso Cancelado"/>
	</cfif>
	<cfquery name="rsPEorden" datasource="#Session.Edu.DSN#">
	 	SELECT isnull(max(c.PEorden),0)+10 as PEorden
	 	FROM Nivel b, PeriodoEvaluacion c
	 	WHERE c.Ncodigo 	= <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
	   	  AND b.CEcodigo 	= <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
	   	  AND b.Ncodigo 	= c.Ncodigo
	</cfquery>
	<cfquery name="rsInsert" datasource="#Session.Edu.DSN#">
		SELECT 1 
		FROM EvaluacionConceptoMateria a, PeriodoEvaluacion b  
		WHERE a.PEcodigo = <cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
		  AND a.PEcodigo = b.PEcodigo
	</cfquery>
	<cfif rsInsert.recordcount eq 0>
		<cfquery name="rsUpdate" datasource="#Session.Edu.DSN#">
			UPDATE PeriodoEvaluacion 
			SET Ncodigo       	= <cfqueryparam value="#form.Ncodigo#"       cfsqltype="cf_sql_numeric">,
				PEdescripcion 	= <cfqueryparam value="#form.PEdescripcion#" cfsqltype="cf_sql_varchar">,
			<cfif len(trim(Form.PEorden)) NEQ 0>
				PEorden 	= <cfqueryparam value="#Form.PEorden#" cfsqltype="cf_sql_integer">
			<cfelse>
				PEorden 	= <cfqueryparam value="#rsPEorden.PEorden#" cfsqltype="cf_sql_integer">
			</cfif>
			WHERE PEcodigo    = <cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
	<cfelse>
		<cfquery name="rsUpdate" datasource="#Session.Edu.DSN#">
			UPDATE PeriodoEvaluacion 
			SET PEdescripcion = <cfqueryparam value="#form.PEdescripcion#" cfsqltype="cf_sql_varchar">,
			<cfif len(trim(Form.PEorden)) NEQ 0>
				PEorden 	= <cfqueryparam value="#Form.PEorden#" cfsqltype="cf_sql_integer">
			<cfelse>
				PEorden 	= <cfqueryparam value="#rsPEorden.PEorden#" cfsqltype="cf_sql_integer">
			</cfif>
			WHERE PEcodigo    = <cfqueryparam value="#form.PEcodigo#"      cfsqltype="cf_sql_numeric">
	 	</cfquery>
	</cfif>
	<cfset params=params&"&PEcodigo="&Form.PEcodigo>
</cfif>
<cflocation url="PeriodoEvaluacion.cfm?Pagina=#Form.Pagina#&Filtro_PEdescripcion=#Form.Filtro_PEdescripcion#&Filtro_PEorden=#Form.Filtro_PEorden#&HFiltro_PEdescripcion=#Form.Filtro_PEdescripcion#&HFiltro_PEorden=#Form.Filtro_PEorden##params#">