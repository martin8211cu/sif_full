<cf_templateheader title="Ayudas en L&iacute;nea">
<cf_web_portlet_start titulo="Ayudas en L&iacute;nea">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	
	<cfif isdefined("Url.fAcodigo") and not isdefined("Form.fAcodigo")>
		<cfset Form.fAcodigo = Url.fAcodigo>
	</cfif>
	<cfif not isdefined("Form.fAcodigo")>
		<cfset Form.fAcodigo = "">
	</cfif>

	<cfset filtro = "">
	<cfset navegacion = "">
	<cfif isdefined("Form.fAcodigo") and Len(Trim(Form.fAcodigo))>
		<cfset filtro = filtro & " and upper(a.Acodigo) like '%" & UCase(Form.fAcodigo) & "%'">
		<cfset navegacion = navegacion & "fAcodigo=" & Form.fAcodigo>
	</cfif>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	  	<td>
			<cfoutput>
			<form method="post" action="Ayudas.cfm" style="margin: 0 ">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
				  <tr>
					<td width="1%" nowrap><strong>Descripci&oacute;n:&nbsp;</strong></td>
					<td nowrap>
						<input name="fAcodigo" type="text" style="width: 100%;" value="<cfif isdefined('Form.fAcodigo')>#Form.fAcodigo#</cfif>">
					</td>
					<td width="1%" nowrap>
						<input name="btnBuscar" type="submit" value="Buscar">
						<input name="btnLimpiar" type="button" value="Limpiar" onClick="javascript: this.form.fAcodigo.value = '';">
					</td>
				  </tr>
				</table>
			</form>
			</cfoutput>
		</td>
	  	<td>&nbsp;</td>
	  </tr>
	  <tr> 
		<td valign="top" width="35%" nowrap>
			<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Ayuda a, Idiomas b"/>
				<cfinvokeargument name="columnas" value="'#Form.fAcodigo#' as fAcodigo, Ayid, a.Acodigo, a.Iid, b.Icodigo"/>
				<cfinvokeargument name="desplegar" value="Acodigo"/>
				<cfinvokeargument name="etiquetas" value="Uri"/>
				<cfinvokeargument name="Cortes" value="Icodigo"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="	a.Iid = b.Iid 
														#filtro#
													    order by a.Acodigo"/>
				<cfinvokeargument name="align" value="left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="Ayudas.cfm"/>
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="Conexion" value="sifcontrol"/>
				<cfinvokeargument name="keys" value="Ayid"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke> 
		  </td>
		  <td valign="top" style="padding-left: 10px; " nowrap="nowrap" width="65%">
			<cfinclude template="Ayudas_form.cfm">
		  </td>
	  </tr>
	  <tr>
	  	<td colspan="2">&nbsp;</td>
	  </tr>
	</table>
	
<cf_web_portlet_end>
<cf_templatefooter>
