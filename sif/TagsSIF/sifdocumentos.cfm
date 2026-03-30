<cfset def = QueryNew("campo") >
<!--- Parámetros del TAG --->
<!--- Conexion a utilizar en los queries --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String">
<!--- Query que contiene los valores para cargar los campos en el modo cambio --->
<cfparam name="Attributes.query" default="#def#" type="query">
<!--- Nombre del form que contiene los campos --->
<cfparam name="Attributes.form" default="form1" type="String">
<!--- Nombre del Campo CCTcodigo --->
<cfparam name="Attributes.CCTcodigo" default="CCTcodigo" type="string">
<!--- Nombre del Campo Ddocumento--->
<cfparam name="Attributes.Ddocumento" default="Ddocumento" type="string">
<!--- Módulo que se quiere consultar --->
<cfparam name="Attributes.Modulo" default="CC" type="string">
<!--- Index para incluir mas de un tag en el mismo form --->
<cfparam name="Attributes.index" default="0" type="numeric">

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>
<cfoutput>
<script language="JavaScript" type="text/javascript">
	<!--//
	var popUpWin=0;
	function popUpWindowsifdocumentos#Attributes.index#(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = 
	}
	function doConlisDocumentos#Attributes.index#() {
		var params ="";
		params = "?form=#Attributes.form#&cctcodigo=#Attributes.cctcodigo#&ddocumento=#Attributes.ddocumento#&conexion=#Attributes.conexion#";
		alert(params);

	}
	//-->
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfif Attributes.Modulo EQ 'CC'>
			<cfset cctcodigo = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.cctcodigo')#')#')">
		<cfelseif Attributes.Modulo EQ 'CP'>
			<cfset cptcodigo = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.cptcodigo')#')#')">
			<cfset sncodigo = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.sncodigo')#')#')">
			<cfset iddocumento = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.iddocumento')#')#')">
		</cfif>
		<cfset ddocumento = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.ddocumento')#')#')">
	</cfif>
	<tr>
		<td nowrap>
			<input type="text"
				name="#Attributes.ddocumento#" id="#Attributes.ddocumento#" disabled 
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#ddocumento#')#</cfif>">
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Catálogos" name="imagen" width="18" 
			height="14" border="0" align="absmiddle" onClick='javascript: doConlisDocumentos#Attributes.index#();'></a>
		</td>
		<td>
			<cfif Attributes.Modulo EQ 'CC'>
				<input type="hidden"
					name="#Attributes.cctcodigo#" id="#Attributes.cctcodigo#"
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#cctcodigo#')#</cfif>" >
			<cfelseif Attributes.Modulo EQ 'CP'>
				<input type="hidden"
					name="#Attributes.cptcodigo#" id="#Attributes.cptcodigo#"
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#cptcodigo#')#</cfif>" >
				<input type="hidden"
					name="#Attributes.sncodigo#" id="#Attributes.sncodigo#"
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#sncodigo#')#</cfif>" >
				<input type="hidden"
					name="#Attributes.iddocumento#" id="#Attributes.iddocumento#"
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#iddocumento#')#</cfif>" >
			</cfif>
		</td>
	</tr>
</table>
</cfoutput>