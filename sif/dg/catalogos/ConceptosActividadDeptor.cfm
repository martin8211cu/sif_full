<cfif isdefined("url.DGGDid") and not isdefined("form.DGGDid")>
	<cfset form.DGGDid = url.DGGDid >
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

<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
<cfelse>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGGDcodigo")	and not isdefined("form.filtro_DGGDcodigo")>
	<cfset form.filtro_DGGDcodigo = url.filtro_DGGDcodigo >
</cfif>
<cfif isdefined("url.filtro_PCEcodigo")	and not isdefined("form.filtro_PCEcodigo")>
	<cfset form.filtro_PCEcodigo = url.filtro_PCEcodigo >
</cfif>
<cfif isdefined("url.filtro_PCDvalor")	and not isdefined("form.filtro_PCDvalor")>
	<cfset form.filtro_PCDvalor = url.filtro_PCDvalor >
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.DGGDid") and len(trim(form.DGGDid)) and isdefined("form.PCEcatid") and len(trim(form.PCEcatid)) and isdefined("form.PCDcatid") and len(trim(form.PCDcatid)) and isdefined("form.Empresa") and len(trim(form.Empresa)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGGDid, 
			  b.DGGDcodigo,
			  b.DGGDdescripcion, 
			  a.PCDcatid, 
			  c.PCDvalor, 
			  c.PCDdescripcion, 
			  a.PCEcatid,
			  d.PCEcodigo,
			  d.PCEdescripcion,
			  a.Ecodigo,
			  e.Edescripcion 
		
		from DGDeptosGastosDistribuir a
		
		inner join DGGastosDistribuir b
		on b.DGGDid=a.DGGDid
		and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		inner join PCDCatalogo c
		on c.PCDcatid=a.PCDcatid
		
		inner join PCECatalogo d
		on c.PCEcatid=a.PCEcatid

		inner join Empresas e
		on e.Ecodigo=a.Ecodigo
		and e.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		
		where a.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
		  and a.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and a.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
  		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">
	</cfquery>
</cfif>
<cf_templateheader title="Gastos a Distribuir por Departamentos">
		<cf_web_portlet_start titulo="Gastos a Distribuir por Departamentos">
			<cfoutput>
			<form style="margin:0" action="DeptosGastosDistribuir-sql.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td colspan="4" align="center" bgcolor="##ececff" >
						<table width="100%" cellpadding="0" >
							<tr><td align="center"><font color="##006699"><strong>Departamentos que integran una cuenta de Gastos por Distribuir</strong></font></td></tr>
						</table>
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="45%" nowrap="nowrap"><strong>Gasto:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#trim(data.DGGDcodigo)# - #data.DGGDdescripcion#
							<input type="hidden" name="DGGDid" value="#data.DGGDid#" />
						<cfelse>
							<cf_conlis
								campos="DGGDid, DGGDcodigo, DGGDdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,30"
								title="Lista de Gastos a Distribuir"
								tabla="DGGastosDistribuir"
								columnas="DGGDid, DGGDcodigo, DGGDdescripcion"
								filtro="CEcodigo=#session.CEcodigo# order by DGGDcodigo, DGGDdescripcion"
								desplegar="DGGDcodigo, DGGDdescripcion"
								filtrar_por="DGGDcodigo, DGGDdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="DGGDid, DGGDcodigo, DGGDdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Gastos --"
								tabindex="1" >
						</cfif>
						
					</td>
				</tr>

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

				<tr>
					<td align="right" valign="middle" width="1%" nowrap="nowrap"><strong>Valor de Cat&aacute;logo:</strong></td>
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
							title="Lista de Valores de Cat&oacute;logo"
							tabla="PCDCatalogo"
							columnas="PCDcatid, PCDvalor, PCDdescripcion"
							filtro="PCEcatid=$PCEcatid,numeric$ order by PCDvalor, PCDdescripcion"
							desplegar="PCDvalor, PCDdescripcion"
							filtrar_por="PCDvalor, PCDdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="PCDcatid, PCDvalor, PCDdescripcion"
							asignarformatos="S, S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Valores de Cat&oacute;logo --"
							tabindex="1" >
						</cfif>
						
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

			<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo))>
				<input type="hidden" name="filtro_DGGDcodigo" value="#form.filtro_DGGDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_PCEcodigo") and len(trim(form.filtro_PCEcodigo))>
				<input type="hidden" name="filtro_PCEcodigo" value="#form.filtro_PCEcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor))>
				<input type="hidden" name="filtro_PCDvalor" value="#form.filtro_PCDvalor#"  /> 
			</cfif>
		</form>
		</cfoutput>
		<cf_web_portlet_end>
		
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
				objForm.DGGDid.required = true;
				objForm.DGGDid.description = 'Gasto';			
	
				objForm.PCEcatid.required = true;
				objForm.PCEcatid.description = 'Catálogo';			

				objForm.PCDcatid.required = true;
				objForm.PCDcatid.description = 'Valor de Catálogo';

				objForm.Empresa.required = true;
				objForm.Empresa.description = 'Empresa';

			
			function deshabilitarValidacion(){
				objForm.DGGDid.required = false;
				objForm.PCEcatid.required = false;
				objForm.PCDcatid.required = false;
				objForm.Empresa.required = false;
			}
			
			function funcRegresar(){
				deshabilitarValidacion();
				document.form1.action = 'DeptosGastosDistribuir-lista.cfm';
			}
		</script>
		
	<cf_templatefooter>