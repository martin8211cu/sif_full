<cfif isdefined("url.CCTDid") and len(trim(url.CCTDid))>
	<cfset form.CCTDid = url.CCTDid>
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
<cfparam name="form.MaxRows" default="20">


<cfset filtro = ''>

<cfif isdefined("form.FILTRO_CCTDESCRIPCION") and len(trim(FILTRO_CCTDESCRIPCION))>
	<cfset filtro = filtro & ' and CCTdescripcion like '&"'%#form.FILTRO_CCTDESCRIPCION#%'">
</cfif>
<cfif isdefined("form.FILTRO_CCTDLEYENDA1") and len(trim(FILTRO_CCTDLEYENDA1))>
	<cfset filtro = filtro & ' and CCTDleyenda1 like '&"'%#form.FILTRO_CCTDLEYENDA1#%'">
</cfif>


<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
        <cfinclude template="../../Utiles/sifConcat.cfm">
			<cfquery name="rs" datasource="#session.DSN#">
				select 
					a.CCTDid, 
					a.CCTcodigo, 
					case when <cf_dbfunction name="length"	args="a.CCTDleyenda1"> > 30 then 
						<cf_dbfunction name="sPart" args="a.CCTDleyenda1,1,30"> #_Cat# '...'  
					else 
						a.CCTDleyenda1 
					end as CCTDleyenda1,
					b.CCTdescripcion
				from CCTransaccionesD a 
					inner join CCTransacciones b
					  on b.Ecodigo = a.Ecodigo
					 and b.CCTcodigo = a.CCTcodigo
				where a.Ecodigo=#Session.Ecodigo#
				#preservesinglequotes(filtro)#
			</cfquery>
		
			<cfinvoke 
				component			="sif.Componentes.pListas" 
				method				="pListaQuery"
				returnvariable		="pListaTran"
				query				="#rs#"
				desplegar			="CCTdescripcion, CCTDleyenda1"
				etiquetas			="Transacci&oacute;n, Leyenda"
				align				="left,left"
				formatos			="S,S"
				mostrar_filtro		="true"
				filtrar_por			="CCTdescripcion,CCTDleyenda1"
				ira					="CCTD.cfm"
				maxrows				="#form.MaxRows#"
				showEmptyListMsg	="true"
				keys				="CCTDid"
			/>
		</td>
		<td valign="top">
			<cfset modo = "ALTA">
			<cfif isdefined("form.CCTDid") and len(trim(form.CCTDid))>
				<cfquery name="rsForm" datasource="#session.dsn#">
					select 
						a.CCTDid,
						a.CCTcodigo,
						a.CCTDleyenda1,
						a.CCTD_CDCcodigo,
						b.CCTdescripcion
					from CCTransaccionesD a
						inner join CCTransacciones b
						  on b.Ecodigo = a.Ecodigo
						 and b.CCTcodigo = a.CCTcodigo
					where CCTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCTDid#">
				</cfquery>
				<cfif rsForm.recordcount eq 1>
					<cfset modo = "CAMBIO">
				</cfif>
			</cfif>
			
			<cfoutput>
				<form name="form1" action="CCTD_sql.cfm" method="post">
					<input name="CCTDid" type="hidden" tabindex="-1" value="<cfif modo eq "CAMBIO" and rsForm.CCTDid gt 0>#rsForm.CCTDid#</cfif>">	
					<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
					<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
					<table width="100%" border="0" cellspacing="2" cellpadding="0">
						<tr>
							<td nowrap="nowrap" align="right"><strong>Transacci&oacute;n:</strong>&nbsp;</td>
							<td>
								<cfif modo neq "CAMBIO">
									<cfquery name="rsTransacciones" datasource="#session.DSN#">
										select 
											a.CCTcodigo, 
											a.CCTdescripcion
										from CCTransacciones a
										where a.Ecodigo = #session.Ecodigo#
										  and a.CCTpago = 0
										  and a.CCTtranneteo = 0
										  and  (select count(1)
												from CCTransaccionesD b
												where b.Ecodigo = a.Ecodigo
												and b.CCTcodigo = a.CCTcodigo
												) = 0
									</cfquery>
									 <select name="CCTcodigo">
										<cfloop query="rsTransacciones">
											<option value="#rsTransacciones.CCTcodigo#" >#rsTransacciones.CCTdescripcion#</option>
										</cfloop>
									 </select>
								<cfelse>
									#rsForm.CCTdescripcion#
									<input name="CCTcodigo" type="hidden" value="#rsForm.CCTcodigo#">
								</cfif>
							</td>
						</tr>
						<tr>
							<td class="fileLabel" nowrap="nowrap" align="right"><strong>Leyenda:</strong>&nbsp;</td>
							<td>
								<cfif modo neq "CAMBIO">
									<cfset LvarLeyenda = "">
								<cfelse>
									<cfset LvarLeyenda = rsForm.CCTDleyenda1>
								</cfif>
								<!--- <input type="text" name="CCTDleyenda1" maxlength="35" size="30" tabindex="1" value="" /> --->
								<textarea name="CCTDleyenda1" tabindex="1" style="width:450; height:50">#HTMLEditFormat(LvarLeyenda)#</textarea>
							</td>
						</tr>
						<tr>
							<td align="right">
								<input type="checkbox" name="CCTD_CDCcodigo" id="CCTD_CDCcodigo" <cfif modo eq "CAMBIO" and rsForm.CCTD_CDCcodigo>checked="checked"</cfif>>
							</td>
							<td align="left">
								<label for="CCTD_CDCcodigo">Imprimir Cliente Detallista</label>
							</td>
						</tr>
					</table>
					<cf_botones modo="#modo#" tabindex="1">
				</form>
				<cf_qforms>
					<cf_qformsRequiredField name="CCTDleyenda1" description="Leyenda">
				</cf_qforms>
			</cfoutput>
		</td>
	</tr>
</table>

