<link href="/cfmx/asp/css/asp.css"  rel="stylesheet" type="text/css">

<cfif isdefined("form.SCuri") and len(trim(form.SCuri)) gt 0>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<!--- Parametros para la navegacion --->
<cfif isdefined("url.fSScodigo") and not isdefined("form.fSScodigo")>
	<cfparam name="form.fSScodigo" default="#url.fSScodigo#">
</cfif>
<cfif isdefined("url.fSMcodigo") and not isdefined("form.fSMcodigo")>
	<cfparam name="form.fSMcodigo" default="#url.fSMcodigo#">
</cfif>
<cfif isdefined("url.fProceso") and not isdefined("form.fProceso")>
	<cfparam name="form.fProceso" default="#url.fProceso#">
</cfif>

<!--- Consulta de sistemas --->
<cfquery name="rsSistemas" datasource="asp">
	select rtrim(SScodigo) as SScodigo, SSdescripcion
	from SSistemas
	order by SScodigo
</cfquery>

<!--- calcula sistema actual ---> 
<cfif isdefined("form.fSScodigo")>
	<cfset sistemaActual = trim(form.fSScodigo) >
<cfelseif not isdefined("form.fSScodigo") and rsSistemas.RecordCount gt 0>
	<cfset sistemaActual = rsSistemas.SScodigo >
</cfif>

<!--- Consulta de modulos --->
<cfif isdefined("sistemaActual")>
	<cfquery name="rsModulos" datasource="asp">
		select rtrim(SMcodigo) as SMcodigo, SMdescripcion
		from SModulos
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#">
		order by SMdescripcion
	</cfquery>

	<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMcodigo)) gt 0>
		<cfset moduloActual = form.fSMcodigo >
	<cfelseif ( not isdefined("form.fSMcodigo") ) and rsModulos.RecordCount gt 0>
		<cfset moduloActual =rsModulos.SMcodigo >
	</cfif>	
</cfif>

