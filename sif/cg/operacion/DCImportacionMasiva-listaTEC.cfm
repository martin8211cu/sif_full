<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

<cfif isdefined("Url.fechadesde") and not isdefined("Form.fechadesde")>
	<cfparam name="Form.fechadesde" default="#Url.fechadesde#">
</cfif>
<cfif isdefined("Url.fechahasta") and not isdefined("Form.fechahasta")>
	<cfparam name="Form.fechahasta" default="#Url.fechahasta#">
</cfif>
<cfif isdefined("Url.periodo") and not isdefined("Form.periodo")>
	<cfparam name="Form.periodo" default="#Url.periodo#">
</cfif>
<cfif isdefined("Url.mes") and not isdefined("Form.mes")>
	<cfparam name="Form.mes" default="#Url.mes#">
</cfif>
<cfif isdefined("Url.descripcion") and not isdefined("Form.descripcion")>
	<cfparam name="Form.descripcion" default="#Url.descripcion#">
</cfif>

<cfif not isdefined("Form.fechadesde")>
	<cfset Form.fechadesde = LSDateFormat(Now(), 'dd/mm/yyyy')>
</cfif>
<cfif not isdefined("Form.fechahasta")>
	<cfset Form.fechahasta = LSDateFormat(Now(), 'dd/mm/yyyy')>
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.fechadesde")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fechadesde=" & Form.fechadesde>
</cfif>
<cfif isdefined("Form.fechahasta")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fechahasta=" & Form.fechahasta>
</cfif>
<cfif isdefined("Form.periodo") and Len(Trim(Form.periodo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "periodo=" & Form.periodo>
</cfif>
<cfif isdefined("Form.mes") and Len(Trim(Form.mes)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "mes=" & Form.mes>
</cfif>
<cfif isdefined("Form.descripcion") and Len(Trim(Form.descripcion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "descripcion=" & Form.descripcion>
</cfif>



	<cf_templateheader title="Importaci&oacute;n de Documentos Contables">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n Masiva de Documentos Contables">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			
				<script language="javascript" type="text/javascript">
					function funcRegresar() {
					 location.href = 'DocContablesImportacion-lista.cfm'
					 return false;
					}

					function funcAplicar() {
						document.form1.action = 'DCImportacionMasiva-sql.cfm';
						document.form1.submit();
						return false;
					}
					function Marcar(c) {
						if (c.checked) {
							for (counter = 0; counter < document.form1.chk.length; counter++)
							{
								if ((!document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
									{  document.form1.chk[counter].checked = true;}
							}
							if ((counter==0)  && (!document.form1.chk.disabled)) {
								document.form1.chk.checked = true;
							}
						}
						else {
							for (var counter = 0; counter < document.form1.chk.length; counter++)
							{
								if ((document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
									{  document.form1.chk[counter].checked = false;}
							};
							if ((counter==0) && (!document.form1.chk.disabled)) {
								document.form1.chk.checked = false;
							}
						};
					}
				</script>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>
						<!---
						<cfquery name="rsLista" datasource="#Session.DSN#">
							select a.ECIid, a.Cconcepto, a.Eperiodo, a.Emes, a.Efecha, a.Edescripcion, a.Edocbase, a.Ereferencia, a.BMfalta, a.BMUsucodigo,
									(select	case when sum(case when c.Dmovimiento = 'D' then c.Dlocal else 0 end) != sum(case when c.Dmovimiento = 'C' then c.Dlocal else 0 end) then '<font color=''##FF0000''>Desbalanceada!</font>' else '' end
									 from DContablesImportacion c
									 where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									 and c.ECIid = a.ECIid) as balanceada,
									(select	case when sum(case when c.Dmovimiento = 'D' then c.Dlocal else 0 end) != sum(case when c.Dmovimiento = 'C' then c.Dlocal else 0 end) then c.ECIid else -1 end
									 from DContablesImportacion c
									 where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									 and c.ECIid = a.ECIid) as inactivada
							from EContablesImportacion a

								left outer join ConceptoContableE b
									on a.Ecodigo = b.Ecodigo
									and a.Cconcepto = b.Cconcepto
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						</cfquery>
						--->
						<cfquery name="rsLista" datasource="#Session.DSN#">
							select a.ECIid, a.Cconcepto, a.Eperiodo, a.Emes, a.Efecha, a.Edescripcion, a.Edocbase, a.Ereferencia, a.BMfalta, a.BMUsucodigo, '' as balanceada, 0 as inactivada
							from EContablesImportacion a

								left outer join ConceptoContableE b
									on a.Ecodigo = b.Ecodigo
									and a.Cconcepto = b.Cconcepto

							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							<cfif isdefined("form.fechadesde") and len(trim(form.fechadesde)) and isdefined("form.fechahasta") and len(trim(form.fechahasta))>
  								and a.Efecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechadesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechahasta)#">
							<cfelseif isdefined("form.fechadesde") and len(trim(form.fechadesde))>
  								and a.Efecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechadesde)#">
							<cfelseif isdefined("form.fechahasta") and len(trim(form.fechahasta))>
  								and a.Efecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechahasta)#">
							</cfif>
							<cfif isdefined("form.periodo") and len(trim(form.periodo))>
  								and a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.periodo#">
							</cfif>	
							<cfif isdefined("form.mes") and len(trim(form.mes)) and form.mes NEQ -1>
  								and a.Emes = <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.mes#">
							</cfif>	
							<cfif isdefined("form.descripcion") and len(trim(form.descripcion))>
  								and upper(a.Edescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(form.descripcion)#%">
							</cfif>	
						</cfquery>
						
						<cfoutput>
						<form method="post" name="filtros" action="#GetFileFromPath(GetTemplatePath())#" class="AreaFiltro" style="margin:0;">
						<table width="100%"  border="0" cellspacing="2" cellpadding="0">
							<tr>
								<td align="right" width="1%" nowrap><strong>Descripci&oacute;n</strong> </td>
								<td align="left" nowrap>
									<input type="text" name="descripcion" size="50" maxlength="100" value="<cfif isdefined("form.descripcion")>#form.descripcion#</cfif>">
								</td>
								<td align="right" nowrap><strong>Fecha Desde:</strong></td>
								<td align="left" nowrap>
									<cf_sifcalendario form="filtros" value="#LSDateFormat(form.fechadesde,'dd/mm/yyyy')#" name="fechadesde">
								</td>
								<td align="right" nowrap><strong>Fecha Hasta:</strong></td>
								<td align="left" nowrap>
									<cf_sifcalendario form="filtros" value="#LSDateFormat(form.fechahasta,'dd/mm/yyyy')#" name="fechahasta">
								</td>
								<td align="right" nowrap><strong>Periodo</strong> </td>
									<td>
										<input tabindex="1" type="text" name="periodo" style="text-align:right"size="10" maxlength="4" 
										onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
										onFocus="javascript:this.select();" 
										value="<cfif isdefined("form.periodo")>#form.periodo#</cfif>">
									</td>

								<td align="right" nowrap><strong>Mes</strong> </td>
								<td align="left" nowrap>
									<select name="mes">
										<option value="-1">Todos</option>				  
										<cfloop query="rsMeses">
											<option value="#VSvalor#"<cfif isdefined("form.mes") and form.mes eq VSvalor> selected</cfif>>#VSdesc#</option>
										</cfloop>	
									</select>
								</td>
							</tr>
							 <tr>
								<td align="center" nowrap>
								  <input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);">
								  <strong>Seleccionar Todos</strong>
								 </td>
								<td colspan="7" align="center"><input type="submit" name="bFiltrar" value="Filtrar">
							  <input type="submit" name="bLimpiar" value="Limpiar"></td>
							</tr>
						</table>
						</form>
					</cfoutput>
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="Edescripcion, Efecha, Eperiodo, Emes, balanceada"/>
						<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Fecha, Periodo, Mes, &nbsp;"/>
						<cfinvokeargument name="formatos" value="V,D,V,V,V"/>
						<cfinvokeargument name="align" value="left, center, center, center, center"/>
						<cfinvokeargument name="ajustar" value="S"/>
						<cfinvokeargument name="showlink" value="false"/>
						<cfinvokeargument name="checkboxes" value="S"/>
						<cfinvokeargument name="keys" value="ECIid"/>
						<cfinvokeargument name="maxrows" value="0"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="formname" value="form1"/>
						<cfinvokeargument name="botones" value="Aplicar,Regresar"/>
						<cfinvokeargument name="inactivecol" value="inactivada"/>
					</cfinvoke>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
