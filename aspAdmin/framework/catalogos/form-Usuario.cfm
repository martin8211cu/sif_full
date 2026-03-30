<!-- Establecimiento del modo -->
<!--- se supone que este mantenimento siempre entra en cambio, a no ser qeu se llame desde otro lado--->
<cfset modo="CAMBIO">

<!--- Consultas --->
<cfif modo neq 'ALTA' >
	<cfquery name="rsForm" datasource="sdc">
		select Usucodigo,Pnombre, Papellido1, Papellido2, TIcodigo,  Pid, Psexo, Pdireccion, Ppais, 
			   isnull(Poficina, '') as Poficina, Pcelular, Pcasa, isnull(Pfax, '') as Pfax, Ppagertel, 
			   Ppagernum, Pemail1, Pemail2, convert(varchar, Pnacimiento, 103) as Pnacimiento
		from Usuario
		where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
	</cfquery>

	<cfquery name="rsPreferencia" datasource="sdc">
		select skin_cfm from UsuarioPreferencia
		where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
	</cfquery>
</cfif>

<cfquery name="rsPais" datasource="sdc">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<cfquery name="rsIdentificacion" datasource="sdc">
	select TIcodigo, TInombre 
	from TipoIdentificacion
</cfquery>

<!--- leer skins del archivo css --->
<cfsetting enablecfoutputonly="yes">
	<cffile action="read" file="#  ExpandPath('/aspAdmin/css/web_portlet.css') #" variable="web_portlet_css">
	<cfset web_portlet_array = ListToArray(web_portlet_css, chr(10) & chr(13))>
	<cfset skin_array = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(web_portlet_array)#" index="i">
		<cfset skin_line = Trim(web_portlet_array[i])>
		<cfif Left(skin_line, 2) EQ "/*" and Right(skin_line,2) EQ "*/">
			<cfset skin_line = Trim(Mid(skin_line, 3, Len(skin_line) - 4))>
			<cfif ListLen(skin_line,":") EQ 3 AND ListGetAt(skin_line,1,":") EQ "name">
				<cfset ArrayAppend(skin_array, ListGetAt(skin_line, 3, ":") & "," & ListGetAt(skin_line, 2, ":"))>
			</cfif>
		</cfif>
	</cfloop>
	<cfset ArraySort(skin_array,"textnocase")>
<cfsetting enablecfoutputonly="no">

