<!--- puedo hacer el mismo tramite mas de una vez ?????????? --->
<cfquery name="persona" datasource="#session.tramites.dsn#">
	select p.id_persona
	from TPPersona p
	where p.identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.identificacion_persona#">
</cfquery>
<cfif persona.recordcount eq 0 >
<cfthrow message="Error. La persona no existe.">
</cfif>

<cfinvoke component="home.tramites.componentes.tramites"
	method="detalle_tramite"
	id_persona="#persona.id_persona#"
	id_tramite="#url.id_tramite#"
	id_funcionario="#session.tramites.id_funcionario#"
	returnvariable="instancia" />

<script type="text/javascript">
<!--
function reqlista_mostrar_tr(rownum){
	var v_row = document.getElementById('reqlista_det_' + rownum);
	var v_img = document.getElementById('reqlista_img_' + rownum);
	var abrir = v_row.style.display == 'none';
	if (v_row) {
		v_row.style.display = abrir ? (document.all?'block':'table-row') : 'none';
	}
	if (v_img) {
		v_img.src = abrir ? '../../images/tri-open.gif' : '../../images/tri-closed.gif';
	}
	resize_parent();

}
var popUpWin = 0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWin){
		if(!popUpWin.closed) popUpWin.close();
	}
	popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function infoRequisito(requisito,tramite) {
	var params ="";
	params = "?id_requisito="+requisito;
	params += "&id_tramite="+tramite;
	popUpWindow("/cfmx/home/tramites/Operacion/gestion/infoRequisito.cfm"+params,250,200,650,400);
}

-->
</script>


<cfoutput>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<form name="form4" action="/cfmx/home/tramites/Operacion/gestion/datos-variables-sql.cfm" style="margin:0;" method="post">
	<input type="hidden" name="loc" value="gestion">
	<input type="hidden" name="id_tramite" value="#url.id_tramite#">
	<input type="hidden" name="id_persona" value="#data.id_persona#">
	<cfset requisitos = '' >
	<cfset campos = '' >
	

