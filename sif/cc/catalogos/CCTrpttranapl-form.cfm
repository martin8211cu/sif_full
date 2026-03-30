
<cfif isdefined("url.CCTcolrpttranapl") and len(trim(url.CCTcolrpttranapl))>
	<cfset form.CCTcolrpttranapl = url.CCTcolrpttranapl>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="10">

<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<cfinvoke 
				component="sif.Componentes.pListas" 
				method="pLista"
				returnvariable="rsLista"
				columnas="Ecodigo,CCTcolrpttranapl,CCTcolrpttranapldesc"
				etiquetas="Columna,Descripci&oacute;n"
				tabla="CCTrpttranapl"
				filtro="Ecodigo=#Session.Ecodigo#"
				desplegar="CCTcolrpttranapl,CCTcolrpttranapldesc"
				filtrar_por="CCTcolrpttranapl,CCTcolrpttranapldesc"
				align="left,left"
				formatos="S,S"
				ira="CCTrpttranapl.cfm"
				maxrows="#form.MaxRows#"
				keys='CCTcolrpttranapl'
			/>
		</td>
		<td valign="top">
			<cffunction 
				name="getNextVal" 
				access="private" 
				description="Obtiene la Siguiente Columna para la Empresa" 
				returntype="numeric">
				<cfquery name="rsNextVal" datasource="#session.dsn#">
					select coalesce(max(CCTcolrpttranapl),0)+1 as NextVal
					from CCTrpttranapl
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
				<cfreturn rsNextVal.NextVal>
			</cffunction>				
			<cfset modo = "ALTA">
			<cfif isdefined("form.CCTcolrpttranapl") and len(trim(form.CCTcolrpttranapl))>
				<cfquery name="rsForm" datasource="#session.dsn#">
					select *
					from CCTrpttranapl
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and CCTcolrpttranapl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCTcolrpttranapl#">
				</cfquery>
				<cfif rsForm.recordcount eq 1>
					<cfset modo = "CAMBIO">
				</cfif>
			</cfif>
			<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="tituloListas" align="center"> DATOS DE LA ETIQUETA DE LA COLUMNA 
						<cfif modo neq "CAMBIO">
							#getNextVal()#.
						<cfelse>
							#rsForm.CCTcolrpttranapl#.
						</cfif>
					</td>
				</tr>
			</table>
			<form name="form1" action="CCTrpttranapl-sql.cfm" method="post">
				<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
				<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
				<table width="100%" border="0" cellspacing="2" cellpadding="0">
					<tr>
						<td class="fileLabel" nowrap="nowrap" align="right">Columna:&nbsp;</td>
						<td>
							<cfif modo neq "CAMBIO">
								<cfset Lvar_col = getNextVal()>
							<cfelse>
								<cfset Lvar_col = rsForm.CCTcolrpttranapl>
							</cfif>
							<input type="text" tabindex="-1" name="CCTcolrpttranapl" readonly="true" value="#Lvar_col#" size="15" class="cajasinborde"/>
						</td>
					</tr>
					<tr>
						<td class="fileLabel" nowrap="nowrap" align="right">Descripci&oacute;n:&nbsp;</td>
						<td>
							<cfif modo neq "CAMBIO">
								<cfset Lvar_desc = "">
							<cfelse>
								<cfset Lvar_desc = rsForm.CCTcolrpttranapldesc>
							</cfif>
							<input type="text" name="CCTcolrpttranapldesc" maxlength="35" size="30" tabindex="1" value="#HTMLEditFormat(Lvar_desc)#" />
						</td>
					</tr>
				</table>
				<cf_botones modo="#modo#" tabindex="1">
			</form>
			<cf_qforms>
				<cf_qformsRequiredField name="CCTcolrpttranapl" description="Columna">
				<cf_qformsRequiredField name="CCTcolrpttranapldesc" description="Descripción">
			</cf_qforms>
			</cfoutput>
		</td>
	</tr>
</table>

