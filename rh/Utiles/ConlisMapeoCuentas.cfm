

<!--- codigo --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Codigo"
	Default="C&oacute;digo"
	xmlfile="/rh/generales.xml"		
	returnvariable="vCodigo"/>		

<!--- descripcion --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descripcion"
	Default="Descripci&oacute;n"
	xmlfile="/rh/generales.xml"		
	returnvariable="vDescripcion"/>		

<!--- Filtrar --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Filtrar"
	Default="Filtrar"
	xmlfile="/rh/generales.xml"		
	returnvariable="vFiltrar"/>		


<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.tipo") and not isdefined("Form.tipo")>
	<cfparam name="Form.tipo" default="#Url.tipo#">
</cfif>
<cfif isdefined("Url.CGICMid") and not isdefined("Form.CGICMid")>
	<cfparam name="Form.CGICMid" default="#Url.CGICMid#">
</cfif>
<cfif isdefined("Url.CGICCid") and not isdefined("Form.CGICCid")>
	<cfparam name="Form.CGICCid" default="#Url.CGICCid#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.codigo#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		if (window.opener.func#form.codigo#) {window.opener.func#form.codigo#()}
		window.opener.document.#form.formulario#.#form.codigo#.focus();
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.Cdescripcion") and not isdefined("Form.Cdescripcion")>
	<cfparam name="Form.Cdescripcion" default="#Url.Cdescripcion#">
</cfif>
<cfif isdefined("Url.Cformato") and not isdefined("Form.Cformato")>
	<cfparam name="Form.Cformato" default="#Url.Cformato#">
</cfif>

<cfset filtro = "">
<cfset descripcion = "Lista de Cuentas Contables Sin Mapear">

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#&tipo=#form.tipo#" >
<cfif isdefined("Form.Cdescripcion") and Len(Trim(Form.Cdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(c.Cdescripcion) like '%" & UCase(Form.Cdescripcion) & "%'">
	<cfset navegacion = navegacion & "&Cdescripcion=" & Form.Cdescripcion>
</cfif>
<cfif isdefined("Form.Cformato") and Len(Trim(Form.Cformato)) NEQ 0>
 	<cfset filtro = filtro & " and c.Cformato like '%" & Form.Cformato & "%'">
	<cfset navegacion = navegacion & "&Cformato=" & Form.Cformato>
</cfif>
<cfif isdefined("Form.CGICMid") and Len(Trim(Form.CGICMid)) NEQ 0>
	<cfset navegacion = navegacion & "&CGICMid=" & Form.CGICMid>
</cfif>
<cfif isdefined("Form.CGICCid") and Len(Trim(Form.CGICCid)) NEQ 0>
	<cfset navegacion = navegacion & "&CGICCid=" & Form.CGICCid>
</cfif>


<html>
<head>
<title><cfoutput>#descripcion#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<!---<tr><td><table width="100%"><tr><td class="tituloMantenimiento" align="center"><font size="2">Conceptos de Servicio</font></td></tr></table></td></tr>--->
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisMapeoCuentas.cfm">
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>#vCodigo#</strong></td>
				<td> 
					<input name="Cformato" type="text" id="desc" size="20" maxlength="100" onClick="this.select();" value="<cfif isdefined("Form.Cformato")>#Form.Cformato#</cfif>">
				</td>
				<td align="right"><strong>#vDescripcion#</strong></td>
				<td> 
					<input name="Cdescripcion" type="text" id="codigo" size="35" maxlength="100" onClick="this.select();" value="<cfif isdefined("Form.Cdescripcion")>#Form.Cdescripcion#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#vFiltrar#">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.id") and len(trim(form.id))>
						<input type="hidden" name="id" value="#form.id#">
					</cfif>
					<cfif isdefined("form.codigo") and len(trim(form.codigo))>
						<input type="hidden" name="codigo" value="#form.codigo#">
					</cfif>
					<cfif isdefined("form.desc") and len(trim(form.desc))>
						<input type="hidden" name="desc" value="#form.desc#">
					</cfif>
					<input type="hidden" name="tipo" value="<cfif isdefined("form.tipo") and len(trim(form.tipo))>#form.tipo#</cfif>">
					<input type="hidden" name="CGICMid" value="<cfif isdefined("form.CGICMid") and len(trim(form.CGICMid))>#form.CGICMid#</cfif>">
					<input type="hidden" name="CGICCid" value="<cfif isdefined("form.CGICCid") and len(trim(form.CGICCid))>#form.CGICCid#</cfif>">
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="rsMapeoCuentas" datasource="#session.dsn#">
			select
				c.Ccuenta, 
				c.Cformato, 
				left (c.Cdescripcion, 35) as Cdescripcion, 
				case m.Ctipo 
					when 'A' then 'ACT' 
					when 'P' then 'PAS' 
					when 'C' then 'CAP' 
					when 'I' then 'ING' 
					when 'G' then 'GAS' 
					else 'Orden' 
				end as Ctipo
			from CContables c 
				inner join CtasMayor m 
				  on m.Cmayor = c.Cmayor 
				 and m.Ecodigo = c.Ecodigo
			where
			c.Ecodigo = #session.Ecodigo#
			and c.Cformato <> c.Cmayor
			and c.Cmovimiento = 'S'
			and not exists(
						select 1
						from CGIC_Cuentas mc
						where mc.Ccuenta = c.Ccuenta
						and mc.CGICMid = #form.CGICMid#
							)
			#Preservesinglequotes(filtro)#
			order by c.Cformato
		</cfquery>

		<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
			<cfinvokeargument name="query" value="#rsMapeoCuentas#">
			<cfinvokeargument name="desplegar" value="Cformato, Cdescripcion, Ctipo">
			<cfinvokeargument name="etiquetas" value="Cuenta, Descripción, Tipo">
			<cfinvokeargument name="formatos" value="S,S,S">
			<cfinvokeargument name="align" value="left,left,left">
			<cfinvokeargument name="ajustar" value="N">
			<cfif isdefined ("rsMapeoCuentas") and rsMapeoCuentas.recordcount GT 0>
				<cfinvokeargument name="botones" value="Agregar"/>
			</cfif>
			<cfinvokeargument name="showEmptyListMsg" value="true">
			<cfinvokeargument name="irA" value="/cfmx/sif/cg/catalogos/SQLCatalogoCuentasM.cfm?CGICMid=#form.CGICMid#&CGICCid=#form.CGICCid#">
			<cfinvokeargument name="formName" value="form2">
			<cfinvokeargument name="keys" value="Ccuenta">
			<cfinvokeargument name="funcion" value="ProcesarLinea">
			<cfinvokeargument name="fparams" value="Ccuenta">
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="maxrows" value="100"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
		</cfinvoke>

	</td></tr>	
</table>

</body>
</html>
<script language='javascript' type='text/JavaScript' >
<!--//
	function ProcesarLinea(Ccuenta){
		return false;
	}
	
	//function funcAgregar(){
	//	popUpWinSN.close();
//}

	
//-->
</script>
