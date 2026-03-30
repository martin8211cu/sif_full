<!--- <cfdump var="#url#"> --->
<!--- <cfdump var="#form#"> --->

<!--- Parámetros para llamar al ConlisSucursales --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>

<cfif isdefined("Url.CGE5COD") and not isdefined("Form.CGE5COD")>
	<cfparam name="Form.CGE5COD" default="#Url.CGE5COD#">
</cfif>

<cfif isdefined("Url.CGE5DES") and not isdefined("Form.CGE5DES")>
	<cfparam name="Form.CGE5DES" default="#Url.CGE5DES#">
</cfif>

<cfoutput>
<script language="JavaScript" type="text/javascript">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function Asignar(codigo,descripcion) {
		if (window.opener != null) {
			window.opener.document.#url.formulario#.#url.CGE5COD#.value = codigo;
			window.opener.document.#url.formulario#.#url.CGE5DES#.value = descripcion;
		
			if (window.opener.func#url.CGE5COD#) {
				window.opener.func#url.CGE5DES#()
			}
		window.close();
		}
	}
</script>
</cfoutput>
 
<!--- Filtros --->
<cfif isdefined("url.CGE5COD") and not isdefined("form.CGE5COD")>
	<cfset form.CGE5COD = url.CGE5COD >
</cfif>

<cfif isdefined("url.CGE5DES") and not isdefined("form.CGE5DES")>
	<cfset form.CGE5DES = url.CGE5DES >
</cfif>

<!--- Filtro --->
<cfset filtro = "">
<cfset navegacion = "&formulario=#form.formulario#" >

<cfif isdefined("Form.CGE5COD") and Len(Trim(Form.CGE5COD)) neq 0>
 	<cfset filtro = filtro & " and upper(CGE5COD) like '%" & ucase(Form.CGE5COD) & "%'">
	<cfset navegacion = navegacion & "&CGE5COD=" & Form.CGE5COD>
</cfif> 
<cfif isdefined("Form.CGE5DES") and Len(Trim(Form.CGE5DES)) neq 0>
 	<cfset filtro = filtro & " and upper(CGE5DES) like '%" & ucase(Form.CGE5DES) & "%'">
	<cfset navegacion = navegacion & "&CGE5DES=" & Form.CGE5DES>
</cfif> 

<html>
<head>
<title>Lista de Sucursales</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfoutput>
<form style="margin:0;" name="filtroSucursal" method="post" action="ConlisSucursales.cfm" >
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
						<td align="right" nowrap><strong>C&oacute;digo:</strong>&nbsp;</td>
						<td> 
                  			<input name="CGE5COD" type="text" id="cod" size="5" maxlength="5" onClick="this.select();" value="<cfif isdefined("Form.CGE5DES")>#Form.CGE5DES#</cfif>">
						</td>
						<td align="right" nowrap><strong>Sucursal:</strong>&nbsp;</td>
						<td> 
                  			<input name="CGE5DES" type="text" id="desc" size="40" maxlength="40" onClick="this.select();" value="<cfif isdefined("Form.CGE5DES")>#Form.CGE5DES#</cfif>">
						</td>
						<td align="center">
							<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
							
							<cfif isdefined("form.formulario") and len(trim(form.formulario))>
								<input type="hidden" name="formulario" value="#form.formulario#">
							</cfif>
							<cfif isdefined("form.CGE5COD") and len(trim(form.CGE5COD))>
								<input type="hidden" name="CGE5COD" value="#form.CGE5COD#">
							</cfif>
							<cfif isdefined("form.CGE5DES") and len(trim(form.CGE5DES))>
								<input type="hidden" name="CGE5DES" value="#form.CGE5DES#">
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	
		<tr>
			<td>
				<cfquery name="rsEmpresa" datasource="desarrollo">
					select CGE1COD FROM CGE000		
				</cfquery>
	
				<cfquery name="rsSucursal" datasource="desarrollo">
					select CGE5COD, CGE5DES
					from CGE005
					where CGE1COD = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpresa.CGE1COD#">
				</cfquery>

				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsSucursal#"/>
					<cfinvokeargument name="where" value="#filtro#"/>
					<cfinvokeargument name="desplegar" value="CGE5COD, CGE5DES"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="n"/>
					<cfinvokeargument name="irA" value="ConlisSucursales.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="keys" value="CGE5COD"/>	
					<cfinvokeargument name="funcion" value="Asignar"/>
					<cfinvokeargument name="fparams" value="CGE5COD,CGE5DES"/>
				</cfinvoke>
			</td>
		</tr>	
	</table>
</form>
</cfoutput>

</body>
</html>
