<script type="text/javascript" language="javascript1.2">
	function funcMuestraDetalles(prn_RHOPid){
		if (document.forms['form2'].nosubmit) {document.forms['form2'].nosubmit=false;return false;}		
		var nav_detalle    = document.getElementById("nav_detalle");
		nav_detalle.style.display = '';
		document.form2.RHOPid.value = prn_RHOPid;
		document.getElementById("OtrasO").width = 0;
		document.getElementById("OtrasO").height = 0;
		document.getElementById("Detalle").width = 950;
		document.getElementById("Detalle").height = 300;
		document.getElementById("Detalle").src="OtrasPartidasD.cfm?RHEid="+document.form2.RHEid.value+"&RHOPid="+prn_RHOPid;
	}

	function funcRegresaPlazas(prn_RHEid){		
		var nav_detalle    = document.getElementById("nav_detalle");
		nav_detalle.style.display = 'none';
		document.form2.RHEid.value = prn_RHEid;
		document.getElementById("OtrasO").src="SP-PPresupuestarias.cfm?RHEid="+prn_RHEid;
		document.getElementById("OtrasO").width = 950;
		document.getElementById("OtrasO").height = 300;
		document.getElementById("Detalle").width = 0;
		document.getElementById("Detalle").height = 0;	
	}
	function funcNavega(prs_opcion){
		/*////////	Valores de prs_opcion: /////////////
				PP --> Plazas Presupuestarias
				CO --> Detalles
		*//////////////////////////////////////////////		
		if (prs_opcion == 'OP'){				
			//document.form2.Categoria.value = '';
			document.form2.RHOPid.value = '';
			document.getElementById("OtrasO").src="OtrasPartidas.cfm?RHEid="+document.form2.RHEid.value;
			document.getElementById("OtrasO").width = 950;
			document.getElementById("OtrasO").height = 300;
			document.getElementById("Detalle").width = 0;
			document.getElementById("Detalle").height = 0;
			var nav_detalle    = document.getElementById("nav_detalle");
			nav_detalle.style.display = 'none';						
		}	
		if (prs_opcion == 'CO'){
			document.getElementById("Detalle").src="DetallesOtrasP.cfm?RHEid="+document.form2.RHEid.value+"&RHOPid="+document.form2.RHOPid.value;
			document.getElementById("Detalle").width = 950;
			document.getElementById("Detalle").height = 300;
			document.getElementById("OtrasO").width = 0;
			document.getElementById("OtrasO").height = 0;
		}		
	}
</script>
<cfoutput>
<form name="form2" action="" method="post">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr >
			<td >
				<table width="100%" border="0" class="navbar">
					<tr><td>  
						<table width="50" border="0" >				  							
							<input type="hidden" name="RHOPid" value=""><!----  name="RHPEid" Detalle seleccionada de la lista ---->
							<input type="hidden" name="RHEid" value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">	<!---Llave del escenario de la lista--->
							<input type="hidden" name="RHEfdesde" value="<cfif isdefined("data") and len(trim(data.RHEfdesde))>#data.RHEfdesde#</cfif>"><!---- Fecha desde del escenario seleccionado---->
							<input type="hidden" name="RHEfhasta" value="<cfif isdefined("data") and len(trim(data.RHEfhasta))>#data.RHEfhasta#</cfif>"><!---- Fecha hasta del escenario seleccionado---->
							  <tr>
								<td width="1%">&nbsp;</td>
								<td width="12%" id="nav_OtrasP" nowrap><a href="javascript: funcNavega('OP');">Otras Partidas</a></td>
								<td width="70%" id="nav_detalle" nowrap style="display:none"><a href="javascript: funcNavega('DP');">> Detalle</a></td>
							  </tr>				  
						</table>		
					</td></tr>
				</table>							  		
			</td>
		</tr>
		<tr><td valign="top">
			<cfoutput><iframe id="OtrasO" frameborder="0" name="OtrasO" width="950"  height="300" style="visibility:visible;border:none; vertical-align:top" src="OtrasPartidas.cfm?RHEid=#form.RHEid#&RHEfdesde=#data.RHEfdesde#&RHEfhasta=#data.RHEfhasta#"></iframe></cfoutput>
			<iframe id="Detalle"  frameborder="0" name="Detalle"  width="0" height="0" style="visibility:visible; border:none;"></iframe>
		</td></tr>	
	</table>
</form>	
</cfoutput>