<table border="0" cellpadding="2" cellspacing="0" width="520">
	<cfset datos_variables_mostrado = false>
	<cfloop query="instancia">
		<input type="hidden" name="id_requisito" value="#instancia.id_requisito#">
		<cfset tiene_cita = '' >
		<cfset tiene_conexion = '' >
		<cfif instancia.es_cita and len(trim(instancia.id_cita)) >
			<cfquery name="cita" datasource="#session.tramites.dsn#">
				select fecha from TPCita where id_cita = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_cita#">
			</cfquery>
			<cfsavecontent variable="tiene_cita">
				<table>
				<tr>
					<td width="1%"><img src="../../images/cita.gif" border="0"></td>
					<td align="left">Cita programada para el dia #LSDateFormat(cita.fecha,'dd/mm/yyyy')#, #LSTimeFormat(cita.fecha, 'h:mm tt')#</td>
				</tr>
				</table>
			</cfsavecontent>
		</cfif>
		
		<cfif instancia.es_conexion and len(trim(instancia.id_documento)) >
			<cfset institucion = '' >
			<cfquery name="doc" datasource="#session.tramites.dsn#">
				select id_inst
				from TPDocumento
				where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_documento#">
			</cfquery>
			<cfquery name="inst" datasource="#session.tramites.dsn#">
				select id_inst, nombre_inst
				from TPInstitucion
				where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#doc.id_inst#">
			</cfquery>
			<cfset institucion = inst.nombre_inst >

			<cfif len(trim(institucion))>
			<cfsavecontent variable="tiene_conexion">
				<table>
				<tr>
					<td width="1%"><a href="/cfmx/home/tramites/Operacion/gestion/conectar-sql.cfm?id_tramite=#instancia.id_tramite#&id_requisito=#instancia.id_requisito#&id_documento=#instancia.id_documento#&id_persona=#data.id_persona#&identificacion_persona=#data.identificacion_persona#&id_tipoident=#data.id_tipoident#"><img src="../../images/conexion.gif" border="0"></a></td>
					<td align="left"><a href="/cfmx/home/tramites/Operacion/gestion/conectar-sql.cfm?id_tramite=#instancia.id_tramite#&id_requisito=#instancia.id_requisito#&id_documento=#instancia.id_documento#&id_persona=#data.id_persona#&identificacion_persona=#data.identificacion_persona#&id_tipoident=#data.id_tipoident#">Conectarse a #institucion#</a></td>
				</tr>
				</table>
			</cfsavecontent>
			</cfif>
		</cfif>
		
		<cfinclude template="../../vistas/requisitos-variables.cfm">		
		
		<!---<cfinclude template="requisitos-variables.cfm">--->
		<tr bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
			<cfif Len(link)>
				<cfset link2 = link & "?id_persona=#instancia.id_persona#">
				<cfset link2 = link2 & "&id_instancia=#instancia.id_instancia#">
				<cfset link2 = link2 & "&id_tramite=#url.id_tramite#">
				<cfset link2 = link2 & "&id_requisito=#instancia.id_requisito#">
				<cfset link2 = link2 & "&id_tipoident=#url.id_tipoident#">
				<cfset link2 = "href='" & link2 & "'" >
			</cfif>
			<td width="16"><a #link2# ><img src="../../images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#"></a></td>
			<td width="16" align="center"><a style="font-size:16px" #link2# >#CurrentRow#</a></td>
			<td width="16">
				<cfif Len(datos_var) or ( instancia.es_pago eq 0 and instancia.permisos eq 1 )>
					<cfset datos_variables_mostrar = (not completado) and permisos and (not datos_variables_mostrado)>
					<cfset datos_variables_mostrado = datos_variables_mostrado or datos_variables_mostrar>
					<a href="javascript:reqlista_mostrar_tr('#CurrentRow#')">
					<img id="reqlista_img_#CurrentRow#" 
						src="<cfif not datos_variables_mostrar>../../images/tri-closed.gif<cfelse>../../images/tri-open.gif</cfif>" 
						alt="info" width="16" height="16" border="0" title="Registrar detalle">
					</a>
		  </cfif>		  </td>
			<td width="376"><a style="font-size:16px" #link2# >
			<!---#trim(instancia.codigo_requisito)# - --->
			</a><a style="font-size:16px" #link2# >#instancia.nombre_requisito#</a></td>
			 <td width="80"><cfif len(trim(instancia.fecha_registro))><a style="font-size:16px" #link2# >
		 #LSDateFormat(instancia.fecha_registro,'dd/mm/yyyy')#</a></cfif></td>
		<td width="16" align="right">
		<a href="javascript:infoRequisito(#id_requisito#,#id_tramite#)">
		<img style="cursor:hand;" alt="Ver Detalle del Requisito #trim(instancia.codigo_requisito)# - #instancia.nombre_requisito#" 
			src="../../images/info.gif" border="0"></a>
		  </td>
		
		</tr>
		
		<cfif Len(datos_var)>
			<tr id="reqlista_det_#CurrentRow#" style="<cfif not datos_variables_mostrar>display:none;</cfif>" 
				bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
				<td colspan="2">&nbsp;</td>
				<td colspan="4">
					#datos_var#
				</td>
			</tr>
		<cfelse>
			<cfif instancia.es_pago eq 0 and instancia.permisos eq 1 >
				<tr id="reqlista_det_#CurrentRow#" style="<cfif not datos_variables_mostrar>display:none;</cfif>" 
					bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
					<td colspan="2">&nbsp;</td>
					<td colspan="4">
						<table width="480" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid black;background-color:##ededed ">
							<tr><td colspan="2">
								<cfoutput>
								<input type="checkbox" name="completado_#instancia.id_requisito#" id="completado_#instancia.id_requisito#" value="1" <cfif instancia.completado>checked</cfif> >
								<label for="completado_#instancia.id_requisito#">
								 <strong>Marcar el requisito como completado</strong></label>
								 </cfoutput>
								 </td></tr>
								<tr><td colspan="2">#tiene_cita#</td></tr>
								<tr><td colspan="2">#tiene_conexion#</td></tr>
						</table>
					</td>
				</tr>
			</cfif>
		</cfif>
	</cfloop>
	
	<tr><td colspan="6">&nbsp;</td></tr>
	<tr>
		<td colspan="6" style="border:1px solid gray " >
		<div style="width:100%;cursor:pointer;background-color:##ededed"
			 id="leyenda_requisitos_titulo" onclick="var x=document.getElementById('leyenda_requisitos_contenido');if(x){x.style.display=x.style.display=='none'?'block':'none';}">
			 <strong><em>Leyenda:</em></strong>
		</div>
		<div id="leyenda_requisitos_contenido" style="display:block;width:510px;">
			<img src="/cfmx/home/tramites/images/check-verde.gif"> Terminado<br>
			<img src="/cfmx/home/tramites/images/candado.gif"> No tiene permisos<br>
			<img src="/cfmx/home/tramites/images/plata.gif"> Requiere pago previo<br>
			<img src="/cfmx/home/tramites/images/cita.gif"> Sacar cita<br>
			<img src="/cfmx/home/tramites/images/no-esta.gif"> No est&aacute; en el expediente
		</div>
	</td></tr>
	<tr><td colspan="6">&nbsp;</td></tr>
	<tr><td colspan="6" align="center"><input type="submit" name="Guardar" value="Guardar" class="boton"></td></tr>
</table>
		
	<!---<input type="hidden" name="id_requisito" value="<cfoutput>#requisitos#</cfoutput>">--->
	<input type="hidden" name="id_campo" value="<cfoutput>#campos#</cfoutput>">
</form>

</cfoutput>



