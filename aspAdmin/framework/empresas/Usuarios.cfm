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
		var top = (screen.height - 600) / 2;
		var left = (screen.width - 600) / 2;
		window.open('conlisUsuarios.cfm?&ecodigo2=<cfoutput>#form.ecodigo2#</cfoutput>', 'Usuarios','menu=no,scrollbars=yes,top='+top+',left='+left+',width=600,height=550');
	}
	
</script>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr class="itemtit"><td colspan="2"><font size="2"><b>Lista de Usuarios</b></font></td></tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>

	<tr>				
		<td valign="top">

			<cfset select = " case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
							((case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' '	else null end) +
							 (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end) +
							 (case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) as nombre,
							 u.Usucuenta, convert(varchar, ue.Usucodigo) as Usucodigo, ue.Ulocalizacion, #form.ecodigo2# as ecodigo2 " >					 
		
			<cfset from = " UsuarioEmpresarial ue, Usuario u, Empresa e, UsuarioEmpresa uemp " >
		
			<cfset where = " ue.Usucodigo = u.Usucodigo
						 and ue.Ulocalizacion = u.Ulocalizacion
						 and ue.cliente_empresarial = e.cliente_empresarial
						 and uemp.Ecodigo = e.Ecodigo
						 and uemp.cliente_empresarial = ue.cliente_empresarial
						 and uemp.Usucodigo = u.Usucodigo
						 and uemp.Ulocalizacion = u.Ulocalizacion
						 and e.Ecodigo = #form.ecodigo2#" >
		
			<cfset where = where & " order by  upper((case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null end) +
													 (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end) +
													 (case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) ">

			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="#from#"/>
				<cfinvokeargument name="columnas" value="#select#"/>
				<cfinvokeargument name="desplegar" value="nombre,Usulogin,Usucuenta"/>
				<cfinvokeargument name="etiquetas" value="Nombre,Login,Cuenta"/>
				<cfinvokeargument name="formatos" value="V,V,V"/>
				<cfinvokeargument name="filtro" value="#where#"/>
				<cfinvokeargument name="align" value="left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="SQLUsuarios.cfm"/>
				<cfinvokeargument name="Conexion" value="sdc"/>
				<cfinvokeargument name="MaxRows" value="30"/>
				<cfinvokeargument name="keys" value="Usucodigo,Ulocalizacion"/>
				<cfinvokeargument name="navegacion" value="botonSel=Buscar"/>
				<!---<cfinvokeargument name="Cortes" value="nombre"/>--->
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
			if ( confirm('Va a deshabilitar los usuarios para la empresa. Desde continuar?' ) ){
				document.lista.ECODIGO2.value = '<cfoutput>#form.ecodigo2#</cfoutput>';
				document.lista.action = 'SQLUsuarios.cfm';
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay usuarios seleccionados para el proceso.');
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