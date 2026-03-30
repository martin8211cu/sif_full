<cfif isdefined("Form.id_inst") and Len(Trim(Form.id_inst)) and isdefined("Form.id_funcionario") and Len(Trim(Form.id_funcionario))>
	<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
	<cfset varQueryName = "rsDatos">
	<cfset MaxRows = 10>
	
	<cfif isdefined("Url.filtro_fecha") and Len(Trim(Url.filtro_fecha))>
		<cfparam name="Form.filtro_fecha" default="#Url.filtro_fecha#">
	</cfif>
	<cfif isdefined("Url.filtro_accion") and Len(Trim(Url.filtro_accion))>
		<cfparam name="Form.filtro_accion" default="#Url.filtro_accion#">
	</cfif>
	<cfif isdefined("Url.filtro_texto") and Len(Trim(Url.filtro_texto))>
		<cfparam name="Form.filtro_texto" default="#Url.filtro_texto#">
	</cfif>
	
	<cfset navegacion = "tab=#Form.tab#&id_inst=#Form.id_inst#&id_funcionario=#Form.id_funcionario#">
	<cfif isdefined("Form.filtro_fecha") and Len(Trim(Form.filtro_fecha))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_fecha=" & Form.filtro_fecha>
	</cfif>
	<cfif isdefined("Form.filtro_accion") and Len(Trim(Form.filtro_accion))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_accion=" & Form.filtro_accion>
	</cfif>
	<cfif isdefined("Form.filtro_texto") and Len(Trim(Form.filtro_texto))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_texto=" & Form.filtro_texto>
	</cfif>
	
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select a.accion, a.texto, a.BMfechamod,
			   c.codigo_sucursal, c.nombre_sucursal, b.codigo_ventanilla, b.nombre_ventanilla,
			   d.identificacion_persona, d.nombre || ' ' || d.apellido1 || ' ' || d.apellido2 as nombre_completo,
			   e.nombre_tramite, f.nombre_requisito
		from TPBitacoraFuncionario a
			left outer join TPVentanilla b
				on b.id_ventanilla = a.id_ventanilla
			left outer join TPSucursal c
				on c.id_sucursal = b.id_sucursal
			left outer join TPPersona d
				on d.id_persona = a.id_persona
			left outer join TPTramite e
				on e.id_tramite = a.id_tramite
			left outer join TPRequisito f
				on f.id_requisito = a.id_requisito
		where a.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_funcionario#">
		<cfif isdefined("Form.filtro_fecha") and Len(Trim(Form.filtro_fecha))>
			and a.BMfechamod 
				between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.filtro_fecha)#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(Form.filtro_fecha)))#">
		</cfif>
		<cfif isdefined("Form.filtro_accion") and Len(Trim(Form.filtro_accion))>
			and a.accion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.filtro_accion#">
		</cfif>
		<cfif isdefined("Form.filtro_texto") and Len(Trim(Form.filtro_texto))>
			and upper(a.texto) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(Form.filtro_texto))#%">
		</cfif>
		order by a.BMfechamod desc
	</cfquery>
	
	<cfquery name="comboAcciones" datasource="#session.tramites.dsn#">
		select distinct accion
		from TPBitacoraFuncionario
		order by accion
	</cfquery>

	<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
		<cfset PageNum_lista = Form.PageNum_lista>
	<cfelseif isdefined("Url.PageNum_lista") and Len(Trim(Url.PageNum_lista))>
		<cfset PageNum_lista = Url.PageNum_lista>
	<cfelse>
		<cfset PageNum_lista = 1>
	</cfif>
	
	<cfif MaxRows LT 1>
		<cfset MaxRows = Evaluate("#varQueryName#").RecordCount>
	</cfif>
	<cfif MaxRows LT 1>
		<cfset MaxRows_lista = 1>
	<cfelse>
		<cfset MaxRows_lista = MaxRows>
	</cfif>
	<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(Evaluate("#varQueryName#").RecordCount,1))>		
	<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,Evaluate("#varQueryName#").RecordCount)>
	<cfset TotalPages_lista = Ceiling(Evaluate("#varQueryName#").RecordCount/MaxRows_lista)>
	<cfif Len(Trim(CGI.QUERY_STRING)) GT 0>
		<cfset QueryString_lista='&'&CGI.QUERY_STRING>
	<cfelse>
		<cfset QueryString_lista="">
	</cfif>
	<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
	<cfif tempPos NEQ 0>
	  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
	</cfif>
	
	<cfif Len(Trim(navegacion)) NEQ 0>
		<cfset nav = ListToArray(navegacion, "&")>
		<cfloop index="nv" from="1" to="#ArrayLen(nav)#">
			<cfset tempkey = ListGetAt(nav[nv], 1, "=")>
			<cfset tempPos1 = ListContainsNoCase(QueryString_lista,"?" & tempkey & "=")>
			<cfset tempPos2 = ListContainsNoCase(QueryString_lista,"&" & tempkey & "=")>
			<!--- 
				Chequear substrings duplicados en el contenido de la llave
			--->
			<cfif tempPos1 EQ 0 and tempPos2 EQ 0>
			  <cfset QueryString_lista=QueryString_lista&"&"&nav[nv]>
			</cfif>
		</cfloop>
	</cfif>

	<cfoutput>
		<form name="formBitacora" method="post" action="#CurrentPage#" style="margin: 0;">
			<input type="hidden" name="tab" value="#Form.tab#" />
			<input type="hidden" name="id_inst" value="#Form.id_inst#" />
			<input type="hidden" name="id_funcionario" value="#Form.id_funcionario#" />
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
			  <tr class="areaFiltro">
				<td class="fileLabel" align="right">Fecha:</td>
				<td>
					<cfif isdefined("Form.filtro_fecha") and Len(Trim(Form.filtro_fecha))>
						<cfset fecha = Form.filtro_fecha>
					<cfelse>
						<cfset fecha = "">
					</cfif>
					<cf_sifcalendario form="formBitacora" name="filtro_fecha" value="#fecha#">
				</td>
				<td class="fileLabel" align="right">Acci&oacute;n:</td>
				<td>
					<select name="filtro_accion">
						<option value="">(Todos)</option>
						<cfloop query="comboAcciones">
							<option value="#comboAcciones.accion#" <cfif isdefined("form.filtro_accion") and form.filtro_accion EQ comboAcciones.accion> selected</cfif>>#comboAcciones.accion#</option>
						</cfloop>
					</select>
				</td>
				<td class="fileLabel" align="right">Texto:</td>
				<td>
					<input type="text" name="filtro_texto" size="40" value="<cfif isdefined("Form.filtro_texto") and Len(Trim(Form.filtro_texto))>#Form.filtro_texto#</cfif>" />
				</td>
				<td align="right">
					<input type="submit" name="btnFiltrar" value="Filtrar" />
				</td>
			  </tr>
			</table>
		</form>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td class="tituloIndicacion">
				<strong>Fecha</strong>
			</td>
			<td class="tituloIndicacion">
				<strong>Acci&oacute;n</strong>
			</td>
			<td class="tituloIndicacion">
				<strong>Texto</strong>
			</td>
			<td class="tituloIndicacion">
				<strong>Ventanilla</strong>
			</td>
			<td class="tituloIndicacion">
				<strong>Persona</strong>
			</td>
			<td class="tituloIndicacion">
				<strong>Tr&aacute;mite</strong>
			</td>
			<td class="tituloIndicacion">
				<strong>Requisito</strong>
			</td>
		  </tr>
		  <cfif rsDatos.recordCount>
			  <cfloop query="rsDatos" startrow="#StartRow_lista#" endrow="#StartRow_lista+MaxRows_lista-1#">
				  <cfif rsDatos.currentRow MOD 2>
					<cfset estilo = "listaNon">
				  <cfelse>
					<cfset estilo = "listaPar">
				  </cfif>
				  <tr class="#estilo#">
					<td height="40">
						#LSDateFormat(rsDatos.BMfechamod, 'dd/mm/yyyy')#<br />
						#LSTimeFormat(rsDatos.BMfechamod, 'hh:mm tt')#
					</td>
					<td>
						#HtmlEditFormat(rsDatos.accion)#
					</td>
					<td>
						#HtmlEditFormat(rsDatos.texto)#
					</td>
					<td>
						#HtmlEditFormat(rsDatos.nombre_sucursal)#<br />
						#HtmlEditFormat(rsDatos.nombre_ventanilla)#
					</td>
					<td>
						#HtmlEditFormat(rsDatos.identificacion_persona)#<br />
						#HtmlEditFormat(rsDatos.nombre_completo)#
					</td>
					<td>
						#HtmlEditFormat(rsDatos.nombre_tramite)#
					</td>
					<td>
						#HtmlEditFormat(rsDatos.nombre_requisito)#
					</td>
				  </tr>
			  </cfloop>
			  <tr>
				<td colspan="7">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="7" align="center">
					<cfif PageNum_lista GT 1>
					  <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/First.gif" border="0"></a> 
					</cfif>
					<cfif PageNum_lista GT 1>
					  <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Previous.gif" border="0"></a> 
					</cfif>
					<cfif PageNum_lista LT TotalPages_lista>
					  <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Next.gif" border="0"></a> 
					</cfif>
					<cfif PageNum_lista LT TotalPages_lista>
					  <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Last.gif" border="0"></a> 
					</cfif> 
				</td>
			  </tr>
		  <cfelse>
			  <tr>
				<td colspan="7">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="7" align="center">
					<strong>No se encontraron movimientos realizados por el funcionario</strong>
				</td>
			  </tr>
		  </cfif>
		  <tr>
			<td colspan="7">&nbsp;</td>
		  </tr>
		</table>
	</cfoutput>
	
</cfif>
