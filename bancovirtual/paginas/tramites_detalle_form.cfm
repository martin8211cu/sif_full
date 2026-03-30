<cfinvoke component="home.tramites.componentes.tramites"
	method="detalle_tramite"
	id_persona="#session.user#"
	id_tramite="#url.id_tramite#"
	id_funcionario="0"
	returnvariable="data" />

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

<cfquery name="tramite" datasource="tramites_cr">
	select nombre_tramite
	from TPTramite
	where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
</cfquery>


<table width="530" align="center"  style=" border:1px solid #595959 ">
	<tr>
		<td colspan="2" align="left" bgcolor="#FFFFFF" class="bajada" style="padding:5px;" id=color8 nowrap ><div align="left"><b><font size="3">Tr&aacute;mite: <cfoutput>#tramite.nombre_tramite#</cfoutput></font></b></div></td>
	</tr>					

	<tr><td bgcolor="#595959"><font size="2" color="#FFFFFF" face="Geneva, Arial, Helvetica, sans-serif"><strong>Listado de Requisitos</strong></font></td></tr>
	<tr>
		<td>
			<table width="515" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td  align="center" bgcolor="#FFFFFF" width="60" class="bajada" id=color8 height="15"><div align="right"><b>REQUISITOS</b></div></td>
					<td  align="center" bgcolor="#FFFFFF" width="60" class="bajada" id=color8 height="15"><div align="center"><b>ESTADO</b></div></td>
					<td align="center" bgcolor="#FFFFFF" width="60" class="bajada" id=color8 height="15">&nbsp;</td>
				</tr>
				
				<cfoutput query="data">
					<tr> 
						<td align="center" bgcolor="<cfif data.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="left"><cfif data.es_pago eq 1 and data.completado eq 0><a title="Ir a Pagar" <cfif data.es_pago eq 1 and data.completado eq 0 >style="color:##BB0E12"<cfelse>style="color:##666666"</cfif> href="pagar.cfm?id_tramite=#data.id_tramite#&id_requisito=#data.id_requisito#"></cfif> #data.nombre_requisito#<cfif data.es_pago eq 1  and data.completado eq 0></a></cfif></div></td>
						<td align="center" bgcolor="<cfif data.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7>
							<div align="center">
								<cfif data.completado eq 1 >
									Completado
								<cfelseif data.es_pago eq 1 and data.completado eq 0>
									<a title="Ir a Pagar" style="color:##BB0E12" href="pagar.cfm?id_tramite=#data.id_tramite#&id_requisito=#data.id_requisito#">Ir a Pagar</a>
								<cfelseif data.completado eq 0 >
									Pendiente
								</cfif>
							</div>
						</td>
						<td width="1%" align="center" bgcolor="<cfif data.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7>
							<cfif data.es_pago eq 1 and data.completado eq 0>
								<a title="Ir a Pagar" style="color:##BB0E12" href="pagar.cfm?id_tramite=#data.id_tramite#&id_requisito=#data.id_requisito#"><img src="../images/plata.gif" border="0"></a>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			</table> 
		</td>
	</tr>
</table>

<br>
<table align="center" > 
<tr>
	<td><img style="cursor:hand; " src="../images/regresar.gif" onClick="location.href='tramites.cfm'"></td>
</tr>
</table>



<!---
<table border="0" cellpadding="2" cellspacing="0" width="530">
	<cfset datos_variables_mostrado = false>
	<cfloop query="data">
		<!---<cfinclude template="misrequisitos-variables.cfm">--->
		<tr bgcolor="<cfif data.currentrow mod 2>##FAFAFA</cfif>"
			style="cursor: pointer;"
			onClick="javascript:location.href= 'req_cumplido.cfm?id_tramite= #url.id_tramite#&id_persona=#session.user#&id_requisito=#data.id_requisito#&misreq=true';"			onMouseOver="javascript: style.color = 'red'" 
			onMouseOut="javascript: style.color = 'black'">
			<td width="16"><img src="/cfmx/home/tramites/images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#"></td>
			<td width="16" align="center"> <font style="font-size:16px">#CurrentRow#<font style="font-size:16px"></td>
			<td width="16">
				<cfif isdefined('datos_var') and Len(datos_var)>	
					<cfset datos_variables_mostrar = (not completado) and permisos and (not datos_variables_mostrado)>
					<cfset datos_variables_mostrado = datos_variables_mostrado or datos_variables_mostrar>
					<cfif not isdefined('url.imprimir')>
					<a href="javascript:reqlista_mostrar_tr('#CurrentRow#')">
					<img id="reqlista_img_#CurrentRow#" 
						src="<cfif not datos_variables_mostrar>/cfmx/home/tramites/images/tri-closed.gif<cfelse>../../images/tri-open.gif</cfif>" 
						alt="info" width="16" height="16" border="0" title="Registrar detalle">
					</a>
					</cfif>
		  		</cfif>	
			</td>
			<td width="376"><font style="font-size:16px">#data.nombre_requisito#</font></td>
			<td width="80">
				<cfif len(trim(data.fecha_registro))>
					<font style="font-size:16px">#LSDateFormat(data.fecha_registro,'dd/mm/yyyy')#</font>
				</cfif>
			</td>
			<td width="16" align="right">
				<a href="javascript:infoRequisito(#id_requisito#,#id_tramite#)">
				<img style="cursor:hand;" alt="Ver Detalle del Requisito #trim(data.codigo_requisito)# - #data.nombre_requisito#" 
					src="/cfmx/home/tramites/images/info.gif" border="0"></a>
			</td>
		</tr>
		<cfif isdefined('datos_var') and Len(datos_var) and not isdefined('url.imprimir')>
			<tr id="reqlista_det_#CurrentRow#" style="<cfif not datos_variables_mostrar>display:none;</cfif>" 
				bgcolor="<cfif data.currentrow mod 2>##FAFAFA</cfif>">
				<td colspan="2">&nbsp;</td>
				<td colspan="4">
					#datos_var#
				</td>
			</tr>
		<cfelseif isdefined('datos_var') and  Len(datos_var) and isdefined('url.imprimir')>
			<tr bgcolor="<cfif data.currentrow mod 2>##FAFAFA</cfif>">
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
--->


