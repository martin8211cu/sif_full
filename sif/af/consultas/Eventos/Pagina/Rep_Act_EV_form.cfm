<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 5-5-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->

<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfinclude template="../../../portlets/pNavegacion.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		
<cfoutput>
	<form name="form1" method="post" action="Rep_Act_EV_sql.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top" align="center">
			<fieldset><legend>Datos del Reporte</legend>
				<table  width="100%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td nowrap="nowrap" align="right">
							<strong>Categor&iacute;a Desde:</strong>&nbsp;
						</td>
						<td  >
							<cfset params = '' >							
							<cfif isDefined('url.codigodesde')> 
								<cfset params ="#url.codigodesde#,#url.ACinicio#,#url.ACdescripciondesde#">
							</cfif>
							<cf_conlis
								campos="codigodesde, ACinicio, ACdescripciondesde"								
								values="#params#"							 
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
								tabla="ACategoria"
								columnas="ACcodigo as codigodesde, ACcodigodesc as ACinicio, ACdescripcion as ACdescripciondesde"
								filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigodesc"
								desplegar="ACinicio, ACdescripciondesde"
								filtrar_por="ACcodigodesc, ACdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="codigodesde, ACinicio, ACdescripciondesde"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
								tabindex="1">
						</td>
						<td width="10%">&nbsp;</td>
					</tr>
					<tr>
						<td align="right">
							<strong>Categor&iacute;a Hasta:</strong>&nbsp;
						</td>
						<td  >
							<cfset params = '' >
							<cfif isDefined('url.codigohasta')> 
								<cfset params ="#url.codigohasta#,#url.AChasta#,#url.ACdescripcionhasta#">
							</cfif>
							<cf_conlis
								campos="codigohasta, AChasta, ACdescripcionhasta"
								values="#params#"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
								tabla="ACategoria"
								columnas="ACcodigo as codigohasta, ACcodigodesc as AChasta, ACdescripcion as ACdescripcionhasta"
								filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigodesc"
								desplegar="AChasta, ACdescripcionhasta"
								filtrar_por="ACcodigodesc, ACdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="codigohasta, AChasta, ACdescripcionhasta"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
								tabindex="2">
						</td>
						<td width="10%">&nbsp;</td>
					</tr>
					<tr>
						<td class="fileLabel" align="right"><strong>Activo desde:&nbsp;</strong></td>
						<td> 
							 <cfif isDefined('url.AidDesde')>  
								<cfquery name="rsActivoDesde" datasource="#Session.DSN#">
									select Activos.Aid as AidDesde, Activos.Aplaca as AplacaDesde, Activos.Adescripcion as AdescripcionDesde from Activos where 
									Activos.Ecodigo = #session.ecodigo# and Aid= #url.AidDesde# order by Aplaca
								</cfquery>
							<cfelse>
								<cfset rsActivoDesde = QueryNew('Aid')>
				 			</cfif> 
							<cf_sifactivo name="AidDesde" placa="AplacaDesde" desc="AdescripcionDesde" tabindex="3"
							frame="frocupacionDesde" form= "form1" query="#rsActivoDesde#">
						</td>
					</tr>
					<tr>
						<td class="fileLabel" align="right"><strong>Activo hasta:&nbsp;</strong></td>
						<td>
							<cfif isDefined('url.AidHasta')>  
								<cfquery name="rsActivoHasta" datasource="#Session.DSN#">
									select Activos.Aid as AidHasta, Activos.Aplaca as AplacaHasta, Activos.Adescripcion as AdescripcionHasta from Activos where 
									Activos.Ecodigo = #session.ecodigo# and Aid= #url.AidHasta# order by Aplaca
								</cfquery>
							<cfelse>
								<cfset rsActivoHasta = QueryNew('Aid')>
				 			</cfif> 
							<cf_sifactivo name="AidHasta" placa="AplacaHasta" desc="AdescripcionHasta" tabindex="4"
								frame="frocupacionHasta" form= "form1" query="#rsActivoHasta#">
						</td>
					</tr>
					
					<tr>
						<td align="right"><strong>Per&iacute;odo:</strong>&nbsp;</td>
						<td>
						<cfset params = '' >
						<cfif isDefined('url.periodoInicial')> 
								<cfset params ="#url.periodoInicial#">
						</cfif>
						<cf_periodos name="periodoInicial" value="#params#" tabindex="5">
						</td>
					</tr>
					<tr>
						<cfset params = '' >
						<cfif isDefined('url.mesInicial')> 
								<cfset params ="#url.mesInicial#">
						</cfif>
						<td align="right"><strong>Mes:</strong>&nbsp;</td>
						
						<td><cf_meses name="mesInicial" value="#params#"tabindex="6"></td>
					</tr>
					<tr>
						<td align="right"><strong>Estado de Activo:</strong>&nbsp;</td>
						<td>
							<select name="EstadoActivo" tabindex="7">
								<option value="Vigente" 	<cfif isDefined('url.EstadoActivo')and #url.EstadoActivo# eq 'Vigente'>selected </cfif>>   Vigente   </option>
								<option value="Depreciado"  <cfif isDefined('url.EstadoActivo')and #url.EstadoActivo# eq 'Depreciado'>selected </cfif>>Depreciado</option>
								<option value="Retirado"    <cfif isDefined('url.EstadoActivo')and #url.EstadoActivo# eq 'Retirado'> selected </cfif>>  Retirado  </option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td align="right"><strong>Resumido</strong>&nbsp;</td>
						<td>
							<input name="Resumido" type="checkbox" tabindex="8" h   <cfif isDefined('url.Resumido')>checked</cfif>/>
						</td>
					</tr>
					
					<tr >
                    	<td align="center" colspan="2">
                        	<input type="submit" name="Consultar" class="btnConsultar" value="Consultar" tabindex="9" >
                        </td>
                    </tr>
					<tr >
                    	<td align="center" colspan="2">
                        	<input type="button" name="Limpiar" class="btnLimpiar" value="Limpiar" onclick="javascript:funcLimpiar();" tabindex="10">
                        </td>
                    </tr>
				</table>
				</fieldset>
			</td>	
		</tr>
	</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<script language="javascript" type="text/javascript">
	function funcLimpiar(){
		document.form1.codigodesde.value ='';
		document.form1.ACinicio.value ='';
		document.form1.ACdescripciondesde.value ='';
		document.form1.codigohasta.value ='';
		document.form1.AChasta.value ='';		
		document.form1.ACdescripcionhasta.value ='';
		document.form1.AidDesde.value ='';
		document.form1.AplacaDesde.value ='';
		document.form1.AdescripcionDesde.value ='';
		document.form1.AidHasta.value ='';
		document.form1.AplacaHasta.value ='';
		document.form1.AdescripcionHasta.value ='';		 
		document.form1.Resumido.checked =false;
		document.form1.EstadoActivo.selectedIndex = 0;
		document.form1.periodoInicial.selectedIndex = 0;
		document.form1.mesInicial.selectedIndex = 0;						
	}

	objForm.codigodesde.required=true;
	objForm.codigodesde.description='Categoría Desde';
	objForm.codigohasta.required=true;
	objForm.codigohasta.description='Categoría Hasta';
</script>
