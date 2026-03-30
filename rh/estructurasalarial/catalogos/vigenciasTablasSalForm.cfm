<cfquery name="rsAdminSal" datasource="#Session.DSN#">
	select 1
	from UsuarioRol
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="RH">
	and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="ADMINSAL">
</cfquery>

<cfset esAdminSal = (rsAdminSal.recordCount GT 0)>
<!--- Esta variable se seteo asi para que nadie pueda modificar en esta pantalla --->
<cfset Modificable = false>

<cf_dbfunction name="to_sdatedmy" args="RHVTfechahasta" returnvariable="lvar_fechaHasta">
<cf_dbfunction name="to_sdatedmy" args="#createdate(6100,01,01)#" returnvariable="lvar_fechaIndefinida">
<cf_dbfunction name="to_char" args="x.RHVTcodigo" returnvariable="lvar_RHVTcodigo">

<cf_web_portlet_start titulo="Tablas Salariales">
<cfif isdefined("url.RHTTid") and not isdefined("form.RHTTid")><cfset form.RHTTid = url.RHTTid></cfif>
<cfif isdefined("url.RHVTid") and not isdefined("form.RHVTid")><cfset form.RHVTid = url.RHVTid></cfif>
<cfif isdefined("url.RHMCid") and not isdefined("form.RHMCid")><cfset form.RHMCid = url.RHMCid></cfif>
<cfif isdefined("url.PAGENUMPADRE") and not isdefined("form.PAGENUMPADRE")><cfset form.PAGENUMPADRE = url.PAGENUMPADRE></cfif>
<!---M2---><cfif isdefined("form.PageNum_data") and not isdefined("url.PageNum_data")><cfset url.PageNum_data = form.PageNum_data></cfif>
<cfif isdefined("url.PAGENUM") and not isdefined("form.PAGENUM")><cfset form.PAGENUM = url.PAGENUM></cfif>
<cfif isdefined("form.vigencias") and isdefined("form.PAGENUM") and not isdefined("form.PAGENUMPADRE")><cfset form.PAGENUMPADRE = form.PAGENUM><cfset form.PAGENUM = 1></cfif>
<cfparam name="form.PAGENUM" type="numeric" default="1">
<cfparam name="form.PAGENUMPADRE" type="numeric" default="1">
<cfset modo = "ALTA"><cfif isdefined("form.RHVTid")><cfset modo = "CAMBIO"></cfif>
<cfquery name="rsPadre" datasource="#Session.DSN#">
	select codigo = RHTTcodigo, descripcion = RHTTdescripcion
	from RHTTablaSalarial
	where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
