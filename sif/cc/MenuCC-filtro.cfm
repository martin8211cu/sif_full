<!--- maneja variables que vienen por url --->
<cfif isdefined("Url.Ocodigo")><cfset Form.Ocodigo = Url.Ocodigo></cfif>
<cfif isdefined("Url.Mcodigo")><cfset Form.Mcodigo = Url.Mcodigo></cfif>
<cfif isdefined("Url.Socio")><cfset Form.Socio = Url.Socio></cfif>
<cfif isdefined("Url.Documento")><cfset Form.Documento = Url.Documento></cfif>
<!--- define valore por defecto a las variables --->
<cfparam name="Form.Ocodigo" default="-1">
<cfparam name="Form.Mcodigo" default="-1">
<cfparam name="Form.Socio" default="">
<cfparam name="Form.Documento" default="">
<!--- limpia filtros que no se utilizan en el análisis que se está viendo --->
<cfif Form.Analisis eq 1>
	<cfif Form.Nivel eq 1>
		<cfset Form.Mcodigo = "-1">
		<cfset Form.Documento = "">		
	<cfelseif Form.Nivel eq 2>
		<cfset Form.Mcodigo = "-1">
	</cfif>
<cfelse>
	<cfif Form.Nivel eq 1>
		<cfset Form.Socio = "">
		<cfset Form.Documento = "">
	<cfelseif Form.Nivel eq 2>
		<cfset Form.Documento = "">
	</cfif>
</cfif>
<cfset nav_filtro = "&Ocodigo=#Form.Ocodigo#&Mcodigo=#Form.Mcodigo#&Socio=#Form.Socio#&Documento=#Form.Documento#">
<!--- consultas del filtro --->
<cfquery name="rsOficinas" datasource="#session.dsn#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by 2
</cfquery>
<!--- consultas del filtro --->
<cfquery name="rsMonedas" datasource="#session.dsn#">
	select Mcodigo, Mnombre, Miso4217
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by 1,2
</cfquery>
<!--- pinta el filtro --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Oficina 	= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset MSG_Oficina 	= t.Translate('MSG_Oficina','El Filtro de oficina es el único que afecta la lista y además los gráficos. Los demás solo afectan la lista.')>
<cfset LB_Todas 	= t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>


<cfoutput>
	<cfsavecontent variable="_Filtro">
		<table width="1%" align="center"  border="0" cellspacing="0" cellpadding="0" style="margin:0;">
		<form name="formfiltro" action="MenuCC.cfm" method="post" style="margin:0;">
			<input type="hidden" name="Analisis" value="#Form.Analisis#">
			<input type="hidden" name="Nivel" value="#Form.Nivel#">
			<input type="hidden" name="Order_By" value="#Form.Order_By#">
			<tr>
				<td class="cfmenu_titulo">#Oficina#&nbsp;:&nbsp;</td>
				<td class="cfmenu_titulo">
					<cfsavecontent variable="l1tooltiptext">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
                                	#MSG_Oficina#
								</td>
							</tr>
						</table>
					</cfsavecontent>
					<cf_tooltiptext text="#l1tooltiptext#">
						<select name="Ocodigo" onchange="javascript:this.form.submit();">
							<option value="-1"> -- #LB_Todas# --</option>
							<cfloop query="rsOficinas">
								<option value="#Ocodigo#" <cfif Ocodigo eq Form.Ocodigo>selected</cfif>>#Odescripcion#</option>
							</cfloop>
						</select>
					</cf_tooltiptext>
				</td>
				<cfsavecontent variable="Filtro_Moneda">
					<td class="cfmenu_titulo">#LB_Moneda#&nbsp;:&nbsp;</td>
					<td class="cfmenu_titulo">
						<select name="Mcodigo" onchange="javascript:this.form.submit();">
							<option value="-1"> -- #LB_Todas# --</option>
							<cfloop query="rsMonedas">
								<option value="#Mcodigo#" <cfif Mcodigo eq Form.Mcodigo>selected</cfif>>#Mnombre#</option>
							</cfloop>
						</select>
					</td>
				</cfsavecontent>
				<cfsavecontent variable="Filtro_Socio">
					<td class="cfmenu_titulo">#LB_Socio#&nbsp;:&nbsp;</td>
					<td class="cfmenu_titulo">
						<table width="1%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td><input type="text" name="Socio" value="#Form.Socio#"></td>
							<td><input type="submit" name="GoSocio" value="Go"></td>
						  </tr>
						</table>
					</td>
				</cfsavecontent>
				<cfsavecontent variable="Filtro_Documento">
					<td class="cfmenu_titulo">#LB_Documento#&nbsp;:&nbsp;</td>
					<td class="cfmenu_titulo">
						<table width="1%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td><input type="text" name="Documento" value="#Form.Documento#"></td>
							<td><input type="submit" name="GoDocumento" value="Go"></td>
						  </tr>
						</table>
					</td>
				</cfsavecontent>				
				<cfif Form.Analisis eq 1>
					<cfif Form.Nivel eq 1>
						#Filtro_Socio#
					<cfelseif Form.Nivel eq 2>
						#Filtro_Socio#
						#Filtro_Moneda#
					<cfelse>
						#Filtro_Socio#
						#Filtro_Moneda#
						#Filtro_Documento#
					</cfif>
				<cfelse>
					<cfif Form.Nivel eq 1>
						#Filtro_Moneda#
					<cfelseif Form.Nivel eq 2>
						#Filtro_Moneda#
						#Filtro_Socio#
					<cfelse>
						#Filtro_Moneda#
						#Filtro_Socio#
						#Filtro_Documento#
					</cfif>
				</cfif>
			</tr>
		</form>
		</table>
	</cfsavecontent>
</cfoutput>