<!--- Paso de URL A FORM --->

<cfif isdefined('url.FAX04CVD') and not isdefined('form.FAX04CVD')>
	<cfparam name="form.FAX04CVD" default="#url.FAX04CVD#">
</cfif>
<cfif isdefined('url.CDCcodigo') and not isdefined('form.CDCcodigo')>
	<cfparam name="form.CDCcodigo" default="#url.CDCcodigo#">
</cfif>
<cfif isdefined('url.FechaI') and not isdefined('form.FechaI')>
	<cfparam name="form.FechaI" default="#url.FechaI#">
</cfif>
<cfif isdefined('url.FechaF') and not isdefined('form.FechaF')>
	<cfparam name="form.FechaF" default="#url.FechaF#">
</cfif>
<cfif isdefined('url.NumeroCotI') and not isdefined('form.NumeroCotI')>
	<cfparam name="form.NumeroCotI" default="#url.NumeroCotI#">
</cfif>
<cfif isdefined('url.NumeroCotF') and not isdefined('form.NumeroCotF')>
	<cfparam name="form.NumeroCotF" default="#url.NumeroCotF#">
</cfif>

<!--- QUERY PARA el tag de Oficinas--->
<cfquery name = "rsOficinas" datasource="#session.DSN#">
	Select Ocodigo, Oficodigo, Odescripcion
    from Oficinas
    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>


<cfquery name="rsClientes" datasource="#Session.DSN#" >
	select CDCcodigo, CDCidentificacion, CDCnombre
	from ClientesDetallistasCorp
	where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">
</cfquery>

<!--- VERIFICA QUE LAS FECHA INICIAL SEA MENOR QUE LA FECHA FINAL, Y SI NO LAS INVIERTE--->

<cfif isdefined("form.FechaI") and len(trim(form.FechaI)) and isdefined("form.FechaF") and len(trim(form.FechAF))>
	<cfset form.FechaI = LSParseDateTime(form.FechaI) >
	<cfset form.FechaF = LSParseDateTime(form.FechaF) >
	<cfif FechaI gt FechaF >
		<cfset tmp = form.FechaI >
		<cfset form.FechaI = form.FechaF >
		<cfset form.FechaF = tmp >
	</cfif>
</cfif>

<!--- VERIFICA QUE LA COTIZACION INICIAL SEA MENOR QUE LA COTIZACION FINAL, Y SI NO LAS INVIERTE--->

<cfif isdefined("form.NumeroCotI") and isdefined("form.NumeroCotF")>
	<cfif NumeroCotI gt NumeroCotF >
		<cfset tmp2 = form.NumeroCotI >
		<cfset form.NumeroCotI = form.NumeroCotF >
		<cfset form.NumeroCotF = tmp2 >
	</cfif>
</cfif>


<cfquery name="rsLista" datasource="#Session.DSN#">
	select NumeroCot, Vigencia, FechaCot, FechaVen, b.CDCnombre, c.FAM21NOM
	from FACotizacionesE a
	
	inner join ClientesDetallistasCorp b
		on a.CDCcodigo = b.CDCcodigo
	<!--- FILTRO POR CLIENTE --->
	<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>
		and a.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
	</cfif>	
				

	inner join FAM021 c
		on a.FAX04CVD = c.FAX04CVD
		<!--- FILTRO POR Vendedor --->
	<cfif isdefined("form.FAX04CVD") and len(trim(form.FAX04CVD))>
		and a.FAX04CVD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAX04CVD#">
	</cfif>		
		
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	 <!--- FILTROS DE FECHAS --->
 	<cfif isdefined("form.FechaI") and len(trim(form.FechaI)) and isdefined("form.FechaF") and len(trim(form.FechAF))> 
  		and a.FechaCot between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaI#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, form.FechaF))#">
 	<cfelseif isdefined("form.FechaI") and len(trim(form.FechaI)) and not isdefined("form.FechaF")>
  		and a.FechaCot >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaI#">
	<cfelseif isdefined("form.FechaF") and len(trim(form.FechaF)) and not isdefined("form.FechaI")>
		and a.FechaCot <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, form.FechaF))#">
	</cfif>
	
	<!--- FILTRO DE COTIZACIONES ---> 
 	<cfif isdefined("form.NumeroCotI")  and Len(Trim(form.NumeroCotI)) and isdefined("form.NumeroCotF")  and Len(Trim(form.NumeroCotF))> 
  		and a.NumeroCot between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCotI#"> and  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCotF#">
 	<cfelseif isdefined("form.NumeroCotI") and Len(Trim(form.NumeroCotI))>
  		and a.NumeroCot >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCotI#">
 	<cfelseif isdefined("form.NumeroCotF") and Len(Trim(form.NumeroCotF))>
		and a.NumeroCot <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCotF#">
	</cfif>
	 	and a.Estatus = 1
		<cfif isdefined ("form.Tipo") and Form.Tipo eq 0>
			and a.FechaVen < convert(datetime, convert(varchar, getdate(), 112))
		</cfif>  
