<cfsetting requesttimeout="3600">
<!---SQL de revaluacion--->
<cfset IDtrans = 3>
<cfset session.debug = false>
<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetProRev" returnvariable="ParamProRev" Conexion="#session.dsn#" Ecodigo="#session.Ecodigo#"/>

<cfif ParamProRev NEQ 1>
	<cfset ParamProRev = "">
<cfelse>
	<cfset ParamProRev = "_second">
</cfif>
<cfif session.debug>
	SQL de revaluacion modo debug.<br>
	<cfdump var="#Form#">
	<a href="../MenuAF.cfm">Activos Fijos</a> | <a href="agtProceso_REVALUACION.cfm?#params#">Lista de Grupos de Transacciones</a> | <a href="agtProceso_genera_REVALUACION.cfm?#params#">Generar Revaluacion</a><br>
</cfif>

<cfif isdefined("btnGenerar")>
	<cf_PleaseWait SERVER_NAME="/cfmx/sif/af/operacion/agtProceso_sql_REVALUACION.cfm" >
	<cfif session.debug>
		Generando...<br>
	</cfif>
	<cfinvoke component="sif.Componentes.AF_RevaluacionActivos" method="AF_RevaluacionActivos#ParamProRev#"
			returnvariable="rsResultadosDA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfif isdefined("form.FOcodigo") and len(trim(form.FOcodigo))><cfinvokeargument name="FOcodigo" value="#form.FOcodigo#"></cfif>
		<cfif isdefined("form.FDcodigo") and len(trim(form.FDcodigo))><cfinvokeargument name="FDcodigo" value="#form.FDcodigo#"></cfif>
		<cfif isdefined("form.FCFid") and len(trim(form.FCFid))><cfinvokeargument name="FCFid" value="#form.FCFid#"></cfif>
		<cfif isdefined("form.FACcodigo") and len(trim(form.FACcodigo))><cfinvokeargument name="FACcodigo" value="#form.FACcodigo#"></cfif>
		<cfif isdefined("form.FACid") and len(trim(form.FACid))><cfinvokeargument name="FACid" value="#form.FACid#"></cfif>
		<cfif isdefined("form.FAFCcodigo") and len(trim(form.FAFCcodigo))><cfinvokeargument name="FAFCcodigo" value="#form.FAFCcodigo#"></cfif>
		<cfinvokeargument name="debug" value="#form.debug#">
	</cfinvoke>
<cfelseif isdefined("btnProgramar")>
	<cfinvoke component="sif.Componentes.AF_RevaluacionActivos" method="AF_RevaluacionActivos#ParamProRev#"
			returnvariable="rsResultadosDA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfif isdefined("form.FOcodigo") and len(trim(form.FOcodigo))><cfinvokeargument name="FOcodigo" value="#form.FOcodigo#"></cfif>
		<cfif isdefined("form.FDcodigo") and len(trim(form.FDcodigo))><cfinvokeargument name="FDcodigo" value="#form.FDcodigo#"></cfif>
		<cfif isdefined("form.FCFid") and len(trim(form.FCFid))><cfinvokeargument name="FCFid" value="#form.FCFid#"></cfif>
		<cfif isdefined("form.FACcodigo") and len(trim(form.FACcodigo))><cfinvokeargument name="FACcodigo" value="#form.FACcodigo#"></cfif>
		<cfif isdefined("form.FACid") and len(trim(form.FACid))><cfinvokeargument name="FACid" value="#form.FACid#"></cfif>
		<cfif isdefined("form.FAFCcodigo") and len(trim(form.FAFCcodigo))><cfinvokeargument name="FAFCcodigo" value="#form.FAFCcodigo#"></cfif>
		<cfinvokeargument name="debug" value="#form.debug#">
		<cfinvokeargument name="Programar" value="true">
		<cfinvokeargument name="FechaProgramacion" value="#DateAdd('n',Form.MinutosProgramacion,DateAdd('h',Form.HoraProgramacion+Form.AMPM,LSParseDateTime(Form.FechaProgramacion)))#">
	</cfinvoke>
<cfelseif isdefined("btnAplicar")>
	<cfif isdefined("form.chk")>
		<cfset datos = ListToArray(form.chk)>
		<cfloop from="1" to="#ArrayLen(datos)#" index="idx">
			<cfinvoke component="sif.Componentes.AF_ContabilizarRevaluacion" method="AF_ContabilizarRevaluacion" 
					returnvariable="rsResultadosDA">
				<cfinvokeargument name="AGTPid" value="#datos[idx]#">
				<cfinvokeargument name="debug" value="#session.debug#">
			</cfinvoke>
		</cfloop>
	</cfif>
<cfelseif isdefined("btnProgramarAplicacion")>
	<cfif isdefined("form.chk")>
		<cfset datos = ListToArray(form.chk)>
		<cfloop from="1" to="#ArrayLen(datos)#" index="idx">
			<cfinvoke component="sif.Componentes.AF_ContabilizarRevaluacion" method="AF_ContabilizarRevaluacion" 
					returnvariable="rsResultadosDA">
				<cfinvokeargument name="AGTPid" value="#datos[idx]#">
				<cfinvokeargument name="debug" value="#session.debug#">
				<cfinvokeargument name="Programar" value="true">
				<cfinvokeargument name="FechaProgramacion" value="#DateAdd('n',Form.MinutosProgramacion,DateAdd('h',Form.HoraProgramacion+Form.AMPM,LSParseDateTime(Form.FechaProgramacion)))#">
			</cfinvoke>
		</cfloop>
	</cfif>
</cfif>

<cfif session.debug>
	<a href="../MenuAF.cfm">Activos Fijos</a> | <a href="agtProceso_REVALUACION.cfm?#params#">Lista de Grupos de Transacciones</a> | <a href="agtProceso_genera_REVALUACION.cfm?#params#">Generar Revaluacion</a><br>
	<cfabort>
</cfif>

<cflocation url="agtProceso_REVALUACION.cfm?#params#">