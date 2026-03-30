<title>Informaci&oacute;n del Centro Funcional</title>

<!--- Asignación de valores a las variables del form --->	
<cfif isDefined("url.DEid") and not isDefined("form.DEid")>
	<cfset form.DEid = url.DEid>
</cfif>
<cfif isDefined("url.CFid") and not isDefined("form.CFid")>
	<cfset form.CFid = url.CFid>
</cfif>
<cfif isDefined("url.ECFlinea") and not isDefined("form.ECFlinea")>
	<cfset form.ECFlinea = url.ECFlinea>
</cfif>

<!--- Obtengo el No. de línea para preguntar si la línea se puede borrar --->
<cfquery name="rsUltimaLinea" datasource="#session.dsn#">
	select ECFlinea as Linea
	from EmpleadoCFuncional a
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and ECFhasta = (select max(ECFhasta)
						from EmpleadoCFuncional b
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.DEid = a.DEid
						)
</cfquery>

<!--- Consulta Id, Código y Descripción del Centro Funcional --->
<cfquery name="rsCFuncional" datasource="#session.dsn#">
	select 	CFid as CFid2, 
			CFcodigo as CFcodigo2, 
			CFdescripcion as CFdescripcion2 
	from CFuncional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
</cfquery>

<!--- Obtengo los datos correspondiente a la línea --->
<cfquery name="rsDatos" datasource="#session.dsn#">
	select 
		a.ECFlinea,
		a.CFid,
		a.ECFencargado,
		a.ECFdesde,
		a.ECFhasta
	from EmpleadoCFuncional a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and ECFlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECFlinea#">
</cfquery>

<!--- Consulta si la línea esta vigente para habilitar CF y Encargado --->
<cfquery name="rsValidaVigencia" datasource="#session.dsn#">
	select 1
	from EmpleadoCFuncional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and ECFlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECFlinea#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between ECFdesde and ECFhasta
</cfquery>

<cfset vigente = rsValidaVigencia.recordcount >

<cfoutput>
<form name="form2" id="form2" method="post" action="empleadosCF-modificarCFSQL.cfm">
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<input type="hidden" name="ECFlinea" value="#form.ECFlinea#">
	<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
		<!--- Línea No. 1 --->
		<tr><td>&nbsp;</td></tr>
		<!--- Línea No. 2 --->
		<tr>
			<td>
				<fieldset>
					<legend><strong>Informaci&oacute;n del Centro Funcional</strong></legend>			
					<table width="100%" border="0" cellspacing="2" cellpadding="0">
						<tr><td colspan="2">&nbsp;</td></tr>
						<cfif vigente NEQ 0>
							<tr>
								<td width="30%" class="fileLabel"><strong>Centro Funcional</strong></td>
								<td>
								<cfset valuesArrayC = ArrayNew(1)>
								<cfif isdefined("rsCFuncional.CFid2")>
									<cfset ArrayAppend(valuesArrayC, rsCFuncional.CFid2)>
								</cfif>
								<cfif isdefined("rsCFuncional.CFcodigo2")>
									<cfset ArrayAppend(valuesArrayC, rsCFuncional.CFcodigo2)>
								</cfif>
								<cfif isdefined("rsCFuncional.CFdescripcion2")>
									<cfset ArrayAppend(valuesArrayC, rsCFuncional.CFdescripcion2)>
								</cfif>
								<cf_conlis
								campos="CFid2, CFcodigo2, CFdescripcion2"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								valuesArray="#valuesArrayC#"
								tabla="CFuncional"
								columnas="CFid as CFid2, CFcodigo as CFcodigo2, CFdescripcion as CFdescripcion2"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFcodigo2, CFdescripcion2"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFid2, CFcodigo2, CFdescripcion2"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1"
								form="form2">		
								<!--- 
								<cf_rhcfuncional form="form2" id="CFid2" name="CFcodigo2" desc="CFdescripcion2"  query="#rsCFuncional#" tabindex="1" frame="frcfuncional">
								--->
								</td>
							</tr>						
							<tr>
								<td width="30%" class="fileLabel"><strong>Encargado</strong></td>
								<td><input type="checkbox" name="ECFencargado" id="ECFencargado" tabindex="1" value="0" <cfif rsDatos.ECFencargado EQ 1>checked</cfif> ></td>	
							</tr>
						<cfelse>
							<tr>
								<td width="30%" class="fileLabel"><strong>Centro Funcional</strong></td>
								<td>#rsCFuncional.CFcodigo2# - #rsCFuncional.CFdescripcion2#</td>
							</tr>						
							<tr>
								<td width="30%" class="fileLabel"><strong>Encargado</strong></td>
								<td><input type="checkbox" name="ECFencargado" id="ECFencargado" tabindex="1" value="0" <cfif rsDatos.ECFencargado EQ 1>checked</cfif> disabled ></td>	
							</tr>
						</cfif>
						<tr>
							<td colspan="2">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="30%" class="fileLabel"><strong>Fecha Desde</strong></td>
										<td> 
											<cf_sifcalendario form="form2" value="#DateFormat(rsDatos.ECFdesde,'dd/mm/yyyy')#" name="ECFdesde" tabindex="1">
										</td>
										<td class="fileLabel"><strong>Fecha Hasta</strong></td>
										<td>
											<cf_sifcalendario form="form2" value="#DateFormat(rsDatos.ECFhasta,'dd/mm/yyyy')#" name="ECFhasta" tabindex="1">
										</td>	
									</tr>
								</table>
							</td>
						</tr>

					</table>
				</fieldset>
			</td>
		</tr>
		<!--- Línea No. 3 --->
		<tr><td>&nbsp;</td></tr>
		<!--- Línea No. 4 --->
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2" align="center">
							<input type="submit" name="btnmodificar" value="Modificar">
							<!---<cfif rsUltimaLinea.Linea EQ form.ECFlinea>
								<input type="submit" name="btnEliminar" value="Eliminar" onClick="javascript: return confirm('Esta seguro que desea eliminar este registro')">
							</cfif>--->
							<input type="button" name="btncerrar" value="Cancelar" onClick="javascript: window.close();">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<cf_qforms form="form2" objForm="objForm2">
	<cfif vigente NEQ 0>
		<cf_qformsRequiredField args="CFid2,Centro Funcional">
	</cfif>
	<cf_qformsRequiredField args="ECFdesde,Fecha Desde">
	<cfif rsUltimaLinea.Linea NEQ form.ECFlinea>
		<cf_qformsRequiredField args="ECFhasta,Fecha Hasta">
	</cfif>
</cf_qforms>

