<cfset currentPage = GetFileFromPath(GetTemplatePath())>
<cfset tamVentanaConcursantes = 175>

<cfparam name="Form.tab" default="1">

<cfif isdefined("Form.RHCconcurso") and Len(Trim(Form.RHCconcurso))>
	<cfset modoAdmConcursos = "CAMBIO">
<cfelse>
	<cfset modoAdmConcursos = "ALTA">
</cfif>

<cfset modoEval = 0>
<!--- 
	0: Nuevo Concursante
	1: Datos del Concursante
	2: Descalificar Concursante
	3: Calificar Concursante
	4: Eliminar Concursante
--->

<cfif modoAdmConcursos EQ "CAMBIO">

	<!--- Query del Concurso --->

    <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
	<!---
	<cf_translatedata name="get" tabla="RHConcursos" col="RHCsedetrabajo" returnvariable="LvarRHCsedetrabajo">
	<cf_translatedata name="get" tabla="RHConcursos" col="RHCtipocontrato" returnvariable="LvarRHCtipocontrato">
	--->

    <cf_dbfunction name="spart" args="#LvarRHCdescripcion#°1°50" delimiters="°" returnvariable="LvaRHCdescripcion">
    <cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">

    	
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#">
		Select a.RHCconcurso, a.RHCcodigo, #LvaRHCdescripcion# as RHCdescripcion, 
			a.CFid, c.CFcodigo as CFcodigoresp, #LvarCFdescripcion# as CFdescripcionresp, 
			a.RHPcodigo, coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,#LvarRHPdescpuesto# as RHPdescpuesto, a.RHCcantplazas, a.RHCfecha,
			a.RHCfapertura, a.RHCfcierre, a.RHCmotivo, a.RHCotrosdatos, a.RHCestado, a.Usucodigo, 
			a.ts_rversion,a.horafin, coalesce(a.RHCexterno,0) as RHCexterno
			<cfif isdefined("request.useTranslateData") and request.useTranslateData>
				,a.RHCotrosdatos_#session.idioma#
			</cfif>
			<!--- ,#LvarRHCsedetrabajo# as RHCsedetrabajo
			,#LvarRHCtipocontrato# as RHCtipocontrato --->
        from RHConcursos a

			left outer join RHPuestos b
				on b.RHPcodigo = a.RHPcodigo
				and b.Ecodigo  = a.Ecodigo

			left outer join CFuncional c
				on c.CFid	   = a.CFid
				and c.Ecodigo  = a.Ecodigo
				
		where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
		and a.RHCestado in (10, 15, 40, 50, 60)
	</cfquery>
	<!--- Si el query no devuelve el concurso, quiere decir que se le cambió el estado, por lo tanto ya no aparece más en esta pantalla --->
	<cfif rsRHConcursos.recordCount EQ 0>
		<cfset modoAdmConcursos = "ALTA">
		<cfset StructDelete(Form, "RHCconcurso")>
		<cfset Form.tab = 1>
	</cfif>
</cfif>

<cfif modoAdmConcursos EQ "CAMBIO" and isdefined("Form.RHCPid") and Len(Trim(Form.RHCPid))>
	<!--- Query del Concursante --->
	<cfquery name="rsConcursante" datasource="#Session.DSN#">
		select a.RHCPid, b.DEidentificacion as identificacion, 
			<cf_dbfunction name="concat" args="b.DEapellido1,' ',b.DEapellido2,'  ',b.DEnombre"> as Nombre,
			a.DEid, a.RHOid, a.RHCdescalifica, a.RHCrazondeacalifica, a.RHCPtipo, a.RHCPpromedio, a.RHCevaluado
		from RHConcursantes a, DatosEmpleado b
		where a.RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
		and b.DEid = a.DEid
		and b.Ecodigo = a.Ecodigo
		union
		select a.RHCPid, b.RHOidentificacion as identificacion, 
			<cf_dbfunction name="concat" args="b.RHOapellido1,' ',b.RHOapellido2,'  ',b.RHOnombre"> as Nombre,
			   a.DEid, a.RHOid, a.RHCdescalifica, a.RHCrazondeacalifica, a.RHCPtipo, a.RHCPpromedio, a.RHCevaluado
		from RHConcursantes a, DatosOferentes b
		where a.RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
		and b.RHOid = a.RHOid
		and b.Ecodigo = a.Ecodigo
	</cfquery>
	
	<!--- Modo dentro del Tab de Concursantes --->
	<cfif isdefined("Form.op") and Len(Trim(Form.op))>
		<cfset modoEval = Form.op>
	</cfif>
</cfif>

<script type="text/javascript">
	<!--
	function tab_set_current (n){
		document.formConcursos.tab.value = escape(n);
		<cfif modoAdmConcursos EQ "CAMBIO">
		document.formConcursos.RHCconcurso.value = "<cfoutput>#JSStringFormat(form.RHCconcurso)#</cfoutput>";
		</cfif>
		document.formConcursos.submit();
	}
	//-->
</script>

<cfif Form.tab EQ 1 OR modoEval EQ 3>
	<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
</cfif>
