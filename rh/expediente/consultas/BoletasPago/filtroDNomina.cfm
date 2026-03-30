<!--- NTIdescripcion, HDRIdentificacion, DRNnombre, Apellidos, DRNtipopago, HDRNperiodo, DRNliquido --->
<cfset _CurrentPage=GetFileFromPath(GetTemplatePath())>
<!--- Pasa los valores del Url al Form --->
<cfif isDefined("Url._NTIcodigo") and not isDefined("Form._NTIcodigo")>
	<cfset Form._NTIcodigo = Url._NTIcodigo>
</cfif>
<cfif isDefined("Url._HDRIdentificacion") and not isDefined("Form._HDRIdentificacion")>
	<cfset Form._HDRIdentificacion = Url._HDRIdentificacion>
</cfif>
<cfif isDefined("Url._CBcc") and not isDefined("Form._CBcc")>
	<cfset Form._CBcc = Url._CBcc>
</cfif>
<cfif isDefined("Url._Nombre") and not isDefined("Form._Nombre")>
	<cfset Form._Nombre = Url._Nombre>
</cfif>
<cfif isDefined("Url._HDRNperiodo") and not isDefined("Form._HDRNperiodo")>
	<cfset Form._HDRNperiodo = Url._HDRNperiodo>
</cfif>
<!--- Prepara el Filtro --->
<cfif isdefined("Form._NTIcodigo") and Trim(Form._NTIcodigo) NEQ '-A'>
	<cfset filtro = filtro & " and a.NTIcodigo = '" & Trim(Form._NTIcodigo) & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "_NTIcodigo=" & Form._NTIcodigo>
</cfif>
<cfif isdefined("Form._HDRIdentificacion") and Len(Trim(Form._HDRIdentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.HDRIdentificacion) like '%" & #UCase(Form._HDRIdentificacion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "_HDRIdentificacion=" & Form._HDRIdentificacion>
</cfif>
<cfif isdefined("Form._CBcc") and Len(Trim(Form._CBcc)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.CBcc) like '%" & #UCase(Form._CBcc)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "_CBcc=" & Form._CBcc>
</cfif>
<cfif isdefined("Form._Nombre") and Len(Trim(Form._Nombre)) NEQ 0>
	<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(a.HDRNapellido1 , ' ' )}, a.HDRNapellido2 )}, ' ' )}, a.HDRNnombre )} ) like '%" & #UCase(Form._Nombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "_Nombre=" & Form._Nombre>
</cfif>

<cfif isdefined("Form._HDRNperiodo") and Len(Trim(Form._HDRNperiodo)) NEQ 0>
	<cfset filtro = filtro & " and a.HDRNperiodo >= "& LSParseDateTime(Form._HDRNperiodo)>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "_HDRNperiodo=" & Form._HDRNperiodo>
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="translate" key="CMB_Todos" Default="Todos"
	returnVariable="CMB_Todos"/>
	
<cfquery name="_rsNTipoIdentificacion" datasource="#Session.DSN#">
	select NTIcodigo, NTIdescripcion
	from NTipoIdentificacion
	union 
	select '-A', '#CMB_Todos#' from dual
</cfquery>
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<form style="margin:0;" action="<cfoutput>#_CurrentPage#</cfoutput>" method="post" name="_form">
  <cfif isDefined("Form._HDRNestado")>
	<input type="hidden" name="_HDRNestado" value="<cfoutput>#Form._HDRNestado#</cfoutput>">
  </cfif>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="areafiltro" align="center">
    <tr align="left" valign="bottom"> 
      <td nowrap class = "filelabel"><cf_translate  key="LB_TipoIdentificacion">Tipo Identificaci&oacute;n</cf_translate></td>
      <td nowrap class = "filelabel"><cf_translate  key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
      <td nowrap class = "filelabel"><cf_translate  key="LB_CuentaCliente">Cuenta Cliente</cf_translate></td>
	  <td nowrap class = "filelabel"><cf_translate  key="LB_Nombre">Nombre</cf_translate></td>
	  <td nowrap class = "filelabel"><cf_translate  key="LB_Periodo">Periodo</cf_translate></td>
	  <td nowrap class = "filelabel"></td>
  </tr>
    <tr align="left" valign="bottom"> 
      <td nowrap>
        <select name="_NTIcodigo" tabindex="1">
			<cfoutput query="_rsNTipoIdentificacion">
				<cfif isDefined("Form._NTIcodigo") and Form._NTIcodigo eq NTIcodigo>
					<option value="#NTIcodigo#" selected>#NTIdescripcion#</option>
				<cfelse>
					<option value="#NTIcodigo#">#NTIdescripcion#</option>
				</cfif>
			</cfoutput>
		</select></td>
      <td nowrap>
        <input name="_HDRIdentificacion" type="text" size="15" maxlength="25" value="<cfif isDefined("Form._HDRIdentificacion")><cfoutput>#Form._HDRIdentificacion#</cfoutput></cfif>" tabindex="2"></td>
      <td nowrap>
        <input name="_CBcc" type="text"  size="25" maxlength="25" value="<cfif isDefined("Form._CBcc")><cfoutput>#Form._CBcc#</cfoutput></cfif>" tabindex="3"></td>
      <td nowrap>
        <input name="_Nombre" type="text"  size="40" maxlength="90" value="<cfif isDefined("Form._Nombre")><cfoutput>#Form._Nombre#</cfoutput></cfif>" tabindex="4"></td>
      <td nowrap>
        <cfif isDefined("Form._HDRNperiodo")><cfoutput><cf_sifcalendario name="_HDRNperiodo" form="_form" value="#Form._HDRNperiodo#" tabindex="5"></cfoutput><cfelse><cf_sifcalendario name="_HDRNperiodo" form="_form" tabindex="5"></cfif></td>
	  <td nowrap>
        <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Filtrar"
		Default="Filtrar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Filtrar"/>
		
		<input name="_Filtrar" type="submit" value="<cfoutput>#BTN_Filtrar#</cfoutput>" tabindex="6"><input type="hidden" name="ERNid" value="<cfoutput>#Form.ERNid#</cfoutput>"></td>
  </tr>
</table>
</form>
<script language="JavaScript" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("_form");
	//Funciones adicionales de validación
	function _Field_isFecha(){
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampo"
	Default="El campo"
	returnvariable="MSG_ElCampo"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeContenerUnaFechaValida"
	Default="debe contener una fecha válida."
	returnvariable="MSG_DebeContenerUnaFechaValida"/>
		
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Periodo"
	Default="Periodo"
	returnvariable="MSG_Periodo"/>		
		
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "<cfoutput>#MSG_ElCampo#</cfoutput> " + this.description + " <cfoutput>#MSG_DebeContenerUnaFechaValida#</cfoutput>";
	}
	_addValidator("isFecha", _Field_isFecha);	
	//Validaciones del Encabezado
	objForm._HDRNperiodo.description = "<cfoutput>#MSG_Periodo#</cfoutput>";
	objForm._HDRNperiodo.validateFecha();
	objForm._HDRNperiodo.validate = true;
</script>