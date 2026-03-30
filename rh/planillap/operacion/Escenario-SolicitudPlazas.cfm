<script type="text/javascript" language="javascript1.2">
	function funcMuestraComponentes(prn_RHSAid){
		if (document.forms['form2'].nosubmit) {document.forms['form2'].nosubmit=false;return false;}		
		var nav_componentes    = document.getElementById("nav_componentes");
		nav_componentes.style.display = '';
		document.form2.RHSAid.value = prn_RHSAid;
		document.getElementById("PlazaSolic").width = 0;
		document.getElementById("PlazaSolic").height = 0;
		document.getElementById("Componente").width = 950;
		document.getElementById("Componente").height = 300;
		document.getElementById("Componente").src="SP-ComponentesPlazaSolic.cfm?RHEid="+document.form2.RHEid.value+"&RHSAid="+prn_RHSAid;
	}

	function funcRegresaPlazas(prn_RHEid){		
		var nav_componentes    = document.getElementById("nav_componentes");
		nav_componentes.style.display = 'none';
		document.form2.RHEid.value = prn_RHEid;
		document.getElementById("PlazaSolic").src="SP-PPresupuestarias.cfm?RHEid="+prn_RHEid;
		document.getElementById("PlazaSolic").width = 950;
		document.getElementById("PlazaSolic").height = 300;
		document.getElementById("Componente").width = 0;
		document.getElementById("Componente").height = 0;	
	}
	function funcNavega(prs_opcion){
		/*////////	Valores de prs_opcion: /////////////
				PP --> Plazas Presupuestarias
				CO --> Componentes
		*//////////////////////////////////////////////		
		if (prs_opcion == 'PP'){				
			//document.form2.Categoria.value = '';
			document.form2.RHSAid.value = '';
			document.getElementById("PlazaSolic").src="SP-PPresupuestarias.cfm?RHEid="+document.form2.RHEid.value;
			document.getElementById("PlazaSolic").width = 950;
			document.getElementById("PlazaSolic").height = 300;
			document.getElementById("Componente").width = 0;
			document.getElementById("Componente").height = 0;
			var nav_componentes    = document.getElementById("nav_componentes");
			nav_componentes.style.display = 'none';						
		}	
		if (prs_opcion == 'CO'){
			document.getElementById("Componente").src="SP-ComponentesPlazaSolic.cfm?RHEid="+document.form2.RHEid.value+"&RHSAid="+document.form2.RHSAid.value;
			document.getElementById("Componente").width = 950;
			document.getElementById("Componente").height = 300;
			document.getElementById("PlazaSolic").width = 0;
			document.getElementById("PlazaSolic").height = 0;
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
							<input type="hidden" name="RHSAid" value=""><!----  name="RHPEid" Detalle seleccionada de la lista ---->
							<input type="hidden" name="RHEid" value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">	<!---Llave del escenario de la lista--->
							<input type="hidden" name="RHEfdesde" value="<cfif isdefined("data") and len(trim(data.RHEfdesde))>#data.RHEfdesde#</cfif>"><!---- Fecha desde del escenario seleccionado---->
							<input type="hidden" name="RHEfhasta" value="<cfif isdefined("data") and len(trim(data.RHEfhasta))>#data.RHEfhasta#</cfif>"><!---- Fecha hasta del escenario seleccionado---->
							  <tr>
								<td width="1%">&nbsp;</td>
								<td width="12%" id="nav_plazas" nowrap><a href="javascript: funcNavega('PP');">Plazas Solicitadas</a></td>
								<td width="70%" id="nav_componentes" nowrap style="display:none"><a href="javascript: funcNavega('CO');">> Componentes</a></td>
							  </tr>				  
						</table>		
					</td></tr>
				</table>							  		
			</td>
		</tr>
		<tr><td valign="top">
			<cfoutput><iframe id="PlazaSolic" frameborder="0" name="PlazaSolic" width="950"  height="300" style="visibility:visible;border:none; vertical-align:top" src="SP-PPresupuestarias.cfm?RHEid=#form.RHEid#&RHEfdesde=#data.RHEfdesde#&RHEfhasta=#data.RHEfhasta#"></iframe></cfoutput>
			<iframe id="Componente"  frameborder="0" name="Componente"  width="0" height="0" style="visibility:visible; border:none;"></iframe>
		</td></tr>	
	</table>
</form>	
</cfoutput>



