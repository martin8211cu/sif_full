<cf_templateheader title="Ayudas en L&iacute;nea">

		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
			
				<td valign="top">
						<cfif isdefined("Url.showbk") and not isdefined("Form.showbk")>
							<cfset Form.showbk = Url.showbk>
						</cfif>						<cfif isdefined("Url.EImodulo") and not isdefined("Form.EImodulo")>
							<cfset Form.EImodulo = Url.EImodulo>
						</cfif>
						<cfif isdefined("url.EIcodigo") and len(trim(url.EIcodigo))>
							<cfset form.fEIcodigo = url.EIcodigo>
						</cfif>
						<cfif isdefined("url.fEIdescripcion") and len(trim(url.fEIdescripcion))>
							<cfset form.fEIdescripcion = url.fEIdescripcion>
						</cfif>
						<cfset filtro = "1=1">
						<cfset navegacion = "">
						<cfif isdefined("Form.EImodulo") and Len(Trim(Form.EImodulo)) NEQ 0 and Trim(Form.EImodulo) NEQ "-1">
							<cfset filtro = filtro & Iif(Len(Trim(filtro)) NEQ 0, DE(" and "), DE("")) & " EImodulo = '#Form.EImodulo#'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EImodulo=" & Form.EImodulo>
						</cfif>
						<cfif isdefined("Form.fEIcodigo") and Len(Trim(Form.fEIcodigo)) NEQ 0 >
							<cfset filtro = filtro & Iif(Len(Trim(filtro)) NEQ 0, DE(" and "), DE("")) & " upper(EIcodigo) like '%#Ucase(Form.fEIcodigo)#%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EIcodigo=" & Form.fEIcodigo >
						</cfif>
						<cfif isdefined("Form.fEIdescripcion") and Len(Trim(Form.fEIdescripcion)) NEQ 0 >
							<cfset filtro = filtro & Iif(Len(Trim(filtro)) NEQ 0, DE(" and "), DE("")) & " upper(EIdescripcion) like '%#Ucase(Form.fEIdescripcion)#%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fEIdescripcion=" & Form.fEIdescripcion>
						</cfif>
						<cfparam name="Form.showbk" default="0">						<cfif Form.showbk NEQ '1'>
							<cfset filtro = filtro & Iif(Len(Trim(filtro)) NEQ 0, DE(" and "), DE("")) & " not EIcodigo like '%.[0-9][0-9][0-9]' ">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "showbk=" & Form.showbk>
						<cfelse>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "showbk=" & Form.showbk>
						</cfif><!---
						<cfquery name="rsModulos" datasource="sifcontrol">
							select modulo, nombre from sdc..Modulo
							where sistema in ('sif','rh')
							and activo = 1
							order by sistema, modulo, nombre
						</cfquery>--->
						<cfquery name="rsModulos" datasource="asp">
							select SScodigo, SMcodigo, SMdescripcion nombre
							from SModulos
							where SScodigo in ('SIF','RH','SACI','TLC')
							order by SScodigo, SMcodigo, SMdescripcion
						</cfquery>
						<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Lista de Encabezados de Importación">
							<form action="ListaImportador.cfm" method="post" style="margin:0">
							<table border="0" cellpadding="2" cellspacing="0" class="areaFiltro" width="100%">
							  <tr>
							  <td><strong><cf_translate  key="LB_Codigo">C&oacute;digo</cf_translate></strong></td>
 							  <td><strong><cf_translate  key="LB_Modulo">M&oacute;dulo</cf_translate>: </strong></td>
								<td><strong><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate>:</strong></td>
								<td>&nbsp;</td>
							  </tr>
							  <tr>
							  	
								<td><input type="text" name="fEIcodigo"  onFocus="javascript:this.select();"   value="<cfif isdefined("form.fEIcodigo")><cfoutput>#form.fEIcodigo#</cfoutput></cfif>" size="12" maxlength="12"></td>
								<td>
									<select name="EImodulo" tabindex="1" onChange="javascript: this.form.submit();">
										<option value="-1" <cfif not isdefined("Form.EImodulo") or (isdefined("Form.EImodulo") and Trim(Form.EImodulo) EQ "-1")> selected</cfif>>(Todos)</option>
										<cfoutput query="rsModulos">
											<cfset modulo = LCase(Trim(rsModulos.SScodigo) & '.' & Trim(rsModulos.SMcodigo))>
											<option value="#modulo#"
											 <cfif isdefined("Form.EImodulo") and Trim(Form.EImodulo) EQ Trim(modulo)> selected</cfif> >
											 #modulo# - #rsModulos.nombre#</option>
										</cfoutput>
									</select>
								</td>
								<td><input type="text" name="fEIdescripcion"  onFocus="javascript:this.select();"   value="<cfif isdefined("form.fEIdescripcion")><cfoutput>#form.fEIdescripcion#</cfoutput></cfif>" size="40" maxlength="40">
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Filtrar"
								Default="Filtrar"
								returnvariable="BTN_Filtrar"/>
																
								
								<input type="submit" name="Btnfiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
								</td>
								<td align="right">
									<input type="checkbox" id="showbk" name="showbk" value="1" <cfif form.showbk is "1">checked </cfif>onClick="javascript: this.form.submit();">
								</td>
								<td><label for="showbk"><cf_translate  key="LB_MostrarBackups">Mostrar backups</cf_translate></label></td>
							  </tr>
							</table>
							</form>
							<table width="100%" cellpadding="0" cellspacing="0" >
								<tr>
									<td>
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Codigo"
										Default="Código"
										returnvariable="LB_Codigo"/> 
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Modulo"
										Default="Módulo"
										returnvariable="LB_Modulo"/> 
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Descripcion"
										Default="Descripción"
										returnvariable="LB_Descripcion"/> 
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Nuevo"
										Default="Nuevo"
										returnvariable="BTN_Nuevo"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Exportar"
										Default="Exportar"
										returnvariable="BTN_Exportar"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Importar"
										Default="Importar"
										returnvariable="BTN_Importar"/>

										
										<cfinvoke 
											component="sif.Componentes.pListas"
											method="pListaRH"
											returnvariable="pListaRet">
												<cfinvokeargument name="conexion" value="sifcontrol"/>
												<cfinvokeargument name="tabla" value="EImportador"/>
												<cfinvokeargument name="columnas" value="EIid, EIcodigo, EImodulo, EIdescripcion, #form.showbk# as showbk "/>
												<cfinvokeargument name="desplegar" value="EIcodigo, EImodulo, EIdescripcion"/>
												<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Modulo#,#LB_Descripcion#"/>
												<cfinvokeargument name="formatos" value="V, V, V"/>
												<cfinvokeargument name="filtro" value="#filtro# order by upper(EIcodigo)" />
												<cfinvokeargument name="align" value="left, left, left"/>
												<cfinvokeargument name="ajustar" value="N"/>
												<cfinvokeargument name="Nuevo" value="Importador.cfm"/>
												<cfinvokeargument name="irA" value="Importador.cfm"/>
												<cfinvokeargument name="botones" value="#BTN_Nuevo#,#BTN_Exportar#,#BTN_Importar#"/>
												<cfinvokeargument name="showEmptyListMsg" value="true"/>
												<cfinvokeargument name="keys" value="EIid, showbk"/>
												<cfinvokeargument name="navegacion" value="#navegacion#"/>
										</cfinvoke>
									</td>
								</tr>
							</table>										
						<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	


<cf_templatefooter>