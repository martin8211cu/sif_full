
<cfif isdefined("url.DGCDid") and not isdefined("form.DGCDid")>
	<cfset form.DGCDid = url.DGCDid >
</cfif>
<cfif isdefined("url.PCEcatid") and not isdefined("form.PCEcatid")>
	<cfset form.PCEcatid = url.PCEcatid >
</cfif>
<cfif isdefined("url.PCDcatid") and not isdefined("form.PCDcatid")>
	<cfset form.PCDcatid = url.PCDcatid >
</cfif>


<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
<cfelse>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGCDcodigo")	and not isdefined("form.filtro_DGCDcodigo")>
	<cfset form.filtro_DGCDcodigo = url.filtro_DGCDcodigo >
</cfif>
<cfif isdefined("url.filtro_PCDvalor")	and not isdefined("form.filtro_PCDvalor")>
	<cfset form.filtro_PCDvalor = url.filtro_PCDvalor >
</cfif>

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

<cfset modo = 'ALTA'>
<cfif isdefined("form.DGCDid") and len(trim(form.DGCDid)) and isdefined("form.PCEcatid") and len(trim(form.PCEcatid)) and isdefined("form.PCDcatid") and len(trim(form.PCDcatid)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGCDid, 
			  b.DGCDcodigo,
			  b.DGCDdescripcion, 
			  a.PCDcatid, 
			  c.PCDvalor, 
			  c.PCDdescripcion, 
			  a.PCEcatid
		
		from DGCriteriosDepto a
		
		inner join DGCriteriosDistribucion b
		on b.DGCDid=a.DGCDid
		and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		inner join PCDCatalogo c
		on c.PCDcatid=a.PCDcatid
		
		where a.DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">
		  and a.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and a.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
	</cfquery>
</cfif>
<cf_templateheader title="Criterios de Distribuci&oacute;n por Departamentos">
		<cf_web_portlet_start titulo="Criterios de Distribuci&oacute;n por Departamentos">
			<cfoutput>
			<form style="margin:0" action="criteriosDepto-sql.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td colspan="4" align="center" bgcolor="##ececff" >
						<table width="100%" cellpadding="0" >
							<tr><td align="center"><font color="##006699"><strong>Criterios de Distribuci&oacute;n por Departamentos</strong></font></td></tr>
						</table>
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="45%" nowrap="nowrap"><strong>Criterio:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#trim(data.DGCDcodigo)# - #data.DGCDdescripcion#
							<input type="hidden" name="DGCDid" value="#data.DGCDid#" />
						<cfelse>
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
						</cfif>
						
					</td>
				</tr>

				<!---
				<tr>
					<td align="right" valign="middle" width="1%" nowrap="nowrap"><strong>Cat&aacute;logo:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#trim(data.PCEcodigo)# - #data.PCEdescripcion#
							<input type="hidden" name="PCEcatid" value="#data.PCEcatid#" />
						<cfelse>
						<cf_conlis
							campos="PCEcatid, PCEcodigo, PCEdescripcion"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,30"
							title="Lista de Cat&oacute;logos"
							tabla="PCECatalogo"
							columnas="PCEcatid, PCEcodigo, PCEdescripcion"
							filtro="CEcodigo=#SESSION.CECODIGO# order by PCEcodigo, PCEdescripcion"
							desplegar="PCEcodigo, PCEdescripcion"
							filtrar_por="PCEcodigo, PCEdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="PCEcatid, PCEcodigo, PCEdescripcion"
							asignarformatos="S, S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Cat&oacute;logos --"
							tabindex="1" >
						</cfif>
						
					</td>
				</tr>
				--->

				<tr>
					<td align="right" valign="middle" width="1%" nowrap="nowrap"><strong>Departamento:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#trim(data.PCDvalor)# - #data.PCDdescripcion#
							<input type="hidden" name="PCDcatid" value="#data.PCDcatid#" />
						<cfelse>
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
						</cfif>
						<input type="hidden" name="PCEcatid" value="#vCatalogo#" />
					</td>
				</tr>

				<tr>
					<td colspan="4" align="center"><cf_botones modo="#modo#" exclude="cambio" include="Regresar" tabindex="2"></td>
				</tr>
			</table>
			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 

			<cfif isdefined("form.filtro_DGCDcodigo") and len(trim(form.filtro_DGCDcodigo))>
				<input type="hidden" name="filtro_DGCDcodigo" value="#form.filtro_DGCDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor))>
				<input type="hidden" name="filtro_PCDvalor" value="#form.filtro_PCDvalor#"  /> 
			</cfif>
		</form>
		</cfoutput>
		<cf_web_portlet_end>
		
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
				objForm.DGCDid.required = true;
				objForm.DGCDid.description = 'Criterio';			
	
				objForm.PCDcatid.required = true;
				objForm.PCDcatid.description = 'Departamento';
			
			function deshabilitarValidacion(){
				objForm.DGCDid.required = false;
				objForm.PCDcatid.required = false;
			}
			
			function funcRegresar(){
				deshabilitarValidacion();
				document.form1.action = 'criteriosDepto-lista.cfm';
			}
		</script>
		
	<cf_templatefooter>

