<!---<cfsetting enablecfoutputonly="yes">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,0,0,10)#>
<cfinclude template="/home/check/dominio.cfm">--->



<!---<cfset registros = 0 >--->
<cfset vDebug = false >

<cfset start = Now()>
<cfoutput>
Proceso de Env&iacute;o de Correos de Alertas de Acciones<br>
Iniciando proceso #TimeFormat(start,"HH:MM:SS")#<br></cfoutput>

<cfquery name="bds" datasource="asp">
	select distinct c.Ccache
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'RH'
	and Ereferencia is not null
</cfquery>

<!--- calculo de la semana --->
<cfset fecha = now() >
<cfset fecha_inicio = dateadd('d', 1-DayOfWeek(fecha),fecha) >


<cfloop query="bds">
	<cfif vDebug >***********************************************************<br><b>CACHE:</b> <cfdump var="#bds.Ccache#"><br><br></cfif>

	<cfset cache = trim(bds.Ccache) > 

	<cfset continuar = true >
	<!--- validacion de existencia de las tablas --->
	<cftry>
		<cfquery name="rsEmpresas" datasource="#cache#">
			select 1 from RHAlertaAcciones 
		</cfquery>
	<cfcatch type="any">
		<cfset continuar = false >
	</cfcatch>
	</cftry>
	
	<cfif continuar >
		<cfquery name="empresas" datasource="#cache#">
			select Ecodigo, Edescripcion, EcodigoSDC
			from Empresas
			where  EcodigoSDC is not null
			   and  Ecodigo is not null
			   and  Edescripcion is not null
		</cfquery>
		
		
		<cfloop query="empresas">
			<cfset LvarEmpresa = empresas.Ecodigo >
			<cfset LvarEmpresasdc = empresas.EcodigoSDC >
			<cfset LvarEmpresa_nombre = empresas.Edescripcion >
			<cfset fechahoy = LSDateFormat(Now(), 'dd/mm/yyyy')>
			
				 
			<cfinvoke component="rh.Componentes.RH_RecordatorioAlertas" method="AltaAlerta"
				returnvariable="contador">
				<cfinvokeargument name="RHTid" value="-1">
				<cfinvokeargument name="Fecha" value="#fechahoy#">
				<cfinvokeargument name="Lcache" value="#cache#">
				<cfinvokeargument name="empresa" value="#LvarEmpresa#">
				<cfinvokeargument name="empresasdc" value="#LvarEmpresasdc#">
				<cfinvokeargument name="empresa_nombre" value="#LvarEmpresa_nombre#">
			</cfinvoke>
			<cfif vDebug ><b>Empresa:</b><cfdump var="#empresa#"><br><br></cfif>
		</cfloop> <!--- control de empresas --->
	</cfif>	
	<!---<cfif vDebug ><br>***********************************************************<br></cfif>--->
</cfloop>

<cfoutput>
<cfset finish = Now()>
<!---Correos enviados: #contador#<br>
--->Proceso terminado #TimeFormat(finish,"HH:MM:SS")#<br>
</cfoutput>
