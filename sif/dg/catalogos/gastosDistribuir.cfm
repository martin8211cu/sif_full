<cfif isdefined("url.DGGDid") and not isdefined("form.DGGDid")>
	<cfset form.DGGDid = url.DGGDid >
</cfif>
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
<cfelse>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGGDcodigo")	and not isdefined("form.filtro_DGGDcodigo")>
	<cfset form.filtro_DGGDcodigo = url.filtro_DGGDcodigo >
</cfif>
<cfif isdefined("url.filtro_DGGDdescripcion")	and not isdefined("form.filtro_DGGDdescripcion")>
	<cfset form.filtro_DGGDdescripcion = url.filtro_DGGDdescripcion >
</cfif>

<cfif isdefined("url.proceso") and not isdefined("form.proceso")>
	<cfset form.proceso = url.proceso >
</cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo >
</cfif>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfset form.mes = url.mes >
</cfif>


<cfset vCriterios = arraynew(1)>
<cfset vCriterios[1] = ''>
<cfset vCriterios[2] = ''>
<cfset vCriterios[3] = ''>

<cfset vConceptos = arraynew(1)>
<cfset vConceptos[1] = ''>
<cfset vConceptos[2] = ''>
<cfset vConceptos[3] = ''>

<cfset vConceptosdest = arraynew(1)>
<cfset vConceptosdest[1] = ''>
<cfset vConceptosdest[2] = ''>
<cfset vConceptosdest[3] = ''>


