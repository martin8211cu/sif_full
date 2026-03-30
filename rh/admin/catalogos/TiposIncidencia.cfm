<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ConceptosDePago" default="Conceptos de Pago" returnvariable="LB_ConceptosDePago" component="sif.Componentes.Translate" method="Translate"/>	 
<cfinvoke key="LB_CODIGO" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_DESCRIPCION" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_METODO" default="M&eacute;todo" xmlfile="/rh/generales.xml" returnvariable="LB_METODO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" xmlfile="/rh/generales.xml" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" xmlfile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">		    	            
				<script language="javascript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>                  
				<cf_web_portlet_start titulo="#LB_ConceptosDePago#">
					<cfset regresar = "/cfmx/rh/indexAdm.cfm">
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarStatusText = ArrayNew(1)>			 
					<cfset navBarItems[1] = "Administraci&oacute;n de N&oacute;mina">
					<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
					<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top"> 
							<td width="50%"> 
								<!-------------------------------------------------------------- Filtro -------------------------------------------------------------->	
								<cfif isDefined("Url.FCIcodigo") and not isDefined("Form.FCIcodigo")>
									<cfset Form.FCIcodigo = Url.FCIcodigo>
								</cfif>
								<cfif isDefined("Url.FCIdescripcion") and not isDefined("Form.FCIdescripcion")>
									<cfset Form.FCIdescripcion = Url.FCIdescripcion>
								</cfif>
								<cfif isDefined("Url.fMetodo") and not isDefined("Form.fMetodo") >
									<cfset Form.fMetodo = Url.fMetodo >
								</cfif>
			
								<cfset filtro = "">
								<cfset navegacion = "">
			
								<cfset camposExtra = ''>
								<cfif isdefined("Form.FCIcodigo") and Len(Trim(Form.FCIcodigo)) NEQ 0>
									<cfset filtro = filtro & " and upper(CIcodigo) like '%" & #UCase(Form.FCIcodigo)# & "%'">
									<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FCIcodigo=" & Form.FCIcodigo>
									<cfset camposExtra = ", '#form.FCIcodigo#' as FCIcodigo" >
								</cfif>
			
								<cfif isdefined("Form.FCIdescripcion") and Len(Trim(Form.FCIdescripcion)) NEQ 0>
									<cfset filtro = filtro & " and upper(CIdescripcion) like '%" & #UCase(Form.FCIdescripcion)# & "%'">
									<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FCIdescripcion=" & Form.FCIdescripcion>
									<cfset camposExtra = camposExtra & ", '#form.FCIdescripcion#' as FCIdescripcion" >
								</cfif>
			
								<cfif isdefined("Form.fMetodo") and Len(Trim(Form.fMetodo)) gt 0>
									<cfset filtro = filtro & " and CItipo = #form.fMetodo# " >
									<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fMetodo=" & form.fMetodo >
									<cfset camposExtra = camposExtra & ", '#form.fMetodo#' as fMetodo" >
								</cfif>
			
			
								<form style="Margin:0" action="TiposIncidencia.cfm" method="post" name="filtro">
									<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
									  <tr>
										<cfoutput>
										<td nowrap class="fileLabel">#LB_CODIGO#</td>
										<td nowrap class="fileLabel">#LB_DESCRIPCION#</td>
										<td nowrap class="fileLabel">#LB_METODO#</td>
										</cfoutput>
										<td nowrap>&nbsp;</td>
									  </tr>
									  <tr>
										<td nowrap>
											<input name="FCIcodigo" type="text" size="5" maxlength="5" value="<cfif isDefined("FCIcodigo")><cfoutput>#Form.FCIcodigo#</cfoutput></cfif>">
										</td>
										<td nowrap>
											<input name="FCIdescripcion" type="text" size="20" maxlength="80" value="<cfif isDefined("FCIdescripcion")><cfoutput>#Form.FCIdescripcion#</cfoutput></cfif>">
										</td>
			
										<td>
											<select name="fMetodo">
												<option value="" <cfif isdefined("form.fMetodo") and form.fMetodo eq ''>selected</cfif> >Todos</option>
												<option value="0" <cfif isdefined("form.fMetodo") and form.fMetodo eq 0>selected</cfif> >Horas</option>
												<option value="1" <cfif isdefined("form.fMetodo") and form.fMetodo eq 1>selected</cfif> >D&iacute;as</option>
												<option value="2" <cfif isdefined("form.fMetodo") and form.fMetodo eq 2>selected</cfif> >Importe</option>
												<option value="3" <cfif isdefined("form.fMetodo") and form.fMetodo eq 3>selected</cfif> >C&aacute;lculo</option>
											</select>
										</td>
			
										<td nowrap>
											<input name="butFiltrar" type="submit" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
											<input name="resButton" type="button" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onclick="document.filtro.FCIcodigo.value=''; document.filtro.FCIdescripcion.value=''; document.filtro.fMetodo.value='';">
										</td>
									  </tr>
									</table>
								</form>
								<!------------------------------------------------------------------------------------------------------------------------------------>	
								<cfinvoke component="rh.Componentes.pListas"  method="pListaRH" returnvariable="pListaRet">
									<cfinvokeargument name="tabla" 		value="CIncidentes"/>
									<cfinvokeargument name="columnas" 	value="CIid, CIcodigo, CIdescripcion, CIfactor, case CItipo when 0 then 'Horas' when 1 then 'Días' when 2 then 'Importe' when 3 then 'Cálculo' end as dCItipo, CItipo, CInegativo, CIcantmin,CIidexceso, CIcantmax #camposExtra#"/>
									<cfinvokeargument name="desplegar" 	value="CIcodigo, CIdescripcion, dCItipo"/>
									<cfinvokeargument name="etiquetas" 	value="#LB_CODIGO#,#LB_DESCRIPCION#,#LB_METODO#"/>
									<cfinvokeargument name="formatos" 	value=""/>
									<cfinvokeargument name="filtro" 	value="Ecodigo = #Session.Ecodigo# and CIcarreracp = 0 #filtro# order by CIcodigo"/>
									<cfinvokeargument name="align" 		value="left, left, left"/>
									<cfinvokeargument name="ajustar" 	value=""/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" 		value="TiposIncidencia.cfm"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
									<cfinvokeargument name="keys"		value="CIid"/>
								</cfinvoke>
							</td>
							<td width="60%"><cfinclude template="TiposIncidencia-form.cfm"></td>
						</tr>
						<tr valign="top"><td>&nbsp;</td><td>&nbsp;</td></tr>
					</table>
				<cf_web_portlet_end>
				<script language="javascript1.2" type="text/javascript">
					function formular(value){
						document.lista.CIID.value = value;
						document.lista.action = 'TiposIncidencia-formular.cfm';
						document.lista.submit();
						return false;
					}
				</script>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>