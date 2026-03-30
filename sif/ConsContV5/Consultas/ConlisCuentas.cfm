<!--- Parámetros para llamar al ConlisAsientos --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>

<cfif isdefined("Url.CGM1IM") and not isdefined("Form.CGM1IM")>
	<cfparam name="Form.CGM1IM" default="#Url.CGM1IM#">
</cfif>

<cfif isdefined("Url.CGM1CD") and not isdefined("Form.CGM1CD")>
	<cfparam name="Form.CGM1CD" default="#Url.CGM1CD#">
</cfif>

<cfoutput>
<script language="JavaScript" type="text/javascript">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function Asignar(codigo,descripcion) {
		if (window.opener != null) {
			window.opener.document.#form.formulario#.#form.CGM1IM#.value = codigo;
			window.opener.document.#form.formulario#.#form.CGM1CD#.value = descripcion;
		
			if (window.opener.func#form.CGM1IM#) {
				window.opener.func#form.CGM1IM#()
			}
		window.close();
		}
	}
</script>
</cfoutput>

<html>
<head>
<title>Lista de Cuentas Contables</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfoutput>
<form style="margin:0;" name="filtroAsiento" method="post" action="ConlisCuentas.cfm" >
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
						<td align="right" nowrap><strong>Cuenta Mayor:</strong>&nbsp;</td>
						<td> 
                  			<input name="f_CGM1IM" type="text" id="cod" size="4" maxlength="4" onClick="this.select();" value="<cfif isdefined("Form.f_CGM1IM") and Form.f_CGM1IM NEQ ''>#Form.f_CGM1IM#</cfif>">
						</td>
						<td align="right" nowrap><strong>Cuenta Detalle :</strong>&nbsp;</td>
						<td> 
                  			<input name="f_CGM1CD" type="text" id="desc" size="30" maxlength="30" onClick="this.select();" value="<cfif isdefined("Form.f_CGM1CD") and Form.f_CGM1CD NEQ ''>#Form.f_CGM1CD#</cfif>">
						</td>
						<td align="center">
							<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
							
							<cfif isdefined("form.formulario") and len(trim(form.formulario))>
								<input type="hidden" name="formulario" value="#form.formulario#">
							</cfif>
							<cfif isdefined("form.CGM1IM") and len(trim(form.CGM1IM))>
								<input type="hidden" name="CGM1IM" value="#form.CGM1IM#">
							</cfif>
							<cfif isdefined("form.CGM1CD") and len(trim(form.CGM1CD))>
								<input type="hidden" name="CGM1CD" value="#form.CGM1CD#">
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	
		<tr>
			<td>
				<!--- Navegacion --->
				<cfset navegacion = "&formulario=#form.formulario#" >
				<cfif isdefined("Form.CGM1IM") and Len(Trim(Form.CGM1IM)) neq 0>
					<cfset navegacion = navegacion & "&CGM1IM=" & Form.CGM1IM>
				</cfif> 
				<cfif isdefined("Form.CGM1CD") and Len(Trim(Form.CGM1CD)) neq 0>
					<cfset navegacion = navegacion & "&CGM1CD=" & Form.CGM1CD>
				</cfif>
			
				<cfquery name="rsCuentas" datasource="desarrollo">
					select CGM1IM, coalesce(rtrim(ltrim(CGM1CD)),'No tiene Cuenta Detalle') as CGM1CD, CTADES
					from CGM001
					where 1=1
					<cfif isdefined("Form.f_CGM1IM") and Len(Trim(Form.f_CGM1IM)) neq 0>
						and upper(CGM1IM) like '%#ucase(Form.f_CGM1IM)#%'
					</cfif>
						
					<cfif isdefined("Form.f_CGM1CD") and Len(Trim(Form.f_CGM1CD)) neq 0>
						and upper(CGM1CD) like '%#ucase(Form.f_CGM1CD)#%' 
					</cfif>
					order by CGM1IM, CGM1CD
				</cfquery>

				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsCuentas#"/>
					<cfinvokeargument name="desplegar" value="CGM1IM, CGM1CD"/>
					<cfinvokeargument name="etiquetas" value="Cuenta Mayor, Cuenta Detalle"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="n"/>
					<cfinvokeargument name="irA" value="ConlisCuentas.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="keys" value="CGM1IM"/>	
					<cfinvokeargument name="funcion" value="Asignar"/>
					<cfinvokeargument name="fparams" value="CGM1IM, CGM1CD"/>
					<cfinvokeargument name="MaxRows" value="15"/>
				</cfinvoke>
			</td>
		</tr>	
	</table>
</form>
</cfoutput>

</body>
</html>