<table width="100%" border="0" align="center">
	<cfif isdefined("sistemaActual") and isdefined("moduloActual")>
		<!--- ================================= --->
		<!---               FILTRO              --->
		<!--- ================================= --->
		<cfoutput>
		<tr>
			<td >
				<form name="filtro" action="" method="post" style="margin:0">
					<table class="contenido" width="100%" border="1" cellpadding="0" cellspacing="0">
						<tr class="itemtit">
							<td width="1%" align="left"  ><strong>Sistema</strong></td>
						  <td align="left">
								<select name="fSScodigo" onChange="javascript:document.filtro.fSMcodigo.value='';  document.filtro.submit();">
									<cfloop query="rsSistemas">
										<option value="#rsSistemas.SScodigo#" <cfif sistemaActual eq rsSistemas.SScodigo>selected</cfif>>#rsSistemas.SScodigo#</option>
										<cfif sistemaActual eq rsSistemas.SScodigo>
											<cfset nombreSistema = rsSistemas.SSdescripcion >
										</cfif>
									</cfloop>
								</select>
								<cfif isdefined("nombreSistema")>#nombreSistema#<cfelse>No hay sistemas definidos</cfif>
                                <img src="edit.gif" alt="Editar sistema" width="19" height="17" border="0" onClick="location.href='sistemas.cfm?SScodigo='+escape(filtro.fSScodigo.value)"> </td>
						  <td align="right" rowspan="2" valign="top" >
						  <input type="button" value="Verificar Componentes" onClick="javascript:location.href='componentes-verif.cfm';">
						  </td>
						</tr>
				
						<tr class="itemtit">
							<td align="left"><strong>M&oacute;dulo</strong></td>
						  <td align="left">
								<select name="fSMcodigo" onChange="javascript:document.filtro.submit();">
									<cfloop query="rsModulos">
										<option value="#rsModulos.SMcodigo#" <cfif moduloActual eq rsModulos.SMcodigo>selected</cfif> >#rsModulos.SMdescripcion#</option>					
										<cfif moduloActual eq rsModulos.SMcodigo>
											<cfset nombreModulo =rsModulos.SMdescripcion >
										</cfif>
									</cfloop>
								</select>	
								<cfif isdefined("nombreModulo")>#nombreModulo#<cfelse>No hay m&oacute;dulos definidos</cfif>
                                <img src="edit.gif" alt="Editar módulo" width="19" height="17" border="0" onClick="location.href='modulos.cfm?SScodigo='+escape(filtro.fSScodigo.value)+'&fSScodigo='+escape(filtro.fSScodigo.value)+'&SMcodigo='+escape(filtro.fSMcodigo.value)"> </td>
						</tr>
					</table>
				</form>
			</td>
		</tr>
		</cfoutput>
		<!--- ================================= --->
	
		<cfif isdefined("moduloActual")> <!--- cfif 1 --->
			<cfoutput>
	
			<cfif modo NEQ 'ALTA' >
				<cfquery name="rsForm" datasource="asp" maxrows="1">
					select SScodigo, SMcodigo, SPcodigo, SPdescripcion
					from SProcesos
					where SScodigo = '#sistemaActual#'
					and SMcodigo = '#moduloActual#'
				</cfquery>
				
			</cfif>
	
	<!--- ==================================================================== --->
	<!---                          lista de Procesos						   --->
	<!--- ==================================================================== --->
				<!---
				<cfquery name="rsLista" datasource="asp">
					select SPcodigo, SPdescripcion
					from ModulosCuentaE a, SProcesos b
					where b.SScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#">
					and b.SMcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#moduloActual#">
					and a.SScodigo=b.SScodigo
					and a.SMcodigo=b.SMcodigo
					order by b.SScodigo, b.SMcodigo, SPdescripcion
				</cfquery>
				--->
				
				<cfset navegacion = "">
				<cfset additionalCols = "">

				<cfif isdefined("form.fSScodigo") and len(trim(form.fSSCodigo)) gt 0>
					<cfset additionalCols = additionalCols & "'#Form.fSScodigo#' as fSScodigo, ">
					<cfset navegacion = Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSScodigo=" & form.fSScodigo>
				</cfif>

				<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMCodigo)) gt 0>
					<cfset additionalCols = additionalCols & "'#Form.fSMcodigo#' as fSMcodigo, ">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSMcodigo=" & form.fSMcodigo>
				</cfif>
				<cfif isdefined("form.SScodigo") and isdefined("form.SMcodigo") and isdefined("form.SPcodigo")>
	
					<script src="/cfmx/sif/js/qForms/qforms.js"></script>
					<script language="JavaScript1.2" type="text/javascript">
					
						/* ====== QForms ====== */
						// specify the path where the "/qforms/" subfolder is located
						qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
						// loads all default libraries
						qFormAPI.include("*");
						//Funciones que utilizan el objeto Qform.
					
						//definicion del color de los campos con errores de validación para cualquier instancia de qforms
						qFormAPI.errorColor = "##FFFFCC";
						/* ====== QForms ====== */
					</script>
	
					<tr><td>
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<cfquery name="nombreProceso" datasource="asp">
								select SPdescripcion from SProcesos where SPcodigo='#form.SPcodigo#'
							</cfquery>

							<cfif modo neq 'ALTA'>
								<cfquery name="rsTipo" datasource="asp">
									select SCtipo
									from SComponentes
									where SCuri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SCuri#"> 
									  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SPcodigo)#">
									  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SMcodigo)#">
									  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SScodigo)#">
								</cfquery>
							</cfif>
							
							<cfquery name="nombreProceso" datasource="asp">
								select SPdescripcion from SProcesos where SPcodigo='#form.SPcodigo#'
							</cfquery>


							<tr><td colspan="5" bgcolor="##F5F5F5" align="center" class="subTitulo" nowrap><font size="2">Asignaci&oacute;n de Componentes. <br>
							  Proceso: #form.SPcodigo# - #nombreProceso.SPdescripcion# 
							  <cfif len(form.SPcodigo)>
							  <img src="edit.gif" alt="Editar proceso" width="19" height="17" border="0" onClick="location.href='procesos.cfm?SScodigo=#form.SScodigo#&fSScodigo=#form.SScodigo#&SMcodigo=#form.SMcodigo#&fSMcodigo=#form.SMcodigo#&SPcodigo=#form.SPcodigo#'">
							  </cfif></font></td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							<form style="margin:0; " name="form2" method="post" action="componentes-sql.cfm">
								<!--- vienen de la lista--->
								<input type="hidden" name="SScodigo" value="#trim(form.SScodigo)#">
								<input type="hidden" name="SMcodigo" value="#trim(form.SMcodigo)#">
								<input type="hidden" name="SPcodigo" value="#trim(form.SPcodigo)#">
	
								<!--- vienen del filtro --->
								<cfif isdefined("sistemaActual")><input type="hidden" name="fSScodigo" value="#trim(sistemaActual)#"></cfif>
								<cfif isdefined("moduloActual")><input type="hidden" name="fSMcodigo" value="#trim(moduloActual)#"></cfif>
							
								<tr>
									<td>Uri:&nbsp;</td>
									<td align="left">
										<input type="text" name="SCuri" size="80" maxlength="255" value="<cfif modo neq 'ALTA'>#trim(form.SCuri)#</cfif>" onChange="change_uri(this.form)" onFocus="this.select();" >
										<cfif modo neq 'ALTA'><input type="hidden" name="f_SCuri" value="#form.SCuri#"></cfif>