<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="1%">&nbsp;</td>
		<td rowspan="2" valign="top">
			<form name="form1" method="post" action="SQLUsuario.cfm">
			<table border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td colspan="2" class="subTitulo"><div align="center">Identificaci&oacute;n</div></td>
				</tr>
				
				<tr>
					<td colspan="2" class="etiqueta">Nombre</td>
				</tr>
				
				<tr>
					<td colspan="2"><input name="Pnombre" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pnombre)#</cfif>" size="30" maxlength="60" onFocus="this.select()" ></td>
				</tr>
				
				<tr>
					<td colspan="2" class="etiqueta">Apellidos</td>
				</tr>
				
				<tr>
					<td colspan="2">
						<input name="Papellido1" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Papellido1)#</cfif>" size="30" maxlength="60" onFocus="this.select()" >
						<input name="Papellido2" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Papellido2)#</cfif>" size="30" maxlength="60" onFocus="this.select()" >
					</td>
				</tr>
				
				<tr>
					<td colspan="2">Identificaci&oacute;n</td>
				</tr><tr>
					<td colspan="2">
						<select name="TIcodigo" class="resultset" title="3">
							<cfloop query="rsIdentificacion">
								<option value="#rsIdentificacion.TIcodigo#" <cfif modo neq 'ALTA' and  rsForm.TIcodigo eq rsIdentificacion.TIcodigo>selected</cfif> >#rsIdentificacion.TInombre#</option>
							</cfloop>
						</select>
						<input name="Pid" type="text" value="<cfif modo neq 'ALTA'>#rsForm.Pid#</cfif>" size="40" maxlength="60" onFocus="this.select()" ></td>
				</tr>
				
				<tr>
					<td ><input type="radio" name="Psexo" value="M" <cfif modo neq 'ALTA' and rsForm.Psexo eq 'M'>checked</cfif>  onFocus="this.select()" >Masculino</td>
					<td>Nacimiento</td>
				</tr>

				<tr>
					<td ><input type="radio" name="Psexo" value="F" <cfif modo neq 'ALTA' and rsForm.Psexo eq 'F'>checked</cfif>  onFocus="this.select()" >Femenino</td>
					<td>
						<cfif modo neq 'ALTA'><cfset value = rsForm.Pnacimiento><cfelse><cfset value = ""></cfif>
						<cf_sifcalendario name="Pnacimiento" value="#value#"></td>	
				</tr>
				
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2" class="etiqueta">
						<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
							<tr>
								<td colspan="2" class="subTitulo" ><div align="center">Ubicaci&oacute;n</div></td>
							</tr><tr>
								<td colspan="2" class="etiqueta">Pa&iacute;s</td>
							</tr>
							
							<tr>
								<td colspan="2" valign="top" >
									<select name="Ppais">
										<cfloop query="rsPais">
											<option value="#rsPais.Ppais#" <cfif modo neq 'ALTA' and  rsForm.Ppais eq rsPais.Ppais>selected</cfif> >#rsPais.Pnombre#</option>
										</cfloop>
									</select>
								</td>
							</tr>
							
							<tr>
								<td colspan="2" class="etiqueta">Direcci&oacute;n</td>
							</tr>
							
							<tr>
								<td colspan="2">
									<textarea name="Pdireccion" cols="50" rows="3" ><cfif modo neq 'ALTA'>#trim(rsForm.Pdireccion)#</cfif></textarea>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				
				<tr>
					<td colspan="2"><br/>
						<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
							<tr>
								<td height="21" colspan="2" class="subTitulo" ><div align="center">Tel&eacute;fonos</div></td>
							</tr>
							
							<tr>
								<td >Oficina</td>
								<td >Celular</td>
							</tr>
							
							<tr>
								<td><input name="Poficina" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Poficina)#</cfif>" size="30" maxlength="30" onFocus="this.select()" ></td>
								<td><input name="Pcelular" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pcelular)#</cfif>" size="30" maxlength="30" onFocus="this.select()" ></td>
							</tr>
							
							<tr>
								<td>Habitaci&oacute;n</td>
								<td>Fax</td>
							</tr>
							
							<tr>
								<td><input name="Pcasa" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pcasa)#</cfif>" size="30" maxlength="30" onFocus="this.select()" ></td>
								<td><input name="Pfax" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pfax)#</cfif>" size="30" maxlength="30" onFocus="this.select()" ></td>
							</tr>
							
							<tr>
								<td>Localizador</td>
								<td>C&oacute;digo Localizador</td>
							</tr>
							<tr>
								<td><input name="Ppagertel" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Ppagertel)#</cfif>" size="30" maxlength="30" onFocus="this.select()" ></td>
								<td><input name="Ppagernum" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Ppagernum)#</cfif>" size="30" maxlength="30" onFocus="this.select()" ></td>
							</tr>
						</table>
					</td>
				</tr>
				
				<tr>
					<td colspan="2" class="etiqueta"><br/>
						<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
							<tr>
								<td colspan="2" class="subTitulo" ><div align="center">Correo Electr&oacute;nico</div></td>
							</tr>
							
							<tr>
								<td >Email (*)</td>
								<td >Email adicional</td>
							</tr>
							
							<tr>
								<td><input name="Pemail1" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pemail1)#</cfif>" size="30" maxlength="60" onFocus="this.select()" ></td>
								<td><input name="Pemail2" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pemail2)#</cfif>" size="30" maxlength="60" onFocus="this.select()" ></td>
							</tr>
							<tr>
								<td colspan="2" align="center"><b> (*) Esta direcci&oacute;n de correo ser&aacute; utilizada por los procesos autom&aacute;ticos de notificaci&oacute;n en los servicios del portal </b></td>
							</tr>
						</table>
					</td>
				</tr>

				<tr>
					<td colspan="2" class="etiqueta"><br/>
						<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
							<tr>
								<td colspan="2" class="subTitulo" ><div align="center">Preferencias</div></td>
							</tr>
							
							<tr>
								<td nowrap >Estilo de Presentación</td>
							</tr>
							
							<tr>
								<td>
									<select name="skin_cfm">
	<cfloop from="1" to="#ArrayLen(skin_array)#" index="i">
		<cfoutput><option value="#ListGetAt(skin_array[i],2)#" <cfif 
			ListGetAt(skin_array[i],2) EQ session.preferences.skin>selected</cfif>>#
			ListGetAt(skin_array[i],1)#</option></cfoutput>
	</cfloop>
