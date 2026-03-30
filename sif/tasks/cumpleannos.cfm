<cfsetting enablecfoutputonly="yes">
<cfapplication name="SIF_ASP" 
	sessionmanagement="No"
	clientmanagement="No"
	setclientcookies="No"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cfset registros = 0 >
<cfset vDebug = false >

<cfquery name="bds" datasource="asp">
	select distinct c.Ccache
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'RH'
	and Ereferencia is not null
</cfquery>

<cfset start = Now()>
<cfoutput>
	Proceso de Env&iacute;o de Mesajes de Cumplea&ntilde;os<br>
	Iniciando proceso #TimeFormat(start,"HH:MM:SS")#<br>
</cfoutput>
<cfset contador = 0 >

<cfloop query="bds">
	<cfif vDebug >***********************************************************<br><b>CACHE:</b> <cfdump var="#bds.Ccache#"><br><br></cfif>

	<cfset cache = trim(bds.Ccache) > 

	<cfset continuar = true >
	<!--- validacion de existencia de las tablas --->
	<cftry>
		<!---
			verifica que la tabla Empresas exista
		--->
		<cfquery name="rsEmpresas" datasource="#cache#">
			select 1 from Empresas
			where 1=2
		</cfquery>
		
		<!---
			verifica que la tabla DatosEmpleado exista, y
			tenga las columnas DEtelefono2 y DEfechanac
		--->
	
		<cfquery name="rsEmpresas" datasource="#cache#">
			select DEtelefono2, DEfechanac from DatosEmpleado
			where 1=2
		</cfquery>
	
	<cfcatch type="any">
		<cfset continuar = false >
	</cfcatch>
	</cftry>

	<cfif continuar >
		<cfquery name="empresas" datasource="#cache#">
			select Ecodigo, Edescripcion
			from Empresas
		</cfquery>

			<cfloop query="empresas">
				<cfset empresa = empresas.Ecodigo >
				<cfset empresa_nombre = empresas.Edescripcion >

				<cfquery name="dataSMS"	 datasource="#cache#">
					select Pvalor 
					from Parametros 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
					  and Pcodigo = 610
				</cfquery>
				<cfif dataSMS.recordCount gt 0 and trim(dataSMS.Pvalor) eq 1 >
					<cfquery name="data" datasource="#cache#">
						select DEtelefono2 as celular, DEfechanac 
						from DatosEmpleado
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
						  and <cf_dbfunction name="date_part" args="MM,DEfechanac" datasource="#cache#" > = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Month(Now())#">
						  and <cf_dbfunction name="date_part" args="DD,DEfechanac" datasource="#cache#" > = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Day(Now())#">
						  <!---and datepart(mm, DEfechanac) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Month(Now())#">
						  and datepart(dd, DEfechanac) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Day(Now())#">--->
					</cfquery>

					<cfloop query="data">
						<cfif len(trim(data.celular))>
							<cfset contador = contador + 1 >
							<cfset info = "#trim(empresa_nombre)# le desea un feliz cumpleanos." >
							<cfquery datasource="asp">
								insert into SMS ( SScodigo, SMcodigo, asunto, para, texto, fecha_creado, BMfecha, BMUsucodigo )
								values ( 'RH', 
										 'NOMINA',
										 <cfqueryparam cfsqltype="cf_sql_varchar"   value="Feliz Cumpleanos:">,
										 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#data.celular#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#info#">,
										 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric"   value="0"> )
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>

				<cfif vDebug ><b>Empresa:</b><cfdump var="#empresa#"><br><br></cfif>
			</cfloop> <!--- control de empresas --->
			
	</cfif>	
	<!---<cfif vDebug ><br>***********************************************************<br></cfif>--->
</cfloop>

<cfoutput>
<cfset finish = Now()>
Mensajes enviados: #contador#<br>
Proceso terminado #TimeFormat(finish,"HH:MM:SS")#<br>
</cfoutput>