</cfquery>
<!---M2---><cfset modomonto = "ALTA"><cfif isdefined("form.RHMCid")><cfset modomonto = "CAMBIO"></cfif>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top" width="50%">
		<cfset filtro = ''>
		<cfset navegacion = "RHTTid=" & Form.RHTTid>
		<!---  FILTRO 
		<cfif isdefined("url.PAGENUM") and not isdefined("form.Pagina")><cfset form.Pagina = url.PAGENUM></cfif>
		<cfif isdefined("form.PAGENUM") and not isdefined("form.Pagina")><cfset form.Pagina = form.PAGENUM></cfif>
		<cfif isdefined("url.fRHTTcodigo") and not isdefined("form.fRHTTcodigo")><cfset form.fRHTTcodigo = url.fRHTTcodigo></cfif>
		<cfif isdefined("url.fRHTTdescripcion") and not isdefined("form.fRHTTdescripcion")><cfset form.fRHTTdescripcion = url.fRHTTdescripcion></cfif>
		<cfif isdefined("Form.fRHTTcodigo")>
			<cfset filtro = filtro & " and RHTTcodigo like '%" & Form.fRHTTcodigo & "%'">
			<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE('&'),DE('')) & "fRHTTcodigo=" & Form.fRHTTcodigo>
		</cfif>
		<cfif isdefined("Form.fRHTTdescripcion")>
			<cfset filtro = filtro & " and RHTTdescripcion like '%" & Form.fRHTTdescripcion & "%'">
			<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE('&'),DE('')) & "fRHTTdescripcion=" & Form.fRHTTdescripcion>
		</cfif>
		<form action="vigenciasTablasSal.cfm" method="post" name="formfiltro" style="margin:0">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
			  <tr>
				<td><strong>C&oacute;digo</strong></td>
				<td><strong>Descripci&oacute;n</strong></td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td><input name="fRHTTcodigo" type="text" id="fRHTTcodigo" size="5" maxlength="5" <cfif isdefined('Form.fRHTTcodigo')>value="<cfoutput>#Form.fRHTTcodigo#</cfoutput>"</cfif>></td>
				<td><input name="fRHTTdescripcion" type="text" id="fRHTTdescripcion" <cfif isdefined('Form.fRHTTdescripcion')>value="<cfoutput>#Form.fRHTTdescripcion#</cfoutput>"</cfif> size="40" maxlength="80"></td>
				<td><input type="submit" value="Filtrar" name="Filtrar"></td>
			  </tr>
			</table>
		</form> --->
		<!--- LISTA --->
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRHRet">
			<cfinvokeargument name="tabla" value="RHVigenciasTabla"/>
			<cfinvokeargument name="columnas" value="RHTTid, RHVTid, RHVTcodigo, RHVTfecharige,case #preservesinglequotes(lvar_fechaHasta)# when #preservesinglequotes(lvar_fechaIndefinida)# then 'Indefinido' else #preservesinglequotes(lvar_fechaHasta)# end as RHVTfechahasta,RHVTporcentaje,case RHVTestado when 'A' then 'Aplicado' when 'P' then 'Pendiente' else RHVTestado end as RHVTestado, PAGENUMPADRE = #form.PAGENUMPADRE#"/>
			<cfinvokeargument name="desplegar" value="RHVTfecharige,RHVTfechahasta,RHVTporcentaje,RHVTestado"/>
			<cfinvokeargument name="etiquetas" value="Fecha Desde,Fecha Hasta,Porcentaje Inc,Estado"/>
			<cfinvokeargument name="formatos" value="D,S,N,S"/>
			<cfinvokeargument name="filtro" value="RHTTid = #Form.RHTTid# #filtro# order by RHVTfecharige,RHVTfechahasta,RHVTestado"/>
			<cfinvokeargument name="align" value="center,center,center,center"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="irA" value="vigenciasTablasSal.cfm"/>
			<cfinvokeargument name="maxRows" value="20"/>
			<cfinvokeargument name="keys" value="RHVTid"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="PageIndex" value="2"/>
		</cfinvoke>
	</td>
	<td valign="top">&nbsp;&nbsp;&nbsp;</td>
    <td valign="top">
		<!--- mantenimiento #1 --->
		<cfif (MODO neq "ALTA")>
			<cfquery name="rsRHVigenciasTabla" datasource="#session.dsn#">
				select RHVTid, RHTTid, RHVTfecharige, RHVTestado, 
					   case RHVTestado when 'A' then 'Aplicado' when 'P' then 'Pendiente' else RHVTestado end as RHVTestadodesc, 
					   case #preservesinglequotes(lvar_fechaHasta)# when #preservesinglequotes(lvar_fechaIndefinida)# then 'Indefinido' else #preservesinglequotes(lvar_fechaHasta)# end as RHVTfechahasta, 
					   case when RHVTtablabase is null then 'No Definida' else (select #preservesinglequotes(lvar_RHVTcodigo)# from RHVigenciasTabla x where x.RHVTid = RHVigenciasTabla.RHVTtablabase) end as RHVTtablabase, 
					   RHVTporcentaje, RHVTdocumento, RHVTdescripcion, ts_rversion
				from RHVigenciasTabla
				where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
				and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
			</cfquery>
			
			<!---================== ULTIMA VIGENCIA PARA LA TABLA SALARIAL =======================------>
			<cfquery name="rsUltimaVigencia" datasource="#session.DSN#">
				select max(RHVTfecharige) as UltimaVigencia
				from RHVigenciasTabla b					
				where b.RHTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
					and b.RHVTestado = 'A'
			</cfquery>
						
			<cfif isdefined("rsUltimaVigencia") and rsUltimaVigencia.RecordCount NEQ 0 and len(trim(rsUltimaVigencia.UltimaVigencia))>
				<cfset UltimaVigencia = LSParseDateTime(rsUltimaVigencia.UltimaVigencia)>
			</cfif>			
			<!----===============================================================================----->
			
			<cfset ts = "">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsRHVigenciasTabla.ts_rversion#"/>
			</cfinvoke>
			<cfquery name="rsUAplicadoa" datasource="#Session.DSN#">
				select RHVTfecharige
				from RHVigenciasTabla
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and rtrim(RHVTestado) = 'A'
				and coalesce(RHVTfechahasta,<cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">) = <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">
				and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
			</cfquery>
			<cfquery name="rsUAplicadob" datasource="#Session.DSN#">
				select RHVTfecharige
				from RHVigenciasTabla
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and rtrim(RHVTestado) = 'A'
				and coalesce(RHVTfechahasta, <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">) = <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">
				and '#rsRHVigenciasTabla.RHVTfecharige#' >= dateadd(dd,1,RHVTfecharige)
			</cfquery>
		</cfif>
		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
		<form action="vigenciasTablasSalSQL.cfm" method="post" name="form1">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
					  	<td nowrap><strong>&nbsp;</strong></td>
						<td nowrap colspan="4" class="tituloListas" align="center"><cfoutput>#rsPadre.codigo#&nbsp;#rsPadre.descripcion#</cfoutput></td>
						<td nowrap><strong>&nbsp;</strong></td>
					  </tr>
					  <tr>
						<td nowrap><strong>&nbsp;</strong></td>
						<td nowrap><strong>Rige</strong></td>
						<td nowrap><strong>Hasta</strong></td>
						<td nowrap><strong>Tabla Base</strong></td>
						<td nowrap><strong>% Incremento</strong></td>
						<td nowrap><strong>&nbsp;</strong></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td>
							<cfoutput>
								<cfif (MODO neq "ALTA")>
									<cfif Modificable>
										<cf_sifcalendario name="RHVTfecharige" value="#LSDateFormat(rsRHVigenciasTabla.RHVTfecharige,'dd/mm/yyyy')#" tabindex="1">
									<cfelse>
										<input type="text" name="RHVTfecharige" value="#LSDateFormat(rsRHVigenciasTabla.RHVTfecharige,'dd/mm/yyyy')#" style="border:0;" readonly="">
									</cfif>
								<cfelse>
									<cf_sifcalendario name="RHVTfecharige" tabindex="1">
								</cfif>
							</cfoutput>
						</td>
						<td><cfif (MODO neq "ALTA")><cfoutput>#rsRHVigenciasTabla.RHVTfechahasta#</cfoutput><cfelse>Indefinido</cfif></td>
						<td><cfif (MODO neq "ALTA")><cfoutput>#rsRHVigenciasTabla.RHVTtablabase#</cfoutput><cfelse><cf_rhvigenciatabla tipo="#Form.RHTTid#" id="RHVTtablabase" tabindex="1"></cfif></td>
						<td>
							<input type="text" 
								name="RHVTporcentaje" id="RHVTporcentaje"
								size="15" 
								maxlength="18" 
								style="text-align: right; <cfif not Modificable and MODO neq "ALTA">border:0;</cfif>"
								<cfif not Modificable and MODO neq "ALTA">readonly=""</cfif>
								onFocus="this.value=qf(this); this.select();" 
								onBlur="javascript: fm(this,2);"  								
								onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"  
								tabindex="1"
								value="<cfif (MODO neq "ALTA")><cfoutput>#LSCurrencyFormat(rsRHVigenciasTabla.RHVTporcentaje,'none')#</cfoutput><cfelse>0.00</cfif>">%
						</td>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td nowrap><strong>&nbsp;</strong></td>
						<td nowrap colspan="2"><strong>Documento que autoriza</strong></td>
						<td nowrap colspan="2"><strong>Descripci&oacute;n</strong></td>
						<td nowrap><strong>&nbsp;</strong></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td colspan="2">
							<input type="text"
								name="RHVTdocumento" id="RHVTdocumento"
								onFocus="javascript:this.select();"
								maxlength="80"
								<cfif not Modificable and MODO neq "ALTA">style= "border=0;"</cfif>
								<cfif not Modificable and MODO neq "ALTA">readonly=""</cfif>
								size="40"
								tabindex="1"
								value="<cfif (MODO neq "ALTA")><cfoutput>#HTMLEditFormat(rsRHVigenciasTabla.RHVTdocumento)#</cfoutput></cfif>">
						</td>
						<td colspan="2">
							<input type="text"
								name="RHVTdescripcion" id="RHVTdescripcion"
								onFocus="javascript:this.select();"
								<cfif not Modificable and MODO neq "ALTA">style= "border=0;"</cfif>
								<cfif not Modificable and MODO neq "ALTA">readonly=""</cfif>
								maxlength="80"
								size="40"
								tabindex="1"
								value="<cfif (MODO neq "ALTA")><cfoutput>#HTMLEditFormat(rsRHVigenciasTabla.RHVTdescripcion)#</cfoutput></cfif>">
						</td>
						<td>&nbsp;</td>
					  </tr>
				  </table>
				</td>
			  </tr>
			  <tr height="10">
			  	<td style="color:#0000FF">
					<cfif (MODO neq "ALTA")>Estado <cfoutput>#rsRHVigenciasTabla.RHVTestadodesc#</cfoutput></cfif>
				</td>
			  </tr>
			  <tr>
				<td>
					<cfif not esAdminSal>
						<p class="style1">Este usuario no tiene el rol adecuado para dar mantenimiento a las vigencias</p>
					</cfif>
					<input name="RHTTid" type="hidden" value="<cfoutput>#Form.RHTTid#</cfoutput>">
					<input name="PAGENUMPADRE" type="hidden" value="<cfoutput>#Form.PAGENUMPADRE#</cfoutput>">
					<input name="PAGENUM" type="hidden" value="<cfoutput>#Form.PAGENUM#</cfoutput>">
					<cfif (MODO NEQ "ALTA") and CompareNoCase(Trim(rsRHVigenciasTabla.RHVTestado),"A") eq 0>
						<p class="style1">Este registro no puede ser modificado ni eliminado porque ya fue aplicado.</p>
						<cfif esAdminSal>
							<input type="hidden" name="RHVTid" value="<cfif isdefined("form.RHVTid") and len(trim(form.RHVTid))><cfoutput>#form.RHVTid#</cfoutput></cfif>">
							<cf_botones modo="#modo#" tabindex="1" include="Imprimir,Exportar,Regresar" exclude="Baja,Cambio">
						<cfelse>
							<cf_botones names="Regresar" values="Regresar">
						</cfif>
					<cfelseif (MODO NEQ "ALTA") and (isdefined("UltimaVigencia") and LSParseDateTime(rsRHVigenciasTabla.RHVTfecharige) LT UltimaVigencia)> <!---and (rsUAplicadoa.RecordCount neq rsUAplicadob.RecordCount)>--->
						<p class="style1">Este registro no puede ser aplicado porque la fecha rige debe ser mayor por al menos un día que la última fecha rige aplicada.</p>
						<cfif esAdminSal>
							<cf_botones modo="#modo#" tabindex="1" include="Regresar,Exportar">
						<cfelse>
							<cf_botones names="Regresar" values="Regresar">
						</cfif>
						<input type="hidden" name="RHVTid" value="<cfoutput>#rsRHVigenciasTabla.RHVTid#</cfoutput>">
						<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
					<cfelseif (MODO neq "ALTA")>
						<cfif esAdminSal>
							<cf_botones modo="#modo#" tabindex="1" include="Aplicar,Exportar,Imprimir,Regresar">
						<cfelse>
							<cf_botones names="Regresar" values="Regresar">
						</cfif>
						<input type="hidden" name="RHVTid" value="<cfoutput>#rsRHVigenciasTabla.RHVTid#</cfoutput>">
						<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
					<cfelse>
						<cfif esAdminSal>
							<cf_botones modo="#modo#" tabindex="1" include="Importar,Regresar">
						<cfelse>
							<cf_botones names="Regresar" values="Regresar">
						</cfif>
					</cfif>
					
				</td>
			  </tr>
			</table>
		</form>

<!--- M2 mantenimiento #2 --->
			<cfif (MODO neq "ALTA")>
<!--- M2 consultas exclusivas del mantenimiento 2--->
				<cfquery name="rsComponentes" datasource="#Session.DSN#">
					select <cf_dbfunction name="to_char" args="a.CSid"> as CSid, a.CSdescripcion, a.CSusatabla
					from ComponentesSalariales a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					order by a.CScodigo, a.CSdescripcion, a.CSid
				</cfquery>
				<cfif (MODOMONTO neq "ALTA")>
<!--- M2 consulta para llenar el form2 en modo cambio --->
					<cfquery name="rsRHMontosCategoria" datasource="#Session.DSN#">
						select a.RHMCid, a.RHVTid, a.CSid, a.RHCPlinea, a.RHMCmonto, a.RHVTfrige, a.RHVTfhasta, a.BMfalta, a.BMfmod, a.BMUsucodigo, a.RHMCmontomax, a.RHMCmontomin, a.ts_rversion,
							   s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
							   t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
							   u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion
						from RHMontosCategoria a
							 left outer join RHCategoriasPuesto r
								on r.RHCPlinea = a.RHCPlinea
							 left outer join RHTTablaSalarial s
								on s.RHTTid = r.RHTTid
							 left outer join RHCategoria t
								on t.RHCid = r.RHCid
							 left outer join RHMaestroPuestoP u
								on u.RHMPPid = r.RHMPPid
						where a.RHMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMCid#">
					</cfquery>
					<cfset tsmonto = "">
					<cfinvoke 
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="tsmonto">
						<cfinvokeargument name="arTimeStamp" value="#rsRHMontosCategoria.ts_rversion#"/>
					</cfinvoke>
				</cfif>
				<br>
<!--- M2 pintado del form 2 --->
				<!--- <fieldset><legend>Montos por Categor&iacute;a</legend> --->
				<cf_web_portlet_start titulo="Montos por Categor&iacute;a">

				<cfif Modificable and esAdminSal>
				<form action="vigenciasTablasSalSQL.cfm" method="post" name="form2" onSubmit="javascript:prepararForm();">
					<input name="RHTTid" type="hidden" value="<cfoutput>#Form.RHTTid#</cfoutput>">
					<input type="hidden" name="RHVTid" value="<cfoutput>#rsRHVigenciasTabla.RHVTid#</cfoutput>">
					<cfif isdefined("Form.PageNum2") and Len(Trim(Form.PageNum2))>
						<input name="PageNum_lista2" type="hidden" value="<cfoutput>#Form.PageNum2#</cfoutput>">
					<cfelseif isdefined("Form.PageNum_lista2") and Len(Trim(Form.PageNum_lista2))>
						<input name="PageNum_lista2" type="hidden" value="<cfoutput>#Form.PageNum_lista2#</cfoutput>">
					</cfif>
					<cfif isdefined("Form.PageNum_lista3") and Len(Trim(Form.PageNum_lista3))>
						<input name="PageNum_lista3" type="hidden" value="<cfoutput>#Form.PageNum_lista3#</cfoutput>">
					<cfelseif isdefined("Form.PageNum3") and Len(Trim(Form.PageNum3))>
						<input name="PageNum_lista3" type="hidden" value="<cfoutput>#Form.PageNum3#</cfoutput>">
					</cfif>
					<input name="PAGENUMPADRE" type="hidden" value="<cfoutput>#Form.PAGENUMPADRE#</cfoutput>">
					<input name="PAGENUM" type="hidden" value="<cfoutput>#Form.PAGENUM#</cfoutput>">
					<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
						<table cellpadding="0" cellspacing="0" width="100%" border="0">
							<cfif (MODOMONTO neq "ALTA") and Len(Trim(rsRHMontosCategoria.RHCPlinea))>
							  <cf_rhcategoriapuesto form="form2" query="#rsRHMontosCategoria#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" showTablaSalarial="false" tabindex="1">
							<cfelse>
							  <cf_rhcategoriapuesto form="form2" tablaReadonly="true" incluyeTabla="false" showTablaSalarial="false" tabindex="1">
							</cfif>
						  <tr>
							<td><strong>Componente</strong></td>
						  	<td>
								<select name="CSid" tabindex="1" <cfif (MODOMONTO neq "ALTA")>disabled</cfif>>
									<cfoutput query="rsComponentes">
										<option value="#rsComponentes.CSid#" <cfif (MODOMONTO neq "ALTA") and rsRHMontosCategoria.CSid eq rsComponentes.CSid>selected</cfif>>#rsComponentes.CSdescripcion#</option>
									</cfoutput>
								</select>
							</td>
						  </tr>
						  <tr>
							<td><strong>Monto</strong></td>
						  	<td>
								<input type="text" 
									name="RHMCmonto" id="RHMCmonto"
									size="20" 
									maxlength="18" 
									style="text-align: right"  
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,2);"  
									onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
									tabindex="1"
									value="<cfif (MODOMONTO neq "ALTA")><cfoutput>#LSCurrencyFormat(rsRHMontosCategoria.RHMCmonto,'none')#</cfoutput><cfelse>0.00</cfif>">
							</td>
						  </tr>
						  <tr>
							<td><strong>Monto M&iacute;nimo</strong></td>
						  	<td>
								<input type="text" 
									name="RHMCmontomin" id="RHMCmontomin"
									size="20" 
									maxlength="18" 
									style="text-align: right"  
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,2);"  
									onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
									tabindex="1"
									value="<cfif (MODOMONTO neq "ALTA")><cfoutput>#LSCurrencyFormat(rsRHMontosCategoria.RHMCmontomin,'none')#</cfoutput><cfelse>0.00</cfif>">
							</td>
						  </tr>
						  <tr>
							<td><strong>Monto M&aacute;ximo</strong></td>
						  	<td>
								<input type="text" 
									name="RHMCmontomax" id="RHMCmontomax"
									size="20" 
									maxlength="18" 
									style="text-align: right"  
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,2);"  
									onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
									tabindex="1"
									value="<cfif (MODOMONTO neq "ALTA")><cfoutput>#LSCurrencyFormat(rsRHMontosCategoria.RHMCmontomax,'none')#</cfoutput><cfelse>0.00</cfif>">
							</td>
						  </tr>
						</table>
						
