<!---------
	
	Modificado por: Alejandro Bolaños APH
	Fecha de modificación: 30 de septiembre 2011
	Motivo:	Se agregan el criterio de mes para el calculo de la depreciacion
	Fecha de modificación: 2 de diciembre 2011
	Motivo:	Se agregan el criterio de Activo desde y Hasta para el calculo de la depreciacion
----------->

<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = ''>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = ''>
</cfif>

<cfsetting requesttimeout="36000">
<!---SQL de depreciacion--->
<cfset IDtrans = 11>
<cfset session.debug = false>

<cfif session.debug>
	SQL de depreciacion modo debug.<br>
    <cfdump var="#Form#">
	<a href="../MenuAF.cfm">Activos Fijos</a> | <a href="agtProceso_DEPRECIACION_FISCAL.cfm?#params#">Lista de Grupos de Transacciones</a> | <a href="agtProceso_genera_DEPRECIACION_Fiscal.cfm?#params#">Generar Depreciacion</a><br>
</cfif>

<cfif isdefined("btnGenerar") and (#form.FDepreciacion# EQ "DFNormal")>
	<cf_PleaseWait SERVER_NAME="/cfmx/sif/af/operacion/agtProceso_sql_DEPRECIACION_Fiscal#LvarPar#.cfm" >
	<cfif session.debug>
		Generando...<br>
	</cfif>
	<cfinvoke component="sif.Componentes.AF_DepreciacionFiscalActivos" method="AF_DepreciacionFiscalActivos"
			returnvariable="rsResultadosDA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfif isdefined("form.FOcodigo") and len(trim(form.FOcodigo))><cfinvokeargument name="FOcodigo" value="#form.FOcodigo#"></cfif>
		<cfif isdefined("form.FDcodigo") and len(trim(form.FDcodigo))><cfinvokeargument name="FDcodigo" value="#form.FDcodigo#"></cfif>
		<cfif isdefined("form.FCFid") and len(trim(form.FCFid))><cfinvokeargument name="FCFid" value="#form.FCFid#"></cfif>
		<cfif isdefined("form.FACcodigo") and len(trim(form.FACcodigo))><cfinvokeargument name="FACcodigo" value="#form.FACcodigo#"></cfif>
		<cfif isdefined("form.FACid") and len(trim(form.FACid))><cfinvokeargument name="FACid" value="#form.FACid#"></cfif>
		<cfif isdefined("form.FAFCcodigo") and len(trim(form.FAFCcodigo))><cfinvokeargument name="FAFCcodigo" value="#form.FAFCcodigo#"></cfif>
        <cfif isdefined("form.FDepreciacion") and len(trim(form.FDepreciacion))><cfinvokeargument name="FDepreciacion" value="#form.FDepreciacion#"></cfif>
        <cfif isdefined("form.Mes") and len(trim(form.Mes))><cfinvokeargument name="Mes" value="#form.Mes#"></cfif>
		<!---FILTRO ACTIVO--->
        <cfif isdefined("form.AplacaDesde") and len(trim(form.AplacaDesde))><cfinvokeargument name="AplacaDesde" value="#form.AplacaDesde#"></cfif>
        <cfif isdefined("form.AplacaHasta") and len(trim(form.AplacaHasta))><cfinvokeargument name="AplacaHasta" value="#form.AplacaHasta#"></cfif>
        <cfinvokeargument name="debug" value="#session.debug#">
	</cfinvoke>
    
<cfelseif isdefined("btnProgramar") and (#form.FDepreciacion# EQ "DFNormal")>
	<cfinvoke component="sif.Componentes.AF_DepreciacionFiscalActivos" method="AF_DepreciacionFiscalActivos"
			returnvariable="rsResultadosDA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfif isdefined("form.FOcodigo") and len(trim(form.FOcodigo))><cfinvokeargument name="FOcodigo" value="#form.FOcodigo#"></cfif>
		<cfif isdefined("form.FDcodigo") and len(trim(form.FDcodigo))><cfinvokeargument name="FDcodigo" value="#form.FDcodigo#"></cfif>
		<cfif isdefined("form.FCFid") and len(trim(form.FCFid))><cfinvokeargument name="FCFid" value="#form.FCFid#"></cfif>
		<cfif isdefined("form.FACcodigo") and len(trim(form.FACcodigo))><cfinvokeargument name="FACcodigo" value="#form.FACcodigo#"></cfif>
		<cfif isdefined("form.FACid") and len(trim(form.FACid))><cfinvokeargument name="FACid" value="#form.FACid#"></cfif>
		<cfif isdefined("form.FAFCcodigo") and len(trim(form.FAFCcodigo))><cfinvokeargument name="FAFCcodigo" value="#form.FAFCcodigo#"></cfif>
		<cfif isdefined("form.FDepreciacion") and len(trim(form.FDepreciacion))><cfinvokeargument name="FDepreciacion" value="#form.FDepreciacion#"></cfif>
        <cfif isdefined("form.Mes") and len(trim(form.Mes))><cfinvokeargument name="Mes" value="#form.Mes#"></cfif>
		<!---FILTRO ACTIVO--->
        <cfif isdefined("form.AplacaDesde") and len(trim(form.AplacaDesde))><cfinvokeargument name="AplacaDesde" value="#form.AplacaDesde#"></cfif>
        <cfif isdefined("form.AplacaHasta") and len(trim(form.AplacaHasta))><cfinvokeargument name="AplacaHasta" value="#form.AplacaHasta#"></cfif>        
        <cfinvokeargument name="debug" value="#session.debug#">
		<cfinvokeargument name="Programar" value="true">
		<cfif Form.HoraProgramacion eq 12>
			<cfif Form.AMPM eq 12>
				<cfinvokeargument name="FechaProgramacion" value="#DateAdd('n',Form.MinutosProgramacion,DateAdd('h',Form.HoraProgramacion,LSParseDateTime(Form.FechaProgramacion)))#">
			<cfelse>
				<cfinvokeargument name="FechaProgramacion" value="#DateAdd('n',Form.MinutosProgramacion,DateAdd('h',Form.HoraProgramacion-12,LSParseDateTime(Form.FechaProgramacion)))#">
			</cfif>
		<cfelse>
			<cfinvokeargument name="FechaProgramacion" value="#DateAdd('n',Form.MinutosProgramacion,DateAdd('h',Form.HoraProgramacion+Form.AMPM,LSParseDateTime(Form.FechaProgramacion)))#">
		</cfif>
	</cfinvoke>
    
<cfelseif isdefined("btnGenerar") and (#form.FDepreciacion# EQ "DFAcelerada")>
	<cf_PleaseWait SERVER_NAME="/cfmx/sif/af/operacion/agtProceso_sql_DEPRECIACION_Fiscal#LvarPar#.cfm" >
	<cfif session.debug>
		Generando...<br>
	</cfif>
	<cfinvoke component="sif.Componentes.AF_DepreciacionFiscalActivosAcel" method="AF_DepreciacionFiscalActivosAcel"
			returnvariable="rsResultadosDA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfif isdefined("form.FOcodigo") and len(trim(form.FOcodigo))><cfinvokeargument name="FOcodigo" value="#form.FOcodigo#"></cfif>
		<cfif isdefined("form.FDcodigo") and len(trim(form.FDcodigo))><cfinvokeargument name="FDcodigo" value="#form.FDcodigo#"></cfif>
		<cfif isdefined("form.FCFid") and len(trim(form.FCFid))><cfinvokeargument name="FCFid" value="#form.FCFid#"></cfif>
		<cfif isdefined("form.FACcodigo") and len(trim(form.FACcodigo))><cfinvokeargument name="FACcodigo" value="#form.FACcodigo#"></cfif>
		<cfif isdefined("form.FACid") and len(trim(form.FACid))><cfinvokeargument name="FACid" value="#form.FACid#"></cfif>
		<cfif isdefined("form.FAFCcodigo") and len(trim(form.FAFCcodigo))><cfinvokeargument name="FAFCcodigo" value="#form.FAFCcodigo#"></cfif>
        <cfif isdefined("form.FDepreciacion") and len(trim(form.FDepreciacion))><cfinvokeargument name="FDepreciacion" value="#form.FDepreciacion#"></cfif>
        <cfif isdefined("form.Mes") and len(trim(form.Mes))><cfinvokeargument name="Mes" value="#form.Mes#"></cfif>
		<!---FILTRO ACTIVO--->
        <cfif isdefined("form.AplacaDesde") and len(trim(form.AplacaDesde))><cfinvokeargument name="AplacaDesde" value="#form.AplacaDesde#"></cfif>
        <cfif isdefined("form.AplacaHasta") and len(trim(form.AplacaHasta))><cfinvokeargument name="AplacaHasta" value="#form.AplacaHasta#"></cfif>        
		<cfinvokeargument name="debug" value="#session.debug#">
	</cfinvoke>
    
<cfelseif isdefined("btnProgramar") and (#form.FDepreciacion# EQ "DFAcelerada")>
	<cfinvoke component="sif.Componentes.AF_DepreciacionFiscalActivosAcel" method="AF_DepreciacionFiscalActivosAcel"
			returnvariable="rsResultadosDA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfif isdefined("form.FOcodigo") and len(trim(form.FOcodigo))><cfinvokeargument name="FOcodigo" value="#form.FOcodigo#"></cfif>
		<cfif isdefined("form.FDcodigo") and len(trim(form.FDcodigo))><cfinvokeargument name="FDcodigo" value="#form.FDcodigo#"></cfif>
		<cfif isdefined("form.FCFid") and len(trim(form.FCFid))><cfinvokeargument name="FCFid" value="#form.FCFid#"></cfif>
		<cfif isdefined("form.FACcodigo") and len(trim(form.FACcodigo))><cfinvokeargument name="FACcodigo" value="#form.FACcodigo#"></cfif>
		<cfif isdefined("form.FACid") and len(trim(form.FACid))><cfinvokeargument name="FACid" value="#form.FACid#"></cfif>
		<cfif isdefined("form.FAFCcodigo") and len(trim(form.FAFCcodigo))><cfinvokeargument name="FAFCcodigo" value="#form.FAFCcodigo#"></cfif>
		<cfif isdefined("form.FDepreciacion") and len(trim(form.FDepreciacion))><cfinvokeargument name="FDepreciacion" value="#form.FDepreciacion#"></cfif>
        <cfif isdefined("form.Mes") and len(trim(form.Mes))><cfinvokeargument name="Mes" value="#form.Mes#"></cfif>
		<!---FILTRO ACTIVO--->
        <cfif isdefined("form.AplacaDesde") and len(trim(form.AplacaDesde))><cfinvokeargument name="AplacaDesde" value="#form.AplacaDesde#"></cfif>
        <cfif isdefined("form.AplacaHasta") and len(trim(form.AplacaHasta))><cfinvokeargument name="AplacaHasta" value="#form.AplacaHasta#"></cfif>        
        <cfinvokeargument name="debug" value="#session.debug#">
		<cfinvokeargument name="Programar" value="true">
		<cfif Form.HoraProgramacion eq 12>
			<cfif Form.AMPM eq 12>
				<cfinvokeargument name="FechaProgramacion" value="#DateAdd('n',Form.MinutosProgramacion,DateAdd('h',Form.HoraProgramacion,LSParseDateTime(Form.FechaProgramacion)))#">
			<cfelse>
				<cfinvokeargument name="FechaProgramacion" value="#DateAdd('n',Form.MinutosProgramacion,DateAdd('h',Form.HoraProgramacion-12,LSParseDateTime(Form.FechaProgramacion)))#">
			</cfif>
		<cfelse>
			<cfinvokeargument name="FechaProgramacion" value="#DateAdd('n',Form.MinutosProgramacion,DateAdd('h',Form.HoraProgramacion+Form.AMPM,LSParseDateTime(Form.FechaProgramacion)))#">
		</cfif>
	</cfinvoke>
    
<cfelseif isdefined("btnAplicar")>
	<cfif isdefined("form.chk")>
		<cfset datos = ListToArray(form.chk)>
		<cfloop from="1" to="#ArrayLen(datos)#" index="idx">
			<cfinvoke component="sif.Componentes.AF_ContabilizarDepreciacionFiscal" method="AF_ContabilizarDepreciacion" 
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
			<cfinvoke component="sif.Componentes.AF_ContabilizarDepreciacionFiscal" method="AF_ContabilizarDepreciacion" 
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
	<a href="../MenuAF.cfm">Activos Fijos</a> | <a href="agtProceso_DEPRECIACION_FISCAL.cfm?#params#">Lista de Grupos de Transacciones</a> | <a href="agtProceso_genera_DEPRECIACION_Fiscal.cfm?#params#">Generar Depreciacion</a><br>
	<cfabort>
</cfif>

<cflocation url="agtProceso_DEPRECIACION_FISCAL#LvarPar#.cfm?#params#">
