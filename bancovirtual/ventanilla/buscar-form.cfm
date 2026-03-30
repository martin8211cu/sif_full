<cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla)) eq 0>
	<table width="530" border="0" align="center" style="border:1px solid gray" bgcolor="#CCCCCC">
		<TR><TD align="center"><strong>Usted no esta asociado a ninguna ventanilla.</strong></TD></TR>
	</table>
<cfelse>	
	<!--- Style para que los botones sean de colores --->
	<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">
	
	<!---<body style="margin:0" onload="resize_parent()">--->
	<cf_templatecss>
	<cfinclude template="configuracion.cfm" >
	
	<cfif isdefined("url.identificacion_persona") and not isdefined("form.identificacion_persona")>
		<cfparam name="form.identificacion_persona" default="#url.identificacion_persona#">
	</cfif>
	<cfif isdefined("url.id_tipoident") and not isdefined("form.id_tipoident")>
		<cfparam name="form.id_tipoident" default="#url.id_tipoident#">
	</cfif>
	
	<script type="text/javascript">
	var popUpWin = 0;
		function popUpWindow(URLStr, left, top, width, height){
			if(popUpWin){
				if(!popUpWin.closed) popUpWin.close();
			}
			popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}
	
	/*
		function resize_parent(){
			if (window.parent && document.all) {
				// usar solamente en Internet Explorer
				var nw_height = document.body.parentNode.scrollHeight;
				var fr = window.parent.document.getElementById('iframe_gestion');
				if (fr) {
					//fr.height = nw_height;
					fr.style.height = nw_height + "px";
				}
			}
		}
	*/	
	</script>
	
		<cfparam name="url.identificacion_persona" default="">
		<cfparam name="url.id_tipoident" default="0">
		<cfquery name="data" datasource="tramites_cr">
			select 	p.id_persona,
					p.id_tipoident, 
					p.id_direccion, 
					p.identificacion_persona, 
					p.nombre, 
					p.apellido1, 
					p.apellido2, 
					p.nacimiento, 
					p.sexo, 
					p.casa, 
					p.oficina, 
					p.celular, 
					p.fax, 
					p.email1, 
					p.foto, 
					p.nacionalidad, 
					p.extranjero,
					coalesce(d.direccion1, d.direccion2) as direccion,
					p.ts_rversion
			from TPPersona p
			left join TPDirecciones d
			on p.id_direccion = d.id_direccion		
			where identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.identificacion_persona)#">
			and p.id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipoident#">
		</cfquery>
	
		<cfif data.recordcount gt 0 and isdefined("url.id_tramite") and len(trim(url.id_tramite))>
			<cfquery name="infoTramite" datasource="tramites_cr">
				select codigo_tramite, nombre_tramite
				from TPTramite
				where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
			</cfquery>
		</cfif>
	
	<!---<cfinclude template="/home/menu/pNavegacion.cfm">--->
	<table width="530" border="0" align="center">
		<tr><td colspan="4">
	
			<cfoutput>
			<script type="text/javascript">
				function cambia_persona(f){
					location.href="?loc=gestion&identificacion_persona="+escape(f.identificacion_persona.value);
				}
			</script>
			<cfquery name="tipoidentificacion" datasource="tramites_cr">
				select id_tipoident, codigo_tipoident, nombre_tipoident 
				from TPTipoIdent
			</cfquery>
	
		<cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))>
			<cfquery datasource="tramites_cr" name="rsventanilla">
				select nombre_ventanilla
				from TPVentanilla
				where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">
			</cfquery>
		</cfif>
	
			<table border="0" cellpadding="5" cellspacing="0" width="100%">
				<form name="form1" action="buscar-sql.cfm" target="_parent" method="get" style="margin:0;" onSubmit="return validar_form1(this);">
				<tr>
					<td colspan="2" valign="top">
						<cfif data.recordcount eq 0 >
						<table width="100%" cellpadding="2" cellspacing="2">
							<cfif isdefined("rsventanilla")>
								<tr><td colspan="3" bgcolor="##CCCCCC" style="border:1px solid gray "><font size="2"><strong>Ventanilla: #rsventanilla.nombre_ventanilla#</strong></font></td></tr>
							</cfif>
	
							<tr>
								<td colspan="3" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong><font size="2">Buscar por Identificaci&oacute;n y Tr&aacute;mite</font></strong></td>
							</tr>
	
							<tr>
								<td valign="middle" nowrap colspan="2">
								<strong>Identificaci&oacute;n:&nbsp;</strong>
								</td>
							</tr>	
	
							<tr>
								<td valign="middle"> 
									<select name="id_tipoident">
										<cfloop query="tipoidentificacion">
											<option value="#tipoidentificacion.id_tipoident#" <cfif isdefined("url.id_tipoident") and url.id_tipoident eq tipoidentificacion.id_tipoident>selected</cfif> >#tipoidentificacion.nombre_tipoident#</option>
										</cfloop>
									</select>
									<input autocomplete="off" name="identificacion_persona" type="text" value="<cfif len(trim(data.identificacion_persona))>#trim(data.identificacion_persona)#<cfelseif isdefined("url.identificacion_persona")>#trim(url.identificacion_persona)#</cfif>" <cfif isdefined("url.noexistepersona")>onFocus="javascript: document.getElementById('error1').style.display='none';"</cfif> >
									<input name="id_persona" type="hidden" value="#data.id_persona#">
								</td>
								<td align="right"><table cellspacing="1"><tr><td><input type="submit" value="Buscar" class="boton"></td><td><!---<input type="button" value="Cerrar" class="boton" onclick="location.href='?'">---></td></tr></table> </td>
							</tr> 
		
							<cfquery name="tipo" datasource="tramites_cr">
								select id_tipotramite, codigo_tipotramite, nombre_tipotramite 
								from TPTipoTramite
								order by 2
							</cfquery>
							
							<cfquery name="combotramite" datasource="tramites_cr">
								select t.id_tramite, t.codigo_tramite, t.nombre_tramite,
									i.id_inst, i.nombre_inst
								from TPTramite t
									join TPInstitucion i
										on t.id_inst = i.id_inst
								order by i.nombre_inst, i.id_inst, t.codigo_tramite, t.id_tipotramite
							</cfquery>
	
							<tr>
								<td ><strong>Tr&aacute;mite:&nbsp;</strong></td>
							</tr>	
	
							<tr>
								<td colspan="2">
									<select name="id_tramite" <cfif isdefined("url.noexistepersona")>onFocus="javascript: document.getElementById('error1').style.display='none';"</cfif> >
										<option value="" >- seleccionar -</option>
										<cfset c_inst="">
										<cfloop query="combotramite">
											<cfif (c_inst neq id_inst) or CurrentRow EQ 1>
												<cfif CurrentRow NEQ 1>
													</optgroup>
												</cfif>
												<cfset c_inst = id_inst>
												<optgroup label="#HTMLEditFormat(nombre_inst)#">
											</cfif>
											<option value="#id_tramite#" <cfif isdefined("url.id_tramite") and url.id_tramite eq combotramite.id_tramite>selected</cfif> >
												#trim(HTMLEditFormat(codigo_tramite))# - #HTMLEditFormat(nombre_tramite)#
										  </option>
										</cfloop>
									</select>
									<a href="javascript:informacion()"><img alt="Ver Tramites" src="../../images/info.gif" border="0"></a></td>
							</tr>
	
							<cfif isdefined("url.noexistepersona")>
							<tr id="error1"><td colspan="2">
								<table width="98%" class="areaFiltro" align="center" cellpadding="2" cellspacing="0">
									<tr>
										<td width="1%"><img src="../../images/stop.gif"></td>
										<td>No se encontraron datos para la identificaci&oacute;n #url.identificacion_persona#</td>
									</tr>	
								</table>
							</td></tr>
							</cfif>
							
							
							
				</form>						
							<tr><td>&nbsp;</td></tr>
						<form name="form2" action="buscar-sql.cfm" method="get" target="_parent" style="margin:0;" onSubmit="return validar_form2(this);">
							<tr>
								<td colspan="3" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong><font size="2">Buscar por N&uacute;mero de Tr&aacute;mite</font></strong></td>
							</tr>
							<tr>
								<td colspan="2"><strong>N&uacute;mero de Tr&aacute;mite:&nbsp;</strong></td>
							</tr>	
	
							<tr>
								<td><input autocomplete="off" size="15" maxlength="18" name="tramite" type="text" value="" <cfif isdefined("url.noexiste")>onFocus="javascript: document.getElementById('error2').style.display='none';"</cfif>></td>
								<td align="right"><input type="submit" name="BuscarTramite" value="Buscar" class="boton"></td>
							</tr>
							<cfif isdefined("url.noexiste")>
							<tr id="error2"><td colspan="2">
								<table width="98%" class="areaFiltro" align="center" cellpadding="2" cellspacing="0">
									<tr>
										<td width="1%"><img src="../../images/stop.gif"></td>
										<td>No se encontraron datos para el tr&aacute;mite #url.tramite#</td>
									</tr>	
								</table>
							</td></tr>
							</cfif>
						</form>						
							
						</table>
						</cfif>
					</td>
				</tr>
				
				<!---
				<cfif data.recordcount gt 0 >
				<tr>
					<td bgcolor="##ECE9D8" style="padding:3px; font-size:20px;">
					<strong>#trim(infoTramite.nombre_tramite)#</strong>
					</td>
				<td bgcolor="##ECE9D8" style="padding:3px; font-size:20px;" align="right">
					<a href="javascript:infoTramite(#id_tramite#)">
					<img alt="Ver Detalle del Tramite #trim(infoTramite.codigo_tramite)# - #infoTramite.nombre_tramite#" 
						src="../../images/info.gif" border="0"></a>
				</td>
				</tr>
				<tr>
					<td colspan="2" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong>Datos Personales</strong></td>
				</tr>
				<tr>
					<td colspan="2">
						<table width="520" cellpadding="2" cellspacing="0">
							<tr>
								<td valign="top">
									<cfif Len(data.foto) GT 1>
										<cfinvoke component="sif.Componentes.DButils"
										method="toTimeStamp"
										returnvariable="tsurl">
										<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
										</cfinvoke>
										<img align="middle" width="78" height="90" src="/cfmx/home/tramites/Operacion/gestion/foto_persona.cfm?s=#URLEncodedFormat(data.id_persona)#&amp;ts=#tsurl#" border="0" >
									<cfelse>
										<img align="middle"  width="78" height="90" src="/cfmx/home/public/not_avail.gif" border="0" >
									</cfif>
								</td>
								<td valign="top">
									<table width="100%" cellpadding="2" cellspacing="0">
										<tr>
											<td valign="top">
											#data.nombre# #data.apellido1# #data.apellido2#</td>
											<TD align="right"><!---<input type="button" value="Cerrar" onclick="location.href='?'" class="boton">---></TD>
										</tr>
							
										<tr>
											<td valign="top" colspan="2">  
												<cfif len(trim(data.id_direccion))>
													<cf_tr_direccion key="#data.id_direccion#" action="display">
												</cfif>
											</td>
										</tr>
	
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<cfelseif isdefined("url.identificacion_persona") and len(trim(url.identificacion_persona))>
					<tr>
						<td colspan="2" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong>Datos Personales</strong></td>
					</tr>
					<tr><td colspan="2" align="center">No se encontro la persona</td></tr>
				</cfif>
				--->
			</table>
	
			</cfoutput>
		</td></tr>
			
		<!---
		<cfif data.recordcount gt 0 and isdefined("url.id_tramite") and len(trim(url.id_tramite))>
			<tr bgcolor="#ECE9D8" style="padding:3px; ">
			  <td colspan="2" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;" width="520"><strong>Requisitos</strong></td>
			</tr>
			<tr><td colspan="2"><cfinclude template="requisitos-lista.cfm"></td></tr>
		</cfif>
		--->
	
		<script language="javascript1.2" type="text/javascript">
			<cfif data.recordcount eq 0 >
				function tramites(f, value){
					var tramite = f.id_tramite;
					tramite.options.length = 0;
		
					tramite.options.length++;
					tramite.options[tramite.options.length-1].value = '';
					tramite.options[tramite.options.length-1].text = '- seleccionar -';
					tramite.options[tramite.options.length-1].selected = true;
					
					var cont = 0;
					<cfoutput query="combotramite">
						if ( value.length == 0 || value == #combotramite.id_tramite# ){
							tramite.options.length++;
							tramite.options[tramite.options.length-1].value = #combotramite.id_tramite#;
							tramite.options[tramite.options.length-1].text = '#JSStringFormat(combotramite.codigo_tramite)# - #JSStringFormat(combotramite.nombre_tramite)#';
							cont++;
						}
					</cfoutput>
					
					if( cont == 0 && value !='' ){
						tramite.options[tramite.options.length-1].text = '- No existen trámites -';
					}
				}
			</cfif>
			
			function infoTramite(tramite) {
				var params ="";
				params = "?id_tramite="+tramite;
				popUpWindow("/cfmx/home/tramites/Operacion/gestion/infoTramite.cfm"+params,250,200,650,400);
			}
			function informacion() {
				location.href='/cfmx/home/tramites/Operacion/gestion/info_tramite.cfm'
				//popUpWindow("/cfmx/home/tramites/Operacion/gestion/info_tramite.cfm",250,200,650,400);
			}
			
			function validar_form1(f){
				var msj = '';
				
				if( f.id_tipoident.value == '' ){
					msj += ' - El campo Tipo de Identificación es requerido.\n';
				}
				if( f.identificacion_persona.value == '' ){
					msj += ' - El campo Identificación es requerido.\n';
				}
				if( f.id_tramite.value == '' ){
					msj += ' - El campo Trámite es requerido.\n';
				}
				if (msj != ''){
					alert('Se presentaron los siguientes errores:\n' + msj)
					return false;
				}
	
				return true;
			}
			
			function validar_form2(f){
				var msj = '';
				
				if( f.tramite.value == '' ){
					msj += ' - El campo Trámite es requerido.\n';
				}
				if( isNaN(f.tramite.value) ){
					msj += ' - El campo Trámite debe ser numérico.\n';
				}
	
				if (msj != ''){
					alert('Se presentaron los siguientes errores:\n' + msj)
					return false;
				}
	
				return true;
			}
	
	
	
			function onchange_tramite(obj){
				if ( document.form1.identificacion_persona.value != '' ){
					location.href = '/cfmx/home/menu/portal.cfm?loc=gestion&identificacion_persona='+document.form1.identificacion_persona.value+'&id_tipotramite='+document.form1.id_tipotramite.value+'&id_tramite='+obj.value;
				}
				else{
					alert('Seleccione la persona.');
				}
			}
			
			/*
			<cfif isdefined("url.id_tipotramite") and len(trim(url.id_tipotramite))>
				document.form1.id_tipotramite.value = <cfoutput>#url.id_tipotramite#</cfoutput>
			</cfif>
			*/
	/*
			<cfif isdefined("url.id_tramite") and len(trim(url.id_tramite))>
				document.form1.id_tramite.value = <cfoutput>#url.id_tramite#</cfoutput>
			</cfif>
			*/
			
			/*
			<cfif isdefined("url.noexiste")>
				alert('No se encotraron datos')
			</cfif>
			*/
	
		</script>
	</table>
</cfif>
