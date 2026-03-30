

<cfset vDebug = true >

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
	and c.Ccache = 'minisif' <!---quitar--->
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
			select 1 from DLaboralesEmpleado 
		</cfquery>
		<cfquery name="rsEmpresas" datasource="#cache#">
			select 1 from RHTipoAccion 
		</cfquery>
		<cfquery name="rsEmpresas" datasource="#cache#">
			select 1 from RHAlertaAcciones 
		</cfquery>
	<cfcatch type="any">
		<!---<cfdump var="#cfcatch#">--->
		<cfset continuar = false >
	</cfcatch>
	</cftry>
	
	<cfif continuar >
		
		<cfquery name="rsGet" datasource="#cache#">
					select  a.DLffin as fhasta,a.DLfechaaplic as faccion, '' as frecordatorio, b.RHTdiasalerta as diasAntes, a.*, b.*
					from DLaboralesEmpleado a
						
						inner join RHTipoAccion b
						on b.RHTid = a.RHTid
						and b.RHTalerta = 1
						and b.RHTdiasalerta >=0
					
					where  (a.DLalertagen is  null 
					or a.DLalertagen = 0)
					<!---and DEid = 4839 quitar--->
		</cfquery>
		
		<cfloop query="rsGet">
			<cfset F_recordatorio = DateAdd("d", -rsGet.diasAntes, rsGet.fhasta)>
			<cfset rsGet.frecordatorio = F_recordatorio>
		</cfloop>
		
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
				
				<cfquery name="rsGet2" dbtype="query">
					select  *
					from rsGet 
					where  fhasta >= #now()#
					and frecordatorio <= #now()#
					and Ecodigo =  #LvarEmpresa#
				</cfquery>

				<cfif vDebug ><b>Empresa:</b><cfdump var="#LvarEmpresa#"><br></cfif>
				<cfif rsGet2.recordCount GT 0>
					<!---<cfif vDebug><cfdump var="#rsGet2#"> <br><b>CACHE:</b> <cfdump var="#LvarEmpresa#"><br></cfif>--->
									
					<cfif rsGet2.recordCount GT 0>
					Ids de nuevas alertas: 
					</cfif>
					
					<cfloop query="rsGet2">
						<cfset contador = ''>
						<cfinvoke component="rh.Componentes.RH_RecordatorioAlertas" method="AddAlerta"
							returnvariable="contador">
							<cfinvokeargument name="RHTid" value="#rsGet2.RHTid#">
							<cfinvokeargument name="Fecha" value="#fechahoy#">
							<cfinvokeargument name="Lcache" value="#cache#">
							<cfinvokeargument name="empresa" value="#LvarEmpresa#">
							<cfinvokeargument name="empresasdc" value="#LvarEmpresasdc#">
							<cfinvokeargument name="empresa_nombre" value="#LvarEmpresa_nombre#">
							<cfinvokeargument name="DLlinea" value="#rsGet2.DLlinea#">
							<cfinvokeargument name="DEid" value="#rsGet2.DEid#">
							<cfinvokeargument name="fdesdeaccion" value="#rsGet2.faccion#">
							<cfinvokeargument name="fhastaaccion" value="#rsGet2.fhasta#">
							<cfinvokeargument name="falerta" value="#rsGet2.fhasta#">
						</cfinvoke>
						<!---<cfdump var="#contador#"><br>--->
					</cfloop>
				<cfif vDebug ><cfdump var="Alerta_#contador#"><br></cfif>
			<cfelse>
				<cfif vDebug ><cfdump var="No hay alertas"><br></cfif>
			</cfif>
		</cfloop> <!--- control de empresas --->
		
	</cfif>	
	<!---<cfif vDebug ><br>***********************************************************<br></cfif>--->
</cfloop>

<cfoutput>
<cfset finish = Now()>
<!---Correos enviados: #contador#<br>--->
Proceso terminado #TimeFormat(finish,"HH:MM:SS")#<br>
</cfoutput>
