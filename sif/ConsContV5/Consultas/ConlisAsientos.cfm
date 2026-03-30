<!--- Parámetros para llamar al ConlisAsientos --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>

<cfif isdefined("Url.CG5CON") and not isdefined("Form.CG5CON")>
	<cfparam name="Form.CG5CON" default="#Url.CG5CON#">
</cfif>

<cfif isdefined("Url.CG5DES") and not isdefined("Form.CG5DES")>
	<cfparam name="Form.CG5DES" default="#Url.CG5DES#">
</cfif>

<cfoutput>
<script language="JavaScript" type="text/javascript">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function Asignar(codigo,descripcion) {
		if (window.opener != null) {
			window.opener.document.#form.formulario#.#form.CG5CON#.value = codigo;
			window.opener.document.#form.formulario#.#form.CG5DES#.value = descripcion;
		
			if (window.opener.func#form.CG5CON#) {
				window.opener.func#form.CG5CON#()
			}
		window.close();
		}
	}
</script>
</cfoutput>

<html>
<head>
<title>Lista de Asientos Contables</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfoutput>
<form style="margin:0;" name="filtroAsiento" method="post" action="ConlisAsientos.cfm" >
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
						<td align="right" nowrap><strong>C&oacute;digo:</strong>&nbsp;</td>
						<td> 
                  			<input name="f_CG5CON" type="text" id="cod" size="5" maxlength="5" onClick="this.select();" value="<cfif isdefined("Form.f_CG5CON") and Form.f_CG5CON NEQ ''>#Form.f_CG5CON#</cfif>">
						</td>
						<td align="right" nowrap><strong>Asiento Contable:</strong>&nbsp;</td>
						<td> 
                  			<input name="f_CG5DES" type="text" id="desc" size="40" maxlength="40" onClick="this.select();" value="<cfif isdefined("Form.f_CG5DES") and Form.f_CG5DES NEQ ''>#Form.f_CG5DES#</cfif>">
						</td>
						<td align="center">
							<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
							
							<cfif isdefined("form.formulario") and len(trim(form.formulario))>
								<input type="hidden" name="formulario" value="#form.formulario#">
							</cfif>
							<cfif isdefined("form.CG5CON") and len(trim(form.CG5CON))>
								<input type="hidden" name="CG5CON" value="#form.CG5CON#">
							</cfif>
							<cfif isdefined("form.CG5DES") and len(trim(form.CG5DES))>
								<input type="hidden" name="CG5DES" value="#form.CG5DES#">
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
				<cfif isdefined("Form.CG5CON") and Len(Trim(Form.CG5CON)) neq 0>
					<cfset navegacion = navegacion & "&CG5CON=" & Form.CG5CON>
				</cfif> 
				<cfif isdefined("Form.CG5DES") and Len(Trim(Form.CG5DES)) neq 0>
					<cfset navegacion = navegacion & "&CG5DES=" & Form.CG5DES>
				</cfif>
			
				<cfquery name="rsAsiento" datasource="desarrollo">
					select CG5CON, CG5DES 
					from CGM005
					where 1=1
					<cfif isdefined("Form.f_CG5CON") and Len(Trim(Form.f_CG5CON)) neq 0>
						and CG5CON  >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_CG5CON#">
					</cfif>
						
					<cfif isdefined("Form.f_CG5DES") and Len(Trim(Form.f_CG5DES)) neq 0>
						and upper(CG5DES) like '%#ucase(Form.f_CG5DES)#%' 
					</cfif>
				</cfquery>

				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsAsiento#"/>
					<cfinvokeargument name="desplegar" value="CG5CON, CG5DES"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="n"/>
					<cfinvokeargument name="irA" value="ConlisAsientos.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="keys" value="CG5CON"/>	
					<cfinvokeargument name="funcion" value="Asignar"/>
					<cfinvokeargument name="fparams" value="CG5CON,CG5DES"/>
					<cfinvokeargument name="MaxRows" value="15"/>
				</cfinvoke>
			</td>
		</tr>	
	</table>
</form>
</cfoutput>

</body>
</html>
