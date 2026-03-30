<cfif isdefined("url.ecodigo2") and not isdefined("form.ecodigo2")>
	<cfset form.ecodigo2 = url.ecodigo2 >
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fNombre.value  = "";
		document.filtro.fNombreC.value = "";
		document.filtro.fCuenta.value  = "";
	}
	
	function doConlis() {
		var top = (screen.height - 500) / 2;
		var left = (screen.width - 450) / 2;
		window.open('conlisModulos.cfm?ecodigo2=<cfoutput>#form.ecodigo2#</cfoutput>', 'Modulos','menu=no,scrollbars=yes,top='+top+',left='+left+',width=450,height=500');
	}
	
</script>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr class="itemtit"><td colspan="2"><font size="2"><b>Lista de M&oacute;dulos</b></font></td></tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>

	<tr>				
		<td valign="top">

			<cfset select = "rtrim(m.modulo) as modulo, m.nombre as nom_modulo, rtrim(s.sistema) as sistema, s.nombre as nom_sistema, #form.ecodigo2# as ecodigo2" >
			<cfset from   = "Sistema s, Modulo m, EmpresaModulo em" >
			<cfset where = " m.sistema = s.sistema
			  			 and em.modulo = m.modulo
			  		     and em.Ecodigo = #form.ecodigo2#
			  			 and em.activo = 1" >
			<cfset where =	where & " order by upper(m.modulo) " >
			
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="#from#"/>
				<cfinvokeargument name="columnas" value="#select#"/>
				<cfinvokeargument name="desplegar" value="modulo,nom_modulo"/>
				<cfinvokeargument name="etiquetas" value="Nombre,Módulo"/>
				<cfinvokeargument name="formatos" value="V,V"/>
				<cfinvokeargument name="filtro" value="#where#"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="SQLModulos.cfm"/>
				<cfinvokeargument name="Conexion" value="sdc"/>
				<cfinvokeargument name="MaxRows" value="30"/>
				<cfinvokeargument name="keys" value="modulo"/>
				<cfinvokeargument name="navegacion" value="botonSel=Buscar"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/> 
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="botones" value="Agregar,Eliminar"/>
				<cfinvokeargument name="checkboxes" value="S"/>
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">

	function funcAgregar(){
		doConlis();
		return false;
	}

	function funcEliminar(){
		if ( checkeados() ){
			if ( confirm('Va a deshabilitar los módulos para la empresa. Desde continuar?' ) ){
				document.lista.ECODIGO2.value = '<cfoutput>#form.ecodigo2#</cfoutput>';
				document.lista.action = 'SQLModulos.cfm';
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay empresas seleccionados para el proceso.');
		}	

		return false;
	}

	function existe(form, name){
	// RESULTADO
	// Valida la existencia de un objecto en el form
	
		if (form[name] != undefined) {
			return true
		}
		else{
			return false
		}
	}

	function check_all(obj){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (obj.checked){
				if (form.chk.length){
					for (var i=0; i<form.chk.length; i++){
						form.chk[i].checked = "checked";
					}
				}
				else{
					form.chk.checked = "checked";
				}
			}	
		}
	}

	function checkeados(){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked){
						return true;
					}
				}
				return false;
			}
			else{
				if (form.chk.checked){
					return true;
				}
				else{	
					return false;
				}	
			}
		}
	}

</script>