<a href="javascript:conlisFiles()" ><img width="16" height="16" src="foldericon.png" border="0"></a>									</td>
									<td>Tipo:&nbsp;</td>
									<td align="left">
										<select name="SCtipo" onChange="change_uri(this.form)" >
											<option value="P" <cfif isdefined("form.CodSCtipo") and form.CodSCtipo eq 'P'>selected</cfif> >P&aacute;gina</option>
											<option value="D" <cfif isdefined("form.CodSCtipo") and form.CodSCtipo eq 'D'>selected</cfif>  >Directorio (sin subdirectorios)</option>
											<option value="S" <cfif isdefined("form.CodSCtipo") and form.CodSCtipo eq 'S'>selected</cfif> >Subdirectorios</option>
											<option value="O" <cfif isdefined("form.CodSCtipo") and form.CodSCtipo eq 'O'>selected</cfif> >Opci&oacute;n</option>
										</select>
									</td>
									<td align="center">
										<cfif modo neq 'ALTA'>
											<input type="submit" name="Guardar" value="Guardar">
											<input type="submit" name="Eliminar" value="Eliminar" onClick="deshabilitarValidacion();">
											<cfif rsTipo.SCtipo eq 'P'><input type="submit" name="Home" value="Home" onClick="deshabilitarValidacion();"></cfif>
											<input type="submit" name="Nuevo" value="Nuevo" onClick="deshabilitarValidacion();">
										<cfelse>
											<input type="submit" name="Agregar" value="Agregar">
										</cfif>
									</td>
								</tr>	
							</form>
	
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan="5" bgcolor="##F5F5F5" align="center" class="subTitulo"><font size="2">Lista de Componentes</font></td>
							</tr>
	
							<tr><td colspan="5">
								<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
								<cf_dbfunction name="like" args="b.SPhomeuri,a.SCuri #_Cat# '?%'" returnvariable="SPhomeuriLIKESCuri">
							
								<cfinvoke 
								 component="commons.Componentes.pListas"
								 method="pListaRH"
								 returnvariable="pListaRet">
									<cfinvokeargument name="tabla" value="SComponentes a, SProcesos b"/>
									<cfinvokeargument name="columnas" value="#additionalCols# a.SScodigo, a.SMcodigo, a.SPcodigo, a.SCuri, (case a.SCtipo when 'P' then 'Página' when 'O' then 'Opción' when 'D' then 'Directorio' when 'S' then 'Subdirectorio' end) as SCtipo,SCtipo as CodSCtipo, (case when b.SPhomeuri = a.SCuri OR #PreserveSingleQuotes(SPhomeuriLIKESCuri)# then '<img border=''0'' src=''/cfmx/asp/imagenes/home.gif''>' end) as home"/>
									<cfinvokeargument name="desplegar" value="SCuri, SCtipo, home"/>
									<cfinvokeargument name="etiquetas" value="Uri, Tipo, Página Inicial"/>
									<cfinvokeargument name="formatos" value=""/>
									<cfinvokeargument name="filtro" value="a.SScodigo='#trim(form.SScodigo)#' and a.SMcodigo='#trim(form.SMcodigo)#' and a.SPcodigo='#trim(form.SPcodigo)#' and a.SScodigo=b.SScodigo and a.SMcodigo=b.SMcodigo and a.SPcodigo=b.SPcodigo order by a.SCuri"/>
									<cfinvokeargument name="align" value=" left, left, center"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="irA" value="componentes.cfm"/>
									<cfinvokeargument name="maxRows" value="0"/>
									<cfinvokeargument name="keys" value="SScodigo,SMcodigo,SPcodigo,SCuri"/>
									<cfinvokeargument name="form" value="listaComponentes"/>
									<cfinvokeargument name="conexion" value="asp"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
									<cfinvokeargument name="ShowEmptyListMsg" value="true"/>
									<cfinvokeargument name="formName" value="lista2"/>
									<cfinvokeargument name="debug" value="N"/>
								</cfinvoke>
							</td></tr>
						</table>
					</td></tr>
	
					<script type="text/javascript">
						objForm = new qForm("form2");
					
						objForm.SCuri.required = true;
						objForm.SCuri.description="Uri";
						objForm.SCtipo.required = true;
						objForm.SCtipo.description="Tipo";
					
						function deshabilitarValidacion(){
							objForm.SCuri.required  = false;
							objForm.SCtipo.required = false;
						}
						form2.SCuri.focus();
	
					</script>
				</cfif>
				<tr>
					<td colspan="2" bgcolor="##F5F5F5" align="center" class="subTitulo"><font size="2">Lista de Procesos</font></td>
				</tr>
				
				<tr><td>
						
				<cfinvoke 
					 component="commons.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="SSistemas a, SModulos b, SProcesos c "/>
						<cfinvokeargument name="columnas" value="#additionalCols# rtrim(c.SScodigo) as SScodigo, rtrim(c.SMcodigo) as SMcodigo, rtrim(c.SPcodigo) as SPcodigo, c.SPdescripcion"/>
						<cfinvokeargument name="desplegar" value="SPcodigo, SPdescripcion"/>
						<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="filtro" value="c.SScodigo='#sistemaActual#' and c.SMcodigo='#moduloActual#' and a.SScodigo=b.SScodigo and b.SMcodigo=c.SMcodigo and b.SScodigo=c.SScodigo order by c.SPorden, SPdescripcion"/>
						<cfinvokeargument name="align" value=" left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="componentes.cfm"/>
						<cfinvokeargument name="maxRows" value="0"/>
						<cfinvokeargument name="keys" value="SPcodigo,SMcodigo,SScodigo"/>
						<cfinvokeargument name="conexion" value="asp"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="ShowEmptyListMsg" value="true"/>
					</cfinvoke>
				</td></tr>
				
			</cfoutput>
		<cfelse>
			<tr><td align="center" colspan="5"><b>Debe definir los m&oacute;dulos para este Sistema</b></td></tr>
		</cfif> <!--- cfif 1 --->

	
	<cfelseif not isdefined("sistemaActual")>
		<cfoutput>
		<tr><td>&nbsp;</td></tr>
		<tr><td><b><font size="2">No han sido definidos los sistemas.</font></b></td></tr>
		<tr><td>&nbsp;</td></tr>
		</cfoutput>
	<cfelseif not isdefined("moduloActual")>
		<cfoutput>
		<tr><td>&nbsp;</td></tr>
		<tr><td><b><font size="2">No han sido definidos los módulos.</font></b></td></tr>
		<tr><td>&nbsp;</td></tr>
		</cfoutput>
	</cfif>

