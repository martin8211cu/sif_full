<cf_templateheader title="Cuentas por Cobar">
	<cf_templatecss>
	<cfif isdefined('url.SNCcodigo')>
		<cfset form.SNCcodigo = url.SNCcodigo>
		<cfset form.CAMBIO='CAMBIO'>
	</cfif>
	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Socios de Negocio Corporativos'>

	<cfset filtro = "1=1" >
	<cfif isdefined("form.fSNCidentificacion") and len(trim(form.fSNCidentificacion)) gt 0 >
		<cfset filtro = filtro & "and SNCidentificacion like '%#form.fSNCidentificacion#%'">
	</cfif>
	<cfif isdefined("form.fSNCnombre") and len(trim(form.fSNCnombre)) gt 0 >
		<cfset filtro = filtro & "and upper(SNCnombre) like upper('%#form.fSNCnombre#%')">
	</cfif>
	
	<cfset filtro = filtro & "order by SNCidentificacion" >
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
	<tr>
		<td colspan="2" valign="top">
			<cfinclude template="../../portlets/pNavegacion.cfm">
		</td>
	</tr>
	<tr> <td align="center" colspan="3"><strong>En construcci&oacute;n</strong></td></tr> 
	  <tr>
		  <!--- Filtro, lista--->
		  <td width="40%" valign="top">
				<table width="100%" cellpadding="0" cellspacing="0">
					<!--- filtro --->
					<tr>
						<td valign="top">
						<form style="margin: 0" name="filtro" method="post">
							<table  border="0" width="100%" class="areaFiltro" >
								<tr> 
								  <td nowrap>C&eacute;dula:</td>
								  <td>Nombre</td>
								  <td>&nbsp;</td>
								</tr>
								<tr> 
								  <td><input type="text" name="fSNCidentificacion" maxlength="8" size="10" value=""></td>
								  <td><input type="text" name="fSNCnombre"  maxlength="255" size="40" value=""></td>
								  <td><input type="submit" name="btnFiltrar" value="Filtrar"></td>
								</tr>
							</table>
						</form>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	 
	<tr> 
		<td valign="top" width="50%"> 
			<cfinvoke component="sif.Componentes.pListas" 
			method="pListaRH"	 
			returnvariable="pListaTran">
				<cfinvokeargument name="tabla" value="SNegociosCorporativo"/>
				<cfinvokeargument name="columnas" value="SNCidentificacion,SNCnombre,SNCtipo,SNCcodigo"/>
				<cfinvokeargument name="desplegar" value="SNCidentificacion,SNCnombre,SNCtipo"/>
				<cfinvokeargument name="etiquetas" value="Cédula, Socio Corporativo, Tipo cédula "/>
				<cfinvokeargument name="formatos" value="S,S,S"/>
				<cfinvokeargument name="filtro" value="#filtro#"/>
				<!--- <cfinvokeargument name="filtro" value="CEcodigo=#session.CEcodigo# order by SNCidentificacion"/> --->
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="keys" value="SNCcodigo"/>
				<cfinvokeargument name="irA" value="SNcorporativo.cfm"/>
			</cfinvoke> 
		</td>
		<td width="50%" valign="top"><cfinclude template="SNcorporativo-form.cfm"></td>
	</tr>  
	<tr> 
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	</table>
	<cf_web_portlet_end>	
	<cf_templatefooter>
