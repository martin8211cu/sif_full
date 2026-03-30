 <html><head>
  <link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">
  <cf_templatecss>
</head>
<body style="margin:0 ">
<cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla)) eq 0>
  <table width="530" border="0" align="center" style="border:1px solid gray" bgcolor="#CCCCCC">
    <TR>
      <TD align="center"><strong>Usted no esta asociado a ninguna ventanilla.</strong></TD>
    </TR>
  </table>
  <cfelse>
  <!--- Style para que los botones sean de colores --->
  <!---<body style="margin:0" onload="resize_parent()">--->
  <!---<cfinclude template="configuracion.cfm" >--->
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
  <cfquery name="data" datasource="#session.tramites.dsn#">
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
    <cfquery name="infoTramite" datasource="#session.tramites.dsn#">
				select codigo_tramite, nombre_tramite
				from TPTramite
				where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
			</cfquery>
  </cfif>
  
  
  
<cfquery name="tipo" datasource="#session.tramites.dsn#">
	select id_tipotramite, codigo_tipotramite, nombre_tipotramite 
	from TPTipoTramite
	order by 2
</cfquery>
<cfinvoke component="home.tramites.componentes.tramites"
	method="permisos_obj"
	id_funcionario="#session.tramites.id_funcionario#"
	tipo_objeto="T"
	returnvariable="tramites_validos" >
</cfinvoke>
	<cfquery name="combotramite" datasource="#session.tramites.dsn#">
		select t.id_tramite, t.codigo_tramite, t.nombre_tramite,
			i.id_inst, i.nombre_inst
		from TPTramite t
			join TPInstitucion i
				on t.id_inst = i.id_inst
		<cfif Len(tramites_validos)>
		where id_tramite in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#tramites_validos#" list="yes">)
		<cfelse>
		where 1=0
		</cfif>
		order by i.nombre_inst, i.id_inst, t.codigo_tramite, t.id_tipotramite
	</cfquery>
							
							
  <cfquery name="tipoidentificacion" datasource="#session.tramites.dsn#">
				select id_tipoident, codigo_tipoident, nombre_tipoident , mascara
				from TPTipoIdent
			</cfquery>
  <cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))>
    <cfquery datasource="#session.tramites.dsn#" name="rsventanilla">
				select nombre_ventanilla
				from TPVentanilla
				where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">
			</cfquery>
  </cfif>
  <!---<cfinclude template="/home/menu/pNavegacion.cfm">--->
<table width="760" border="0" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="500" valign="top">
			  <table width="500" border="0" align="left" cellpadding="0" cellspacing="0">
			  <tr>
			  <td colspan="4">
			  <cfoutput>
			  <table border="0" cellpadding="0" cellspacing="0" width="100%">
				<form name="form1" action="buscar-sql.cfm" target="_parent" method="get" style="margin:0;" onSubmit="return validar_form1(this);">
				
				<tr>
				  <td colspan="2" valign="top"><cfif data.recordcount eq 0 >
					  <table width="100%" cellpadding="0" cellspacing="0">
						<cfif isdefined("rsventanilla")>
						  <tr>
							<td colspan="3" bgcolor="##CCCCCC" style="border:1px solid gray; padding:3px; "><font size="2"><strong>Ventanilla: #rsventanilla.nombre_ventanilla#</strong></font></td>
						  </tr>
						  <tr><td>&nbsp;</td></tr>
						</cfif>
						<tr>
						  <td colspan="3" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong><font size="2">Buscar por Identificaci&oacute;n y Tr&aacute;mite</font></strong></td>
						</tr>
						<cfif combotramite.RecordCount>
						<tr>
						  <td valign="middle" nowrap colspan="2" style="padding:3px; "><strong>Identificaci&oacute;n:&nbsp;</strong> </td>
						</tr>
						<tr>
						  <td valign="middle" nowrap="nowrap"><select name="id_tipoident" onChange="validar_identificacion()" style="width:200px;" >
							  <cfloop query="tipoidentificacion">
								<option value="#tipoidentificacion.id_tipoident#" <cfif isdefined("url.id_tipoident") and url.id_tipoident eq tipoidentificacion.id_tipoident>selected</cfif> >#tipoidentificacion.nombre_tipoident#</option>
							  </cfloop>
							</select><br>
							<input autocomplete="off" onKeyUp="validar_identificacion()" onChange="validar_identificacion()" name="identificacion_persona" type="text" value="<cfif len(trim(data.identificacion_persona))>#trim(data.identificacion_persona)#<cfelseif isdefined("url.identificacion_persona")>#trim(url.identificacion_persona)#</cfif>" <cfif isdefined("url.noexistepersona")>onFocus="javascript: document.getElementById('error1').style.display='none';"</cfif> >
							<input name="id_persona" type="hidden" value="#data.id_persona#">
							<img src="../../images/Borrar01_S.gif" name="img_ident_mal" width="20" height="18" border="0" id="img_ident_mal" style="display:none">
							<img src="../../images/check-verde.gif" name="img_ident_ok" width="18" height="20" border="0" id="img_ident_ok"  style="display:none">
							<img src="../../images/blank.gif" height="20" width="1" border="0">