</cfquery>		

	<!--- *** Asigna a la variable navegacion los filtros  --->
		<cfset navegacion = "">
		<cfif isdefined("form.FechaI") and len(trim(form.FechaI)) >
			<cfset navegacion = navegacion & "&FechaI=#form.FechaI#">
		</cfif>
		<cfif isdefined("form.FechaF") and len(trim(form.FechaF)) >
			<cfset navegacion = navegacion & "&FechaF=#form.FechaF#">
		</cfif>
		<cfif isdefined("form.NumeroCotI") and len(trim(form.NumeroCotI)) >
			<cfset navegacion = navegacion & "&NumeroCotI=#form.NumeroCotI#">
		</cfif>
		<cfif isdefined("form.NumeroCotF") and len(trim(form.NumeroCotF)) >
			<cfset navegacion = navegacion & "&NumeroCotF=#form.NumeroCotF#">
		</cfif>
		<cfif isdefined("form.FAX04CVD") and len(trim(form.FAX04CVD)) >
			<cfset navegacion = navegacion & "&FAX04CVD=#form.FAX04CVD#">
		</cfif>
		<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo)) >
			<cfset navegacion = navegacion & "&CDCcodigo=#form.CDCcodigo#">
		</cfif>
		


<cf_templateheader title="Punto de Venta - Anulación de Cotizaciones Vencidas">
	<cf_templatecss>
		
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Anulación de Cotizaciones Vencidas">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<form method="post" name="filtros" action="#GetFileFromPath(GetTemplatePath())#" class="AreaFiltro" style="margin:0;">
							<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td width="50%" valign="top">
										<table width="100%"  border="0" cellspacing="2" cellpadding="0">
										  <tr>
										    <td width="12%" align="right" nowrap><strong>Fecha inicial </strong> </td>
										    <td width="8%" align="left" nowrap>
												<cfif isdefined("Form.FechaI")>
													<cf_sifcalendario form="filtros" value="#LSDateFormat(Form.FechaI,'dd/mm/yyyy')#" name="FechaI">
												<cfelse>
													<cf_sifcalendario form="filtros" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaI">
												</cfif>
											</td>
										    <td width="10%" align="right"><strong>Cliente</strong>
												
											</td>
										    <td width="6%" align="left">
												<cfif isdefined("Form.CDCcodigo")>
													<cf_sifClienteDetCorp form="filtros" modo='ALTA' idquery="#form.CDCcodigo#">
												<cfelse>
													<cf_sifClienteDetCorp form="filtros"  modo='ALTA'>
												</cfif>	
											</td>
										    <td width="19%" align="right"><strong>Cotización Inicial</strong>
												
											</td>
										    <td width="23%" align="left">
												<cfif isdefined("Form.NumeroCotI")>
													<input type="text" name="NumeroCotI" size="20" maxlength="15" value="#Form.NumeroCotI#" >
												<cfelse>
													<input type="text" name="NumeroCotI" size="20" maxlength="15" >
												</cfif>	
											</td>
											<td width="21%" align="center"><strong>Tipo de Cotización</strong>
												
											</td>
											<td width="1%">&nbsp;
											</td>
											
										  </tr>
										  <tr>
										    <td width="12%" align="right" nowrap><strong>Fecha final</strong></td>
										  	<td width="8%" align="left" nowrap>
												<cfif isdefined("Form.FechaF")>
													<cf_sifcalendario form="filtros" value="#LSDateFormat(Form.FechaF,'dd/mm/yyyy')#" name="FechaF">
												<cfelse>
													<cf_sifcalendario form="filtros" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaF">
												</cfif>
											</td>
										    <td width="10%" align="right"><strong>Vendedor</strong>
												
											</td>
										    <td width="6%" align="right">
												<cfif isdefined("Form.FAX04CVD")>
													<cf_sifvendedores form="filtros" id="#Form.FAX04CVD#">
												<cfelse>
													<cf_sifvendedores form="filtros">
												</cfif>
											</td>
										    <td width="19%" align="right"><strong>Cotización Final</strong>
												
											</td>
										    <td width="23%" align="left">
												<cfif isdefined("Form.NumeroCotF")>
													<input type="text" name="NumeroCotF" size="20" maxlength="15" value="#Form.NumeroCotF#" >
												<cfelse>
													<input type="text" name="NumeroCotF" size="20" maxlength="15" >
												</cfif>	
											</td>
											<td width="21%" align="center"><select name="Tipo">
                                              <option value="1">Todas</option>
                                              <option value="0">Vencidas</option>
                                            </select>
												
											</td>
											
										 </tr>
										 <tr>
											<td colspan="7" align="center">&nbsp;</td>
										 </tr>
										 <tr>
											<td align="center" colspan="8">
												<input type="submit" name="bFiltrar" value="Filtrar">
												<input type="submit" name="bLimpiar" value="Limpiar">
											</td>
										</tr>
										 <tr>
										   <td colspan="7" ><strong>
										     <input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);">
                                             <label for="chkTodos">Seleccionar Todos</label>
										   </strong> <strong>										   </strong></td>
									      </tr>
										 <tr>
										   <td colspan="7" >
										   	  <strong>
										     	<label for="chkTodos"></label></strong></td>
									      	
										  </tr>
										 <tr> 
										 </tr>
									</table>
								  </td>
								</tr>
							</table>
						</form>
					</cfoutput>
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="NumeroCot, FechaCot, FechaVen, CDCnombre, FAM21NOM"/>
							<cfinvokeargument name="etiquetas" value="Cotizaci&oacute;n, Fecha, Fecha de Vencimiento, Cliente, Vendedor"/>
							<cfinvokeargument name="formatos" value="V,D,D,V,V"/>
							<cfinvokeargument name="align" value="left, center, center, left, left"/>
							<cfinvokeargument name="ajustar" value="S"/>
							<cfinvokeargument name="irA" value="EliminaCotVencidas-sql.cfm"/>
							<cfinvokeargument name="checkboxes" value="S"/>
							<cfinvokeargument name="keys" value="NumeroCot"/>
							<cfinvokeargument name="formname" value="form1"/>
							<cfinvokeargument name="botones" value="Anular"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/> 
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="maxRows" value="20"/> 
					</cfinvoke>
					
					<script language="javascript" type="text/javascript">
						function Marcar(c) {
							if (c.checked) {
								for (counter = 0; counter < document.form1.chk.length; counter++)
								{
									if ((!document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
										{  document.form1.chk[counter].checked = true;}
								}
								if ((counter==0)  && (!document.form1.chk.disabled)) {
									document.form1.chk.checked = true;
								}
							}
							else {
								for (var counter = 0; counter < document.form1.chk.length; counter++)
								{
									if ((document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
										{  document.form1.chk[counter].checked = false;}
								};
								if ((counter==0) && (!document.form1.chk.disabled)) {
									document.form1.chk.checked = false;
								}
							};
						}
						function funcAnular(){
							var Anula = false;
							if (document.form1.chk) {
								if (document.form1.chk.value) {
									Anula = document.form1.chk.checked;
								} else {
									for (var i=0; i<document.form1.chk.length; i++) {
										if (document.form1.chk[i].checked) { 
											Anula = true;
											break;
										}
									}
								}
							}
							if (Anula) {
								return (confirm("¿Está seguro de que desea Anular las Cotizaciones seleccionadas?"));
							} else {
								alert('Debe seleccionar al menos una Cotización antes de Anular');
								return false;
							}
						}
					</script>
				<cf_web_portlet_end>
<cf_templatefooter>	  