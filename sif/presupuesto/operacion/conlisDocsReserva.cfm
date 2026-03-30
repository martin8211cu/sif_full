<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Documentos de Provisión Presupuestaria</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0;">
	<cfset navegacion = "">
	<cffunction name="fnUrlToFormParam">
		<cfargument name="LprmNombre"  type="string" required="yes">
		<cfargument name="LprmDefault" type="string" required="yes">
		
		<cfparam name="url[LprmNombre]" default="#LprmDefault#">
		<cfparam name="form[LprmNombre]" default="#url[LprmNombre]#">
		<cfif isdefined("navegacion")>
			<cfif len(trim(navegacion))>
				<cfset navegacion = navegacion & "&">
			</cfif>
			<cfset navegacion = navegacion & "#LprmNombre#=" & Form[LprmNombre]>
		</cfif>
	</cffunction>

	<cfset fnUrlToFormParam ("txt_codigo", "")>
	<cfset fnUrlToFormParam ("txt_fecha", "")>
	<cfset fnUrlToFormParam ("txt_descripcion", "")>
	<cfset fnUrlToFormParam ("p1", "")>
	<cfset fnUrlToFormParam ("p2", "")>
	<cfset fnUrlToFormParam ("p3", "")>

	<cfquery name="rsDocProvision" datasource="#Session.DSN#">
		select a.CPDEnumeroDocumento, a.CPDEfechaDocumento, a.CPDEdescripcion
		from CPDocumentoE a
		where a.Ecodigo = #Session.Ecodigo#
		and a.CPDEtipoDocumento = 'R'
		and a.CPDEaplicado = 1
		<cfif Len(Trim(Form.txt_codigo))>
			and upper(a.CPDEnumeroDocumento) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.txt_codigo)#%">
		</cfif>
		<cfif Len(Trim(Form.txt_fecha))>
			and a.CPDEfechaDocumento = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.txt_fecha)#">
 		</cfif>
		<cfif Len(Trim(Form.txt_descripcion))>
			and upper(a.CPDEdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.txt_descripcion)#%">
		</cfif>
		and exists 
					(
						select 1 from CPSeguridadUsuario s
						 where s.Ecodigo	= #session.Ecodigo#
						   and s.CFid		= a.CFidOrigen
						   and s.Usucodigo	= #session.Usucodigo#
						   and s.CPSUreservas = 1
					)
		and exists 
					(
						select 1 from CPDocumentoD d
						 where d.Ecodigo	= #session.Ecodigo#
						   and d.CPDEid		= a.CPDEid
						   and d.CPDDsaldo 	> 0
					)
		order by a.CPDEnumeroDocumento
	</cfquery>
	
	<script language="javascript" type="text/javascript">
		<cfoutput>
		function Asignar(num, desc) {
			window.opener.document.#Form.p1#.#Form.p2#.value = num;
			window.opener.document.#Form.p1#.#Form.p3#.value = desc;
			window.close();
		}
		</cfoutput>
	</script>
	
	<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
	    <td align="center"><strong>Lista de Documentos de Provisión Presupuestaria</strong></td>
      </tr>
	  <tr>
		<td class="areaFiltro">
			<cfoutput>
			<form name="filtro" method="post" style="margin: 0;" action="#GetFileFromPath(GetTemplatePath())#">
				<input type="hidden" name="p1" value="#Form.p1#">
				<input type="hidden" name="p2" value="#Form.p2#">
				<input type="hidden" name="p3" value="#Form.p3#">
				<table width="100%"  border="0" cellspacing="0" cellpadding="3">
				  <tr>
					<td align="right" nowrap class="fileLabel">N&uacute;mero:</td>
					<td nowrap>
						<input name="txt_codigo" type="text" size="10" maxlength="100" value="<cfif isdefined('Form.txt_codigo')>#Form.txt_codigo#</cfif>">
					</td>
					<td align="right" nowrap class="fileLabel">Fecha:</td>
					<td nowrap>
						<cfif isdefined("Form.txt_fecha") and Len(Trim(Form.txt_fecha))>
							<cfset fec = Form.txt_fecha>
						<cfelse>
							<cfset fec = "">
						</cfif>
						<cf_sifcalendario form="filtro" name="txt_fecha" value="#fec#">
					</td>
					<td align="right" nowrap class="fileLabel">Descripci&oacute;n:</td>
					<td nowrap>
						<input name="txt_descripcion" type="text" size="40" maxlength="80" value="<cfif isdefined('Form.txt_descripcion')>#Form.txt_descripcion#</cfif>">
					</td>
					<td align="center" nowrap>
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
			<cfoutput>
			<form name="form1" method="post" action="#GetFileFromPath(GetTemplatePath())#">
				<cfloop collection="#Form#" item="i">
					<cfset v = StructFind(Form, i)>
					<cfif CompareNoCase(i, "txt_codigo") and CompareNoCase(i, "txt_fecha")  and CompareNoCase(i, "txt_descripcion") and Len(Trim(v))>
						<input type="hidden" name="#i#" value="#v#">
					</cfif>
				</cfloop>
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsDocProvision#"/>
					<cfinvokeargument name="desplegar" value="CPDEnumeroDocumento, CPDEfechaDocumento, CPDEdescripcion"/>
					<cfinvokeargument name="etiquetas" value="Documento, Fecha, Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value="N, D, V"/>
					<cfinvokeargument name="align" value="right, center, left"/>
					<cfinvokeargument name="ajustar" value="S,N,N"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="formName" value="form1"/>
					<cfinvokeargument name="incluyeForm" value="false"/>
					<cfinvokeargument name="MaxRows" value="10"/>
					<cfinvokeargument name="funcion" value="Asignar"/>
					<cfinvokeargument name="fparams" value="CPDEnumeroDocumento, CPDEdescripcion"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="EmptyListMsg" value="-- No hay Documentos de Provisión Presupuestaria --"/>
				</cfinvoke>
			</form>
			</cfoutput>
		</td>
	  </tr>
	</table>

</body>
</html>
