<cf_template>
	<cf_templatearea name="title">
			Eliminación de Feligreses
	</cf_templatearea>
	<cf_templatearea name="left">
		<cfinclude template="../pMenu.cfm">
	</cf_templatearea>
	<cf_templatearea name="body">
		<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td nowrap rowspan="5">&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap rowspan="5">&nbsp;</td>
		  </tr>
		  <tr>
			<td nowrap align="left"><strong>Los Siguientes Feligreses serán eliminados:</strong></td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
			<td nowrap>
				<cfif isdefined("Url.empr") and not isdefined("Form.empr")>
					<cfset Form.empr = Url.empr>
				</cfif>
				<cfif isdefined("Url.chk") and not isdefined("Form.chk")>
					<cfset Form.chk = Url.chk>
				</cfif>
				<cfif not isdefined("Form.empr")>
					<cfset Form.empr = session.Ecodigo>
				</cfif>
				<cfset filtro = "">
				<cfset navegacion = "empr=" & form.empr & "&chk=" & form.chk>
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pLista"
				 returnvariable="pListaEduRet">
					<cfinvokeargument name="tabla" value="MEPersona a, asp..Empresa b, asp..UsuarioReferencia c"/>
					<cfinvokeargument name="columnas" value="'#Form.empr#' as empr, 
															convert(varchar, a.MEpersona) as MEpersona, 
															rtrim(a.Papellido1 || ' ' || a.Papellido2) || ', ' || a.Pnombre as Nombre, 
															a.Poficina,
															(case when c.Usucodigo is null then '<font color=''##FF0000''>No</font>' else 'Sí' end) as tieneUsuario
															"/>
					<cfinvokeargument name="desplegar" value="Nombre, Poficina, tieneUsuario"/>
					<cfinvokeargument name="etiquetas" value="Nombre Completo, Tel. Diurno, Usuario"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value=" a.Ecodigo = #Form.empr#
															and a.cliente_empresarial = #Session.CEcodigo#
															and a.activo = 1
															#filtro# 
															and a.MEpersona in (#form.chk#)
															and a.Ecodigo = b.Ereferencia
															and a.MEpersona *= convert(numeric, c.llave)
															and b.Ecodigo *= c.Ecodigo
															and c.STabla = 'MEPersona'
															order by a.Papellido1, a.Papellido2, a.Pnombre
															"/>
					<cfinvokeargument name="align" value="left, center, center"/>
					<cfinvokeargument name="ajustar" value=""/>
					<cfinvokeargument name="irA" value="afiliacion.cfm"/>
					<cfinvokeargument name="formName" value="listaPersonas"/>
					<cfinvokeargument name="MaxRows" value="20"/>
					<cfinvokeargument name="keys" value="MEpersona"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
			</td>
		  </tr>
		  <tr>
			<td nowrap align="center">
				<cfoutput>
				
				<form name="form1" action="afiliacion-eliminacion.cfm" method="post">
					<input type="hidden" name="chk" value="#Form.chk#">
					<input type="hidden" name="empr" value="#Form.empr#">
					
					<input type="button" name="btnAnterior" value="<< ANTERIOR" onClick="javascript: history.back();">
					<input type="submit" name="btnEliminar" value="ELIMINAR">
				</form>
				
				</cfoutput>
			</td>
		  </tr>
		</table>
	</cf_templatearea>
</cf_template>
