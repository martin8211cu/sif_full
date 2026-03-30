
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Debe_seleccionar_al_menos_a_un_candidato"
	Default="Debe seleccionar al menos a un candidato"	
	returnvariable="LB_Debe_seleccionar_al_menos_a_un_candidato"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_que_desea_aplicar_las_relaciones_de_aumento_seleccionadas"
	Default="¿Está seguro de que desea aplicar las relaciones de aumento seleccionadas?"	
	returnvariable="LB_AplicacionRelacionAumento"/>		

<script language="javascript" type="text/javascript">
	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	
	function funcCorreo() {
		<cfoutput>
		var aplica = false;
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				aplica = document.form1.chk.checked;
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			var PARAM  = "EnvioCorreo.cfm";
			open(PARAM,'Correo','left=400,top=450,scrollbars=yes,resizable=yes,width=400,height=150')
		} else {
			alert('#LB_Debe_seleccionar_al_menos_a_un_candidato#');
			return false;
		}
		</cfoutput>
	}
	
	function funcConcurso() {
		<cfoutput>
		var aplica = false;
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				aplica = document.form1.chk.checked;
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			var oferentes = "";
			var height = 400;
			if (document.form1.chk.value) {
				oferentes = document.form1.chk.value;
			}else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) { 
						oferentes = oferentes + document.form1.chk[i].value + ',';
						height = height + 10;
						
					}
				}
				oferentes = oferentes + '-1';
			}
			
			var PARAM  = "Concurso.cfm?oferentes="+oferentes;
			open(PARAM,'concurso','left=300,top=250,scrollbars=yes,resizable=yes,width=600,height='+height)
			
		} else {
			alert('#LB_Debe_seleccionar_al_menos_a_un_candidato#');
			return false;
		}
		</cfoutput>
	}	

	function funcDirecta() {
		<cfoutput>
		var aplica = false;
		var solouno = true;
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				aplica = document.form1.chk.checked;
				solouno = true;
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			var oferentes = "";
			var height = 500;
			if (document.form1.chk.value) {
				oferentes = document.form1.chk.value;
			}else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) { 
						oferentes = oferentes + document.form1.chk[i].value + ',';
						solouno = false;
						//height = height + 10;						
					}
				}
				//oferentes = oferentes + '-1';
			}			
			
		if (!solouno){
			oferentes = oferentes.substring(0,oferentes.length-1);
		}

			var PARAM  = "CDirecta.cfm?oferentes="+oferentes;
			open(PARAM,'concurso','left=250,top=100,scrollbars=yes,resizable=yes,width=800,height='+height)
			
		} else {
			alert('#LB_Debe_seleccionar_al_menos_a_un_candidato#');
			return false;
		}
		</cfoutput>
	}	
	
</script>
<table border="0" cellpadding="2" cellspacing="0" style="height: 24px;">
	<tr>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcCorreo();">
			<img src="/cfmx/rh/imagenes/E-Mail Link.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Enviar_por_Correo">Enviar por Correo</cf_translate></font>
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcConcurso();">
			<img src="/cfmx/rh/imagenes/usuario04_T.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_gregar_a_Concurso">Agregar a Concurso</cf_translate></font>
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcDirecta();">
			<img src="/cfmx/rh/imagenes/RepeatedRegion.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_Contratacion_Directa">Contrataci&oacute;n Directa</cf_translate></font>
		</td>
	</tr>
</table>
