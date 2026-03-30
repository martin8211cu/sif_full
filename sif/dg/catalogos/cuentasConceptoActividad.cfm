<cfif isdefined("url.DGAid") and not isdefined("form.DGAid")>
	<cfset form.DGAid = url.DGAid >
</cfif>
<cfif isdefined("url.DGCid") and not isdefined("form.DGCid")>
	<cfset form.DGCid = url.DGCid >
</cfif>
<cfif isdefined("url.Empresa") and not isdefined("form.Empresa")>
	<cfset form.Empresa = url.Empresa >
</cfif>
<cfif isdefined("url.Cmayor") and not isdefined("form.Cmayor")>
	<cfset form.Cmayor = url.Cmayor >
</cfif>

<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
<cfelse>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGAcodigo")	and not isdefined("form.filtro_DGAcodigo")>
	<cfset form.filtro_DGAcodigo = url.filtro_DGAcodigo >
</cfif>
<cfif isdefined("url.filtro_DGAdescripcion")	and not isdefined("form.filtro_DGAdescripcion")>
	<cfset form.filtro_DGAdescripcion = url.filtro_DGAdescripcion >
</cfif>
<cfif isdefined("url.filtro_DGCcodigo")	and not isdefined("form.filtro_DGCcodigo")>
	<cfset form.filtro_DGCcodigo = url.filtro_DGCcodigo >
</cfif>
<cfif isdefined("url.filtro_DGdescripcion")	and not isdefined("form.filtro_DGdescripcion")>
	<cfset form.filtro_DGdescripcion = url.filtro_DGdescripcion >
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.DGAid") and len(trim(form.DGAid)) and isdefined("form.DGCid") and len(trim(form.DGCid)) and isdefined("form.Empresa") and len(trim(form.Empresa)) and isdefined("form.Cmayor") and len(trim(form.Cmayor)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGAid, 
			   a.DGCid, 
			   a.Ecodigo, 
			   a.Cmayor, 
			   b.DGAcodigo,
			   b.DGAdescripcion, 
			   c.DGCcodigo,
			   c.DGdescripcion, 
			   d.Edescripcion
		
		from DGCtasConceptoActividad a
		
		inner join DGActividades b
		on b.DGAid=a.DGAid
		
		inner join DGConceptosER c
		on  c.DGCid = a.DGCid
		
		inner join Empresas d
		on d.Ecodigo=a.Ecodigo
		and d.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#" >
  		  and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#" >
  		  and a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#" >
  		  and a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#" >
	</cfquery>
	
	<cfquery name="rsCuenta" datasource="#session.DSN#">
		select Cmayor, Cdescripcion
		from CtasMayor
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#" >
		  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#" >
	</cfquery>
	
</cfif>
<cf_templateheader title="Cuentas por Concepto y Actividad">
		<cf_web_portlet_start titulo="Cuentas por Concepto y Actividad">
			<cfoutput>
			<form style="margin:0" action="cuentasConceptoActividad-sql.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td colspan="4" align="center" bgcolor="##ececff" >
						<table width="100%" cellpadding="0" >
							<tr><td align="center"><font color="##006699"><strong>Cuentas que se incluyen en Conceptos de Estado de Resultados por Actividad</strong></font></td></tr>
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
								title="Lista de Actividades"
								tabla="DGActividades"
								columnas="DGAid, DGAcodigo, DGAdescripcion"
								filtro="CEcodigo=#SESSION.CECODIGO# order by DGAcodigo, DGAdescripcion"
								desplegar="DGAcodigo, DGAdescripcion"
								filtrar_por="DGAcodigo, DGAdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="DGAid, DGAcodigo, DGAdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Actividades --"
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

				<tr>
					<td align="right" valign="middle" width="1%" nowrap="nowrap"><strong>Cuenta:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#trim(data.Cmayor)# - #rsCuenta.Cdescripcion#
							<input type="hidden" name="Cmayor" value="#data.Cmayor#" />
						<cfelse>
						<cf_conlis
							campos="Cmayor, Cdescripcion"
							desplegables="S,S"
							modificables="S,S"
							size="4,30"
							title="Lista de Cuentas"
							tabla="CtasMayor"
							columnas="distinct Cmayor, Cdescripcion"
							filtro="1=1 order by Cdescripcion"
							desplegar="Cmayor, Cdescripcion"
							filtrar_por="Cmayor, Cdescripcion"
							etiquetas="Cuenta, Descripci&oacute;n"
							formatos="S,S"
							align="left,left"
							asignar="Cmayor,Cdescripcion"
							asignarformatos="S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Cuentas --"
							tabindex="1" >
						</cfif>
						
					</td>
				</tr>
				
				<tr>
					<td colspan="4" align="center"><cf_botones modo="#modo#" exclude="cambio" include="Regresar" tabindex="2"></td>
				</tr>
			</table>
			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<input type="hidden" name="Empresa" value="#session.Ecodigo#" />

			<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
				<input type="hidden" name="filtro_DGAcodigo" value="#form.filtro_DGAcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGAdescripcion") and len(trim(form.filtro_DGAdescripcion))>
				<input type="hidden" name="filtro_DGAdescripcion" value="#form.filtro_DGAdescripcion#"  /> 
			</cfif>

			<cfif isdefined("form.filtro_DGCcodigo") and len(trim(form.filtro_DGCcodigo))>
				<input type="hidden" name="filtro_DGCcodigo" value="#form.filtro_DGCcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGdescripcion") and len(trim(form.filtro_DGdescripcion))>
				<input type="hidden" name="filtro_DGdescripcion" value="#form.filtro_DGdescripcion#"  /> 
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

				objForm.Empresa.required = true;
				objForm.Empresa.description = 'Empresa';			

				objForm.Cmayor.required = true;
				objForm.Cmayor.description = 'Cuenta';			
			
			function deshabilitarValidacion(){
				objForm.DGAid.required = false;
				objForm.DGCid.required = false;
				objForm.Empresa.required = false;
				objForm.Cmayor.required = false;
			}
			
			function funcRegresar(){
				deshabilitarValidacion();
				document.form1.action = 'cuentasConceptoActividad-lista.cfm';
			}
		</script>
	<cf_templatefooter>