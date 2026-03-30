<!---
<cfif isdefined("url.id_instancia") and len(trim(url.id_instancia))>
	<cfset form.id_instancia = url.id_instancia >
</cfif>

<link type="text/css" rel="stylesheet" href="../../tramites.css">

<cfquery name="tramite" datasource="tramites_cr">
	select id_tramite, id_instancia
	from TPInstanciaTramite
	where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
</cfquery>

<cfquery name="trdata" datasource="tramites_cr">
	select codigo_tramite, nombre_tramite, nombre_inst, descripcion_tramite, nombre_tipotramite
	from TPTramite t 
	
	left outer join TPInstitucion i
	  on t.id_inst = i.id_inst
	
	left outer join TPTipoTramite tt
	  on t.id_tipotramite = tt.id_tipotramite
	
	where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tramite.id_tramite#">
</cfquery>
<cfoutput>
		<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td bgcolor="##ECE9D8" style="padding:3px; font-size:20px;">
				<strong>#trim(trdata.nombre_tramite)#</strong>
				</td>
			<td bgcolor="##ECE9D8" style="padding:3px; font-size:20px;" align="right">
				<table width="100%" border="0" cellpadding="0" cellspacing="2">
					<tr>
						<td align="right"><input type="button" value="Cerrar" class="boton" onClick="javascript:location.href='/cfmx/home/index.cfm'"></td>
						<td>				<a href="javascript:infoTramite(#tramite.id_tramite#)">
				<img alt="Ver Detalle del Tramite #trim(trdata.codigo_tramite)# - #trdata.nombre_tramite#" 
					src="/cfmx/home/tramites/images/info.gif" border="0"></a>
</td>
					</tr>
				</table>
			</td>
			</tr>
			<tr>
				<td colspan="2">
					<table width="520" cellpadding="2" cellspacing="0">
						<tr>
							<td valign="top">
								<table width="100%" cellpadding="2" cellspacing="0">
									<tr>
										<td valign="top"><font size="2"><strong>No. Tr&aacute;mite:</strong> #tramite.id_instancia#</font></td>
									</tr>

									<tr>
										<td valign="top"><font size="2"><strong>Identificaci&oacute;n:</strong> #data.identificacion_persona#</font></td>
									</tr>

									<tr>
										<td valign="top"><font size="2"><strong>Persona:</strong> #data.nombre# #data.apellido1# #data.apellido2#</font></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
</cfoutput>

<script type="text/javascript" language="javascript1.2">
var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

		function infoTramite(tramite) {
			var params ="";
			params = "?id_tramite="+tramite;
			popUpWindow("/cfmx/home/tramites/Operacion/gestion/infoTramite.cfm"+params,250,200,650,400);
		}
</script>
--->