<cfset modo = 'ALTA'>
<cfif isdefined("form.DGGDid") and len(trim(form.DGGDid)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGGDid, 
			   a.DGGDcodigo, 
			   a.DGGDdescripcion, 
			   a.CEcodigo, 
			   a.DGCDid,
			   a.DGCiddest, 
			   a.DGCid,
			   a.Criterio
		from DGGastosDistribuir a
		
		where a.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#" >
	</cfquery>
	
	<cfif len(trim(data.DGCid))>
		<cfquery name="rsConceptos" datasource="#session.DSN#">
			select DGCid, DGCcodigo, DGdescripcion
			from DGConceptosER
			where DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DGCid#">
		</cfquery>
		<cfset vConceptos[1] = rsConceptos.DGCid >
		<cfset vConceptos[2] = rsConceptos.DGCcodigo >
		<cfset vConceptos[3] = rsConceptos.DGdescripcion >
	</cfif>

	<cfif len(trim(data.DGCiddest))>
		<cfquery name="rsConceptos" datasource="#session.DSN#">
			select DGCid, DGCcodigo, DGdescripcion
			from DGConceptosER
			where DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DGCiddest#">
		</cfquery>
		<cfset vConceptosdest[1] = rsConceptos.DGCid >
		<cfset vConceptosdest[2] = rsConceptos.DGCcodigo >
		<cfset vConceptosdest[3] = rsConceptos.DGdescripcion >
	</cfif>
	

	<cfif len(trim(data.DGCDid))>
		<cfquery name="rsCriterio" datasource="#session.DSN#">
			select DGCDid, DGCDcodigo, DGCDdescripcion
			from DGCriteriosDistribucion
			where DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DGCDid#">
		</cfquery>
		<cfset vCriterios[1] = rsCriterio.DGCDid >
		<cfset vCriterios[2] = rsCriterio.DGCDcodigo >
		<cfset vCriterios[3] = rsCriterio.DGCDdescripcion >
	</cfif>
	
	
	
</cfif>
			<cfoutput>
			<form style="margin:0" action="gastosDistribuir-sql.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td colspan="4" align="center" bgcolor="##ececff" >
						<table width="100%" cellpadding="0" >
							<tr><td align="center"><font color="##006699"><strong>Gastos por Distribuir</strong></font></td></tr>
						</table>
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="40%"><strong>C&oacute;digo:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="15" maxlength="10" onfocus="this.select()" 
						name="DGGDcodigo" value="<cfif isdefined("data.DGGDcodigo")>#trim(data.DGGDcodigo)#</cfif>" >
					</td>
				</tr>	
				
				<tr>
					<td align="right" valign="middle" width="1%"><strong>Descripci&oacute;n:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="50" maxlength="80" onfocus="this.select()" 
							name="DGGDdescripcion" value="<cfif isdefined("data.DGGDdescripcion")>#trim(data.DGGDdescripcion)#</cfif>">
					</td>
				</tr>
				
				<tr height="30">
					<td align="right" valign="top"><strong>Distribuir utilizando criterio:&nbsp;</strong></td>
					<td>
						<table width="100%" cellpadding="1" cellspacing="0">
							<tr height="30">
								<td valign="middle" width="1%"><input type="radio" name="tipo" value="70" onclick="javascript:mostrar_campos(this.value);" <cfif modo neq 'ALTA'><cfif len(trim(data.DGCDid)) >checked="checked"</cfif><cfelse>checked="checked"</cfif>   /></td>
								<td width="1%" nowrap="nowrap"><strong>Criterio de Distribuci&oacute;n:&nbsp;</strong></td>
								<td id="idCriterio" height="30">
									<cf_conlis
										campos="DGCDid, DGCDcodigo, DGCDdescripcion"
										desplegables="N,S,S"
										modificables="N,S,N"
										size="0,10,30"
										title="Lista de Criterios"
										tabla="DGCriteriosDistribucion"
										columnas="DGCDid, DGCDcodigo, DGCDdescripcion"
										filtro="CEcodigo=#SESSION.CECODIGO# order by DGCDcodigo, DGCDdescripcion"
										desplegar="DGCDcodigo, DGCDdescripcion"
										filtrar_por="DGCDcodigo, DGCDdescripcion"
										etiquetas="Código, Descripción"
										formatos="S,S"
										align="left,left"
										asignar="DGCDid, DGCDcodigo, DGCDdescripcion"
										asignarformatos="S, S, S"
										showEmptyListMsg="true"
										EmptyListMsg="-- No se encontraron Criterios --"
										tabindex="1"
										valuesArray="#vCriterios#" >

								</td>
							</tr>
							<tr height="30">
								<td valign="middle" width="1%"><input type="radio" name="tipo" value="20" onclick="javascript:mostrar_campos(this.value);" <cfif modo neq 'ALTA'><cfif len(trim(data.DGCid)) >checked="checked"</cfif></cfif> /></td>
								<td width="1%" nowrap="nowrap"><strong>Concepto de ER:&nbsp;</strong></td>
								<td id="idConcepto"  height="30">
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
										tabindex="1"
										valuesArray="#vConceptos#" >
								</td>
							</tr>
							<tr id="idTipo" height="30">
								<td colspan="2"></td>
								<td  height="30">
										<select name="Criterio" tabindex="1" >
											<option value="30" <cfif  isdefined("data.Criterio") and data.Criterio eq 30 >selected</cfif>>Presupuesto Acumulado</option>
											<option value="40" <cfif  isdefined("data.Criterio") and data.Criterio eq 40 >selected</cfif>>Real Acumulado</option>
											<option value="50" <cfif  isdefined("data.Criterio") and data.Criterio eq 50 >selected</cfif>>Presupuesto Mes</option>
											<option value="60" <cfif  isdefined("data.Criterio") and data.Criterio eq 60 >selected</cfif>>Real Mes</option>
										</select>

								</td>
							</tr>
							
						</table>
					</td>
				</tr>
				
				<tr>
					<td align="right" valign="middle" width="40%"><strong>Concepto ER destino:</strong></td>
					<td>
						<cf_conlis
							campos="DGCiddest, DGCcodigodest, DGdescripciondest"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,30"
							
							title="Lista de Conceptos"
							tabla="DGConceptosER"
							columnas="DGCid as DGCiddest, DGCcodigo as DGCcodigodest, DGdescripcion as DGdescripciondest"
							filtro="CEcodigo=#SESSION.CECODIGO# order by DGCcodigo, DGdescripcion"
							
							desplegar="DGCcodigodest, DGdescripciondest"
							filtrar_por="DGCcodigo, DGdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="DGCiddest, DGCcodigodest, DGdescripciondest"
							asignarformatos="S, S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Conceptos --"
							tabindex="1"
							valuesArray="#vConceptosdest#" >
					</td>
				</tr>
				
				<cfset botonextra = '' >
				<cfset botonextravalues = '' >
				<cfif isdefined("form.proceso")>
					<cfset botonextra = ',Procesar' >
					<cfset botonextravalues = ',Proceso de Distribucion' >
				</cfif>
				<tr>
					<td colspan="2" align="center"><cf_botones modo="#modo#" include="Regresar#botonextra#" includevalues="Regresar#botonextravalues#"></td>
				</tr>
			</table>
			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<cfif modo eq 'CAMBIO' >
				<input type="hidden" name="DGGDid" value="#form.DGGDid#" /> 
			</cfif>

			<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo))>
				<input type="hidden" name="filtro_DGGDcodigo" value="#form.filtro_DGGDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGGDdescripcion") and len(trim(form.filtro_DGGDdescripcion))>
				<input type="hidden" name="filtro_DGGDdescripcion" value="#form.filtro_DGGDdescripcion#"  /> 
			</cfif>

			<cfif isdefined("form.filtro_DGCDcodigo") and len(trim(form.filtro_DGCDcodigo))>
				<input type="hidden" name="filtro_DGCDcodigo" value="#form.filtro_DGCDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGCDdescripcion") and len(trim(form.filtro_DGCDdescripcion))>
				<input type="hidden" name="filtro_DGCDdescripcion" value="#form.filtro_DGCDdescripcion#"  /> 
			</cfif>

			<input type="hidden" name="tipo2" value="" />
			
			<cfif isdefined("form.proceso")>
				<input type="hidden" name="proceso" value="ok" />
				<input type="hidden" name="periodo" value="#form.periodo#" />
				<input type="hidden" name="mes" value="#form.mes#" />
			</cfif>
			
			
			
		</form>
		</cfoutput>
		
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
			objForm.DGGDcodigo.required = true;
			objForm.DGGDcodigo.description = 'Código';			
			objForm.DGGDdescripcion.required = true;
			objForm.DGGDdescripcion.description = 'Descripción';			
			objForm.DGCiddest.required = true;
			objForm.DGCiddest.description = 'Concepto ER destino';

			
			function deshabilitarValidacion(){
				objForm.DGGDcodigo.required = false;
				objForm.DGGDdescripcion.required = false;
				objForm.DGCDid.required = false;
				objForm.DGCid.required = false;
				objForm.DGCiddest.required = false;
			}
			
			function mostrar_campos(valor){
				var obj = document.form1.tipo;

/*
				var valor = 20;
				if ( obj[1].checked ){
					valor = 70;
				}
				*/
				
				if ( valor == 20  ){
					document.getElementById("idConcepto").style.display = '';
					document.getElementById("idCriterio").style.display = 'none';
					document.getElementById("idTipo").style.display = '';

					objForm.DGCid.required = true;
					objForm.DGCid.description = 'Concepto';					
					objForm.DGCDid.required = false;
					document.form1.tipo2.value = '20';
					
					
				}
				if ( valor == 70  ){
					document.getElementById("idConcepto").style.display = 'none';
					document.getElementById("idCriterio").style.display = '';
					document.getElementById("idTipo").style.display = 'none';
					
					objForm.DGCid.required = false;
					objForm.DGCDid.required = true;
					objForm.DGCDid.description = 'Criterio';
					document.form1.tipo2.value = '70';
					
				}
				if ( valor == 30 || valor == 40  || valor == 50  || valor == 60 ){
					document.getElementById("idConcepto").style.display = 'none';
					document.getElementById("idCriterio").style.display = 'none';
					document.getElementById("idTipo").style.display = 'none';					
					
					objForm.DGCid.required = false;
					objForm.DGCDid.required = false;
					
				}
			
			}
			
			if ( document.form1.tipo[0].checked ){
				mostrar_campos(70);
			}
			else{
				mostrar_campos(20);
			}
			
			<cfif isdefined("form.proceso")>
				<cfoutput>
				function funcProcesar(){
					location.href = '/cfmx/sif/dg/operacion/gastosDistribuir-verificacion.cfm?periodo=#form.periodo#&mes=#form.mes#';
					return false;
				}
				</cfoutput>	
			</cfif>
			

		</script>
