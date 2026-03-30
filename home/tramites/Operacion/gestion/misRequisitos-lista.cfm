<!--- 
	Creado por: Ana Villavicencio
	Fecha: 11 de Agosto del 2005
	Motivo: Mostrar lista de requisitos de un tramite en especifico.
 --->
<cfinvoke component="home.tramites.componentes.tramites"
	method="detalle_tramite"
	id_persona="#url.id_persona#"
	id_tramite="#url.id_tramite#"
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
	

<table border="0" cellpadding="2" cellspacing="0" width="520">
	<cfset datos_variables_mostrado = false>
	<cfloop query="instancia">


		<!---<cfinclude template="misrequisitos-variables.cfm">--->
		<cfset datos_var = '' >



		<tr bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>"
			style="cursor: pointer;"
			onClick="javascript:location.href= 'req_cumplido.cfm?id_tramite= #url.id_tramite#&id_persona=#form.id_persona#&id_tipoident=#url.id_tipoident#&id_requisito=#instancia.id_requisito#&misreq=true';"			onMouseOver="javascript: style.color = 'red'" 
			onMouseOut="javascript: style.color = 'black'">
			<td width="16"><img src="/cfmx/home/tramites/images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#"></td>
			<td width="16" align="center"> <font style="font-size:16px">#CurrentRow#<font style="font-size:16px"></td>
			<td width="16">
				<cfif Len(datos_var)>	
					<cfset datos_variables_mostrar = (not completado) and permisos and (not datos_variables_mostrado)>
					<cfset datos_variables_mostrado = datos_variables_mostrado or datos_variables_mostrar>
					<a href="javascript:reqlista_mostrar_tr('#CurrentRow#')">
					<img id="reqlista_img_#CurrentRow#" 
						src="<cfif not datos_variables_mostrar>/cfmx/home/tramites/images/tri-closed.gif<cfelse>../../images/tri-open.gif</cfif>" 
						alt="info" width="16" height="16" border="0" title="Ver detalle">
					</a>
		  		</cfif>	
			</td>
			<td width="376"><font style="font-size:16px">#instancia.nombre_requisito#</font></td>
			<td width="80">
				<cfif len(trim(instancia.fecha_registro))>
					<font style="font-size:16px">#LSDateFormat(instancia.fecha_registro,'dd/mm/yyyy')#</font>
				</cfif>
			</td>
			<td width="16" align="right">
				<a href="javascript:infoRequisito(#id_requisito#,#id_tramite#)">
				<img style="cursor:hand;" alt="Ver Detalle del Requisito #trim(instancia.codigo_requisito)# - #instancia.nombre_requisito#" 
					src="/cfmx/home/tramites/images/info.gif" border="0"></a>
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
		<!--- <cfelseif Len(datos_var) and isdefined('url.imprimir')> --->
			<tr id="reqlista_det" style="display:none;" bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
				<td colspan="2">&nbsp;</td>
				<td colspan="4">
					#datos_var#
				</td>
			</tr>
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
</table>
		
	<input type="hidden" name="id_requisito" value="<cfoutput>#requisitos#</cfoutput>">
</form>

</cfoutput>