<!--- M2 OJO OJO OJO campos importantes del form 2 --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td align="center">
								<input type="hidden" name="RHMCid" value="<cfif (MODOMONTO neq "ALTA")><cfoutput>#rsRHMontosCategoria.RHMCid#</cfoutput></cfif>">
								<input type="hidden" name="timestampmonto" value="<cfif (MODOMONTO neq "ALTA")><cfoutput>#tsmonto#</cfoutput></cfif>">
								<cfif (isdefined("url.PageNum_data"))><input name="PageNum_data" type="hidden" value="<cfoutput>#url.PageNum_data#</cfoutput>"></cfif>
								<cfif (MODO NEQ "ALTA") and CompareNoCase(Trim(rsRHVigenciasTabla.RHVTestado),"A")>
									<cf_botones modo="#MODOMONTO#" sufijo="Monto" tabindex="2">
								</cfif>                                       
							</td>
						  </tr>
						</table>
<!--- M2 lista del mantenimiento 2 esta aparte porque el pintado es un poco engorroso --->
				</form>
				</cfif>
				
				<cfinclude template="frame-listamontos.cfm">
				<cf_web_portlet_end>
			</cfif>
		<cfif esAdminSal>
			<cf_qforms form="form1" objForm="objForm">
			<cfif Modificable and MODO NEQ 'ALTA'>
				<cf_qforms form="form2" objForm="objForm2">
			</cfif>
			<script language="javascript" type="text/javascript">
				<!--// 
				//asigna las validaciones
				objForm.RHVTfecharige.description = "Fecha Rige";
				objForm.RHVTfecharige.required = true;
				objForm.RHVTporcentaje.description = "Porcentaje de Incremento";
				<cfif Modificable and (MODO neq "ALTA")>
					objForm2.CSid.description = "Componente";
					objForm2.RHMCmonto.description = "Monto";
					objForm2.RHMCmonto.obj.focus();
					objForm2.CSid.required = true;
					objForm2.RHMCmonto.required = true;
					<cfif MODOMONTO EQ "ALTA">
					objForm2.RHMPPdescripcion.required = true;
					objForm2.RHMPPdescripcion.description = "Categoría/Puesto";
					</cfif>
					function ProcesarMonto(id){
						<cfif NOT ((MODO NEQ "ALTA") and CompareNoCase(Trim(rsRHVigenciasTabla.RHVTestado),"A") eq 0)>
							objForm2.RHMCid.obj.value = id;
							objForm2.obj.action = "vigenciasTablasSal.cfm";
							objForm2.obj.submit();
						</cfif>
					}
				<cfelse>
					objForm.RHVTfecharige.obj.focus();
				</cfif>
				
				function habilitarValidacion(){
					objForm.RHVTfecharige.required = true;
					<cfif Modificable and (MODO neq "ALTA")>
						<cfif MODOMONTO EQ "ALTA">
						objForm2.RHMPPdescripcion.required = false;
						</cfif>
						objForm2.CSid.required = false;
						objForm2.RHMCmonto.required = false;
					</cfif>
				}
				
				function deshabilitarValidacion(){
					objForm.RHVTfecharige.required = false;
					<cfif Modificable and (MODO neq "ALTA")>
						<cfif MODOMONTO EQ "ALTA">
						objForm2.RHMPPdescripcion.required = false;
						</cfif>
						objForm2.CSid.required = false;
						objForm2.RHMCmonto.required = false;
					</cfif>
				}
				
				<cfif Modificable and (MODO neq "ALTA")>
					function funcAltaMonto(){
						<cfif MODOMONTO EQ "ALTA">
						objForm2.RHMPPdescripcion.required = true;
						</cfif>
						objForm2.CSid.required = true;
						objForm2.RHMCmonto.required = true;
					}
					function funcCambioMonto(){
						objForm2.RHMCmonto.required = true;
					}
				</cfif>
				
				function funcAplicar(){
					<cfif Modificable and (MODO neq "ALTA")>
						<cfif MODOMONTO EQ "ALTA">
						objForm2.RHMPPdescripcion.required = false;
						</cfif>
						objForm2.CSid.required = false;
						objForm2.RHMCmonto.required = false;
					</cfif>
				}

				function funcImportar(){
					deshabilitarValidacion();
					objForm.obj.action = "vigenciasTablasImp.cfm";
					return true;
				}
				
				//Funcion para exportar las tablas 				
				function funcExportar(){
					deshabilitarValidacion();
					objForm.obj.action = "vigenciasTablasExp.cfm";
					return true;
				}
	
				//-->
			</script>
		</cfif>
		<script language="javascript" type="text/javascript">
			//funciones llamadas por objetos del form
			function funcRegresar(){
				<cfif esAdminSal>
				deshabilitarValidacion();
				objForm.obj.action = "tipoTablasSal.cfm";
				objForm.PAGENUM.obj.value = objForm.PAGENUMPADRE.getValue();
				<cfelse>
				document.form1.action = "tipoTablasSal.cfm";
				document.form1.PAGENUM.value = document.form1.PAGENUMPADRE.value;
				</cfif>
				return true;
			}

			function prepararForm(){
				<cfif Modificable and esAdminSal and (MODO neq "ALTA")>
					if (objForm2.RHMCmonto.obj) objForm2.RHMCmonto.obj.value = qf(objForm2.RHMCmonto.obj);
					if (objForm2.RHMCmontomin.obj) objForm2.RHMCmontomin.obj.value = qf(objForm2.RHMCmontomin.obj);
					if (objForm2.RHMCmontomax.obj) objForm2.RHMCmontomax.obj.value = qf(objForm2.RHMCmontomax.obj);
				</cfif>
			}
		</script>
		
	</td>
  </tr>
</table>
<cf_web_portlet_end>