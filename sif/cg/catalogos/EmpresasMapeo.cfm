<cfinvoke key="LB_Titulo" default="Mapeo de Cuentas por Empresa" returnvariable="LB_Titulo" component="sif.Componentes.Translate" 
method="Translate" xmlfile="EmpresasMapeo.xml"/>
<cfinvoke key="LB_Empresa" default="Empresa" returnvariable="LB_empresa" component="sif.Componentes.Translate" method="Translate" 
xmlfile="EmpresasMapeo.xml"/>

<cfif isdefined("LvarInfo")>
	<cfset LvarAction   = 'EmpresasMapeo_sql_Inf.cfm'>
	<cfset LvarIrA      = 'EmpresasMapeoInf.cfm'>
	<cfset LvarRegresar = 'TipoMapeoCuentasINFO.cfm'>
<cfelse>
	<cfset LvarAction   = 'EmpresasMapeo_sql.cfm'>
	<cfset LvarIrA      = 'EmpresasMapeo.cfm'>
	<cfset LvarRegresar = 'TipoMapeoCuentas.cfm'>
</cfif>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfif isdefined("Form.Cambio")>
			<cfset modo="CAMBIO">
		<cfelse>
			<cfif not isdefined("Form.modo")>
				<cfset modo="ALTA">
			<cfelseif Form.modo EQ "CAMBIO">
				<cfset modo="CAMBIO">
			<cfelse>
				<cfset modo="ALTA">
			</cfif>
		</cfif>
		
		<cfif isdefined("url.CGICMid") and Len(trim(url.CGICMid)) and (not isdefined("form.CGICMid") or Len(trim(form.CGICMid)) eq 0)>
			<cfset form.CGICMid = url.CGICMid>
		</cfif>
		<cfif isdefined("form.CGICMid2") and Len(trim(form.CGICMid2)) and (not isdefined("form.CGICMid") or Len(trim(form.CGICMid)) eq 0)>
			<cfset form.CGICMid = form.CGICMid2>
		</cfif>
	
		<cf_navegacion name="CGICMid" default="" session>
		<cf_navegacion name="Ecodigo2" default="" session>

		<cfquery name="rsCGIC_Mapeo" datasource="#Session.DSN#">
			select 
				CGICMid,
				CGICMcodigo,
				CGICMnombre
			from CGIC_Mapeo
			where CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
		</cfquery>
		
		<cfoutput>
			<form action="#LvarAction#" method="post" name="form1">
				<table style="width:100%" border="0" cellpadding="0" cellspacing="2">
					<tr>
						<td style="width:50%; vertical-align:top">
							<cfinvoke 
							  component="sif.Componentes.pListas"
							  method="pLista"
							  returnvariable="pListaRet"
								columnas  			= "Ecodigo as Ecodigo2, Edescripcion, #form.CGICMid# as CGICMid2"
								tabla				= "Empresas"
								filtro				= "1 = 	1 order by Edescripcion"
								desplegar			= "Edescripcion"
								etiquetas			= "#LB_Empresa#"
								formatos			= "S"
								align 				= "Left"
								ajustar				= "S"
								incluyeform			= "false"
								formname			= "form1"
								navegacion			= "#navegacion#"
								mostrar_filtro		= "true"
								filtrar_automatico	= "true"
								showLink			= "true"
								showemptylistmsg	= "true"
								keys				= "Ecodigo2"
								MaxRows				= "15"
								irA					= "#LvarIrA#"
								/>

						</td>
						
						<td style="width:50%; vertical-align:top">
							<cfif isdefined("form.Ecodigo2") and len(trim(form.Ecodigo2)) neq 0>
								<cfquery name="rsCGIC_Empresa" datasource="#Session.DSN#">
									select 
										CGICMid,
										Ecodigo,
										CGICinfo1,
										CGICinfo2,
										CGICinfo3,
										CGICinfo4,
										CGICinfo5,
										CGICinfo6,
										CGICinfo7,
										CGICinfo8,
										CGICinfo9,
										MonedaConvertida 
									from CGIC_Empresa
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo2#">
									  and CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
								</cfquery>
								<cfquery name="rsEmpresa" datasource="#session.DSN#">
									select Ecodigo,
										Edescripcion
									from Empresas
									where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo2#">
								</cfquery>
 								<cfif isdefined("rsCGIC_Empresa") and rsCGIC_Empresa.recordcount gt 0>
									<cfset MODO = 'CAMBIO'>
								<cfelse>
									<cfset MODO = 'ALTA'>
								</cfif>
								<table align="center" border="0">
									<tr align="center">
										<td><strong>#LB_Empresa#: #rsEmpresa.Edescripcion#</strong></td>
									</tr>
									<tr align="center"> 
										<td nowrap><strong><cf_translate key=LB_Mapeo>Mapeo</cf_translate>: #rsCGIC_Mapeo.CGICMcodigo# - #rsCGIC_Mapeo.CGICMnombre#</strong>&nbsp;</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
								</table>
								<table border="0" align="center">
									<tr>
										<td>
											<fieldset><legend><cf_translate key=LB_Datos>Datos</cf_translate><legend>
												<table align="center" border="0">
													<tr valign="baseline"> 
														<td nowrap align="right"><strong>1.</strong>&nbsp;</td>
														<td>			
															<input type="text" name="CGICinfo1" value="<cfif MODO NEQ "ALTA">#rsCGIC_Empresa.CGICinfo1#</cfif>"  size="21" maxlength="20" tabindex="1">
														</td>
														<td nowrap align="right"><strong>2.</strong>&nbsp;</td>
														<td>			
															<input type="text" name="CGICinfo2" value="<cfif MODO NEQ "ALTA">#rsCGIC_Empresa.CGICinfo2#</cfif>"  size="21" maxlength="20" tabindex="1">
														</td>
													</tr>
													<tr valign="baseline">
														<td nowrap align="right"><strong>3.</strong>&nbsp;</td>
														<td>			
															<input type="text" name="CGICinfo3" value="<cfif MODO NEQ "ALTA">#rsCGIC_Empresa.CGICinfo3#</cfif>"  size="21" maxlength="20" tabindex="1">
														</td>
														<td nowrap align="right"><strong>4.</strong>&nbsp;</td>
														<td>			
															<input type="text" name="CGICinfo4" value="<cfif MODO NEQ "ALTA">#rsCGIC_Empresa.CGICinfo4#</cfif>"  size="21" maxlength="20" tabindex="1">
														</td>
													</tr>
													<tr valign="baseline"> 
														<td nowrap align="right"><strong>5.</strong>&nbsp;</td>
														<td>			
															<input type="text" name="CGICinfo5" value="<cfif MODO NEQ "ALTA">#rsCGIC_Empresa.CGICinfo5#</cfif>"  size="21" maxlength="20" tabindex="1">
														</td>
														<td nowrap align="right"><strong>6.</strong>&nbsp;</td>
														<td>			
															<input type="text" name="CGICinfo6" value="<cfif MODO NEQ "ALTA">#rsCGIC_Empresa.CGICinfo6#</cfif>"  size="21" maxlength="20" tabindex="1">
														</td>
													</tr>
													<tr valign="baseline">
														<td nowrap align="right"><strong>7.</strong>&nbsp;</td>
														<td>			
															<input type="text" name="CGICinfo7" value="<cfif MODO NEQ "ALTA">#rsCGIC_Empresa.CGICinfo7#</cfif>"  size="21" maxlength="20" tabindex="1">
														</td>
														<td nowrap align="right"><strong>8.</strong>&nbsp;</td>
														<td>			
															<input type="text" name="CGICinfo8" value="<cfif MODO NEQ "ALTA">#rsCGIC_Empresa.CGICinfo8#</cfif>"  size="21" maxlength="20" tabindex="1">
														</td>
													</tr>
													<tr align="center">
														<td nowrap align="center" colspan="4">
															<strong>9.</strong>&nbsp;<input type="text" name="CGICinfo9" value="<cfif MODO NEQ "ALTA">#rsCGIC_Empresa.CGICinfo9#</cfif>"  size="21" maxlength="20" tabindex="1">
														</td>
													</tr>
												</table>
											</fieldset>
										</td>
									</tr>
									<tr align="center">
										<td colspan="2" align="left">
											<input type="checkbox" name="MonedaConvertida" id="MonedaConvertida" <cfif MODO NEQ "ALTA" and rsCGIC_Empresa.MonedaConvertida eq 1>checked</cfif> value="1" tabindex="1"><label for="MonedaConvertida"><cf_translate key=LB_MonedaConvertida>Moneda Convertida</cf_translate></label>
										</td>
									</tr>
									<tr valign="baseline"> 
										<td colspan="2">
											<input type="hidden" name="CGICMid" value="<cfif isdefined("form.CGICMid")>#form.CGICMid#</cfif>">
											<cf_botones modo="#modo#" form="form1" include="Regresar" exclude='Nuevo' tabindex="1">
										</td>
									</tr>
								</table>
							<cfelse>
							<input type="hidden" name="CGICMid" value="<cfif isdefined("form.CGICMid")>#form.CGICMid#</cfif>">
							&nbsp;
							</cfif>
						</td>
					</tr>
				</table>
			</form>
		</cfoutput>
		<script language="javascript" type="text/javascript">
			function funcRegresar(){
				document.form1.action='<cfoutput>#LvarRegresar#</cfoutput>';
				document.form1.submit();
			}
			<cfif isdefined("form.Ecodigo2") and len(trim(form.Ecodigo2)) neq 0>
				document.form1.CGICinfo1.focus();
			</cfif>
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>