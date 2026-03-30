<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Transaccion" default="Transacci&oacute;n" returnvariable="LB_Transaccion"  xmlfile="CCHtransacciones.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Usuario" default="Usuario" returnvariable="LB_Usuario"  xmlfile="CCHtransacciones.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TipoTransaccion" default="Tipo Transacci&oacute;n" returnvariable="LB_TipoTransaccion"  xmlfile="CCHtransacciones.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default="Fecha" returnvariable="LB_Fecha"  xmlfile="CCHtransacciones.xml">

<cfquery name="rsTransac" datasource="#session.dsn#">
	select tp.CCHcod,(select Usulogin from Usuario where Usucodigo=tp.BMUsucodigo and CEcodigo = #session.CEcodigo#) as Usu,
	tp.BMfecha,tp.CCHTtipo, CCHid,CCHTid
	 from CCHTransaccionesProceso tp where CCHid= #form.CCHid#
	 and CCHTtipo in ('APERTURA','AUMENTO','DISMINUCION','CIERRE','REINTEGRO')
</cfquery>

<table width="100%" align="center" cellpadding="2" cellspacing="0" border="1"> 
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td>
			<strong><cfoutput>#LB_Transaccion#</cfoutput></strong>
		</td>
		<td>
			<strong><cfoutput>#LB_Usuario#</cfoutput></strong>
		</td>
		<td>
			<strong><cfoutput>#LB_TipoTransaccion#</cfoutput></strong>
		</td>
		<td>
			<strong><cfoutput>#LB_Fecha#</cfoutput></strong>
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
