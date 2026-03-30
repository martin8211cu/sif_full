<script type="text/javascript" language="javascript1.2">
	function funcMuestraComponentes(prn_RHPEid, DEid){
		var nav_componentes    = document.getElementById("nav_componentes");
		nav_componentes.style.display = '';
		document.form2.RHPEid.value = prn_RHPEid;
		document.getElementById("Plaza").width = 0;
		document.getElementById("Plaza").height = 0;
		document.getElementById("ComponenteST").width = 950;
		document.getElementById("ComponenteST").height = 300;
		document.getElementById("ComponenteST").src="ST-ComponentePlazas.cfm?RHEid="+document.form2.RHEid.value+"&RHPEid="+prn_RHPEid + '&DEid=' + DEid;
		return false;
	}

	function funcRegresaPlazas(prn_RHEid){		
		var nav_componentes    = document.getElementById("nav_componentes");
		nav_componentes.style.display = 'none';
		document.form2.RHEid.value = prn_RHEid;
		document.getElementById("Plaza").src="ST-PPresupuestarias.cfm?RHEid="+prn_RHEid;
		document.getElementById("Plaza").width = 950;
		document.getElementById("Plaza").height = 300;
		document.getElementById("ComponenteST").width = 0;
		document.getElementById("ComponenteST").height = 0;	
	}
	function funcNavega(prs_opcion){
		/*////////	Valores de prs_opcion: /////////////
				PP --> Plazas Presupuestarias
				CO --> Componentes
		*//////////////////////////////////////////////		
		if (prs_opcion == 'PP'){				
			//document.form2.Categoria.value = '';
			document.form2.RHPEid.value = '';
			document.getElementById("Plaza").src="ST-PPresupuestarias.cfm?RHEid="+document.form2.RHEid.value;
			document.getElementById("Plaza").width = 950;
			document.getElementById("Plaza").height = 300;
			document.getElementById("ComponenteST").width = 0;
			document.getElementById("ComponenteST").height = 0;
			var nav_componentes    = document.getElementById("nav_componentes");
			nav_componentes.style.display = 'none';						
		}	
		if (prs_opcion == 'CO'){
			document.getElementById("ComponenteST").src="ST-ComponentePlazas.cfm?RHEid="+document.form2.RHEid.value+"&RHPEid="+document.form2.RHPEid.value;
			document.getElementById("ComponenteST").width = 950;
			document.getElementById("ComponenteST").height = 300;
			document.getElementById("Plaza").width = 0;
			document.getElementById("Plaza").height = 0;
			/*var nav_componentes    = document.getElementById("nav_componentes");
			nav_componentes.style.display = 'none';*/
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
							<input type="hidden" name="RHPEid" value=""><!---- Detalle seleccionada de la lista ---->
							<input type="hidden" name="RHEid" value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">	<!---Llave del escenario de la lista--->
							<input type="hidden" name="RHEfdesde" value="<cfif isdefined("data") and len(trim(data.RHEfdesde))>#data.RHEfdesde#</cfif>"><!---- Fecha desde del escenario seleccionado---->
							<input type="hidden" name="RHEfhasta" value="<cfif isdefined("data") and len(trim(data.RHEfhasta))>#data.RHEfhasta#</cfif>"><!---- Fecha hasta del escenario seleccionado---->
							  <tr>
								<td width="1%">&nbsp;</td>
								<td width="12%" id="nav_plazas" nowrap><a href="javascript: funcNavega('PP');">Plazas Presupuestarias</a></td>
								<!----<td width="15%" id="nav_categorias" nowrap style="display:none"><a href="javascript: funcNavega('CA');">> Categor&iacute;as/Puesto</a></td>----->
								<td width="70%" id="nav_componentes" nowrap style="display:none"><a href="javascript: funcNavega('CO');">> Componentes</a></td>
							  </tr>				  
						</table>		
					</td></tr>
				</table>							  		
			</td>
		</tr>
		<tr><td valign="top">
			<cfoutput>
				<iframe id="Plaza" frameborder="0" name="Oficina" width="950"  height="300" style="visibility:visible;border:none; vertical-align:top" 
				src="ST-PPresupuestarias.cfm?RHEid=#form.RHEid#&RHEfdesde=#data.RHEfdesde#&RHEfhasta=#data.RHEfhasta#<cfif isdefined("url.RHSAid") and len(trim(url.RHSAid))>&RHSAid=#url.RHSAid#</cfif>">
				</iframe>
			</cfoutput>
			<iframe id="ComponenteST"  frameborder="0" name="ComponenteST"  width="0" height="0" style="visibility:visible; border:none;"></iframe>
		</td></tr>	
	</table>
</form>	
</cfoutput>

