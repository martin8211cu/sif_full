<script type="text/javascript" language="javascript1.2">
	function funcMuestraCategoria(prn_RHETEid){
		//EVITA EL ONSUBMIT SI SE ENCUENTRA ESTE ATRIBUTO PRENDIDO EN EL FORM
		if (document.forms['form2'].nosubmit) {document.forms['form2'].nosubmit=false;return false;}
		var nav_categorias    = document.getElementById("nav_categorias");
		nav_categorias.style.display = '';
		window.parent.document.form1.RHETEid.value = prn_RHETEid;
		document.form2.RHETEid.value = prn_RHETEid;
		document.getElementById("Tablas").width = 0;
		document.getElementById("Tablas").height = 0;
		document.getElementById("CategoriasPuesto").width = 950;
		document.getElementById("CategoriasPuesto").height = 300;
		//document.getElementById("CategoriasPuesto").src="TS-CategoriasPuesto.cfm?RHEid="+document.form2.RHEid.value+"&RHETEid="+prn_RHETEid;
		document.getElementById("CategoriasPuesto").src="TS-CategoriasPuesto.cfm?RHEid="+document.form2.RHEid.value+"&RHETEid="+document.form2.RHETEid.value;
	}
	function funcMuestraComponentes(prn_RHEid,prn_RHETEid,prn_RHCid,prn_RHMPPid){//Recibe: Escenario (RHEid), Tabla (RHETEid), Categoria/puesto (RHDTEid)
		var nav_componentes    = document.getElementById("nav_componentes");
		nav_componentes.style.display = '';		
		document.form2.RHCid.value = prn_RHCid;
		document.getElementById("CategoriasPuesto").width = 0;
		document.getElementById("CategoriasPuesto").height = 0;
		document.getElementById("Componentes").width = 950;
		document.getElementById("Componentes").height = 300;
		document.getElementById("Componentes").src="TS-Componentes.cfm?RHEid="+prn_RHEid+"&RHETEid="+prn_RHETEid+"&RHCid="+prn_RHCid+"&RHMPPid="+prn_RHMPPid;
		//document.getElementById("Componentes").src="TS-Componentes.cfm?RHEid="+document.form2.RHEid.value+"&RHETEid="+document.form2.RHETEid.value+"&RHCid="+document.form2.RHCid.value+"&RHMPPid="+document.form2.RHMPPid.value;
	}
	function funcRegresaTabla(prn_RHEid){//Debe recibir: Escenario?
		var nav_categorias     = document.getElementById("nav_categorias");
		var nav_componentes    = document.getElementById("nav_componentes");
		nav_categorias.style.display = 'none';
		nav_componentes.style.display = 'none';
		document.form2.RHCid.value = '';
		document.form2.RHETEid.value = '';
		document.getElementById("Tablas").src="TS-Tabla.cfm?RHEid="+document.form2.RHEid.value;
		//document.getElementById("Tablas").src="TS-Tabla.cfm?RHEid="+prn_RHEid;
		document.getElementById("Tablas").width = 950;
		document.getElementById("Tablas").height = 300;
		document.getElementById("CategoriasPuesto").width = 0;
		document.getElementById("CategoriasPuesto").height = 0;		
		document.getElementById("Componentes").width = 0;
		document.getElementById("Componentes").height = 0;
	}
	function funcRegresaCategoria(prn_RHEid,prn_RHETEid){
		var nav_componentes    = document.getElementById("nav_componentes");
		nav_componentes.style.display = 'none';
		document.form2.RHCid.value = '';
		document.getElementById("CategoriasPuesto").src="TS-CategoriasPuesto.cfm?RHEid="+prn_RHEid+"&RHETEid="+prn_RHETEid;
		document.getElementById("CategoriasPuesto").width = 950;
		document.getElementById("CategoriasPuesto").height = 300;
		document.getElementById("Componentes").width = 0;
		document.getElementById("Componentes").height = 0;
	}
	function funcNavega(prs_opcion){
		/*	Valores de prs_opcion:
				CA --> Categorias/Puesto
				TA --> Tablas
		*/		
		if (prs_opcion == 'CA'){				
			//document.form2.Categoria.value = '';
			document.getElementById("CategoriasPuesto").src="TS-CategoriasPuesto.cfm?RHEid="+document.form2.RHEid.value+"&RHETEid="+document.form2.RHETEid.value;
			document.getElementById("CategoriasPuesto").width = 950;
			document.getElementById("CategoriasPuesto").height = 300;
			document.getElementById("Componentes").width = 0;
			document.getElementById("Componentes").height = 0;
			var nav_componentes    = document.getElementById("nav_componentes");
			nav_componentes.style.display = 'none';						
		}	
		if (prs_opcion == 'TA'){
			document.form2.RHCid.value = '';
			document.form2.RHETEid.value = '';
			document.getElementById("Tablas").src="TS-Tabla.cfm?RHEid="+document.form1.RHEid.value;	
			document.getElementById("Tablas").width = 950;
			document.getElementById("Tablas").height = 300;
			document.getElementById("Componentes").width = 0;
			document.getElementById("Componentes").height = 0;
			document.getElementById("CategoriasPuesto").width = 0;
			document.getElementById("CategoriasPuesto").height = 0;
			var nav_categorias     = document.getElementById("nav_categorias");
			var nav_componentes    = document.getElementById("nav_componentes");
			nav_categorias.style.display = 'none';
			nav_componentes.style.display = 'none';
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
							<input type="hidden" name="RHETEid" value=""><!---- Tabla seleccionada de la lista ---->
							<input type="hidden" name="RHCid" value=""><!---- Categoria seleccionada de la lista ---->
							<input type="hidden" name="RHEid" value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">			<!---Llave del escenario de la lista--->
							<input type="hidden" name="RHMPPid" value="<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>#form.RHMPPid#</cfif>">	<!---Llave del escenario de la lista--->
							<input type="hidden" name="RHEfdesde" value="<cfif isdefined("data") and len(trim(data.RHEfdesde))>#data.RHEfdesde#</cfif>">	<!---- Fecha desde del escenario seleccionado---->
							<input type="hidden" name="RHEfhasta" value="<cfif isdefined("data") and len(trim(data.RHEfhasta))>#data.RHEfhasta#</cfif>">	<!---- Fecha hasta del escenario seleccionado---->
						  <tr>
							<td width="1%">&nbsp;</td>
							<td width="12%" id="nav_tablas" nowrap><a href="javascript: funcNavega('TA');">Tablas Salariales</a></td>
							<td width="15%" id="nav_categorias" nowrap style="display:none"><a href="javascript: funcNavega('CA');">> Categor&iacute;as/Puesto</a></td>
							<td width="70%" id="nav_componentes" nowrap style="display:none"><a href="javascript: funcNavega('CO');">> Componentes</a></td>
						  </tr>				  
			  			</table>		
					</td></tr>
				</table>							  		
			</td>
		</tr>
		<tr><td valign="top">
			<iframe id="Tablas" frameborder="0" name="Tablas" width="950"  height="300" style="visibility:visible;border:none; vertical-align:top" src="TS-Tabla.cfm?RHEid=<cfoutput>#form.RHEid#</cfoutput>"></iframe>
			<iframe id="CategoriasPuesto" frameborder="0" name="CategoriasPuesto" width="0" height="0" style="visibility:visible;border:none;"></iframe>
			<iframe id="Componentes"  frameborder="0" name="Componentes"  width="0" height="0" style="visibility:visible; border:none;"></iframe>
		</td></tr>	
	</table>
</form>	
</cfoutput>

