<cfparam name="url.form" 		default="form1" 					type="String">
<cfparam name="url.name" 		default="actividad" 				type="string">
<cfparam name="url.value" 		default="" 							type="string">
<cfparam name="url.etiqueta" 	default="Actividad Empresarial" 	type="string">
<cfparam name="url.Ecodigo" 	default="#session.Ecodigo#" 		type="numeric">
<cfparam name="url.MostrarTipo" default="" 							type="string">

<cfoutput>
<cf_templatecss>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<form name="Actividades" method="post">
		<input type="hidden" name="cantidad_#url.name#" id="cantidad_#url.name#" value="0"/>
		<tr>
			<td nowrap width="1%">&nbsp;</td>
			<td nowrap width="1%">#url.etiqueta#:&nbsp;</td>
			<td nowrap width="1%">
				<input type="text" name="#url.name#_Act" id="#url.name#_Act" value="#url.value#" size="15" maxlength="15" onchange="dibujarCampos(0); asignarActividad(0, this.value)"/>
				<input type="hidden" name="#url.name#_actId" id="#url.name#_actId" value="" />
			</td>
			<td><label id="lbl_#url.name#"></label></td>
			<td nowrap width="1%" align="right"><input type="submit" class="btnNormal" name="Iniciar" id="Iniciar" value="Iniciar"/></td>
		</tr>
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td width="5%">&nbsp;</td>
			<td colspan="3" width="100%">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr><td id="niveles_#url.name#" nowrap width="0%"></td></tr>
				</table>
			</td>
			<td width="5%">&nbsp;</td>
		</tr>
	</form>
	<tr><td colspan="5">&nbsp;</td></tr>
	<tr>
		<td colspan="5">
			<iframe id="ifrActividad" width="100%" height="300" src="ConlisActividades.cfm?MostrarTipo=<cfoutput>#url.MostrarTipo#</cfoutput>"></iframe>
		</td>
	</tr>
</table>

<script language="javascript1.2" type="text/javascript">
	
	var cant = document.getElementById('cantidad_#url.name#');
	var codRef = new Array();
	var arrayDesc = new Array();
	
	function sbResultadoConLisActividad(actId, codigo, descripcion, niveles){
		document.getElementById('#url.name#_Act').value = codigo;
		document.getElementById('#url.name#_actId').value = actId;
		document.getElementById('lbl_#url.name#').innerHTML = '&nbsp;'+descripcion;
		asignarDesc(1,descripcion);
		dibujarCampos(codigo, niveles);
	}
	
	function dibujarCampos(codigo,cantidad){
		if(cantidad < 0 )
			return;
		contenedor = document.getElementById('niveles_#url.name#');
		contenedor.innerHTML = "";
		var html = "";
		if(cantidad > 0 )
			html = "<label>Mascara:&nbsp;</label>";
		for(i=0; i < cantidad; i++){
			if(i != 0)
				html+='<input type="text" name="#url.name#'+(i+1)+'" id="#url.name#'+(i+1)+'" size="5" onclick="mostrarNivel('+i+',this)"  onchange="mostrarCatalogo('+i+',this)" value="" disabled="disabled"/>';
			else
				html+='<input type="text" name="#url.name#'+(i+1)+'" id="#url.name#'+(i+1)+'" size="5" onclick="asignarActividad(1,document.Actividades.#url.name#_Act.value)" onchange="mostrarCatalogo('+i+',this)"/>';
		}
		contenedor.innerHTML = html;
		cant.value = cantidad; 
	}	
	
	function asignarCatalogo(nivel, codCatalogo, descCatalogo, catalogoRef, habilitar){
		if(habilitar)
			inp = document.getElementById('#url.name#'+nivel);
		else{
			inp = document.getElementById('#url.name#'+(nivel+1));
			habilitar = false;
		}
		if(inp){
			inp.value = codCatalogo;
			arrayDesc[parseInt(nivel)]= descCatalogo;
			nivel = parseInt(nivel) + 1;
			codigo = document.getElementById('#url.name#_Act').value;
			if(nivel <= cant.value && habilitar){
				inpS = document.getElementById('#url.name#'+nivel);
				inpS.disabled="";
			}if(nivel <= cant.value)
				document.getElementById('ifrActividad').src="ConlisActividades.cfm?MostrarTipo=<cfoutput>#url.MostrarTipo#</cfoutput>&nivel="+nivel+"&codigo="+codigo+"&codCatalogo="+codCatalogo+"&catalogoRef="+catalogoRef+"&habilitar="+habilitar;
			if(nivel > cant.value )
				fnOK();
			}
		}
	
		function asignarActividad(nivel, codigo, descripcion){
			nivel = parseInt(nivel);
			arrayDesc[nivel]= descripcion;
			if(nivel == 0){
				nivel += 1;
				document.getElementById('ifrActividad').src="ConlisActividades.cfm?MostrarTipo=<cfoutput>#url.MostrarTipo#</cfoutput>&nivel="+nivel+"&codigo="+codigo;
			}else{
				document.getElementById('ifrActividad').src="ConlisActividades.cfm?MostrarTipo=<cfoutput>#url.MostrarTipo#</cfoutput>&nivel="+nivel+"&codigo="+codigo+"&click=true";
			}
		}

		function asignarCodRef(nivel, catalogoRef){
			codRef[(parseInt(nivel)-1)] = catalogoRef;
		}
		
		function asignarDesc(nivel, desc){
			arrayDesc[(parseInt(nivel)-1)] = desc;
		}
		
		function fnOK(){
			arrayValores = new Array(cant.value+1);
			arrayValores[0] = document.getElementById('#url.name#_Act').value;
			actId = document.getElementById('#url.name#_actId').value;
			
			for(i=0; i < cant.value ; i++)
				arrayValores[i+1] = document.getElementById('#url.name#'+(i+1)).value;	
			if (window.opener.asignarCodigos_#url.name#)
				window.opener.asignarCodigos_#url.name#(actId, arrayValores, arrayDesc);
			window.close();
		}
		
		function listo(nivel){
			if(nivel > cant.value )
				fnOK();
		}
		
		function mostrarNivel(nivel,inp){
			if(! codRef[nivel]){
				codRef[nivel] = '';
			}
			asignarCatalogo(nivel,inp.value,inp.value,codRef[nivel],false);
			this.focus();
		}
		
		function mostrarCatalogo(nivel,inp){
			nivel = parseInt(nivel);
			if(! codRef[nivel])
				codRef[nivel] = '';
			codigo = document.getElementById('#url.name#_Act').value;
			document.getElementById('ifrActividad').src="ConlisActividades.cfm?MostrarTipo=<cfoutput>#url.MostrarTipo#</cfoutput>&nivel="+(nivel + 2)+"&codigo="+codigo+"&codCatalogo="+inp.value+"&catalogoRef="+codRef[nivel]+"&tab=true";
		}
		
		function deshabilitar(nivel, incluir){
			inpS = null;
			nivel = parseInt(nivel);
			for(i = nivel ;  i <= cant.value; i++){
				inpS = document.getElementById('#url.name#'+i);
				inpS.value="";
				if(incluir)
					inpS.disabled="disabled";
				else{
					if( i != nivel )
						inpS.disabled="disabled";
					else{
						inpS.disabled="";
						inpS.focus();
					}
				}	
			}	
		}
		
</script>
</cfoutput>