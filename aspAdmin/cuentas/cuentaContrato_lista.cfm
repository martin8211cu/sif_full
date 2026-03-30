<cfif isdefined("url.cliente_empresarial") and not isdefined("form.cliente_empresarial") >
	<cfset form.cliente_empresarial = url.cliente_empresarial >
</cfif>

<cfparam name="form.Usucodigo" default="">
<cfif isdefined('form.cliente_empresarial') and form.cliente_empresarial NEQ "" and (isdefined('form.COcodigo') and form.COcodigo NEQ '' OR isdefined("form.modo") AND form.modo EQ "ALTA")>
	<cfif not isdefined("form.modo")>
		<cfset form.modo = "CAMBIO">
	</cfif>
	<cfinclude template="CuentaContrato.cfm">
	<cfexit> 
</cfif>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<script src="/cfmx/aspAdmin/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript" src="../js/utilesAspAdmin.js">//</script>

<cfparam name="url.ppCliente_empresarial" default="0">
<cfparam name="form.cliente_empresarial" default="#url.ppCliente_empresarial#">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>				
		<td valign="top">
			<cfoutput>
				<form name="formFiltroContratos" style="margin:0;" action="CuentaPrincipal_tabs.cfm" method="post">
					  <input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#" >
					
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
					  <tr>
						<td width="42%"><b>Nombre</b></td>
						<td width="21%"><strong>Fecha Inicio</strong></td>
						<td width="15%"><strong>Fecha Final</strong></td>
						<td width="22%" rowspan="3" align="center" valign="middle">
							<input type="submit" name="Filtrar" value="Filtrar">
					    	<input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
					  </tr>
					  <tr>
						<td><input name="nombre_filtro" type="text" size="40" maxlength="30" value="<cfif isdefined("form.nombre_filtro") and len(trim(form.nombre_filtro)) gt 0>#form.nombre_filtro#</cfif>" ></td>
						<td>
							<cfif isdefined('form.COinicio_filtro') and form.COinicio_filtro NEQ ''>
								<cfset value = form.COinicio_filtro>
							<cfelse>
								<cfset value = "">
							</cfif>
							<cf_sifcalendario form="formFiltroContratos" name="COinicio_filtro" value="#value#">
						</td>
						<td>
							<cfif isdefined('form.COfinal_filtro') and form.COfinal_filtro NEQ ''>
								<cfset value = form.COfinal_filtro>
							<cfelse>
								<cfset value = "">
							</cfif>
							<cf_sifcalendario form="formFiltroContratos" name="COfinal_filtro" value="#value#">						
						</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
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


			<cfset select = "convert(varchar,cc.cliente_empresarial) as cliente_empresarial
							, convert(varchar,COcodigo) as COcodigo
							, COnombre
							, convert(varchar,COinicio,103) as COinicio
							, convert(varchar,COfinal,103) as COfinal">

			<cfset from   = "ClienteContrato cc, CuentaClienteEmpresarial cce" >
			
			<cfset where  = " cc.cliente_empresarial=#form.cliente_empresarial#
							and cc.cliente_empresarial=cce.cliente_empresarial">
			<cfset navegacion = "" >
			<cfif isdefined("form.Filtrar") and isdefined("form.nombre_filtro") and len(trim(form.nombre_filtro)) gt 0>
				<cfset where = where & " and upper(COnombre) like upper('%#form.nombre_filtro#%')" >
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombre_filtro=" & Form.nombre_filtro>
			</cfif> 
			<cfif isdefined("form.Filtrar") and isdefined("form.COinicio_filtro") and len(trim(form.COinicio_filtro)) gt 0>
				<cfset where = where & " and COinicio >= convert(datetime,'#form.COinicio_filtro#',103)" >
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "COinicio_filtro=" & Form.COinicio_filtro>				
			</cfif> 
			<cfif isdefined("form.Filtrar") and isdefined("form.COfinal_filtro") and len(trim(form.COfinal_filtro)) gt 0>
				<cfset where = where & " and COfinal <= convert(datetime,'#form.COfinal_filtro#',103)" >
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "COfinal_filtro=" & Form.COfinal_filtro>								
			</cfif> 
			<cfset where = where & " order by COnombre" >
			
 			<cfinvoke 
			 component="aspAdmin.Componentes.pListasASP"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="#from#"/>
				<cfinvokeargument name="columnas" value="#select#"/>

				<cfinvokeargument name="desplegar" value="COnombre,COinicio,COfinal"/>
				<cfinvokeargument name="etiquetas" value="Contrato,Inicio,Final"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="align" value="left,center,center"/>
				<cfinvokeargument name="filtro" value="#where#"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="Conexion" value="#session.DSN#"/>
				<cfinvokeargument name="MaxRows" value="10"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="COcodigo,cliente_empresarial"/>
				<cfinvokeargument name="irA" value="CuentaPrincipal_tabs.cfm"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="botones" value="Agregar,Eliminar"/> 
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/aspAdmin/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	
	
//---------------------------------------------------------------------------------------	
	// Se aplica la descripcion de la materia 
	function __isValidaFechas() {
		if((this.value != '')&&(this.obj.form.COfinal_filtro.value != '')){
			if(comparaFechas(this.value,this.obj.form.COfinal_filtro.value,2)){
				this.error = "La fecha de inicio no puede ser mayor que la fecha final";
				this.obj.focus();								
			}
		}
	}	
//--------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isValidaFechas", __isValidaFechas);
	objForm = new qForm("formFiltroContratos");
//--------------------------------------------------------------------------------------
	objForm.COinicio_filtro.validateValidaFechas();
//--------------------------------------------------------------------------------------		
	function limpiar(){
		document.formFiltroContratos.nombre_filtro.value = "";
		document.formFiltroContratos.COinicio_filtro.value = "";
		document.formFiltroContratos.COfinal_filtro.value = "";
	}
//--------------------------------------------------------------------------------------		
	function funcAgregar(){
		document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
		document.lista.action = 'CuentaPrincipal_tabs.cfm';
		//document.lista.submit();
	}
//--------------------------------------------------------------------------------------		
	function funcEliminar(){
		if ( checkeados("V") ){
			if ( confirm('Va eliminar los contratos seleccionados. Desde continuar?' ) ){
				document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
				document.lista.action = 'cuentaContrato_SQL.cfm';				
				return true;
			}
		}else{
			alert('No hay contratos seleccionados para el proceso.');
		}
		return false;
	}
//--------------------------------------------------------------------------------------		
	function existe(form, name){
	// RESULTADO
	// Valida la existencia de un objecto en el form
		if (form[name] != undefined) 
			return true
		else
			return false
	}
//--------------------------------------------------------------------------------------		
	function check_all(obj){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (obj.checked){
				if (form.chk.length){
					for (var i=0; i<form.chk.length; i++){
						form.chk[i].checked = "checked";
					}
				}else{
					form.chk.checked = "checked";
				}
			}	
		}
	}
//--------------------------------------------------------------------------------------		
	function checkeados(pTipo){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked){
						return true;
					}
				}
				return false;
			}else{
				if (form.chk.checked){
					return true;
				}else{	
					return false;
				}	
			}
		}
	}
</script>