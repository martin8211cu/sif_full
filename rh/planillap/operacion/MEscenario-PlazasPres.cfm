<script type="text/javascript" language="javascript1.2">
	function funcMuestraComponentes(prn_RHSAid){
		if (document.forms['form2'].nosubmit) {document.forms['form2'].nosubmit=false;return false;}
		var nav_componentes    = document.getElementById("nav_componentes");
		nav_componentes.style.display = '';
		document.form2.RHSAid.value = prn_RHSAid;
		document.getElementById("PlazaSA").width = 0;
		document.getElementById("PlazaSA").height = 0;
		document.getElementById("ComponenteSA").width = 950;
		document.getElementById("ComponenteSA").height = 300;
		document.getElementById("ComponenteSA").src="SA-ComponentePlazas.cfm?RHEid="+document.form2.RHEid.value+"&RHSAid="+prn_RHSAid;
		return false;
	}

	function funcRegresaPlazas(prn_RHEid){		
		var nav_componentes    = document.getElementById("nav_componentes");
		nav_componentes.style.display = 'none';
		document.form2.RHEid.value = prn_RHEid;
		document.getElementById("PlazaSA").src="MEPlazasPres.cfm?RHEid="+prn_RHEid;
		document.getElementById("PlazaSA").width = 950;
		document.getElementById("PlazaSA").height = 300;
		document.getElementById("ComponenteSA").width = 0;
		document.getElementById("ComponenteSA").height = 0;	
	}
	function funcNavega(prs_opcion){
		/*////////	Valores de prs_opcion: /////////////
				PP --> Plazas Presupuestarias
				CO --> Componentes
		*//////////////////////////////////////////////		
		if (prs_opcion == 'PP'){				
			//document.form2.Categoria.value = '';
			document.form2.RHSAid.value = '';
			document.getElementById("PlazaSA").src="MEPlazasPres.cfm?RHEid="+document.form2.RHEid.value;
			document.getElementById("PlazaSA").width = 950;
			document.getElementById("PlazaSA").height = 300;
			document.getElementById("ComponenteSA").width = 0;
			document.getElementById("ComponenteSA").height = 0;
			var nav_componentes    = document.getElementById("nav_componentes");
			nav_componentes.style.display = 'none';						
		}	
		if (prs_opcion == 'CO'){
			document.getElementById("ComponenteSA").src="SA-ComponentePlazas.cfm?RHEid="+document.form2.RHEid.value+"&RHSAid="+document.form2.RHSAid.value;
			document.getElementById("ComponenteSA").width = 950;
			document.getElementById("ComponenteSA").height = 300;
			document.getElementById("PlazaSA").width = 0;
			document.getElementById("PlazaSA").height = 0;
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
							<input type="hidden" name="RHSAid" value=""><!---- Detalle seleccionada de la lista ---->
							<input type="hidden" name="RHEid" value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">	<!---Llave del escenario de la lista--->
							<input type="hidden" name="RHEfdesde" value="<cfif isdefined("data") and len(trim(data.RHEfdesde))>#data.RHEfdesde#</cfif>"><!---- Fecha desde del escenario seleccionado---->
							<input type="hidden" name="RHEfhasta" value="<cfif isdefined("data") and len(trim(data.RHEfhasta))>#data.RHEfhasta#</cfif>"><!---- Fecha hasta del escenario seleccionado---->
							  <tr>
								<td width="1%">&nbsp;</td>
								<td width="12%" id="nav_plazas" nowrap><a href="javascript: funcNavega('PP');">Plazas Presupuestadas</a></td>
								<td width="70%" id="nav_componentes" nowrap style="display:none"><a href="javascript: funcNavega('CO');">> Componentes</a></td>
							  </tr>				  
						</table>		
					</td></tr>
				</table>							  		
			</td>
		</tr>
		<tr><td valign="top">
			<cfoutput>
				<iframe id="PlazaSA" frameborder="0" name="PlazaSA" width="950"  height="300" style="visibility:visible;border:none; vertical-align:top" src="MEPlazasPres.cfm?RHEid=#form.RHEid#"></iframe>
				<iframe id="ComponenteSA"  frameborder="0" name="ComponenteSA"  width="0" height="0" style="visibility:visible; border:none;"></iframe>
			</cfoutput>	
		</td></tr>	
	</table>
</form>	
</cfoutput>

