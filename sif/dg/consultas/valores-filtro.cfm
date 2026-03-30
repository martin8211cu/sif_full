<cf_templateheader title="Lista de Valores de Distribuci&oacute;n de Gastos por Departamento">

		<cf_web_portlet_start border="true" titulo="Lista de Valores de Distribuci&oacute;n de Gastos por Departamento" >
		<cfoutput>
	
				<!--- =================================================================== --->
				<!--- =================================================================== --->
				<!--- lee la tabla de parametros para obtener el id de catalogo --->
				<cfset vCatalogo = '' >
				<cfquery name="rscatalogo" datasource="#session.DSN#">
					select Pvalor as valor
					from DGParametros
					where Pcodigo=10
				</cfquery>
				<cfif len(trim(rscatalogo.valor)) eq 0>
					<cfquery name="rsInsCatalogo" datasource="#session.DSN#">
						select min(PCEcatid) as valor
						from PCECatalogo
						where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					</cfquery>
					<cfif len(trim(rsInsCatalogo.valor))>
						<cfquery datasource="#session.DSN#">
							insert INTO DGParametros(Pcodigo, Pvalor, BMfechaalta, BMUsucodigo)
							values (	10, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInsCatalogo.valor#">, 
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
						</cfquery>
						<cfset vCatalogo = rsInsCatalogo.valor >
					</cfif>
				<cfelse>
					<cfset vCatalogo = rscatalogo.valor >
				</cfif>
				<cfif len(trim(vCatalogo)) eq 0>
					<cf_errorCode	code = "50369" msg = "No se puede recuperar el Catálogo del plan de Cuentas. Revise los parámetros de la apliación.">
				</cfif>
				<!--- =================================================================== --->
				<!--- =================================================================== --->
	
	
			<form style="margin:0" action="valores.cfm" method="post" name="form1" id="form1" >
	
				<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
					<tr>
						<td align="right" valign="middle" width="1%" nowrap="nowrap"><strong>Departamento:</strong></td>
						<td>
							<cf_conlis
								campos="PCDcatid, PCDvalor, PCDdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,30"
								title="Lista de Departamentos"
								tabla="PCDCatalogo"
								columnas="PCDcatid, PCDvalor, PCDdescripcion"
								filtro="PCEcatid=#vCatalogo# order by PCDvalor, PCDdescripcion"
								desplegar="PCDvalor, PCDdescripcion"
								filtrar_por="PCDvalor, PCDdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="PCDcatid, PCDvalor, PCDdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Departamentos --"
								tabindex="1" >
						</td>
					</tr>
	
					<tr>
						<td align="right" valign="middle" width="45%" nowrap="nowrap"><strong>Criterio:</strong></td>
						<td>
							<cf_conlis
								campos="DGCDid, DGCDcodigo, DGCDdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,30"
								title="Lista de Criterios de Distribuci&oacute;n"
								tabla="DGCriteriosDistribucion"
								columnas="DGCDid, DGCDcodigo, DGCDdescripcion"
								filtro="1=1 order by DGCDcodigo, DGCDdescripcion"
								desplegar="DGCDcodigo, DGCDdescripcion"
								filtrar_por="DGCDcodigo, DGCDdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="DGCDid, DGCDcodigo, DGCDdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Criterios --"
								tabindex="1" >
						</td>
					</tr>
	
					<tr>
						<td align="right" valign="middle" width="45%" nowrap="nowrap"><strong>Per&iacute;odo:</strong></td>
						<td>
							<cf_monto name="Periodo" decimales="0" size="4" value="">
						</td>
					</tr>
					<tr>
						<td align="right" valign="middle" width="45%" nowrap="nowrap"><strong>Mes:</strong></td>
						<td>
							<cfquery name="m" datasource="#session.dsn#">
								select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as m
								from Idiomas a
									inner join VSidioma b
									on b.Iid = a.Iid
									and b.VSgrupo = 1
								where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
								order by <cf_dbfunction name="to_number" args="b.VSvalor">
							</cfquery>
							<select name="Mes" >
								<option value="">-Seleccionar-</option>
								<cfloop query="m">
									<option value="#m.v#" >#m.m#</option>
								</cfloop>
							</select>							
						</td>
					</tr>
					
					<tr>
						<td colspan="4" align="center"><input type="submit" name="btnConsultar" value="Consultar" class="btnConsulta" /></td>
					</tr>
					
				</table>	
	
	
			</form>
		<cf_web_portlet_end>
		</cfoutput>
	<cf_templatefooter>		

