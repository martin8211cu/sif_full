<cffunction name="fnPeriodoContable" output="false" access="private" returntype="struct">
	<cfargument name="Ano" type="numeric" default="-1">
	<cfargument name="Mes" type="numeric" default="-1">
	
	<cfset var LvarFechas = structNew()>
	<cfset var LvarAnoMes = 0>
	<cfset var LvarAnoMesIni = 0>
	<cfset var LvarAnoMesFin = 0>
	<cfset var LvarAnoIni = 0>
	<cfset var LvarMesIni = 0>
	<cfset var LvarAnoFin = 0>
	<cfset var LvarMesFin = 0>

	<cfquery name="rsParametros" datasource="#session.DSN#">
		select 	ano.Pvalor as Ano,
				mes.Pvalor as Mes,
				ult.Pvalor as UltMes
		  from Parametros ano, Parametros mes, Parametros ult
		 where 	ano.Ecodigo = #session.Ecodigo# and ano.Pcodigo=30
		   and 	mes.Ecodigo = #session.Ecodigo# and mes.Pcodigo=40
		   and 	ult.Ecodigo = #session.Ecodigo# and ult.Pcodigo=45
	</cfquery>

	<cfif rsParametros.Ano EQ 0 or rsParametros.Mes EQ 0 or not isnumeric(rsParametros.Ano) or not isnumeric(rsParametros.Mes)>
		<cf_errorCode	code = "50427" msg = "Empresa no ha sido iniciada">
	</cfif>
	
	<cfif rsParametros.UltMes EQ 12>
		<cfset LvarAnoIni = rsParametros.Ano>
		<cfset LvarMesIni = 1>
		<cfset LvarAnoFin = rsParametros.Ano>
		<cfset LvarMesFin = 12>
	<cfelseif rsParametros.Mes GT rsParametros.UltMes>
		<cfset LvarAnoIni = rsParametros.Ano>
		<cfset LvarMesIni = rsParametros.UltMes+1>
		<cfset LvarAnoFin = rsParametros.Ano+1>
		<cfset LvarMesFin = rsParametros.UltMes>
	<cfelse>
		<cfset LvarAnoIni = rsParametros.Ano-1>
		<cfset LvarMesIni = rsParametros.UltMes+1>
		<cfset LvarAnoFin = rsParametros.Ano>
		<cfset LvarMesFin = rsParametros.UltMes>
	</cfif>
	
	<cfset LvarFechas.Actual 	= fnAnoMes(rsParametros.Ano,rsParametros.Mes)>
	<cfset LvarFechas.ActualIni = fnAnoMes(LvarAnoIni,LvarMesIni)>
	<cfset LvarFechas.ActualFin = fnAnoMes(LvarAnoFin,LvarMesFin)>
	<cfset LvarAnoMes = DateFormat(now(),"YYYYMM")>
	<cfif LvarFechas.Actual.AnoMes LT LvarAnoMes>
		<cfset LvarFechas.Actual.Dia = daysinmonth(createdate(LvarFechas.Actual.Ano,LvarFechas.Actual.Mes,1))>
	<cfelseif LvarFechas.Actual.AnoMes EQ LvarAnoMes>
		<cfset LvarFechas.Actual.Dia = DateFormat(now(),"DD")>
	<cfelseif LvarFechas.Actual.AnoMes GT LvarAnoMes>
		<cfset LvarFechas.Actual.Dia = 1>
	</cfif>
	<cfset LvarFechas.Actual.Fecha = createdate(LvarFechas.Actual.Ano,LvarFechas.Actual.Mes,LvarFechas.Actual.Dia)>
	
	<cfif Arguments.Ano NEQ -1 and Arguments.Mes NEQ -1>
		<cfset LvarFechas.Fecha 	= fnAnoMes(Arguments.Ano, Arguments.Mes)>
		
		<cfif LvarFechas.Fecha.AnoMes GT LvarFechas.Actual.AnoMes>
			<cf_errorCode	code = "50428" msg = "No se puede consultar un mes futuro">
		</cfif>
		
		<cfset LvarAnoMes = LvarFechas.Fecha.AnoMes>
		<cfset LvarAnoMesIni = LvarFechas.ActualIni.AnoMes>
		<cfset LvarAnoMesFin = LvarFechas.ActualFin.AnoMes>
		<cfloop condition="NOT (LvarAnoMes GTE LvarAnoMesIni AND LvarAnoMes LTE LvarAnoMesFin)">
			<cfset LvarAnoMesIni = LvarAnoMesIni - 100>
			<cfset LvarAnoMesFin = LvarAnoMesFin - 100>
		</cfloop>
		<cfset LvarFechas.FechaIni 	= fnAnoMes(int(LvarAnoMesIni/100),LvarAnoMesIni mod 100)>
		<cfset LvarFechas.FechaFin 	= fnAnoMes(int(LvarAnoMesFin/100),LvarAnoMesFin mod 100)>
	</cfif>
	<cfreturn LvarFechas>
</cffunction>

<cffunction name="fnAnoMes" output="false" access="private" returntype="struct">
	<cfargument name="Ano" type="numeric" required="yes">
	<cfargument name="Mes" type="numeric" required="yes">
	
	<cfset var LvarAnoMes = structNew()>
	<cfset LvarAnoMes.Ano 	 = Arguments.Ano>
	<cfset LvarAnoMes.Mes 	 = Arguments.Mes>
	<cfset LvarAnoMes.AnoMes = Arguments.Ano*100 + Arguments.Mes>
	<cfreturn LvarAnoMes>
</cffunction>

<cffunction name="fnNombreMes" output="false" access="private" returntype="string">
	<cfargument name="Mes" type="numeric" required="yes">
	<cfswitch expression="#Arguments.Mes#">
		<cfcase value="1"><cfreturn "Enero"></cfcase>
		<cfcase value="2"><cfreturn "Febrero"></cfcase>
		<cfcase value="3"><cfreturn "Marzo"></cfcase>
		<cfcase value="4"><cfreturn "Abril"></cfcase>
		<cfcase value="5"><cfreturn "Mayo"></cfcase>
		<cfcase value="6"><cfreturn "Junio"></cfcase>
		<cfcase value="7"><cfreturn "Julio"></cfcase>
		<cfcase value="8"><cfreturn "Agosto"></cfcase>
		<cfcase value="9"><cfreturn "Setiembre"></cfcase>
		<cfcase value="10"><cfreturn "Octubre"></cfcase>
		<cfcase value="11"><cfreturn "Noviembre"></cfcase>
		<cfcase value="12"><cfreturn "Diciembre"></cfcase>
	</cfswitch>
</cffunction>

<cffunction name="fnNombrePeriodo" output="false" access="private" returntype="string">
	<cfargument name="Inicio" type="struct" required="yes">
	<cfargument name="Final" type="struct" required="yes">
	
	<cfset var LvarAnoMes = structNew()>
	<cfif Arguments.Inicio.Ano EQ Arguments.Final.Ano>
		<cfreturn "de #fnNombreMes(Arguments.Inicio.Mes)# a #fnNombreMes(Arguments.Final.Mes)# de #Arguments.Inicio.Ano#">
	<cfelse>
		<cfreturn "de #fnNombreMes(Arguments.Inicio.Mes)# de #Arguments.Inicio.Ano# a #fnNombreMes(Arguments.Final.Mes)# de #Arguments.Final.Ano#">
	</cfif>
</cffunction>



