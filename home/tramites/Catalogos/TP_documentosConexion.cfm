<cfif isdefined("Form.id_metodo")>
	<cfparam name="Form.id_metodo1" default="#Form.id_metodo#">
<cfelseif isdefined("Form.id_metodo1")>
	<cfparam name="Form.id_metodo" default="#Form.id_metodo1#">
</cfif>

<cfif isdefined("Form.id_documento") AND Len(Trim(Form.id_documento)) GT 0 >
	<!--- <cfquery name="rsDatosC" datasource="#session.tramites.dsn#">
		select * 
		from TPDocumento
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
	</cfquery> --->
	<cfquery name="rsWSServicios" datasource="#session.tramites.dsn#">
		select 
			id_documento, 
			id_servicio, 
			nombre_servicio, 
			con_url, 
			con_usuario, 
			con_passwd,
			proxy_servidor,
			proxy_puerto, 
			BMUsucodigo, 
			BMfechamod,
			ts_rversion
		from WSServicio
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#">
		<cfif isdefined("form.id_servicio")>
			and id_servicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">
		</cfif>
	</cfquery>
	
	<cfquery name="rslista" datasource="#session.tramites.dsn#">
		select 
			id_documento, 
			id_servicio, 
			nombre_servicio, 
			con_url, 
			con_usuario, 
			con_passwd, 
			proxy_servidor,
			proxy_puerto, 
			BMUsucodigo, 
			BMfechamod,
			ts_rversion
		from WSServicio
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#">
	</cfquery>
	
</cfif>

<!---
<cfdump var="#form#">
<cfdump var="#url#">
--->

<cfparam name="form.id_servicio" default="7">

<cfif not isdefined("form.tab")>
	<cfset form.tab = "2">
</cfif>


<cfoutput>
<cfif not isdefined("form.modo2")>
	<cfset form.modo2 = "ALTA">