</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="center">
						<link href="/cfmx/sif/css/estilos.css" rel="stylesheet" type="text/css">
						<input type="hidden" name="botonSel" value="">
						<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
						<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
						<input type="reset" name="Reset" value="Restablecer">
					</td>
				</tr>
			</table>
			</form>
		</td>

		<td width="1%">&nbsp;</td>

		<td width="50%" valign="top">

			<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
				<tr><td align="center" class="subTitulo" >&nbsp;</td></tr>
				
				<tr>
					<td>
						<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Roles disponibles en mi perfil">
							<cfset query_where = "	select rol from UsuarioPermiso u where u.Usucodigo = #session.Usucodigo# and u.Ulocalizacion = '#session.Ulocalizacion#' and u.activo = 1" >
							<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pLista"
							 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="Rol r"/>
								<cfinvokeargument name="columnas" value="rtrim(r.rol) as rol, r.nombre"/>
								<cfinvokeargument name="desplegar" value="nombre"/>
								<cfinvokeargument name="etiquetas" value="Rol"/>
								<cfinvokeargument name="formatos" value="V"/>
								<cfinvokeargument name="filtro" value="r.activo = 1 and (r.rol = 'sys.public' or r.rol in (#query_where#)) order by r.nombre "/>
								<cfinvokeargument name="align" value="left"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="Conexion" value="sdc"/>
								<cfinvokeargument name="showLink" value="false"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
							</cfinvoke>
						</cf_web_portlet>
					</td>
				</tr>
				
				<tr>
					<td  align="center" class="subTitulo">&nbsp;</td>
				</tr>
				
				<cfset select = "distinct st.nombre as nombre_sistema, s.nombre as nombre_servicio, rtrim(st.sistema) as sistema, rtrim (s.servicio) as servicio" >
				<cfset from = "Sistema st, Modulo m, Servicios s, ServiciosRol sr, Rol r" >
				<cfset where = "s.servicio = sr.servicio and r.rol = sr.rol and r.rol = sr.rol and m.modulo = s.modulo
						    and st.sistema = m.sistema and st.activo = 1 and s.activo = 1 and sr.activo = 1 and r.activo = 1
  							and (sr.rol = 'sys.public' or sr.rol in (
    								select rol from UsuarioPermiso ur
    								where ur.Usucodigo = #session.Usucodigo#
      								  and ur.Ulocalizacion = '#session.Ulocalizacion#'
      								  and ur.activo = 1))
  									  and ((agregacion = '2' and not exists (	select * from ServicioOpcional us1
																	where us1.servicio = s.servicio
																	  and us1.Usucodigo = #session.Usucodigo#
																  	  and us1.Ulocalizacion = '#session.Ulocalizacion#'
																  	  and us1.incluir = 0))
   									or (agregacion = '0' and exists (select * from ServicioOpcional us1
									where us1.servicio = s.servicio
	  								and us1.Usucodigo = #session.Usucodigo#
								  	and us1.Ulocalizacion = '#session.Ulocalizacion#'
	  								and us1.incluir = 1))
   									or (agregacion = '1'))
									order by st.orden, st.nombre, st.sistema, s.orden, s.nombre">

				<tr>
					<td>
						<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Servicios disponibles en mi perfil">
							<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pLista"
							 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="#from#"/>
								<cfinvokeargument name="columnas" value="#select#"/>
								<cfinvokeargument name="desplegar" value="nombre_servicio"/>
								<cfinvokeargument name="etiquetas" value="Servicio"/>
								<cfinvokeargument name="formatos" value="V"/>
								<cfinvokeargument name="filtro" value="#where#"/>
								<cfinvokeargument name="align" value="left"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="Conexion" value="sdc"/>
								<cfinvokeargument name="showLink" value="false"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="Cortes" value="nombre_sistema"/>
								<cfinvokeargument name="MaxRows" value="50"/>
							</cfinvoke>
						</cf_web_portlet>
					</td>
				</tr>

			</table>
		</td>
		
		<td width="1%">&nbsp;</td>
	</tr>
</table>
</cfoutput>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Pnombre.required    = true;
	objForm.Pnombre.description = "Nombre";

	objForm.TIcodigo.required    = true;
	objForm.TIcodigo.description = "Tipo de Identificación";

	objForm.Pid.required    = true;
	objForm.Pid.description = "Identificación";

	objForm.Ppais.required    = true;
	objForm.Ppais.description = "País";
</script>