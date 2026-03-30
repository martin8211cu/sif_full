<!--- 
	Creado por: Ana Villavicencio
	Fecha: 11 de Agosto del 2005
	Motivo: forma Mostrar lista de requisitos en proceso y anteriores.
 --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<title>Untitled Document</title>
</head>

<body style="margin:0" onload="resize_parent()">

<cfinclude template="../portlet/ventanilla_sql.cfm">

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
		where identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.ID#">
	</cfquery>
	<cfparam name="form.id_persona" default="#data.id_persona#">

	<cfif data.recordcount gt 0 and isdefined("url.id_tramite") and len(trim(url.id_tramite))>
		<cfquery name="infoTramite" datasource="#session.tramites.dsn#">
			select codigo_tramite, nombre_tramite
			from TPTramite
			where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		</cfquery>
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


		<form name="form1" action="" method="get" style="margin:0;" onSubmit="return validar_form1(this);">
		<input type="hidden" name="loc" value="gestion">
		<table border="0" cellpadding="0" cellspacing="0" width="520" align="center">
			<cfif data.recordcount gt 0 >
				<tr>
					<td width="510" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; font-size:20px;">
					<strong>Mis Tr&aacute;mites</strong>
					</td>
				</tr>
				<tr><td><cfinclude template="hdr_persona.cfm"></td></tr>
				<tr>
					<td>
						<table width="520" cellpadding="2" cellspacing="0" align="center">
							<cfquery name="rsTramites" datasource="#session.tramites.dsn#">
								select fecha_inicio, nombre_tramite, it.id_tramite
								from TPInstanciaTramite it 
								left outer join TPTramite t
								  on it.id_tramite = t.id_tramite
								where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_persona#">
								  and completo = 0
							</cfquery>
							<cfif rsTramites.RecordCount>
								<tr>
									<td width="520" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; font-size:16px;"  colspan="2">
										<strong>Tr&aacute;mites proceso</strong>
									</td>
								</tr>
								<tr>
									<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; font-size:14px;"><strong>Fecha</strong></td>
									<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; font-size:14px;"><strong>Tr&aacute;mite</strong></td>
								</tr>
								<cfloop query="rsTramites">
									<tr style="cursor: pointer;"
									onClick="javascript:location.href= 'TramiteEnProceso.cfm?id_tramite= #rsTramites.id_tramite#&id_persona=#session.datos_personales.ID#';"
									onMouseOver="javascript: style.color = 'red'" 
									onMouseOut="javascript: style.color = 'black'" 
									<cfif rsTramites.CurrentRow MOD 2>bgcolor="##FFFFFF"<cfelse>bgcolor="##EFEFEF"</cfif>>
										<td>#LSDateFormat(fecha_inicio,'dd/mm/yyyy')#</td>
										<td>#nombre_tramite#</td>
									</tr>
								</cfloop>
							<cfelse>
								No tiene tramites en proceso
							</cfif>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="520" cellpadding="2" cellspacing="0" align="center">
							<cfquery name="rsTramites" datasource="#session.tramites.dsn#">
								select fecha_inicio, nombre_tramite, it.id_tramite
								from TPInstanciaTramite it 
								left outer join TPTramite t
								  on it.id_tramite = t.id_tramite
								where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_persona#">
								  and completo = 1
							</cfquery>
							<cfif rsTramites.RecordCount>
								<tr>
									<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; font-size:16px;" colspan="2">
										<strong>Tr&aacute;mites anteriores</strong>
									</td>
								</tr>
								<tr>
									<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; font-size:14px;"><strong>Fecha</strong></td>
									<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; font-size:14px;"><strong>Tr&aacute;mite</strong></td>
								</tr>
								<cfloop query="rsTramites">
									<tr style="cursor: pointer;"
										onClick="javascript:location.href= 'TramiteEnProceso.cfm?id_tramite= #rsTramites.id_tramite#&id_persona=#session.datos_personales.ID#';"
										onMouseOver="javascript: style.color = 'red'" 
										onMouseOut="javascript: style.color = 'black'" 
										<cfif rsTramites.CurrentRow MOD 2>bgcolor="##FFFFFF"<cfelse>bgcolor="##EFEFEF"</cfif>>
										<td>vvvv#LSDateFormat(fecha_inicio,'dd/mm/yyyy')#</td>
										<td>#nombre_tramite#</td>
									</tr>
								</cfloop>
							</cfif>
						</table>
					</td>
				</tr>
			<cfelseif isdefined("url.identificacion_persona") and len(trim(url.identificacion_persona))>
				<tr>
					<td colspan="2" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Datos Personales</strong></td>
				</tr>
				<tr><td colspan="2" align="center">No se encontro la persona</td></tr>
			</cfif>
		</table>

		</form>
		</cfoutput>
	</td></tr>
	<script language="javascript1.2" type="text/javascript">
	
		function validar_form1(f){
			var msj = '';
			
			if( f.id_tipoident.value == '' ){
				msj += ' - El campo Tipo de Identificación es requerido.\n';
			}
			if( f.identificacion_persona.value == '' ){
				msj += ' - El campo Identificación es requerido.\n';
			}
			if (msj != ''){
				alert('Se presentaron los siguientes errores:\n' + msj)
				return false;
			}

			return true;
		}
		
	
	</script>
</table>


</body>
</html>
