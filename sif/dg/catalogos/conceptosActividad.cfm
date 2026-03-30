<cfif isdefined("url.DGAid") and not isdefined("form.DGAid")>
	<cfset form.DGAid = url.DGAid >
</cfif>
<cfif isdefined("url.DGCid") and not isdefined("form.DGCid")>
	<cfset form.DGCid = url.DGCid >
</cfif>
<cfif isdefined("url.DGCADid") and not isdefined("form.DGCADid")>
	<cfset form.DGCADid = url.DGCADid >
</cfif>

<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>
<cfif not isdefined("form.pagenum_lista")>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGAcodigo")	and not isdefined("form.filtro_DGAcodigo")>
	<cfset form.filtro_DGAcodigo = url.filtro_DGAcodigo >
</cfif>
<cfif isdefined("url.filtro_DGAdescripcion")	and not isdefined("form.filtro_DGAdescripcion")>
	<cfset form.filtro_DGAdescripcion = url.filtro_DGAdescripcion >
</cfif>

<cfif not isdefined("form.DGAid")>
	<cf_errorCode	code = "50368" msg = "No se ha seleccionado la actividad.">
</cfif> 

<cfset modo = 'ALTA'>
<cfset vconcepto = arraynew(1) >
<cfset vconcepto[1] = '' >
<cfset vconcepto[2] = '' >
<cfset vconcepto[3] = '' >
<cfif isdefined("form.DGAid") and len(trim(form.DGAid)) and isdefined("form.DGCid") and len(trim(form.DGCid))>
	<cfset modo = 'CAMBIO'>
	
	<cfquery name="data2" datasource="#session.DSN#">
		select a.DGCid, 
			   b.DGCcodigo, 
			   b.DGdescripcion,
			   b.Comportamiento as tipo,
			   case min(b.Comportamiento) when 'O' then 'Objeto de Gasto' else 'Producto' end as Comportamiento,
			   
			   count(1) as total
		from DGConceptosActividadDepto a
		inner join DGConceptosER b
		on b.DGCid=a.DGCid
		where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
		  and a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
		group by a.DGCid, b.DGCcodigo, b.DGdescripcion, b.Comportamiento 
	</cfquery>
</cfif>

	<cfquery name="rsActividad" datasource="#session.DSN#">
		select DGAid, DGAcodigo, DGAdescripcion
		from DGActividades
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
	</cfquery>
	
	<table width="100%" cellpadding="3" bgcolor="#ececff" >
		<tr><td align="center"><font color="#006699"><strong>Conceptos de Estado de Resultados por Actividad</strong></font></td></tr>
		<tr><td align="center"><font color="#006699"><strong>Actividad:&nbsp;<cfoutput>#trim(rsActividad.DGAcodigo)# - #rsActividad.DGAdescripcion#</cfoutput></strong></font></td></tr>
	</table>
	<br />

			<cfoutput>
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td valign="top" width="50%">
							<cfset navegacion = '&tab=2&DGAid=#form.DGAid#' >
							<cfquery name="rsLista" datasource="#session.DSN#">
								select a.DGAid, 
									   a.DGCid,
									   b.DGCcodigo as codigo,
									   b.DGdescripcion as descripcion,
									   count(1) as total

								from DGConceptosActividadDepto a
								
								inner join DGConceptosER b
								on b.DGCid = a.DGCid
									
								where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#" >
								group by a.DGAid, a.DGCid, b.DGCcodigo, b.DGdescripcion
								order by b.DGCcodigo
							</cfquery>
				
							<form style="margin:0" action="conceptosActividad-sql.cfm" method="post" name="lista2" id="lista2" >
							<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet"
							query="#rsLista#"
							desplegar="codigo,descripcion"
							etiquetas="Concepto,Descripcion"
							formatos="S,S"
							align="left,left"
							ira="actividades-tabs.cfm"
							nuevo="actividades-tabs.cfm"
							showemptylistmsg="true"
							showlink="true"
							maxrows="30"
							incluyeForm="false"
							navegacion="#navegacion#"
							pageIndex="2"
							formname="lista2" />
								<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
								<input type="hidden" name="tab" value="2" /> 
					
								<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
									<input type="hidden" name="filtro_DGAcodigo" value="#form.filtro_DGAcodigo#"  /> 
								</cfif>
								<cfif isdefined("form.filtro_DGAdescripcion") and len(trim(form.filtro_DGAdescripcion))>
									<input type="hidden" name="filtro_DGAdescripcion" value="#form.filtro_DGAdescripcion#"  /> 
								</cfif>
					
							</form>							
							
						</td>
						<td valign="top" width="50%">
							<form style="margin:0" action="conceptosActividad-sql.cfm" method="post" name="form2" id="form2" >
							<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
								<tr>
									<td align="right" valign="middle" <cfif modo neq 'ALTA'>width="40%"<cfelse>width="20%"</cfif> nowrap="nowrap"><strong>Concepto:</strong></td>
									<td>
										<CFIF MODO NEQ 'ALTA'>
											#trim(data2.DGCcodigo)# - #data2.DGdescripcion#
											<input type="hidden" name="DGCid" value="#data2.DGCid#" />
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
												tabindex="1"
												form="form2" >
										</CFIF>
									</td>
								</tr>
					
								<CFIF MODO NEQ 'ALTA'>
									<tr>
										<td align="right" valign="middle" nowrap="nowrap"><strong>Comportamiento:</strong></td>
										<td>#trim(data2.comportamiento)#</td>
									</tr>
								</CFIF>			
				
								<tr>
									<td colspan="4" align="center"><cf_botones modo="#modo#" exclude="cambio" include="Regresar" tabindex="2"></td>
								</tr>
							</table>
								<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
								<input type="hidden" name="DGAid" value="#form.DGAid#" /> 
					
								<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
									<input type="hidden" name="filtro_DGAcodigo" value="#form.filtro_DGAcodigo#"  /> 
								</cfif>
								<cfif isdefined("form.filtro_DGAdescripcion") and len(trim(form.filtro_DGAdescripcion))>
									<input type="hidden" name="filtro_DGAdescripcion" value="#form.filtro_DGAdescripcion#"  /> 
								</cfif>
					
							</form>							

						</cfoutput>
						
						<cf_qforms form="form2" objForm="objForm2">
						<script language="javascript1.2" type="text/javascript">
								objForm2.DGCid.required = true;
								objForm2.DGCid.description = 'Concepto';			
							
							function deshabilitarValidacion(){
								objForm2.DGCid.required = false;
							}
							
						</script>

							<cfif isdefined("url.tab2") and not isdefined("form.tab2")>
								<cfset form.tab2 = url.tab2 >
							</cfif>
							<cfif not ( isdefined("form.tab2") and ListContains('1,2', form.tab2) )>
								<cfset form.tab2 = 1 >
							</cfif> 

							<br />
							<cfif isdefined("form.DGAid") and isdefined("form.DGCid") and len(trim(form.DGCid))>
								<cf_tabs width="99%">
									<cf_tab text="Excepciones por Departamento/Concepto" selected="#form.tab2 eq 1#">
										<cfinclude template="deptoConceptoActividad.cfm">
									</cf_tab>
				
									<cf_tab text="Cuentas a eliminar" selected="#form.tab2 eq 2#">
										<cfinclude template="cuentaConceptoActividad.cfm">
									</cf_tab>
								</cf_tabs>
							</cfif>
						</td>
					</tr>
				</table>

