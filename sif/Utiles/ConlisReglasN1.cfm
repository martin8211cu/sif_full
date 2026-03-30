<html>
<head>
	<title>Lista de Reglas de Nivel 1</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>

<cf_templatecss>

<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
<cfset MaxRows = 20>

<cfif isdefined("Url.f")>
	<cfparam name="Form.f" default="#Url.f#">
</cfif>
<cfif isdefined("Url.p1")>
	<cfparam name="Form.p1" default="#Url.p1#">
</cfif>
<cfif isdefined("Url.p2")>
	<cfparam name="Form.p2" default="#Url.p2#">
</cfif>
<cfif isdefined("Url.PCRid")>
	<cfparam name="Form.PCRid" default="#Url.PCRid#">
</cfif>
<cfif isdefined("Url.filtro_OficodigoM")>
	<cfparam name="Form.filtro_OficodigoM" default="#Url.filtro_OficodigoM#">
</cfif>
<cfif isdefined("Url.filtro_Cmayor")>
	<cfparam name="Form.filtro_Cmayor" default="#Url.filtro_Cmayor#">
</cfif>
<cfif isdefined("Url.filtro_PCRregla")>
	<cfparam name="Form.filtro_PCRregla" default="#Url.filtro_PCRregla#">
</cfif>
<cfif isdefined("Url.filtro_PCRvalida")>
	<cfparam name="Form.filtro_PCRvalida" default="#Url.filtro_PCRvalida#">
</cfif>
<cfif isdefined("Url.filtro_PCRdesde")>
	<cfparam name="Form.filtro_PCRdesde" default="#Url.filtro_PCRdesde#">
</cfif>
<cfif isdefined("Url.filtro_PCRhasta")>
	<cfparam name="Form.filtro_PCRhasta" default="#Url.filtro_PCRhasta#">
</cfif>
<cfif isdefined("Url.OficodigoM")>
	<cfparam name="Form.OficodigoM" default="#Url.OficodigoM#">
</cfif>
<cfif isdefined("Url.Cmayor")>
	<cfparam name="Form.Cmayor" default="#Url.Cmayor#">
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.f") and Len(Trim(Form.f))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "f=" & Form.f>
</cfif>
<cfif isdefined("Form.p1") and Len(Trim(Form.p1))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "p1=" & Form.p1>
</cfif>
<cfif isdefined("Form.p2") and Len(Trim(Form.p2))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "p2=" & Form.p2>
</cfif>
<cfif isdefined("Form.PCRid") and Len(Trim(Form.PCRid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "PCRid=" & Form.PCRid>
</cfif>
<cfif isdefined("Form.filtro_OficodigoM") and Len(Trim(Form.filtro_OficodigoM))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_OficodigoM=" & Form.filtro_OficodigoM>
</cfif>
<cfif isdefined("Form.filtro_Cmayor") and Len(Trim(Form.filtro_Cmayor))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_Cmayor=" & Form.filtro_Cmayor>
</cfif>
<cfif isdefined("Form.filtro_PCRregla") and Len(Trim(Form.filtro_PCRregla))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRregla=" & Form.filtro_PCRregla>
</cfif>
<cfif isdefined("Form.filtro_PCRvalida") and Len(Trim(Form.filtro_PCRvalida))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRvalida=" & Form.filtro_PCRvalida>
</cfif>
<cfif isdefined("Form.filtro_PCRdesde") and Len(Trim(Form.filtro_PCRdesde))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRdesde=" & Form.filtro_PCRdesde>
</cfif>
<cfif isdefined("Form.filtro_PCRhasta") and Len(Trim(Form.filtro_PCRhasta))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRhasta=" & Form.filtro_PCRhasta>
</cfif>
<cfif isdefined("Form.OficodigoM") and Len(Trim(Form.OficodigoM))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "OficodigoM=" & Form.OficodigoM>
</cfif>
<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Cmayor=" & Form.Cmayor>
</cfif>

<cfif isdefined("Form.OficodigoM") and Len(Trim(Form.OficodigoM))>
	<cfparam name="Form.filtro_OficodigoM" default="#Form.OficodigoM#">
</cfif>
<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
	<cfparam name="Form.filtro_Cmayor" default="#Form.Cmayor#">
</cfif>

<cfinclude template="sifConcat.cfm">
<!--- Lista de Reglas de Nivel 1 --->
<cfquery name="rsReglas" datasource="#session.DSN#">
	select a.PCRid, 
		   a.Ecodigo, 
		   a.Cmayor, 
		   a.PCEMid, 
		   a.OficodigoM, 
		   a.PCRref, 
		   a.PCRdescripcion, 
		   a.PCRregla, 
		   case when a.PCRvalida = 1 then '<img src=''/cfmx/sif/imagenes/checked.gif''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif''>' end as PCRvalida, 
		   a.PCRdesde, 
		   a.PCRhasta
	from PCReglas a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and (a.PCRref is null or a.PCRid = a.PCRref)
	<cfif isdefined("form.filtro_OficodigoM") and Len(Trim(form.filtro_OficodigoM))>
		and upper(a.OficodigoM) like <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.filtro_OficodigoM))#%">
	</cfif>
	<cfif isdefined("Form.PCRid") and Len(Trim(Form.PCRid))>
		and a.PCRid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
	</cfif>
	<cfif isdefined("form.filtro_Cmayor") and Len(Trim(form.filtro_Cmayor))>
		and upper(a.Cmayor) like <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Trim(form.filtro_Cmayor))#%">
	</cfif>
	<cfif isdefined("Form.filtro_PCRregla") and Len(trim(form.filtro_PCRregla))>
		and (
			upper(a.PCRregla) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(form.filtro_PCRregla))#%">
			or
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(form.filtro_PCRregla))#"> like '%' #_Cat# upper(a.PCRregla) #_Cat# '%'
		)
	</cfif>
	<cfif isdefined("form.filtro_PCRvalida") and Len(Trim(form.filtro_PCRvalida))>
		and a.PCRvalida = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.filtro_PCRvalida#">
	</cfif> 

	<cfif isdefined("form.filtro_PCRdesde") and Len(Trim(form.filtro_PCRdesde)) and isdefined("form.filtro_PCRhasta") and Len(Trim(form.filtro_PCRhasta))>
		and a.PCRdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.filtro_PCRdesde#">
		and a.PCRhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.filtro_PCRhasta#">
	<cfelseif isdefined("form.filtro_PCRdesde") and Len(Trim(form.filtro_PCRdesde))>
		and a.PCRdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.filtro_PCRdesde#">
	<cfelseif isdefined("form.filtro_PCRhasta") and Len(Trim(form.filtro_PCRhasta))> 
		and a.PCRhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.filtro_PCRhasta#">
	</cfif>

	order by OficodigoM, a.Cmayor, a.PCRregla
