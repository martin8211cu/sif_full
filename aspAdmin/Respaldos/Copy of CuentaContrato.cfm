<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select convert(varchar,cc.cliente_empresarial) as cliente_empresarial
			, convert(varchar,COcodigo) as COcodigo
			, COnombre
			, convert(varchar,COinicio,103) as COinicio
			, convert(varchar,COfinal,103) as COfinal
			, COtexto
			, timestamp
		from ClienteContrato cc
			, CuentaClienteEmpresarial cce
		where cc.cliente_empresarial=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
			and cc.cliente_empresarial=cce.cliente_empresarial
			and COcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COcodigo#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function frame(){
		// limpia el frame de administradores
		open('about:blank', 'modulo');
		open('about:blank', 'usuario');
	}	
</script>

<!--- 	<style  type="text/css" >
	iframe.marco {
		width: 100%;
		border: 1px;
		margin: 0px 0px 0px 0px;
		padding: 0px 0px 0px 0px;
	}
	</style>
	 --->
<script src="/cfmx/aspAdmin/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript" src="../js/utilesAspAdmin.js">//</script>
<form name="form1" action="cuentaContrato_SQL.cfm" method="post">
<cfoutput>
	<input type="hidden" name="modo" value="#modo#">
	<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#">
	<cfif modo NEQ 'ALTA'>
		<input type="hidden" name="COcodigo" value="#rsForm.COcodigo#">
	</cfif>
	
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="83%"><strong>Nombre del Contrato</strong></td>
        <td width="3%">&nbsp;</td>
        <td width="14%"><strong>Contrato</strong></td>
      </tr>
      <tr>
        <td><input name="COnombre" type="text" id="COnombre" onFocus="this.select();" value="<cfif modo neq 'ALTA' >#trim(rsForm.COnombre)#</cfif>" size="60" maxlength="255" ></td>
        <td>&nbsp;</td>
        <td rowspan="4"><textarea name="COtexto" cols="50" rows="10"><cfif modo neq 'ALTA' >#trim(rsForm.COtexto)#</cfif></textarea></td>
      </tr>
      <tr>
        <td valign="top">
			<fieldset><legend><strong>Vigencia</strong></legend>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td width="1%">&nbsp;</td>
					<td width="48%"><strong>Desde</strong></td>
					<td width="4%">&nbsp;</td>
					<td width="42%"><strong>Hasta</strong></td>
					<td width="5%">&nbsp;</td>
				  </tr>
				  <tr>
				    <td>&nbsp;</td>
					<td>
						<cfif modo NEQ 'ALTA' and rsForm.COinicio NEQ ''>
							<cfset valueInicio = rsForm.COinicio>
						<cfelse>
							<cfset valueInicio = "">
						</cfif>
						<cf_sifcalendario name="COinicio" value="#valueInicio#">										
					</td>
					<td>&nbsp;</td>
					<td>
						<cfif modo NEQ 'ALTA' and rsForm.COfinal NEQ ''>
							<cfset valueFinal = rsForm.COfinal>
						<cfelse>
							<cfset valueFinal = "">
						</cfif>
						<cf_sifcalendario name="COfinal" value="#valueFinal#">										
					</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
				    <td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				</table>
			</fieldset>
		</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>	  
      <tr>
        <td align="center">
		<cfset mensajeDelete = "¿Desea Eliminar este contrato?">
		<cfinclude template="../portlets/pBotones.cfm">		
        <input type="button" name="Buscar" value="Ir a lista" onClick="javascript: this.form.botonSel.value = this.name; buscar();">		
		</td>
		<td>&nbsp;</td>
      </tr>
    </table>

<!---       <cfif modo neq 'ALTA' and len(rsForm.logo) gt 0 >
        <td colspan="5" align="center" valign="top"> 
          <cf_sifleerimagen autosize="true" border="false" tabla="Empresa" campo="logo" condicion="Ecodigo = #form.Ecodigo2# " conexion="#session.DSN#" imgname="img" width="130" height="80" ruta="/cfmx/aspAdmin/Utiles/sifleerimagencont.cfm"> 
        </td>
        <cfelse>
        <td align="center" valign="top">&nbsp;</td>
      </cfif> --->
</cfoutput>
</form>

<cfif modo NEQ "ALTA">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr valign="top">
			<td width="35%" valign="top">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" >
					<tr>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr class="<cfoutput>#session.preferences.skin#_thcenter</cfoutput>" >
									<td>Trabajar con Paquetes del Contrato</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr id="trmodulo">
						<td class="boxbody">
							<iframe id="modulo" name="modulo" class="marco" src="about:blank" 
								frameborder="0" style="height: 250px">
							Cargando...
							</iframe> 
						</td>
					</tr>
				</table>
			</td>
			<td width="1%">&nbsp;</td>
			<td width="65%" valign="top">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr class="<cfoutput>#session.preferences.skin#_thcenter</cfoutput>" >
									<td>Trabajar con Módulos y Tarifas del Contrato</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr id="trusuario">
						<td class="boxbody">
							<iframe id="usuario" name="usuario" class="marco" src="about:blank" 
								frameborder="0" style="height: 250px">
							Cargando...
							</iframe> 
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<script language="JavaScript1.2" type="text/javascript">
		<cfif modo eq 'ALTA'>
			open("about:blank", "modulo");
			open("about:blank", "usuario");
		<cfelse>
			open("CuentaContratoPaquete.cfm", "modulo");
			open("CuentaContratoTarifa.cfm", "usuario");
		</cfif>
	</script>	
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/aspAdmin/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	function buscar(){
		document.form1.action = 'CuentaPrincipal_tabs.cfm';
		document.form1.modo.value = "";		
		document.form1.submit();
	}
	function deshabilitarValidacion(){
		objForm.COnombre.required  = false;
	}
	function habilitarValidacion(){
		objForm.COnombre.required  = true;
	}	
//---------------------------------------------------------------------------------------	
	// Se aplica la descripcion de la materia 
	function __isValidaFechas() {
		if((btnSelected("Alta", this.obj.form)||(btnSelected("Cambio", this.obj.form)))) {
			if((this.value != '')&&(this.obj.form.COfinal.value != '')){
				if(comparaFechas(this.value,this.obj.form.COfinal.value,2)){
					this.error = "La fecha de inicio no puede ser mayor que la fecha final";
					this.obj.focus();								
				}
			}
		}
	}	
//--------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isValidaFechas", __isValidaFechas);
	objForm = new qForm("form1");
//--------------------------------------------------------------------------------------
	objForm.COnombre.required    = true;
	objForm.COnombre.description = "Nombre";
	objForm.COinicio.validateValidaFechas();
</script>
