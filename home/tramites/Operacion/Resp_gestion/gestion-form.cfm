<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<title>Untitled Document</title>
</head>

<body style="margin:0">

<cfif isdefined("url.identificacion_persona") and not isdefined("form.identificacion_persona")>
	<cfparam name="form.identificacion_persona" default="#url.identificacion_persona#">
</cfif>
<cfif isdefined("url.id_tipoident") and not isdefined("form.id_tipoident")>
	<cfparam name="form.id_tipoident" default="#url.id_tipoident#">
</cfif>


<cfset frame_height = 130>
<cfif isdefined("url.identificacion_persona") and Len(Trim(url.identificacion_persona)) GT 0>
	<cfset frame_height = 750>
</cfif>
<script type="text/javascript">
	if (window.parent) {
		<!--- asegurarse de que estoy en un iframe --->
		var fr = window.parent.document.getElementById('iframe_gestion');
		if (fr) {
			fr.height = <cfoutput>#frame_height#</cfoutput>;
			fr.style.height = "<cfoutput>#frame_height#</cfoutput>px";
		}
	}
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

<form name="form1" action="" method="get" style="margin:0;" onSubmit="return validar(this);">
<input type="hidden" name="loc" value="gestion">
<cfif isdefined("url.id_instancia") and len(trim(url.id_instancia))>
	<input type="hidden" name="id_instancia" value="<cfoutput>#url.id_instancia#</cfoutput>">
</cfif>

<table width="540" border="0" align="center">
	<tr><td colspan="4">

		<cfoutput>
		<script type="text/javascript">
			function cambia_persona(f){
				location.href="?loc=gestion&identificacion_persona="+escape(f.identificacion_persona.value);
			}
		</script>
		<cfquery name="tipoidentificacion" datasource="#session.tramites.dsn#">
			select id_tipoident, codigo_tipoident, nombre_tipoident 
			from TPTipoIdent
		</cfquery>

		<table width="100%" border="0" cellpadding="5" cellspacing="0" align="center">
			<tr>
				<td colspan="4" valign="top">
					<cfif data.recordcount eq 0 >
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td colspan="4" bgcolor="##ECE9D8" style="padding:3px; "><strong>Buscar</strong></td>
						</tr>

						<tr>
							<td width="1%" valign="middle" nowrap>
							<strong>Identificaci&oacute;n:&nbsp;</strong>
							</td>
							<td valign="middle"> 
								<select name="id_tipoident">
									<cfloop query="tipoidentificacion">
										<option value="#tipoidentificacion.id_tipoident#" <cfif isdefined("url.id_tipoident") and url.id_tipoident eq tipoidentificacion.id_tipoident>selected</cfif> >#tipoidentificacion.nombre_tipoident#</option>
									</cfloop>
								</select>
								<input name="identificacion_persona" type="text" value="<cfif len(trim(data.identificacion_persona))>#trim(data.identificacion_persona)#<cfelseif isdefined("url.identificacion_persona")>#trim(url.identificacion_persona)#</cfif>">
								<input name="id_persona" type="hidden" value="#data.id_persona#">
							</td>
							<td align="center"><input type="submit" value="Buscar"> <input type="button" value="Cerrar" onclick="location.href='?'"></td>
						</tr>
	
						<cfquery name="tipo" datasource="#session.tramites.dsn#">
							select id_tipotramite, codigo_tipotramite, nombre_tipotramite 
							from TPTipoTramite
							order by 2
						</cfquery>
						
						<cfquery name="combotramite" datasource="#session.tramites.dsn#">
							select id_tramite, codigo_tramite, nombre_tramite 
							from TPTramite
							order by id_tipotramite
						</cfquery>