</table>

<script type="text/javascript">
	<cfif isdefined("moduloActual")>
		function change_uri(f) {
			f.SCuri.value = f.SCuri.value.
				replace(/\\/g, '/').
				replace(/^https?:\/\/([A-Za-z0-9._]+)(:[0-9]{1,5})?/,'').
				replace(/^\/cfmx/, '').
				replace(/^[A-Za-z]:/,'');
				
			if (f.SCuri.value.indexOf('?') >= 0) {
				f.SCuri.value = f.SCuri.value.substring(0,f.SCuri.value.indexOf('?'));
			}
			
			if (f.SCuri.value.charAt(0) != '/') {
				f.SCuri.value = "/" + f.SCuri.value;
			}
			if (f.SCtipo.value == 'S' || f.SCtipo.value == 'D') {
				if (f.SCuri.value.charAt(f.SCuri.value.length-1) != '/') {
					f.SCuri.value += "/";
				}
			} else if (f.SCuri.value.charAt(f.SCuri.value.length-1) == '/') {
				f.SCuri.value = f.SCuri.value.substring(0,f.SCuri.value.length-1);
			}
		}
	</cfif>

	
	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}
	
	function conlisFiles(){
		closePopup();
		window.gPopupWindow = window.open('files.cfm?p='+escape(form2.SCuri.value),'_blank','left=50,height=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup;
	}
	
	function conlisFilesSelect(filename){
		form2.SCuri.value = filename;
		closePopup();
		window.focus();
		form2.SCuri.focus();
	}
</script>