</cfif>
<form method="post" name="formC" action="TP_documentosConexion_sql.cfm" onsubmit="return validarC();">
	<input name="modo2" value="#form.modo2#" type="hidden"> 
	<input name="tab" value="#form.tab#" type="hidden">
	<table width="95%" cellpadding="0" cellspacing="0"  align="center">
		<tr>
			<td bgcolor="##ECE9D8" style="padding:3px;" colspan="5"><font size="1">Configuraci&oacute;n de Servicios Externos de Conexi&oacute;n</font></td>
		</tr>
		<tr>
			<td width="30%" valign="top">
				<table align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td nowrap align="right"><strong>Servicio:</strong></td>
						<td>
							<select onChange="javascript: if(this.value=='') { return;} document.formC.modo2.value='CAMBIO'; if (document.formC.id_metodo1) {document.formC.id_metodo1.value='';} document.formC.submit();" name="id_servicio">
								<cfif modo2 eq 'ALTA'>
									<option value="">(Nuevo)</option>
								</cfif>
								<cfset Lvarid_servicio = form.id_servicio>
								<cfloop query="rslista">
									<option value="#rslista.id_servicio#" <cfif modo2 eq 'CAMBIO' and isdefined("rslista") and (rslista.id_servicio eq Lvarid_servicio)  > selected</cfif>>#rslista.nombre_servicio#</option>
								</cfloop>
							
							</select>
						</td>
					</tr>
					<tr>
						<td nowrap align="right">Nombre&nbsp;del&nbsp;Servicio:</td>
						<td>
							<input name="nombre_servicio" type="text" value="<cfif modo2 eq 'CAMBIO' and isdefined("rsWSServicios") and len(trim(rsWSServicios.nombre_servicio))>#rsWSServicios.nombre_servicio#</cfif>" size="50" maxlength="255">
						</td>
					</tr>
					<tr valign="baseline"> 
						<td nowrap align="right">Direcci&oacute;n URL:</td>
						<td>
							<input type="text" name="con_url" value="<cfif modo2 eq 'CAMBIO' and isdefined("rsWSServicios")>#trim(rsWSServicios.con_url)#</cfif>" size="50" maxlength="255" onfocus="javascript:this.select();" >
						</td>
					</tr>
					<tr valign="baseline"> 
						<td nowrap align="right">Usuario:</td>
						<td>
							<input type="text" name="con_usuario" value="<cfif modo2 eq 'CAMBIO' and isdefined("rsWSServicios")>#trim(rsWSServicios.con_usuario)#</cfif>" size="50" maxlength="255" onfocus="javascript:this.select();" >
						</td>
					</tr>
					<tr valign="baseline"> 
						<td nowrap align="right">Contrase&ntilde;a:</td>
						<td>
							<input type="password" name="con_passwd" value="<cfif modo2 eq 'CAMBIO' and isdefined("rsWSServicios")>#trim(rsWSServicios.con_passwd)#</cfif>" size="50" maxlength="255" onfocus="javascript:this.select();" >
						</td>
					</tr>	
					<tr valign="baseline"> 
						<td nowrap align="right">Confirmar Contrase&ntilde;a:</td>
						<td>
							<input type="password" name="confir_passwd" value="<cfif modo2 eq'CAMBIO' and isdefined("rsWSServicios")>#trim(rsWSServicios.con_passwd)#</cfif>" size="50" maxlength="255" onfocus="javascript:this.select();" >
						</td>
					</tr>		
					<tr valign="baseline"> 
						<td nowrap align="right">Servidor Proxy:</td>
						<td>
							<input type="text" name="proxy_servidor" value="<cfif modo2 eq 'CAMBIO' and isdefined("rsWSServicios")>#trim(rsWSServicios.proxy_servidor)#</cfif>" size="50" maxlength="255" onfocus="javascript:this.select();" >
						</td>
					</tr>
					<tr valign="baseline"> 
						<td nowrap align="right">Puerto Proxy:</td>
						<td>
							<input type="text" name="proxy_puerto" value="<cfif modo2 eq 'CAMBIO' and isdefined("rsWSServicios")>#trim(rsWSServicios.proxy_puerto)#</cfif>" size="50" maxlength="255" onfocus="javascript:this.select();" >
						</td>
					</tr>
					<tr><td  align="center" colspan="2">&nbsp;</td></tr>
					<tr>
						<td align="center" colspan="2">
							<cfif modo2 eq 'ALTA'>
								<input type="submit" name="btnGuardar" value="Guardar Configuración">
								<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='Tp_DocumentosList.cfm';">
							<cfelse>
								<input type="submit" name="btnModificar" value="Modificar"> 
								<input type="submit" name="btnEliminar" value="Eliminar">
								<input type="submit" name="btnNuevo" value="Nuevo">
							</cfif>
							
						</td>
					</tr>
				</table>
			</td>
			<td width="2%" valign="top">&nbsp;
				
			</td>
			<td width="25%" valign="top">
			
			<!---
				LISTA DE METODOS
			--->
			<cfif modo2 neq 'ALTA'>
				<cfif isdefined("form.MSG1") AND form.MSG1 NEQ "">
					<BR>
					<font color="##FF0000">
						#form.MSG1#
					</font>
				<cfelse>
					<strong><span style="border-bottom:1px solid ##000000">Lista de Funciones</span></strong>
					<BR>&nbsp;
					<cfquery name="rsWSMetodos" datasource="#session.tramites.dsn#">
						select id_metodo, nombre_metodo, clase_input, clase_output,
								case 
									when activo = 0 then ''
									when clase_input = 'E' or clase_output = 'E' then 'ERR'
									else 'OK'
								end as status
						  from WSMetodo
						 where id_servicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">
					</cfquery>
	
					<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsWSMetodos#"/>
						<cfinvokeargument name="desplegar" value="nombre_metodo,status"/>
						<cfinvokeargument name="etiquetas" value="Función, STS"/>
						<cfinvokeargument name="formatos" value="S,S"/>
						<cfinvokeargument name="align" value="left,center"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="TP_documentosConexion_sql.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="incluyeForm" value="no"/>
						<cfinvokeargument name="formName" value="formC"/>
						<cfinvokeargument name="keys" value="id_metodo"/>
					</cfinvoke>
				</cfif>
			</cfif>
			</td>
			<td width="2%" valign="top">&nbsp;
				
			</td>
			<td width="35%" valign="top">
			<!---
				LISTA DE PARAMETROS Y RESULTADOS
			--->
			<cfif modo2 neq 'ALTA' and isdefined("form.id_metodo1") and form.id_metodo1 NEQ "">
				<input type="hidden" name="id_metodo1" value="#form.id_metodo1#">
				<cfif isdefined("form.MSG2") AND form.MSG2 NEQ "">
					<BR>
					<font color="##FF0000">
						#form.MSG2#
					</font>
				<cfelse>
					<strong><span style="border-bottom:1px solid ##000000">Funcion: #form.nombre_metodo#</span></strong><BR><BR>&nbsp;
					<cfset LvarHayError = (form.clase_input EQ "E" OR form.clase_output EQ "E")>
					<cfloop index="i" from="1" to="2">
						<cfif i EQ 1>
							<cfset LvarDireccion = "I">
							<cfset LvarNombre_Direccion = "Parametros">
							<cfset LvarClase_Direccion = "input">
							<cfset LvarTitulo = "No se requiere enviar datos">
						<cfelse>
							<cfset LvarDireccion = "O">
							<cfset LvarNombre_Direccion = "Resultados">
							<cfset LvarClase_Direccion = "output">
							<cfset LvarTitulo = "No se generan datos de salida">
						</cfif>
						<table width="100%" border="0" cellspacing="0" style="border:1px solid ##FF ">
							<tr>
								<td colspan="2">
									<strong>
										#LvarNombre_Direccion# de la Función:<BR>&nbsp;&nbsp;
										<cfset LvarClase = evaluate("form.clase_#LvarClase_Direccion#")>
										<cfif LvarClase EQ "E">
											<font color="##FF0000">
												(Datos no compatibles)
											</font>
										<cfelseif LvarClase EQ "N">
											#LvarTitulo#
										<cfelseif LvarClase EQ "A">
											(Lista variable de Datos)
										<cfelse>
											(Un solo conjunto de Datos)
										</cfif>
									</strong><BR>&nbsp;
								</td>
							</tr>
						<cfquery name="rsWSDatos" datasource="#session.tramites.dsn#">
							select id_dato, nombre_dato, tipo_dato, tipo_valor, valor, id_campo
							  from WSDato
							 where id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_metodo1#">
							   and direccion = '#LvarDireccion#'
						</cfquery>
						<cfquery name="rsDDTipoDato" datasource="#session.tramites.dsn#">
							select id_campo, nombre_campo
							  from TPDocumento d
							  		inner join DDTipoCampo tc
										on tc.id_tipo = d.id_tipo
							 where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#">
						</cfquery>
							<tr>
								<td width="50%" style="background-color:##CCCCCC;"><strong>Campo</strong> /</td>
								<td width="50%" style="background-color:##CCCCCC;">Tipo&nbsp;Dato /</td>
							</tr>
							<tr>
								<td colspan="2" style="background-color:##CCCCCC;">&nbsp;Tipo&nbsp;Valor&nbsp;&nbsp;Valor</td>
							</tr>
							<cfset LvarStyle = "ListaPar">
							<cfloop query="rsWSDatos">
							  <cfif LvarStyle EQ "ListaPar"><cfset LvarStyle = "ListaNon"><cfelse><cfset LvarStyle = "ListaPar"></cfif>
							<tr class="#LvarStyle#">
								<td class="#LvarStyle#">
									<strong>#rsWSDatos.nombre_dato#</strong>
									<input type="hidden" name="id_dato" value="#rsWSDatos.id_dato#">
								</td>
								<td class="#LvarStyle#">
									<cfif rsWSDatos.tipo_dato EQ "E">
										<font color="##FF0000">
											#rsWSDatos.valor#
										</font>
									<cfelseif rsWSDatos.tipo_dato EQ "N">
										Numérico
									<cfelseif rsWSDatos.tipo_dato EQ "S">
										Caracter
									<cfelseif rsWSDatos.tipo_dato EQ "F">
										Fecha
									<cfelseif rsWSDatos.tipo_dato EQ "B">
										Lógico&nbsp;(S/N)
									<cfelseif rsWSDatos.tipo_dato EQ "I">
										Imagen
									<cfelse>
										N/A
									</cfif>
								</td>
							</tr>
						<cfif NOT LvarHayError>
							<tr class="#LvarStyle#">
								<td colspan="2" class="#LvarStyle#">
									<table width="100%">
										<tr>
											<td width="10%">
												<select name="tipo_valor_#rsWSDatos.id_dato#" onChange="sbCambioTipoValor('#rsWSDatos.id_dato#');">
													<option value="D" <cfif rsWSDatos.tipo_valor NEQ "V">selected</cfif>>Dato</option>
													<option value="V" <cfif rsWSDatos.tipo_valor EQ  "V">selected</cfif>><cfif i EQ 1>Valor<cfelse>Ignorar</cfif></option>
												</select>
											</td>
											<td width="90%">
												<div id="div_D_#rsWSDatos.id_dato#" <cfif rsWSDatos.tipo_valor EQ "V">style="display:none"</cfif>>
												&nbsp;
												<select name="id_campo_#rsWSDatos.id_dato#" id="id_campo_#rsWSDatos.id_dato#">
												<cfif i EQ 1>
													<option value="Cedula" <cfif rsWSDatos.tipo_valor EQ "T" AND rsWSDatos.valor EQ "Cedula">selected</cfif>>Cedula</option>
													<option value="Numero Tramite" <cfif rsWSDatos.tipo_valor EQ "T" AND rsWSDatos.valor EQ "Numero Tramite">selected</cfif>>Numero Tramite</option>
													<option value="" disabled>---------------------------</option>
												</cfif>
													<cfset LvarIdDato = rsWSDatos.id_dato>
													<cfset LvarIdCampo = rsWSDatos.id_campo>
													<cfset LvarTipoValor = rsWSDatos.tipo_valor>
													<cfloop query="rsDDTipoDato">
														<option value="#rsDDTipoDato.id_campo#" <cfif LvarTipoValor EQ "D" AND rsDDTipoDato.id_campo EQ LvarIdCampo>selected</cfif>>#rsDDTipoDato.nombre_campo#</option>
													</cfloop>
												</select>
												</div>
												<div id="div_V_#rsWSDatos.id_dato#" <cfif rsWSDatos.tipo_valor NEQ "V">style="display:none"</cfif>>
												&nbsp;
												<input type="<cfif i EQ 1>text<cfelse>hidden</cfif>" name="valor_#rsWSDatos.id_dato#" id="valor_#rsWSDatos.id_dato#" value="<cfif rsWSDatos.tipo_valor EQ "V">#rsWSDatos.valor#</cfif>" size="50">
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</cfif>
							</cfloop>
						</table>
						<BR>&nbsp;
					</cfloop>
					<cfif NOT LvarHayError>
						<table width="100%" border="0" cellspacing="0">
							<tr>
								<td colspan="6" align="center">
									<input type="submit" name="btnGuardarDatos" value="Guardar">
									<input type="submit" name="btnEliminarDatos" value="Eliminar">
									<input type="button" name="btnProbar" value="Probar"
										 onClick="window.open('TP_documentosConexion_wsprobar.cfm?M=#form.id_metodo1#');"
									>
								</td>
							</tr>
						</table>
						<BR>&nbsp;
					</cfif>
				</cfif>
			</cfif>
			</td>
		</tr>
	</table>
	
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsWSServicios.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="id_documento" value="#form.id_documento#">
</form>
</cfoutput>


		<script type="text/javascript" language="javascript1.2">
			document.forms["formC"].nosubmit = false;
			function validarC(){
				var msj = '';
				//if ( !document.formC.con_tipo1.checked ){
					if ( document.formC.con_url.value == '' ){
						var msj = msj + ' - Dirección del Servicio es requerido.\n';
					}
					if ( document.formC.con_usuario.value != '' && document.formC.con_passwd.value == '' ){
						var msj = msj + ' - El password es requerido.\n';
					}	
					if ( document.formC.con_passwd.value != document.formC.confir_passwd.value ){
						var msj = msj + ' - La contraseña de confirmación es diferente \n';
					}												
				//}
				if ( msj != ''){
					msj = 'Se presentaron los siguientes errores:\n' + msj;
					alert(msj)
					return false;
				}
				return true
			}
			function sbCambioTipoValor(id_dato)
			{
				var LvarTipoValor = document.getElementById ("tipo_valor_" + id_dato).value;
				var LvarDiv_D = document.getElementById ("div_D_" + id_dato);
				var LvarDiv_V = document.getElementById ("div_V_" + id_dato);
				
				if (LvarTipoValor == "D")
				{
					LvarDiv_D.style.display = '';
					LvarDiv_V.style.display = 'none';
				}
				else
				{
					LvarDiv_D.style.display = 'none';
					LvarDiv_V.style.display = '';
				}
			}
			
		</script>
		
<!--- //document.formC.action="TP_Documentos.cfm";
				//document.formC.submit();
			<cfoutput>
			function funcNuevo(){
				location.href="TP_Documentos.cfm?id_documento=#form.id_documento#&tab=2&ii='ooo'";
				return false;
			}
			</cfoutput>
				
				 --->
