<cfquery name="rsTransac" datasource="#session.dsn#">
	select tp.CCHcod,(select Usulogin from Usuario where Usucodigo=tp.BMUsucodigo and CEcodigo = #session.CEcodigo#) as Usu,
	tp.BMfecha,tp.CCHTtipo, CCHid,CCHTid
	 from CCHTransaccionesProceso tp where CCHid= #form.CCHid#
	 and CCHTtipo in ('APERTURA','AUMENTO','DISMINUCION','CIERRE','REINTEGRO')
</cfquery>

<table width="100%" align="center" cellpadding="2" cellspacing="0" border="1"> 
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td>
			<strong>Transacci&oacute;n</strong>
		</td>
		<td>
			<strong>Usuario</strong>
		</td>
		<td>
			<strong>Tipo Transaccion</strong>
		</td>
		<td>
			<strong>Fecha</strong>
		</td>
		
	</tr>
	<cfloop query="rsTransac">
	<cfoutput>
		<tr  class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td>			
				<a href="javascript:doConlis(#rsTransac.CCHTid#);">
					#rsTransac.CCHcod#
				</a>				
			</td>
			<td>
				#rsTransac.Usu#
			</td>
			 <td>
				#rsTransac.CCHTtipo#
			</td>
            <td>
				#LSDateFormat(rsTransac.BMfecha,'DD/MM/YYYY')#
			</td>
		</tr>
	</cfoutput>
	</cfloop>
</table>

<script language="javascript1.1" type="text/javascript">

var popUpWinSN=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}

function doConlis(transac){
<cfoutput>
	popUpWindow("/cfmx/sif/tesoreria/GestionEmpleados/CCHDtransacciones.cfm?CCHid=#form.CCHid#&CCHTid="+transac,350,250,800,500);
					
</cfoutput>
}

function closePopUp(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}

function funcfiltro(){
<cfoutput>
	document.detAFVR.action='inconsistencias_form.cfm';
	document.detAFVR.submit();
</cfoutput>
}
</script>
