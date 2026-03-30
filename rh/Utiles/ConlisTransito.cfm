<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Tr&aacute;nsito</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0;">

	<cfset GvarUrlToFormParam = "">
	<cffunction name="fnUrlToFormParam">
		<cfargument name="LprmNombre"  type="string" required="yes">
		<cfargument name="LprmDefault" type="string" required="yes">
		
		<cfparam name="url[LprmNombre]" default="#LprmDefault#">
		<cfparam name="form[LprmNombre]" default="#url[LprmNombre]#">
		<cfif isdefined("GvarUrlToFormParam")>
			<cfif len(trim(GvarUrlToFormParam))>
				<cfset GvarUrlToFormParam = GvarUrlToFormParam & "&">
			</cfif>
			<cfset GvarUrlToFormParam = GvarUrlToFormParam & "#LprmNombre#=" & Form[LprmNombre]>
		</cfif>
	</cffunction>


	<cfset fnUrlToFormParam ("tipo", "")>

	<cfset fnUrlToFormParam ("f", "")>
	<cfset fnUrlToFormParam ("tipoid", "")>
	<cfset fnUrlToFormParam ("id", "")>

	<cfset fnUrlToFormParam ("txt_descripcion", "")>
	<cfset navegacion = GvarUrlToFormParam>
	
	<script language="JavaScript" type="text/javascript">
	function Asignar(tipo, id) {
		if (window.opener != null) {
			<cfoutput>
			window.opener.document.#Form.f#.#Form.tipoid#.value = tipo;
			window.opener.document.#Form.f#.#Form.id#.value = id;
			</cfoutput>
			if (window.opener.funcTransito) window.opener.funcTransito(id);
			window.close();
		}
	}
	</script>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="center" class="tituloListas"><strong>Tr&aacute;nsito</strong></td>
      </tr>
	  <tr>
		<td class="areaFiltro">
			<cfoutput>
			<form name="filtroDocs" method="post" style="margin: 0;" action="#GetFileFromPath(GetTemplatePath())#">
				<cfloop collection="#Form#" item="i">
					<cfif FindNoCase('txt_descripcion', i) EQ 0>
						<input type="hidden" name="#i#" value="#StructFind(Form, i)#">
					</cfif>
				</cfloop>
				<table width="100%"  border="0" cellspacing="0" cellpadding="3">
				  <tr>
					<td align="right" class="fileLabel">Documento:</td>
					<td>
						<input name="txt_descripcion" type="text" size="40" maxlength="80" value="<cfif isdefined('Form.txt_descripcion')>#Form.txt_descripcion#</cfif>">
					</td>
					<td align="center">
						<input name="btnBuscar" type="submit" value="Buscar">
					</td>
				  </tr>
				</table>
			</form>
			</cfoutput>
		</td>
	  </tr>
	  <tr>
		<td align="center">
			<cfif Form.tipo EQ 'A'>
				<cfquery name="rsLista" datasource="#Session.DSN#">
					select '#Form.tipo#' as tipo, 
						   a.Tid, a.Ddocumento, c.CPTdescripcion, d.SNnombre, a.Tfecha, a.Tembarque, b.Adescripcion, a.Tcantidad
					from Transito a
						inner join Articulos b
						on a.Aid = b.Aid
					
						inner join CPTransacciones c
						on a.Ecodigo = c.Ecodigo
						and a.CPTcodigo = c.CPTcodigo
					
						inner join SNegocios d
						on a.Ecodigo = d.Ecodigo
						and a.SNcodigo = d.SNcodigo
						
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					<cfif isdefined("Form.txt_descripcion") and Len(Trim(Form.txt_descripcion))>
						and upper(a.Ddocumento) like '%#Ucase(Form.txt_descripcion)#%'
					</cfif>
				</cfquery>
			<cfelseif Form.tipo EQ 'S'>
				<cfquery name="rsLista" datasource="#Session.DSN#">
					select '#Form.tipo#' as tipo, a.TCid, a.Ddocumento, c.CPTdescripcion, d.SNnombre, a.TCfecha, a.TCembarque, b.Cdescripcion, a.TCcantidad
					from TransitoConceptos a
						inner join Conceptos b
						on a.Cid = b.Cid
					
						inner join CPTransacciones c
						on a.Ecodigo = c.Ecodigo
						and a.CPTcodigo = c.CPTcodigo
					
						inner join SNegocios d
						on a.Ecodigo = d.Ecodigo
						and a.SNcodigo = d.SNcodigo
						
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					<cfif isdefined("Form.txt_descripcion") and Len(Trim(Form.txt_descripcion))>
						and upper(a.Ddocumento) like '%#Ucase(Form.txt_descripcion)#%'
					</cfif>
				</cfquery>
			<cfelse>

			</cfif>
		
			<cfif isdefined("rsLista")>
				<cfoutput>
				<form name="listaCuentas" method="post" action="#GetFileFromPath(GetTemplatePath())#">
					<cfloop collection="#Form#" item="i">
						<cfset v = StructFind(Form, i)>
						<cfif CompareNoCase(i, "txt_codigo") and CompareNoCase(i, "txt_descripcion") and Len(Trim(v))>
							<input type="hidden" name="#i#" value="#v#">
						</cfif>
					</cfloop>
					
					<cfif Form.tipo EQ 'A'>
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="Ddocumento, CPTdescripcion, SNnombre, Tfecha, Tembarque, Adescripcion, Tcantidad"/>
							<cfinvokeargument name="etiquetas" value="Documento, Transacci&oacute;n, Proveedor, Fecha, Embarque, Art&iacute;culo, Cantidad"/>
							<cfinvokeargument name="formatos" value="V,V,V,D,V,V,I"/>
							<cfinvokeargument name="align" value="left, left, left, left, left, left, left"/>
							<cfinvokeargument name="ajustar" value=""/>
							<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
							<cfinvokeargument name="formName" value="form1"/>
							<cfinvokeargument name="MaxRows" value="15"/>
							<cfinvokeargument name="funcion" value="Asignar"/>
							<cfinvokeargument name="fparams" value="tipo, Tid"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
						</cfinvoke>
					<cfelseif Form.tipo EQ 'S'>
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="Ddocumento, CPTdescripcion, SNnombre, TCfecha, TCembarque, Cdescripcion, TCcantidad"/>
							<cfinvokeargument name="etiquetas" value="Documento, Transacci&oacute;n, Proveedor, Fecha, Embarque, Art&iacute;culo, Cantidad"/>
							<cfinvokeargument name="formatos" value="V,V,V,D,V,V,I"/>
							<cfinvokeargument name="align" value="left, left, left, left, left, left, left"/>
							<cfinvokeargument name="ajustar" value=""/>
							<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
							<cfinvokeargument name="formName" value="form1"/>
							<cfinvokeargument name="MaxRows" value="15"/>
							<cfinvokeargument name="funcion" value="Asignar"/>
							<cfinvokeargument name="fparams" value="tipo, TCid"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
						</cfinvoke>
					</cfif>
				</form>
				</cfoutput>
			</cfif>
		</td>
	  </tr>
	</table>

</body>
</html>
