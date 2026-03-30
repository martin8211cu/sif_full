
<script language="javascript" type="text/javascript">
	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	
	function funcBuscar(){
		document.form1.AccionAEjecutar.value="BUSCAR";
		document.form1.CorreoPAra.value="";
		document.form1.CorreoDe.value="";
		document.form1.submit();
	}
	
	function funcLimpiar(){
		<!--- document.form1.reset(); --->
		document.form1.AccionAEjecutar.value="LIMPIAR";
		document.form1.submit();

	}	
	
	function funcReporte(){
		alert("En Construcción");
	}
	
	function funcOcultar(){
		var tr = document.getElementById("TDAREABUSQUEDA");
		var trVER = document.getElementById("TDVER");
		var trNOVER = document.getElementById("TDNOVER");
		<!--- var img = document.getElementById("img_"); --->
		<!--- img.src = ((tr.style.display == "none") ? "/cfmx/rh/imagenes/abajo.gif" : "/cfmx/rh/imagenes/derecha.gif"); --->
		tr.style.display = ((tr.style.display == "none") ? "" : "none");
		trVER.style.display = ((trVER.style.display == "") ? "none" : "");
		trNOVER.style.display = ((trNOVER.style.display == "none") ? "" : "none");
	}

	
</script>
<table border="0" cellpadding="2" cellspacing="0" style="height: 24px;">
	<tr>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcBuscar();">
			<img src="/cfmx/rh/imagenes/find.small.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Buscar">Buscar</cf_translate></font>
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcLimpiar();">
			<img src="/cfmx/rh/imagenes/iedit.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_Limpiar">Limpiar</cf_translate></font>
		</td>
		<!--- 
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcReporte();">
			<img src="/cfmx/rh/imagenes/Hardware16x16.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_Reporte">Reporte</cf_translate></font>
		</td>	
		 --->
		<td>|</td>
		<td id="TDNOVER"  class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcOcultar();">
			<img src="/cfmx/rh/imagenes/refresh.png" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_OcultarAreaFiltros">Ocultar &aacute;rea de filtros</cf_translate></font>
		</td>	
		<td  style="display:none" id="TDVER" class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcOcultar();">
			<img src="/cfmx/rh/imagenes/refresh.png" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_verAreaFiltros">Ver  &aacute;rea de filtros</cf_translate></font>
		</td>			
	</tr>
</table>
