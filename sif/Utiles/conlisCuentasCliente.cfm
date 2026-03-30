<script language="JavaScript" type="text/javascript">
function Asignar(CBid,Bid,Ocodigo,Mcodigo,CBcodigo,CBdescripcion,CBcc,CBTcodigo) {
	if (window.opener != null) {
		window.opener.document.<cfoutput>#url.form#.#url.CBid#</cfoutput>.value=CBid;
		window.opener.document.<cfoutput>#url.form#.#url.Bid#</cfoutput>.value=Bid;
		window.opener.document.<cfoutput>#url.form#.#url.Ocodigo#</cfoutput>.value=Ocodigo;
		window.opener.document.<cfoutput>#url.form#.#url.Mcodigo#</cfoutput>.value=Mcodigo;
		window.opener.document.<cfoutput>#url.form#.#url.CBcodigo#</cfoutput>.value=CBcodigo;
		window.opener.document.<cfoutput>#url.form#.#url.CBdescripcion#</cfoutput>.value=CBdescripcion;
		window.opener.document.<cfoutput>#url.form#.#url.CBcc#</cfoutput>.value=CBcc;
		window.opener.document.<cfoutput>#url.form#.#url.CBTcodigo#</cfoutput>.value=CBTcodigo;
		window.close();
	}
}
</script>

<cfif isdefined("Url.txtCBcc") and not isdefined("Form.txtCBcc")>
	<cfparam name="Form.txtCBcc" default="#Url.txtCBcc#">
</cfif>
<cfif isdefined("Url.txtCBdescripcion") and not isdefined("Form.txtCBdescripcion")>
	<cfparam name="Form.txtCBdescripcion" default="#Url.txtCBdescripcion#">
</cfif>

<cfset filtro="">
<cfset filtro=filtro&"Ecodigo = #url.Ecodigo#">
<cfif url.vMcodigo neq -1>	
	<cfset filtro=filtro&" and Mcodigo = #url.vMcodigo#">
</cfif>
<cfset navegacion = "">
<cfif isdefined("Form.txtCBcc") and Len(Trim(Form.txtCBcc)) NEQ 0>
	<cfset filtro = filtro & " and upper(CBcc) like '%" & #UCase(Form.txtCBcc)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "txtCBcc=" & Form.txtCBcc>
</cfif>
<cfif isdefined("Form.txtCBdescripcion") and Len(Trim(Form.txtCBdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(CBdescripcion) like '%" & #UCase(Form.txtCBdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "txtCBdescripcion=" & Form.txtCBdescripcion>
</cfif>

<html>
<head>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeCuentasCliente"
	Default="Lista de Cuentas Cliente"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_ListaDeCuentasCliente"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_CuentaCliente"
	Default="Cuenta Cliente"
	returnvariable="MSG_CuentaCliente"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DescripcionCuentaCliente"
	Default="Descripción Cuenta Cliente"
	returnvariable="MSG_DescripcionCuentaCliente"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"
	returnvariable="LB_Descripcion"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElValorPara"
	Default="El valor para"
	returnvariable="MSG_ElValorPara"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeContenerSolamenteCaracteresAlfanumericos"
	Default="debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?)"
	returnvariable="MSG_DebeContenerSolamenteCaracteresAlfanumericos"/>
	
<title><cfoutput>#LB_ListaDeCuentasCliente#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>
<cfoutput>
<form name="filtroCC" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td nowrap align="right"><strong><cf_translate  key="LB_CuentaCliente">Cuenta Cliente</cf_translate>: </strong></td>
		<td> 
			<input name="txtCBcc" type="text" id="name" size="25" maxlength="25" value="<cfif isdefined("Form.txtCBcc")>#Form.txtCBcc#</cfif>">
		</td>
		<td nowrap align="right"><strong><cf_translate XmlFile="/sif/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate></strong></td>
		<td> 
			<input name="txtCBdescripcion" type="text" id="desc" size="60" maxlength="80" value="<cfif isdefined("Form.txtCBdescripcion")>#Form.txtCBdescripcion#</cfif>">
		</td>
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Filtrar"
		Default="Filtrar"
		XmlFile="/sif/generales.xml"
		returnvariable="BTN_Filtrar"/>
		
		<td nowrap align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">

	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("filtroCC");
	//Funciones adicionales de validación
	function _Field_isAlfaNumerico()
	{
		var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
		var tmp="";
		var string = this.value;
		var lc=string.toLowerCase();
		for(var i=0;i<string.length;i++) {
		if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
		}
		if (tmp.length!=this.value.length)
		{
		this.error="<cfoutput>#MSG_ElValorPara#</cfoutput> "+this.description+" <cfoutput>#MSG_DebeContenerSolamenteCaracteresAlfanumericos#</cfoutput>";
		}
	}
	
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	//Validaciones del Encabezado
	objForm.txtCBcc.description = "<cfoutput>#MSG_CuentaCliente#</cfoutput>";
	objForm.txtCBcc.validateAlfaNumerico();
	objForm.txtCBcc.validate = true;
	
	objForm.txtCBdescripcion.description = "<cfoutput>#MSG_DescripcionCuentaCliente#</cfoutput>";
	objForm.txtCBdescripcion.validateAlfaNumerico();
	objForm.txtCBdescripcion.validate = true;

</script>

<cfset filtro=filtro&"and CBesTCE = 0 order by CBcc, CBdescripcion">

<cf_dbfunction name="to_char" args="CBid" returnvariable ="VCBid">
<cf_dbfunction name="to_char" args="Bid" returnvariable ="VBid">
<cf_dbfunction name="to_char" args="CBTcodigo" returnvariable ="VCBTcodigo">
<cf_dbfunction name="to_char" args="Mcodigo" returnvariable ="VMcodigo">

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="CuentasBancos"/>
	<cfinvokeargument name="columnas" value="	#VCBid# as CBid, 
												#VBid# as Bid, 
												Ocodigo, 
												#VMcodigo# as Mcodigo, 
												CBcodigo, 
												CBdescripcion, 
												CBcc, 
												#VCBTcodigo# as CBTcodigo"/>
	<cfinvokeargument name="desplegar" value="CBcc, CBdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#MSG_CuentaCliente#,#LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="#filtro#">
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisCuentasCliente.cfm"/>
	<cfinvokeargument name="formName" value="listaCC"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CBid,Bid,Ocodigo,Mcodigo,CBcodigo,CBdescripcion,CBcc,CBTcodigo"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>