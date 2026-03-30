<!--- 
	Creado por: Ana Villavicencio
	Fecha: 11 de Agosto del 2005
	Motivo: Mostrar el detalle de un tramite especifico.
 --->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<title>Untitled Document</title>
</head>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<body style="margin:0" onload="resize_parent()">


<cfif isdefined("url.id_persona") and not isdefined("form.id_persona")>
	<cfparam name="form.id_persona" default="#url.id_persona#">
</cfif>
<cfif isdefined("url.id_tipoident") and not isdefined("form.id_tipoident")>
	<cfparam name="form.id_tipoident" default="#url.id_tipoident#">
</cfif>


<cfset frame_height = 130>
<cfif isdefined("url.id_persona") and Len(Trim(url.id_persona)) GT 0>
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



	<cfparam name="url.id_persona" default="">
	<cfparam name="url.id_tipoident" default="0">
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select 	p.id_persona,
				p.id_tipoident, 
			   	p.id_direccion, 
				p.id_persona, 
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
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(url.id_persona)#">
	</cfquery>


	<cfif data.recordcount gt 0 and isdefined("url.id_tramite") and len(trim(url.id_tramite))>
		<cfquery name="infoTramite" datasource="#session.tramites.dsn#">
			select codigo_tramite, nombre_tramite
			from TPTramite
			where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		</cfquery>
	</cfif>
<cfset param = 'id_tramite='& #url.id_tramite# & '&id_persona='& #url.id_persona# & '&id_tipoident=' & #url.id_tipoident#>
<table width="510" border="0" align="center" cellpadding="0" cellspacing="0">
	<!--- <cfif not  isdefined('url.imprimir')>
	<tr><td><cf_rhimprime datos="/home/tramites/Operacion/gestion/TramiteEnProceso.cfm" paramsuri="&#param#"></td></tr>
	
	</cfif> --->
	<tr><td colspan="4">

		<cfoutput>
		<cfquery name="tipoidentificacion" datasource="#session.tramites.dsn#">
			select id_tipoident, codigo_tipoident, nombre_tipoident 
			from TPTipoIdent
		</cfquery>


		<form name="form1" action="" method="get" style="margin:0;" onSubmit="return validar_form1(this);">
		<input type="hidden" name="loc" value="gestion">
		<cfif isdefined("url.id_instancia") and len(trim(url.id_instancia))>
			<input type="hidden" name="id_instancia" value="<cfoutput>#url.id_instancia#</cfoutput>">
		</cfif>
		<table border="0" cellpadding="0" cellspacing="0" width="520">
			
			
			<cfif data.recordcount gt 0 >
			<tr>
				<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; font-size:20px;" width="445">
                  <strong>#trim(infoTramite.nombre_tramite)#</strong> </td>
				 
				<td nowrap bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; " align="right" width="65">
					<a href="javascript:imprimir();" id="imp">
						<img src="../../images/impresora.gif" border="0" alt="Imprimir">
					</a>
					<a href="javascript:infoTramite(#id_tramite#)">
					<img alt="Ver Detalle del Tramite #trim(infoTramite.codigo_tramite)# - #infoTramite.nombre_tramite#" 
						src="/cfmx/home/tramites/images/info.gif" border="0"></a>
				</td>
			</tr>
			<tr >
				<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; " colspan="2" ><strong>Datos Personales</strong></td>
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
								<table cellpadding="2" cellspacing="0">
									<tr><td valign="top">#data.nombre# #data.apellido1# #data.apellido2#</td></tr>
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
			<cfelseif isdefined("url.id_persona") and len(trim(url.id_persona))>
				<tr>
					<td colspan="2" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; ">
						<strong>Datos Personales</strong>
					</td>
				</tr>
				<tr><td colspan="2" align="center">No se encontro la persona</td></tr>
			</cfif>
		</table>

		</form>
		</cfoutput>
	</td></tr>
		
	
	<cfif data.recordcount gt 0 and isdefined("url.id_tramite") and len(trim(url.id_tramite))>
		<tr bgcolor="#ECE9D8" style="padding:3px; ">
		  <td colspan="2" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong>Requisitos</strong></td>
		</tr>
		<tr><td colspan="2"><cfinclude template="misRequisitos-lista.cfm"></td></tr>
		<cfset form.rows = instancia.REcordCount>
		<tr>
			<td align="center" id="botones">
    		    <input type="button"  onClick="javascript:Regresar();" value="Regresar" class="boton">
			</td>
		</tr>
	</cfif>


	<script language="javascript1.2" type="text/javascript">

		function validar_form1(f){
			var msj = '';
			
			if( f.id_tipoident.value == '' ){
				msj += ' - El campo Tipo de Identificación es requerido.\n';
			}
			if( f.id_persona.value == '' ){
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
			if ( document.form1.id_persona.value != '' ){
				location.href = '/cfmx/home/menu/portal.cfm?loc=gestion&id_persona='+document.form1.id_persona.value+'&id_tipotramite='+document.form1.id_tipotramite.value+'&id_tramite='+obj.value;
			}
			else{
				alert('Seleccione la persona.');
			}
		}
		
		<cfif isdefined("url.id_tipotramite") and len(trim(url.id_tipotramite))>
			document.form1.id_tipotramite.value = <cfoutput>#url.id_tipotramite#</cfoutput>
		</cfif>

		function Regresar(){
			location.href = 'misTramites-form.cfm?identificacion_persona=<cfoutput>#url.id_persona#</cfoutput>&id_tipoident=<cfoutput>#url.id_tipoident#</cfoutput>';
		}
		
		function infoTramite(tramite) {
			var params ="";
			params = "?id_tramite="+tramite;
			popUpWindow("/cfmx/home/tramites/Operacion/gestion/infoTramite.cfm"+params,250,200,650,400);
		}
		
		function imprimir() {
			var botones = document.getElementById("botones");
			var imp = document.getElementById("imp");
			//var det = document.getElementById("reqlista_det");
			imp.style.display = 'none';
			botones.style.display = 'none';
			//det.style.display = '';
			window.print()	
			botones.style.display = ''
			imp.style.display = ''
			//det.style.display = 'none';
		}	
	</script>
</table>


</body>
</html>
