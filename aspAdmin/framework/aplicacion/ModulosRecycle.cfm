<html>
<head>
<title>Reciclar Modulos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<!---<body onUnload="javascript:window.opener.document.location.reload();">--->
<body onUnload="javascript:cerrar();" >

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fmodulo.value = "";
		document.filtro.fnombre.value  = "";
	}
</script>

<cfif isdefined("url.sistema") and not isdefined("form.sistema")>
	<cfset form.sistema = url.sistema >
</cfif>

<cfset navegacion = "&sistema=" & #form.sistema#>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr class="itemtit"><td colspan="2"><font size="2"><b>Lista de M&oacute;dulos Inactivos</b></font></td></tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>

	<tr>				
		<td valign="top">
			<cfoutput>
			<form name="filtro" style="margin:0;" action="ModulosRecycle.cfm" method="post">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr>
						<td align="right"><b>Modulo:&nbsp;</b></td>
						<td><input name="fmodulo" type="text" size="12" maxlength="12" value="<cfif isdefined("form.fmodulo") and len(trim(form.fmodulo)) gt 0>#form.fmodulo#</cfif>" ></td>
						<td align="right"><b>Nombre:&nbsp;</b></td>
						<td><input name="fnombre" type="text" size="40" maxlength="40" value="<cfif isdefined("form.fnombre") and len(trim(form.fnombre)) gt 0>#form.fnombre#</cfif>" ></td>
						<td><input type="submit" name="Filtrar" value="Filtrar"></td>
						<td>
							<input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
							<input name="sistema" type="hidden" value="<cfif isdefined("form.sistema")>#form.sistema#</cfif>" >
						</td>
					</tr>
				</table>
			</form>
			</cfoutput>

			<table width="100%">
				<tr>
					<td width="1%"><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
				 	<td valign="middle"><b>Seleccionar Todo</b></td>
				</tr>	
			</table>

			<cfset where = "activo = 0 and sistema = '#form.sistema#' ">

			<cfif isdefined("form.Filtrar") and isdefined("form.fmodulo") and len(trim(form.fmodulo)) gt 0>
				<cfset where = where & " and upper(modulo) like upper('%#form.fmodulo#%')" >
			</cfif> 

			<cfif isdefined("form.Filtrar") and isdefined("form.fnombre") and len(trim(form.fnombre)) gt 0>
				<cfset where = where & " and upper(nombre) like upper('%#form.fnombre#%')" >
			</cfif> 

			<cfset where = where & " order by upper(modulo) " >

			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Modulo"/>
				<cfinvokeargument name="columnas" value="rtrim(sistema) as sistema, rtrim(modulo) as modulo, nombre"/>
				<cfinvokeargument name="desplegar" value="modulo,nombre"/>
				<cfinvokeargument name="etiquetas" value="Módulo,Nombre"/>
				<cfinvokeargument name="formatos" value="V,V"/>
				<cfinvokeargument name="filtro" value="#where#"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="SistemasPrincipal.cfm"/>
				<cfinvokeargument name="Conexion" value="sdc"/>
				<cfinvokeargument name="MaxRows" value="25"/>
				<cfinvokeargument name="navegacion" value="botonSel=Buscar"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="botones" value="Activar,Eliminar"/>
				<cfinvokeargument name="keys" value="modulo"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">

	function funcActivar(){
		if ( checkeados() ){
			if ( confirm('Va a activar los Módulos seleccionados. Desde continuar?' ) ){
				document.lista.SISTEMA.value = '<cfoutput>#form.sistema#</cfoutput>';
				document.lista.action = 'SQLModulos.cfm';
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay Módulos seleccionados para el proceso.');
		}	

		return false;	
	}

	function funcEliminar(){
		if ( checkeados() ){
			if ( confirm('Va a eliminar permanentemente los Módulos seleccionados. Desde continuar?' ) ){
				document.lista.SISTEMA.value = '<cfoutput>#form.sistema#</cfoutput>';
				document.lista.action = 'SQLModulos.cfm';
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay Módulos seleccionados para el proceso.');
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

	function cerrar(){
		<cfif isdefined("form.update")>
			if ( (window.event.clientY < 0 ) || ( window.event.clientX < 0 ) ){
				if ( !window.opener.closed ){
					window.opener.document.form3.submit();
					return;
				}
			}
		</cfif>
	}

</script>
</body>
</html>