<a href="javascript:doConlis();"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Personas" name="img" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlis();'></a>							
							
							
							<br>
							<input type="text" id="explicar_mascara" name="explicar_mascara" style="border:0;font-style:italic" size="40" readonly="readonly" disabled="disabled">
							</td>
						  <td align="right"><table cellspacing="1">
							  <tr>
								<td><input type="submit" value="Buscar" class="boton"></td>
								<td><!---<input type="button" value="Cerrar" class="boton" onclick="location.href='?'">---></td>
							  </tr>
							</table></td>
						</tr></cfif>
						<tr>
						  <td  style="padding:3px; " colspan="2"><cfif combotramite.RecordCount>
						    <strong>Tr&aacute;mite por realizar:&nbsp;</strong>
						  </cfif></td>
						</tr>
						<tr>
						  <td colspan="2"><cfif combotramite.RecordCount EQ 0>
							  <table width="100%" border="0" align="center" style="border:1px solid gray" bgcolor="##CCCCCC">
								<TR>
								  <TD align="center"><strong>
								  No se le han asignado los permisos <br>requeridos 
									para ver ning&uacute;n tr&aacute;mite.</strong></TD>
								</TR>
							  </table>
							  <cfelse>
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
								  <option value="#id_tramite#" <cfif isdefined("url.id_tramite") and url.id_tramite eq combotramite.id_tramite>selected</cfif> > #trim(HTMLEditFormat(codigo_tramite))# - #HTMLEditFormat(nombre_tramite)# </option>
								</cfloop>
							  </select>
							  <a href="javascript:informacion()"><img alt="Ver Tramites" src="../../images/info.gif" border="0"></a>
							</cfif></td>
						</tr>
						<cfif isdefined("url.noexistepersona")>
						  <tr id="error1">
							<td colspan="2"><table width="98%" class="areaFiltro" align="center" cellpadding="2" cellspacing="0">
								<tr>
								  <td width="1%"><img src="../../images/stop.gif"></td>
								  <td>No se encontraron datos para la identificaci&oacute;n #url.identificacion_persona#.<br>
								  Para registrarlo, 
								  confirme si esta identificación es correcta, y luego 
								  <a href="../../vistas/registro-persona.cfm?id_tipoident=#URLEncodedFormat(url.id_tipoident)#&amp;identificacion_persona=#URLEncodedFormat(url.identificacion_persona)#<cfif isdefined('url.id_tramite')>&amp;id_tramite=#URLEncodedFormat(url.id_tramite)#</cfif>" style="text-decoration:underline">
								  haga clic aqu&iacute;
								  <img src="../../images/popup.gif" width="16" height="16" border="0"></a>. </td>
								</tr>
							  </table></td>
						  </tr>
						</cfif>
						</form>
						
						<tr>
						  <td>&nbsp;</td>
						</tr>
						<form name="form2" action="buscar-sql.cfm" method="get" target="_parent" style="margin:0;" onSubmit="return validar_form2(this);">
						  <tr>
							<td colspan="3" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong><font size="2">Buscar por N&uacute;mero de Tr&aacute;mite</font></strong></td>
						  </tr>
						  <tr>
							<td colspan="2"  style="padding:3px; "><strong>N&uacute;mero de Tr&aacute;mite:&nbsp;</strong></td>
						  </tr>
						  <tr>
							<td><input autocomplete="off" size="15" maxlength="18" name="tramite" type="text" value="" <cfif isdefined("url.noexiste")>onFocus="javascript: document.getElementById('error2').style.display='none';"</cfif>></td>
							<td align="right"><input type="submit" name="BuscarTramite" value="Buscar" class="boton"></td>
						  </tr>
						  <cfif isdefined("url.noexiste")>
							<tr id="error2">
							  <td colspan="2"><table width="98%" class="areaFiltro" align="center" cellpadding="2" cellspacing="0">
								  <tr>
									<td width="1%"><img src="../../images/stop.gif"></td>
									<td>No existe el n&uacute;mero de tr&aacute;mite #url.tramite#</td>
								  </tr>
								</table></td>
							</tr>
						  <cfelseif isdefined("url.completo")>	
							<tr id="error2">
							  <td colspan="2"><table width="98%" class="areaFiltro" align="center" cellpadding="2" cellspacing="0">
								  <tr>
									<td width="1%"><img src="../../images/stop.gif"></td>
									<td>El tr&aacute;mite n&uacute;mero #url.tramite# ya est&aacute; completado.</td>
								  </tr>
								</table></td>
							</tr>						  
						  </cfif>
						</form>
			
						<cfset fecha_inicio = createdate(1900,01,01)>
						<cfset fecha_fin = createdate(6100,01,01)>
						<cfif isdefined("form.fechai") and len(trim(form.fechai))>
							<cfset fecha_inicio = LSParsedateTime(form.fechai) >
						</cfif>
						<cfif isdefined("form.fechaf") and len(trim(form.fechaf))>
							<cfset fecha_fin = LSParsedateTime(form.fechaf) >
						</cfif>
						<cfif DateCompare(fecha_inicio, fecha_fin) eq 1>
							<cfset tmp = fecha_inicio >
							<cfset fecha_inicio = fecha_fin>
							<cfset fecha_fin = tmp>
						</cfif>
						<cfparam name="form.id_ventanilla" default="0">
						<cfparam name="session.tramites.id_inst" default="0">
						<cfif form.id_ventanilla eq 0>
							<cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla)) and session.tramites.id_ventanilla>
								<cfset form.id_ventanilla = session.tramites.id_ventanilla>
							</cfif>
						</cfif>
						<cfquery name="rsVentanillas" datasource="#session.tramites.dsn#">
							select id_ventanilla, nombre_ventanilla
							from TPVentanilla
						</cfquery>
			
						<cfquery name="lista" datasource="#session.tramites.dsn#">
							select 	count(1) as cantidad, completo
								
							from TPInstanciaTramite a
							
							inner join TPPersona p
							  on a.id_persona = p.id_persona
							
							inner join TPTramite t
							  on a.id_tramite = t.id_tramite
							  and t.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
						
							inner join TPInstitucion i
							on i.id_inst=t.id_inst
							
							inner join TPFuncionario f
							on f.id_funcionario = a.id_funcionario
							
							inner join TPPersona p2
							on p2.id_persona=f.id_persona
							
							inner join TPRFuncionarioVentanilla fv
							on fv.id_ventanilla=a.id_ventanilla
							and fv.id_funcionario=a.id_funcionario
							
							inner join TPVentanilla v
							on v.id_ventanilla=fv.id_ventanilla
						
							inner join TPSucursal s
							on s.id_sucursal=v.id_sucursal
							
							where a.fecha_inicio between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_inicio#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_fin#">
							  and a.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">
							  <cfif isdefined("form.id_ventanilla") and len(trim(form.id_ventanilla)) and form.id_ventanilla>
								and a.id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_ventanilla#">
							  </cfif>
							group by completo
						</cfquery>
						<cfset cantidad0 = 0> 
						<cfset cantidad1 = 0> 
						<cfloop query="lista">
							<cfif completo EQ 0>
								<cfset cantidad0 = cantidad> 
							<cfelse>
								<cfset cantidad1 = cantidad> 
							</cfif>
						</cfloop>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong><font size="2">Resumen del d&iacute;a</font></strong></td>
						</tr>
						<tr>
							<td width="1%"  style="padding:3px; "><strong><a href="../../Consultas/tramites-ventanilla.cfm?listado=0" title="Tr&aacute;mites Pendientes:" target="_parent">Tr&aacute;mites Pendientes:</a></strong></td>
							<td  style="padding:3px; "><strong><a href="../../Consultas/tramites-ventanilla.cfm?listado=0" title="Tr&aacute;mites Pendientes:" target="_parent">#cantidad0#</a></strong></td>
							<td>&nbsp;</td>
						</tr>
									<tr>
							<td  style="padding:3px; "><strong><a href="../../Consultas/tramites-ventanilla.cfm?listado=1" title="Tr&aacute;mites Cerrados:" target="_parent">Tr&aacute;mites Cerrados:</a></strong></td>
							<td  style="padding:3px; "><strong><a href="../../Consultas/tramites-ventanilla.cfm?listado=1" title="Tr&aacute;mites Cerrados:" target="_parent">#cantidad1#</a></strong></td>
							<td>&nbsp;</td>
						</tr>
					  </table>
					</cfif>
				  </td>
				</tr>
			</table>
			</cfoutput>
			</td>
			</tr>
			<script language="javascript1.2" type="text/javascript">
			
							function cambia_persona(f){
								location.href="?loc=gestion&identificacion_persona="+escape(f.identificacion_persona.value);
							}
			
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
						}
						
						function validar_form1(f){
							var msj = '';
							
							if( f.id_tipoident.value == '' ){
								msj += ' - El tipo de identificación es requerido.\n';
							}
							if( f.identificacion_persona.value == '' ){
								msj += ' - La identificación es requerida.\n';
							} else if (!validar_identificacion()){
								msj += ' - La identificación tiene un formato incorrecto.\n';
							}
							if( f.id_tramite.value == '' ){
								msj += ' - Debe indicar el trámite por realizar.\n';
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
								msj += ' - El número de trámite es requerido.\n';
							}
							if( isNaN(f.tramite.value) ){
								msj += ' - El número de trámite indicado no es válido.\n';
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
						<cfset mascara_cfc = CreateObject("component", "home.tramites.componentes.mascara")>
						TPTipoIdent_regex = {<cfoutput query="tipoidentificacion"><cfif Len(Trim(mascara))>
							'#JSStringFormat(id_tipoident)#':/#mascara_cfc.mascara2regex(mascara)#/, </cfif></cfoutput>
							dummy: 0
							};
						TPTipoIdent_mascaras = {<cfoutput query="tipoidentificacion"><cfif Len(Trim(mascara))>
							'#JSStringFormat(id_tipoident)#':'#JSStringFormat(mascara)#', </cfif></cfoutput>
							dummy: 0
							}
						
						function validar_identificacion() {
							var f = document.forms.form1;
							if (!(f && f.identificacion_persona)) return;
							// regresa true si la identificacion es valida o si no esta restringida
							var ident = f.identificacion_persona.value;
							var tipoid = f.id_tipoident.value;
							var mascara = TPTipoIdent_regex[tipoid];
							var imal = document.all ? document.all.img_ident_mal : document.getElementById('img_ident_mal');
							var iok = document.all ? document.all.img_ident_ok : document.getElementById('img_ident_ok');
							iok.style.display  = ident.length && mascara && mascara.test(ident) ? 'inline' : 'none';
							imal.style.display = ident.length && mascara && !mascara.test(ident) ? 'inline' : 'none';
							f.explicar_mascara.value = TPTipoIdent_mascaras[tipoid]?'Capturar como: '+TPTipoIdent_mascaras[tipoid]:'';
							return (!mascara) || mascara.test(ident);
						}
						validar_identificacion();
						
						/* CONLIS DE PERSONAS  */
						var popUpWin=0;
						//Levanta el Conlis
						function popUpWindow(URLStr, left, top, width, height)
						{
							if(popUpWin)
							{
								if(!popUpWin.closed) popUpWin.close();
							}
							popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
						}
						//Llama el conlis
						function doConlis() {
							var params ="";
							params = "?formulario=formf&id=id_persona&nombre=nombre&apellido1=apellido1&apellido2=apellido2";
							popUpWindow("/cfmx/home/tramites/Operacion/ventanilla/conlisPersona.cfm"+params,225,110,650,500);
						}



					</script>
			</table>
			</cfif>
		</td>
		<td align="center" valign="top">
		<iframe src="lista-trabajo.cfm" width="100%" height="420" frameborder="0" ></iframe>
		</td>
	</tr>
</table>

<!---
	este iframe ya no va porque en lista-trabajo.cfm
	también se hace ping.
<iframe id="ping_ventanilla" frameborder="0" style="width:0; height:0; visibility:hidden;" src="/cfmx/home/tramites/Operacion/ventanilla/ping_ventanilla.cfm"></iframe>
  --->
</body></html>