</cfquery>

<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
	<cfset PageNum_lista = Form.PageNum_lista>
<cfelseif isdefined("Url.PageNum_lista") and Len(Trim(Url.PageNum_lista))>
	<cfset PageNum_lista = Url.PageNum_lista>
<cfelse>
	<cfset PageNum_lista = 1>
</cfif>

<cfif MaxRows LT 1>
	<cfset MaxRows = rsReglas.RecordCount>
</cfif>
<cfif MaxRows LT 1>
	<cfset MaxRows_lista = 1>
<cfelse>
	<cfset MaxRows_lista = MaxRows>
</cfif>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(rsReglas.RecordCount,1))>		
<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,rsReglas.RecordCount)>
<cfset TotalPages_lista = Ceiling(rsReglas.RecordCount/MaxRows_lista)>
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

<script language="javascript" type="text/javascript">
	function funcFiltrar() {
		document.formLista.PageNum_lista.value = '1';
		document.formLista.submit();
	}
	
	<cfoutput>
	function Asignar(arg1, arg2) {
		window.opener.document.#Form.f#.#Form.p1#.value = arg1;
		window.opener.document.#Form.f#.#Form.p2#.value = arg2;
		window.close();
	}
	</cfoutput>
</script>

<cfoutput>
	<!--- Filtros ---->
	<form name="formLista" method="post" action="#CurrentPage#" style="margin: 0;">
		<input type="hidden" name="StartRow_lista" value="#StartRow_lista#">
		<input type="hidden" name="PageNum_lista" value="#PageNum_lista#">
		<cfif isdefined("form.f") and Len(Trim(form.f))>
			<input type="hidden" name="f" value="#Form.f#">
		</cfif>
		<cfif isdefined("form.p1") and Len(Trim(form.p1))>
			<input type="hidden" name="p1" value="#Form.p1#">
		</cfif>
		<cfif isdefined("form.p2") and Len(Trim(form.p2))>
			<input type="hidden" name="p2" value="#Form.p2#">
		</cfif>
		<cfif isdefined("form.PCRid") and Len(Trim(form.PCRid))>
			<input type="hidden" name="PCRid" value="#Form.PCRid#">
		</cfif>
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr class="areaFiltro">
			<td width="2%">&nbsp;</td>
			<td width="3%">&nbsp;</td>
			<td width="8%"><strong>Oficina</strong></td>
			<td width="1%"><strong>Mayor</strong></td>
			<td width="21%"><strong>Regla</strong></td>
			<td width="8%" align="center"><strong>V&aacute;lida</strong></td>
			<td width="10%" align="center"><strong>Desde</strong></td>
			<td width="10%" align="center"><strong>Hasta</strong></td>
			<td width="10%">&nbsp;</td>
		  </tr>
		  <tr class="areaFiltro" height="25">
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				<cfif isdefined("Form.OficodigoM") and Len(Trim(Form.OficodigoM))>
					<input type="hidden" name="OficodigoM" value="#form.OficodigoM#">
					<input type="hidden" name="filtro_OficodigoM" value="#form.OficodigoM#">
					#form.OficodigoM#
				<cfelse>
					<input type="text" name="filtro_OficodigoM" size="11" maxlength="10" value="<cfif IsDefined("form.filtro_OficodigoM") and Len(Trim("form.filtro_OficodigoM"))>#form.filtro_OficodigoM#</cfif>">
				</cfif>
			</td>
			<td>
				<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
					<input type="hidden" name="Cmayor" value="#form.Cmayor#">
					<input type="hidden" name="filtro_Cmayor" value="#form.Cmayor#">
					#form.Cmayor#
				<cfelse>
					<cfset ctamayor = "">
					<cfif IsDefined("form.filtro_Cmayor") and Len(Trim("form.filtro_Cmayor"))>
						<cfset ctamayor = form.filtro_Cmayor>
					</cfif>
					<cf_sifCuentasMayor form="formLista" Cmayor="filtro_Cmayor" size="30" idquery="#ctamayor#">	
				</cfif>
			</td>
			<td><input type="text" name="filtro_PCRregla" size="35" value="<cfif IsDefined("form.filtro_PCRregla") and Len(Trim("form.filtro_PCRregla"))>#form.filtro_PCRregla#</cfif>"></td>
			<td align="center">
				<select name="filtro_PCRvalida" id="filtro_PCRvalida">
					<option value="">Todos</option>
					<option value="1" <cfif isdefined("Form.filtro_PCRvalida") and Form.filtro_PCRvalida EQ "1"> selected</cfif>>S&iacute;</option>
					<option value="0" <cfif isdefined("Form.filtro_PCRvalida") and Form.filtro_PCRvalida EQ "0"> selected</cfif>>No</option>
				</select>
			</td>
			<td align="center">
				<cfif IsDefined("Form.filtro_PCRdesde") and Len(Trim(Form.filtro_PCRdesde))>
					<cfset fecha = LSDateFormat(Form.filtro_PCRdesde,'dd/mm/yyyy')>
				<cfelse>
					<cfset fecha ="">
				</cfif>
				<cf_sifcalendario name="filtro_PCRdesde" form="formLista" value="#fecha#">
			</td>
			<td align="center">
				<cfif IsDefined("Form.filtro_PCRhasta") and Len(Trim(Form.filtro_PCRhasta))>
					<cfset fecha2 = LSDateFormat(Form.filtro_PCRhasta,'dd/mm/yyyy')>
				<cfelse>
					<cfset fecha2 = "">
				</cfif>
				<cf_sifcalendario name="filtro_PCRhasta" form="formLista" value="#fecha2#">
			</td>
			<td align="center">
				<input type="submit" name="btnFiltrar" value="Filtrar" onClick="javascript: return funcFiltrar();">
			</td>
		  </tr>
		<cfif rsReglas.recordCount>
			<cfloop query="rsReglas" startrow="#StartRow_lista#" endrow="#StartRow_lista+MaxRows_lista-1#">
			  <cfif rsReglas.currentRow MOD 2>
			  	<cfset estilo = "listaNon">
			  <cfelse>
			  	<cfset estilo = "listaPar">
			  </cfif>
			  <tr class="#estilo#" onMouseOver="javascript: this.className='listaParSel'; this.style.cursor='pointer';" onMouseOut="javascript: this.className='#estilo#';" onClick="javascript: Asignar('#rsReglas.PCRid#', '#rsReglas.PCRregla#');">
				<td>&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td>#rsReglas.OficodigoM#</td>
				<td>#rsReglas.Cmayor#</td>
				<td>#rsReglas.PCRregla#</td>
				<td align="center">#rsReglas.PCRvalida#</td>
				<td align="center">#LSDateFormat(rsReglas.PCRdesde,'dd/mm/yyyy')#</td>
				<td align="center">#LSDateFormat(rsReglas.PCRhasta,'dd/mm/yyyy')#</td>
				<td align="center">&nbsp;</td>
			  </tr>
			</cfloop>
		    <tr>
			  <td colspan="9">&nbsp;</td>
		  	</tr>
			<tr> 
			  <td align="center" colspan="9">
				<cfif PageNum_lista GT 1>
				  <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/First.gif" border=0></a> 
				</cfif>
				<cfif PageNum_lista GT 1>
				  <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a> 
				</cfif>
				<cfif PageNum_lista LT TotalPages_lista>
				  <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a> 
				</cfif>
				<cfif PageNum_lista LT TotalPages_lista>
				  <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a> 
				</cfif> 
			  </td>
			</tr>
		<cfelse>
		  <tr>
			<td colspan="9" align="center" class="tituloAlterno">--- NO SE ENCONTRARON REGISTROS ---</td>
		  </tr>
		</cfif>
		  <tr>
			<td colspan="9">&nbsp;</td>
		  </tr>
		</table>
	</form>
</cfoutput>

</body>
</html>
