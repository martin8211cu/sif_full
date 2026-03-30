<cfif isdefined("Form.id_inst") and Len(Trim(Form.id_inst))>
	<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
	<cfset varQueryName = "rsSucursales">
	<cfset MaxRows = 10>
	
	<cfset navegacion = "">
	
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select a.id_inst, a.id_sucursal, a.id_direccion, a.codigo_sucursal, a.nombre_sucursal, a.horario_sucursal, 
			   b.id_ventanilla, b.codigo_ventanilla, b.nombre_ventanilla
		from TPSucursal a
			left outer join TPVentanilla b
				on b.id_sucursal = a.id_sucursal
		where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		order by a.codigo_sucursal, b.codigo_ventanilla
	</cfquery>
	
	<cfquery name="rsSucursales" dbtype="query">
		select distinct id_sucursal, codigo_sucursal, nombre_sucursal, horario_sucursal
		from rsDatos
		order by codigo_sucursal
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
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td width="50%" class="tituloIndicacion">
				<font size="2" color="black"><strong>Sucursal</strong></font>
			</td>
			<td class="tituloIndicacion">
				<font size="2" color="black"><strong>Ventanillas</strong></font>
			</td>
		  </tr>
		  <cfif rsSucursales.recordCount>
			  <cfloop query="rsSucursales" startrow="#StartRow_lista#" endrow="#StartRow_lista+MaxRows_lista-1#">
			  <cfif rsSucursales.currentRow MOD 2>
			  	<cfset estilo = "listaNon">
			  <cfelse>
			  	<cfset estilo = "listaPar">
			  </cfif>
			  <tr class="#estilo#">
				<td <cfif rsSucursales.currentRow NEQ StartRow_lista> style="border-top: 1px solid black;"</cfif> valign="top">
					<table align="center" width="100%" cellpadding="2" cellspacing="0">
					  <tr> 
						<td class="fileLabel" width="5%" align="right" nowrap>
							<font size="2">#rsSucursales.codigo_sucursal#</font>
						</td>
						<td nowrap>
							<font size="2">#rsSucursales.nombre_sucursal#</font>
						</td>
					  </tr>
					</table>
				</td>
				<td <cfif rsSucursales.currentRow NEQ StartRow_lista> style="border-top: 1px solid black;"</cfif> valign="top">
					<cfquery name="rsVentanillas" dbtype="query">
						select distinct id_ventanilla, codigo_ventanilla, nombre_ventanilla
						from rsDatos
						where id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSucursales.id_sucursal#">
						order by codigo_ventanilla
					</cfquery>
					<table width="100%" border="0" cellspacing="0" cellpadding="2">
					  <cfif rsVentanillas.recordCount and Len(Trim(rsVentanillas.codigo_ventanilla))>
						  <cfloop query="rsVentanillas">
							  <tr>
								<td class="fileLabel" width="5%" align="right" nowrap>
									#rsVentanillas.codigo_ventanilla#
								</td>
								<td nowrap>
									#rsVentanillas.nombre_ventanilla#
								</td>
							  </tr>
						  </cfloop>
					  <cfelse>
						  <tr>
							<td colspan="2">
								<strong>No se han creado ventanillas en esta sucursal</strong>
							</td>
						  </tr>
					  </cfif>
					</table>
				</td>
			  </tr>
			  </cfloop>
			  <tr>
				<td colspan="2">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="2" align="center">
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
				<td colspan="2">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="2" align="center">
					<strong>No se han creado sucursales para esta instituci&oacute;n</strong>
				</td>
			  </tr>
		  </cfif>
		  <tr>
		    <td colspan="2">&nbsp;</td>
		  </tr>
		</table>
	</cfoutput>
	
</cfif>
