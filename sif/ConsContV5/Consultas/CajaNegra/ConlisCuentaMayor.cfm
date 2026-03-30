
<cfoutput>
<script language="JavaScript" type="text/javascript">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function Asignar(cuenta,detalle) {
		if (window.opener != null) {
			window.opener.document.form1.CGM1IM.value = cuenta;
			window.opener.document.form1.DETALLE.value = detalle;

			if (window.opener.PintaCajas) {
				window.opener.PintaCajas(cuenta,detalle)
			}
			
			if (window.opener.funcCGM1IM) {
				window.opener.funcCGM1IM()
			}
		window.close();
		}
	}
</script>
</cfoutput>

<html>
<head>
<title>Lista de Cuenta Mayor</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfoutput>
<form style="margin:0;" name="filtroAsiento" method="post" action="ConlisCuentaMayor.cfm" >
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
						<td width="15%" nowrap><strong>Cuenta Mayor:</strong>&nbsp;</td>
						<td width="40%"> 
                  			<input name="f_CGM1IM" type="text" id="cod" size="4" maxlength="4" onClick="this.select();" value="<cfif isdefined("Form.f_CGM1IM") and Form.f_CGM1IM NEQ ''>#Form.f_CGM1IM#</cfif>">
						</td>
						<td width="45%" align="center">
							<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
							
							<cfif isdefined("form.formulario") and len(trim(form.formulario))>
								<input type="hidden" name="formulario" value="#form.formulario#">
							</cfif>
							<cfif isdefined("form.CGM1IM") and len(trim(form.CGM1IM))>
								<input type="hidden" name="CGM1IM" value="#form.CGM1IM#">
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	
		<tr>
			<td>
				<!--- Navegacion --->
				<cfset navegacion = "&formulario=form1" >
				<cfif isdefined("Form.CGM1IM") and Len(Trim(Form.CGM1IM)) neq 0>
					<cfset navegacion = navegacion & "&CGM1IM=" & Form.CGM1IM>
				</cfif> 
				<cfif isdefined("Form.CGM1CD") and Len(Trim(Form.CGM1CD)) neq 0>
					<cfset navegacion = navegacion & "&CGM1CD=" & Form.CGM1CD>
				</cfif>
			
				<cfquery name="rsCuentas" datasource="desarrollo">
					select CGM1IM, CGM1CD, CTADES
					from CGM001
					where 1=1
					<cfif isdefined("Form.f_CGM1IM") and Len(Trim(Form.f_CGM1IM)) neq 0>
						and upper(CGM1IM) like '%#ucase(Form.f_CGM1IM)#%'
					</cfif>
					order by CGM1IM, CGM1CD
				</cfquery>

				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsCuentas#"/>
					<cfinvokeargument name="desplegar" value="CGM1IM, CGM1CD, CTADES"/>
					<cfinvokeargument name="etiquetas" value="Cuenta Mayor, Cuenta Detalle, Descripción"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="align" value="left, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="n"/>
					<cfinvokeargument name="irA" value="ConlisCuentaMayor.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="keys" value="CGM1IM"/>	
					<cfinvokeargument name="funcion" value="Asignar"/>
					<cfinvokeargument name="fparams" value="CGM1IM,CGM1CD"/>
					<cfinvokeargument name="MaxRows" value="15"/>
				</cfinvoke>
			</td>
		</tr>	
	</table>
</form>
</cfoutput>

</body>
</html>

