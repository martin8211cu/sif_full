<cfinvoke component="home.tramites.componentes.tramites"
	method="detalle_tramite"
	id_persona="#form.id_persona#"
	id_tramite="#tramite.id_tramite#"
	id_funcionario="#session.tramites.id_funcionario#"
	returnvariable="instancia" />

<script type="text/javascript">
<!--
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
<table border="0" cellpadding="3" cellspacing="0" width="100%">
	<tr>
		<td width="50%" valign="top">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td bgcolor="##ECE9D8" colspan="3" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Requisitos</strong></td>
				</tr>

				<!--- este include pinta los tr/td necesarios--->
				<tr><td colspan="3">
				<cfinclude template="lista-requisitos.cfm">
				</td></tr>
								
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr>
					<td colspan="3" style="border:1px solid gray " >
					<div style="width:100%;cursor:pointer;background-color:##ededed"
						 id="leyenda_requisitos_titulo" onclick="var x=document.getElementById('leyenda_requisitos_contenido');if(x){x.style.display=x.style.display=='none'?'block':'none';}">
						 <strong><em>Leyenda:</em></strong>
					</div>
					<div id="leyenda_requisitos_contenido" style="display:block;width:100%;">
						<img src="/cfmx/home/tramites/images/check-verde.gif"> Terminado<br>
						<img src="/cfmx/home/tramites/images/candado.gif"> No tiene permisos<br>
						<img src="/cfmx/home/tramites/images/plata.gif"> Requiere pago previo<br>
						<img src="/cfmx/home/tramites/images/cita.gif"> Sacar cita<br>
						<img src="/cfmx/home/tramites/images/no-esta.gif"> No est&aacute; en el expediente
					</div>
				</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3" align="center"></td></tr>
			</table> 
		</td>
		<td width="50%" valign="top">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Informaci&oacute;n del Requisito</strong></td>
				</tr>
				
				<tr>
					<td>
						<cfloop query="instancia">
							<div id="info_req_#instancia.id_requisito#" style="display:block; width:100%px; elevation:above; display: <cfif instancia.currentrow neq 1>none</cfif>;" >
							<cfinclude template="info-requisito.cfm">
							<cfinclude template="lugares-requisito.cfm">
							</div>
						</cfloop>
					</td>
				</tr>
				
			</table>
		</td>
	</tr>

</table>
</cfoutput>



<script language="javascript1.2" type="text/javascript">
	/*
	function informacion(id){
		<cfloop query="instancia">
			document.getElementById('info_req_<cfoutput>#instancia.id_requisito#</cfoutput>').style.display = 'none';
			document.getElementById('tr_<cfoutput>#instancia.id_requisito#</cfoutput>').bgColor = <cfif instancia.currentrow mod 2>'#FAFAFA'<cfelse>'#FFFFFF'</cfif>;
		</cfloop>
		document.getElementById('tr_'+id).bgColor = '#E4E8F3';
		document.getElementById('info_req_'+id).style.display = '';
	}
	*/
	
	function informacion(id){
		<cfloop query="instancia">
			document.getElementById('img<cfoutput>#instancia.id_requisito#</cfoutput>').style.display = 'none';
			document.getElementById('info_req_<cfoutput>#instancia.id_requisito#</cfoutput>').style.display = 'none';
			document.getElementById('tr_<cfoutput>#instancia.id_requisito#</cfoutput>').bgColor = <cfif instancia.currentrow mod 2>'#FAFAFA'<cfelse>'#FFFFFF'</cfif>;
		</cfloop>
		document.getElementById('img'+id).style.display = '';
		document.getElementById('tr_'+id).bgColor = '#E4E8F3';
		document.getElementById('info_req_'+id).style.display = '';
	}	
	
</script>
