
<cfif isdefined("url.DGAid") and not isdefined("form.DGAid")>
	<cfset form.DGAid = url.DGAid >
</cfif>
<cfif isdefined("url.DGCid") and not isdefined("form.DGCid")>
	<cfset form.DGCid = url.DGCid >
</cfif>
<cfif isdefined("url.PCEcatid") and not isdefined("form.PCEcatid")>
	<cfset form.PCEcatid = url.PCEcatid >
</cfif>
<cfif isdefined("url.PCDcatid") and not isdefined("form.PCDcatid")>
	<cfset form.PCDcatid = url.PCDcatid >
</cfif>
<cfif isdefined("url.Empresa") and not isdefined("form.Empresa")>
	<cfset form.Empresa = url.Empresa >
</cfif>

<cfif isdefined("url.pagenum_lista") and not isdefined("form.pageNum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>	
<cfif not isdefined("form.pageNum_lista")>
	<cfset form.pagenum_lista = 1 >
</cfif>

<cfif isdefined("url.filtro_DGAcodigo")	and not isdefined("form.filtro_DGAcodigo")>
	<cfset form.filtro_DGAcodigo = url.filtro_DGAcodigo >
</cfif>
<cfif isdefined("url.filtro_DGCcodigo")	and not isdefined("form.filtro_DGCcodigo")>
	<cfset form.filtro_DGCcodigo = url.filtro_DGCcodigo >
</cfif>
<cfif isdefined("url.filtro_PCEcodigo")	and not isdefined("form.filtro_PCEcodigo")>
	<cfset form.filtro_PCEcodigo = url.filtro_PCEcodigo >
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
<cfif isdefined("form.DGAid") and len(trim(form.DGAid)) and isdefined("form.DGCid") and len(trim(form.DGCid)) and isdefined("form.PCEcatid") and len(trim(form.PCEcatid)) and isdefined("form.PCDcatid") and len(trim(form.PCDcatid)) and isdefined("form.Empresa") and len(trim(form.Empresa)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGAid, 
			  b.DGAcodigo,
			  b.DGAdescripcion, 
			  a.PCDcatid, 
			  c.PCDvalor, 
			  c.PCDdescripcion, 
			  a.PCEcatid,
			  a.Ecodigo,
			  e.Edescripcion ,
			  a.DGCid,
			  f.DGCcodigo,
			  f.DGdescripcion
		
		from DGConceptosActividadDepto a
		
		inner join DGActividades b
		on b.DGAid=a.DGAid
		and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >

		inner join DGConceptosER f
		on f.DGCid=a.DGCid
		and f.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		inner join PCDCatalogo c
		on c.PCDcatid=a.PCDcatid
		
		inner join Empresas e
		on e.Ecodigo=a.Ecodigo
		and e.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
		  and a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
		  and a.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and a.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
  		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">
	</cfquery>
</cfif>
<cf_templateheader title="Conceptos por Actividad y Departamento">
		<cf_web_portlet_start titulo="Conceptos por Actividad y Departamento">
			<cfoutput>
			<form style="margin:0" action="ConceptosActividadDepto-sql.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td colspan="4" align="center" bgcolor="##ececff" >
						<table width="100%" cellpadding="0" >
							<tr><td align="center"><font color="##006699"><strong>Conceptos de Estado de Resultados por Actividad y Departamento</strong></font></td></tr>
						</table>
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="45%" nowrap="nowrap"><strong>Actividad:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#trim(data.DGAcodigo)# - #data.DGAdescripcion#
							<input type="hidden" name="DGAid" value="#data.DGAid#" />
						<cfelse>
							<cf_conlis
								campos="DGAid, DGAcodigo, DGAdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,30"
								title="Lista de Gastos a Distribuir"
								tabla="DGActividades"
								columnas="DGAid, DGAcodigo, DGAdescripcion"
								filtro="CEcodigo=#session.CEcodigo# order by DGAcodigo, DGAdescripcion"
								desplegar="DGAcodigo, DGAdescripcion"
								filtrar_por="DGAcodigo, DGAdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="DGAid, DGAcodigo, DGAdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Gastos --"
								tabindex="1" >
						</cfif>
						
					</td>
				</tr>
				
				<tr>
					<td align="right" valign="middle" width="1%" nowrap="nowrap"><strong>Concepto:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#trim(data.DGCcodigo)# - #data.DGdescripcion#
							<input type="hidden" name="DGCid" value="#data.DGCid#" />
						<cfelse>
						<cf_conlis
							campos="DGCid, DGCcodigo, DGdescripcion"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,30"
							title="Lista de Conceptos"
							tabla="DGConceptosER"
							columnas="DGCid, DGCcodigo, DGdescripcion"
							filtro="CEcodigo=#SESSION.CECODIGO# order by DGCcodigo, DGdescripcion"
							desplegar="DGCcodigo, DGdescripcion"
							filtrar_por="DGCcodigo, DGdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="DGCid, DGCcodigo, DGdescripcion"
							asignarformatos="S, S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Conceptos --"
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
					<td align="right" valign="middle" width="1%" nowrap="nowrap"><strong>Empresa:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#data.Edescripcion#
							<input type="hidden" name="Empresa" value="#data.Ecodigo#" />
						<cfelse>
						<cf_conlis
							campos="Empresa, Edescripcion"
							desplegables="N,S"
							modificables="N,S"
							size="0,30"
							title="Lista de Empresas"
							tabla="Empresas"
							columnas="Ecodigo as Empresa, Edescripcion"
							filtro="cliente_empresarial=#SESSION.CECODIGO# order by Edescripcion"
							desplegar="Edescripcion"
							filtrar_por="Edescripcion"
							etiquetas="Empresa"
							formatos="S"
							align="left"
							asignar="Empresa, Edescripcion"
							asignarformatos="S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Empresas --"
							tabindex="1" >
						</cfif>
						
					</td>
				</tr>

				<tr>
					<td colspan="4" align="center"><cf_botones modo="#modo#" exclude="cambio" include="Regresar" tabindex="2"></td>
				</tr>
			</table>
			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 

			<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
				<input type="hidden" name="filtro_DGAcodigo" value="#form.filtro_DGAcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGCcodigo") and len(trim(form.filtro_DGCcodigo))>
				<input type="hidden" name="filtro_DGCcodigo" value="#form.filtro_DGCcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor))>
				<input type="hidden" name="filtro_PCDvalor" value="#form.filtro_PCDvalor#"  /> 
			</cfif>
		</form>
		</cfoutput>
		<cf_web_portlet_end>
		
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
				objForm.DGAid.required = true;
				objForm.DGAid.description = 'Actividad';			

				objForm.DGCid.required = true;
				objForm.DGCid.description = 'Concepto';			
	
				objForm.PCDcatid.required = true;
				objForm.PCDcatid.description = 'Departamento';

				objForm.Empresa.required = true;
				objForm.Empresa.description = 'Empresa';

			
			function deshabilitarValidacion(){
				objForm.DGAid.required = false;
				objForm.DGCid.required = false;
				objForm.PCDcatid.required = false;
				objForm.Empresa.required = false;
			}
			
			function funcRegresar(){
				deshabilitarValidacion();
				document.form1.action = 'ConceptosActividadDepto-lista.cfm';
			}
		</script>
<cf_templatefooter>

