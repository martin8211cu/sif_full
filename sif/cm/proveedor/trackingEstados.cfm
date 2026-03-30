<cfif isdefined("url.ETcodigo") and not isdefined("form.ETcodigo") >
	<cfset form.ETcodigo = url.ETcodigo >
</cfif>

<!--- Averiguar si existe el Estado 0 (Inicio) en las tablas de EstadosTracking, si no existe hay que generarlo --->
<cfquery name="existsEstados" datasource="sifpublica">
	select 1 from EstadosTracking 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and ETcodigo = 0
</cfquery>

<cfif existsEstados.recordCount EQ 0>
	<cfquery datasource="sifpublica">
		insert EstadosTracking (Ecodigo, ETcodigo, EcodigoASP, CEcodigo, ETdescripcion, Usucodigo, fechaalta, ETorden)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				 0,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">, 
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">, 
				 'Inicio',
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				 1 )
	</cfquery>
</cfif>

<cf_templateheader title="	Registro de Cotizaciones">
			<cf_web_portlet_start titulo="Registro de Estados de Tracking">
				<cfinclude template="pNavegacion.cfm">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td valign="top">
								<cfquery name="rsLista" datasource="sifpublica">
									select ETcodigo, ETdescripcion, ETorden
									from EstadosTracking
									where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								</cfquery>
								
								<cfinvoke 
								 component="sif.Componentes.pListas"
								 method="pListaQuery"
								 returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="ETcodigo,ETdescripcion,ETorden"/>
									<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n,Orden"/>
									<cfinvokeargument name="formatos" value=""/>
									<cfinvokeargument name="align" value="left, left,left"/>
									<cfinvokeargument name="ajustar" value=""/>
									<cfinvokeargument name="irA" value="trackingEstados.cfm"/>
									<cfinvokeargument name="formName" value="lista"/>
									<cfinvokeargument name="MaxRows" value="15"/>
									<cfinvokeargument name="debug" value="N"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
									<cfinvokeargument name="conexion" value="sifpublica"/>
								</cfinvoke>
							</td>
							<td valign="top"><cfinclude template="trackingEstados-form.cfm"></td>
						</tr>
					</table>
			<cf_web_portlet_end>
	<cf_templatefooter>