<!---
						<tr>
							<td nowrap><strong>Tipo de Tr&aacute;mite:&nbsp;</strong></td>
							<td colspan="2" >										
								<select name="id_tipotramite" onChange="javascript:tramites(this.form, this.value);">
									<option value="" selected>- todos -</option>
									<cfloop query="tipo">
										<option value="#tipo.id_tipotramite#">#trim(HTMLEditFormat(tipo.codigo_tipotramite))# - #HTMLEditFormat(tipo.nombre_tipotramite)#</option>
									</cfloop>
								</select>
							</td>
						</tr>
--->						
						<tr>
							<td ><strong>Tr&aacute;mite:&nbsp;</strong></td>
							<td colspan="2">
								<select name="id_tramite" >
									<option value="" >- seleccionar -</option>
									<cfloop query="combotramite">
										<option value="#id_tramite#" <cfif isdefined("url.id_tramite") and url.id_tramite eq combotramite.id_tramite>selected</cfif> >
											#trim(HTMLEditFormat(codigo_tramite))# - #HTMLEditFormat(nombre_tramite)#
											</option>
									</cfloop>
								</select>
							</td>
						</tr>
					</table>
					</cfif>
				</td>
			</tr>
			
			<cfif data.recordcount gt 0 >
			<tr>
				<td colspan="4" bgcolor="##ECE9D8" style="padding:3px; "><strong>Datos Personales</strong></td>
			</tr>
			<tr>
				<td colspan="4">
					<table width="100%" cellpadding="2" cellspacing="0">
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
										<TD><input type="button" value="Cerrar" onclick="location.href='?'"></TD>
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
					<td colspan="4" bgcolor="##ECE9D8" style="padding:3px; "><strong>Datos Personales</strong></td>
				</tr>
				<tr><td colspan="4" align="center">No se encontro la persona</td></tr>
			</cfif>
		</table>
		</cfoutput>
	</td></tr>
		
	
	<cfif data.recordcount gt 0 and isdefined("url.id_tramite") and len(trim(url.id_tramite))>
		<cfquery name="infoTramite" datasource="#session.tramites.dsn#">
			select codigo_tramite, nombre_tramite
			from TPTramite
			where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		</cfquery>
		<tr bgcolor="#ECE9D8" style="padding:3px; "><td style="padding:3px; "><strong>Tr&aacute;mite:&nbsp; <cfoutput>#trim(infoTramite.codigo_tramite)# - #trim(infoTramite.nombre_tramite)#</strong></cfoutput></td></tr>
		<tr><td colspan="4"><cfinclude template="requisitos-lista.cfm"></td></tr>
	</cfif>

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
		
		function validar(f){
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
		
		function onchange_tramite(obj){
			if ( document.form1.identificacion_persona.value != '' ){
				location.href = '/cfmx/home/menu/portal.cfm?loc=gestion&identificacion_persona='+document.form1.identificacion_persona.value+'&id_tipotramite='+document.form1.id_tipotramite.value+'&id_tramite='+obj.value;
			}
			else{
				alert('Seleccione la persona.');
			}
		}
		
		<cfif isdefined("url.id_tipotramite") and len(trim(url.id_tipotramite))>
			document.form1.id_tipotramite.value = <cfoutput>#url.id_tipotramite#</cfoutput>
		</cfif>
/*
		<cfif isdefined("url.id_tramite") and len(trim(url.id_tramite))>
			document.form1.id_tramite.value = <cfoutput>#url.id_tramite#</cfoutput>
		</cfif>
		*/
		
	</script>
</table>
	<!---<INPUT type="button" value="MIENTRAS" onClick="location.href='gestion_sql.cfm?">--->
</form>

<cfif data.recordcount gt 0 and isdefined("url.id_tramite") and len(trim(url.id_tramite))>
	<table align="center" width="540" cellpadding="2" cellspacing="0">
		<tr bgcolor="#ECE9D8" style="padding:3px; "><td style="padding:3px; "><strong>Otros Requisitos:&nbsp; </td></tr>
		<tr><td ><cfinclude template="datos-variables.cfm"></td></tr>
	</table>
</cfif>

</body>
</html>
