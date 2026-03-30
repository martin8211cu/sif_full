<cfif isdefined("Form.id_inst") and Len(Trim(Form.id_inst))>

	<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
	<cfset varQueryName = "rsLista">
	<cfset MaxRows = 10>
	
	<cfset navegacion = "">

	<cfquery name="rsLista" datasource="#session.tramites.dsn#">
		select a.id_requisito, b.id_tiporeq, b.nombre_tiporeq, a.codigo_requisito, a.nombre_requisito,
			   case a.comportamiento
					when 'D' then 'Documental'
					when 'C' then 'Cita'
					when 'P' then 'Pago'
					when 'A' then 'Aprobaci&oacute;n'
					else 'Otro'
			   end as comport_desc
		from TPRequisito  a 
			inner join TPTipoReq b 
				on b.id_tiporeq = a.id_tiporeq
		where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		order by a.codigo_requisito, b.nombre_tiporeq
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

	<script type="text/javascript" language="javascript1.2">
		function infoRequisito(requisito) {
			var params = "?id_requisito="+requisito+"&id_tramite=0";
			var width = 650;
			var height = 400;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			var nuevo = window.open("/cfmx/home/tramites/Operacion/gestion/infoRequisito.cfm"+params,'info','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
		}
	</script>
	
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td class="tituloIndicacion">
					<strong>C&oacute;digo</strong>
				</td>
				<td class="tituloIndicacion">
					<strong>Descripci&oacute;n</strong>
				</td>
				<td class="tituloIndicacion">
					<strong>Tipo</strong>
				</td>
				<td class="tituloIndicacion">
					<strong>Comportamiento</strong>
				</td>
				<td class="tituloIndicacion" align="right" width="1%">&nbsp;</td>
			</tr>
			<cfif rsLista.recordCount>
			  <cfloop query="rsLista" startrow="#StartRow_lista#" endrow="#StartRow_lista+MaxRows_lista-1#">
				  <cfif rsLista.currentRow MOD 2>
					<cfset estilo = "listaNon">
				  <cfelse>
					<cfset estilo = "listaPar">
				  </cfif>
				  <tr class="#estilo#" onmouseover="javascript: this.style.cursor='pointer'; this.className='listaParSel';" onmouseout="javascript: this.className='#estilo#';" onclick="javascript: infoRequisito('#rsLista.id_requisito#');">
					<td>
						#rsLista.codigo_requisito#
					</td>
					<td>
						#rsLista.nombre_requisito#
					</td>
					<td>
						#rsLista.nombre_tiporeq#
					</td>
					<td>
						#rsLista.comport_desc#
					</td>
					<td>
						<img title="Ver Detalle del Requisito #trim(rsLista.codigo_requisito)# - #rsLista.nombre_requisito#" src="/cfmx/home/tramites/images/info.gif" border="0">
					</td>
				  </tr>
			  </cfloop>
			  <tr>
				<td colspan="5">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="5" align="center">
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
				<td colspan="5">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="5" align="center">
					<strong>No se encontraron requisitos en esta institucion</strong>
				</td>
			  </tr>
			</cfif>
			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
		</table>
	</cfoutput>
</cfif>