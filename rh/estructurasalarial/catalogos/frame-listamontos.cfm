<cfparam name="esAdminSal" default="true">

<cfset navegacionMontos = "RHTTid=" & Form.RHTTid & "&RHVTid=" & Form.RHVTid>
<cfset moreCols = "">
<cfset vs_parametros = "">

<cfif isdefined("Url.PageNum_lista2") and Len(Trim(Url.PageNum_lista2))>
	<cfparam name="Form.PageNum_lista2" default="#Url.PageNum_lista2#">
</cfif>
<cfif isdefined("Form.PageNum2") and Len(Trim(Form.PageNum2))>
	<cfparam name="Form.PageNum_lista2" default="#Form.PageNum2#">
</cfif>

<cfif isdefined("Form.PageNum_lista2") and Len(Trim(Form.PageNum_lista2))>
	<cfset navegacionMontos = navegacionMontos & "&PageNum_lista2=" & Form.PageNum_lista2>
	<cfset moreCols = moreCols & ", '#Form.PageNum_lista2#' as PageNum_lista2">
</cfif>

<cfset vs_parametros = "vigenciasTablasSal.cfm?RHTTid=" & Form.RHTTid & "&RHVTid=" & Form.RHVTid>
<cfif isdefined("Form.PageNum_lista2") and Len(Trim(Form.PageNum_lista2))>
	<cfset vs_parametros = vs_parametros & "&PageNum_lista2=" & Form.PageNum_lista2>
</cfif>

<table width="100%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td>
			
			<form name="filtrosLista" action="<cfoutput>#vs_parametros#</cfoutput>" method="post">
				<table>
					<tr>
						<td align="right"><strong>Categor&iacute;a:</strong></td>
						<td><input type="text" name="RHCdescripcion" value="<cfif isdefined("form.RHCdescripcion") and len(trim(form.RHCdescripcion))><cfoutput>#form.RHCdescripcion#</cfoutput></cfif>"></td>
						<td align="right"><strong>&nbsp;Componente:</strong></td>
						<td><input type="text" name="CSdescripcion" value="<cfif isdefined("form.CSdescripcion") and len(trim(form.CSdescripcion))><cfoutput>#form.CSdescripcion#</cfoutput></cfif>"></td>
						<td><input type="submit" name="btn_filtrar" value="Filtrar"></td>
					</tr>
				</table>
			</form>	
		</td>
	</tr>
	<cf_dbfunction name="concat" args="'Puesto: ',rtrim(u.RHMPPcodigo),' - ',u.RHMPPdescripcion,' &nbsp;&nbsp;Categoría: ',rtrim(t.RHCcodigo),' - ',t.RHCdescripcion" returnvariable="Lvar_Puesto">
	<tr>
		<td>
			<cfquery name="data" datasource="#session.dsn#">
				select a.RHMCid, a.RHVTid, a.CSid, a.RHCPlinea, a.RHMCmonto, a.RHVTfrige, a.RHVTfhasta, a.BMfalta, 
					   a.BMfmod, a.BMUsucodigo, a.RHMCmontomax, a.RHMCmontomin, c.CSdescripcion, 
					   s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
					   t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
					   u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion,
					   <!--- 'Puesto: ' || rtrim(u.RHMPPcodigo) || ' - '||u.RHMPPdescripcion || ' &nbsp;&nbsp;Categoría: ' || rtrim(t.RHCcodigo) || ' - '||t.RHCdescripcion as CatPuesto --->
					   #PreserveSingleQuotes(Lvar_Puesto)# as CatPuesto
					   #PreserveSingleQuotes(moreCols)#
				from RHMontosCategoria a
					inner join RHVigenciasTabla b
						on b.RHVTid = a.RHVTid
						and b.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
					inner join ComponentesSalariales c
						on c.CSid = a.CSid
					left outer join RHCategoriasPuesto r
						on r.RHCPlinea = a.RHCPlinea
					left outer join RHTTablaSalarial s
						on s.RHTTid = r.RHTTid
					left outer join RHCategoria t
						on t.RHCid = r.RHCid
					left outer join RHMaestroPuestoP u
						on u.RHMPPid = r.RHMPPid
				where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
					<cfif isdefined("form.RHCdescripcion") and len(trim(form.RHCdescripcion))>
						and upper(t.RHCdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.RHCdescripcion)#%">
					</cfif>
					<cfif isdefined("form.CSdescripcion") and len(trim(form.CSdescripcion))>
						and upper(c.CSdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.CSdescripcion)#%">
					</cfif>
				order by t.RHCcodigo, u.RHMPPcodigo
			</cfquery>
	
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRHRet">
				<cfinvokeargument name="query" value="#data#"/>
				<cfinvokeargument name="desplegar" value="CSdescripcion, RHMCmonto, RHMCmontomin, RHMCmontomax"/>
				<cfinvokeargument name="etiquetas" value="Componente,Monto,M&iacute;nimo,M&aacute;ximo"/>
				<cfinvokeargument name="formatos" value="S,M,M,M"/>
				<cfinvokeargument name="align" value="left,right,right,right"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="irA" value="vigenciasTablasSal.cfm"/>
				<cfinvokeargument name="maxRows" value="15"/>
				<cfinvokeargument name="keys" value="RHMCid"/>
				<cfinvokeargument name="incl" value="listaMontos"/>
				<cfinvokeargument name="formName" value="listaMontos"/>
				<cfinvokeargument name="cortes" value="CatPuesto"/>
				<cfinvokeargument name="navegacion" value="#navegacionMontos#"/>
				<cfinvokeargument name="PageIndex" value="3"/>
				<cfinvokeargument name="Botones" value="Imprimir"/>
				<cfinvokeargument name="showLink" value="true"/>
				<cfinvokeargument name="showemptylistmsg" value="true"/>
				<cfif not esAdminSal>
					<cfinvokeargument name="showLink" value="false"/>
				</cfif>
			</cfinvoke>
		</td>
	</tr>
</table>
<script language="javascript" type="text/javascript">
	function funcImprimir(){
		<cfoutput>
		var PARAM  = "RPlistaMontos.cfm?RHTTid=#form.RHTTid#&RHVTid=#form.RHVTid#"; 
		open(PARAM,'','left=100,top=100,scrollbars=yes,resizable=no,width=800,height=650');
		</cfoutput>
		return false;
	}
</script>


<!---
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_data" default="1">
<cfquery name="data" datasource="#session.dsn#">
	select a.RHMCid, a.RHVTid, a.CSid, a.RHCPlinea, a.RHMCmonto, a.RHVTfrige, a.RHVTfhasta, a.BMfalta, a.BMfmod, a.BMUsucodigo, a.RHMCmontomax, a.RHMCmontomin, c.CSdescripcion
	from RHMontosCategoria a
		inner join RHVigenciasTabla b
			on b.RHVTid = a.RHVTid
			and b.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
		inner join ComponentesSalariales c
			on c.CSid = a.CSid
	where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
</cfquery>
<cfset MaxRows_data=10>
<cfset StartRow_data=Min((PageNum_data-1)*MaxRows_data+1,Max(data.RecordCount,1))>
<cfset EndRow_data=Min(StartRow_data+MaxRows_data-1,data.RecordCount)>
<cfset TotalPages_data=Ceiling(data.RecordCount/MaxRows_data)>
<cfset QueryString_data=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PageNum_data=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif>
<cfset params = "">
<cfset tempPos=ListContainsNoCase(QueryString_data,"RHTTid=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "&RHTTid=" & Form.RHTTid>
<cfset tempPos=ListContainsNoCase(QueryString_data,"RHVTid=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "&RHVTid=" & Form.RHVTid>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PAGENUMPADRE=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "&PAGENUMPADRE=" & Form.PAGENUMPADRE>
<cfset tempPos=ListContainsNoCase(QueryString_data,"PAGENUM=","&")><cfif tempPos NEQ 0><cfset QueryString_data=ListDeleteAt(QueryString_data,tempPos,"&")></cfif><cfset params = params & "&PAGENUM=" & Form.PAGENUM>


<table width="100%"  border="0" cellspacing="0" cellpadding="0">

  <tr>
	<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
	<td class="tituloListas" align="left" height="17" nowrap>C&oacute;digo</td>
	<td class="tituloListas" align="left" height="17" nowrap>Paso</td>
	<td class="tituloListas" align="left" height="17" nowrap>Componente</td>
	<td class="tituloListas" align="left" height="17" nowrap>Monto</td>
	<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
  </tr> 
  
  <cfoutput query="data" maxrows="#MaxRows_data#" startrow="#StartRow_data#">
	<tr class=<cfif data.CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif data.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		<td align="left" width="18" height="18" nowrap onclick="javascript: ProcesarMonto('#RHMCid#');">
			<cfif isdefined("Form.RHMCid") and comparenocase('#data.RHMCid#','#Form.RHMCid#') EQ 0 and not isdefined("NuevoMonto")>
				<img src="/cfmx/rh/imagenes/addressGo.gif" width="18" height="18"> 
			</cfif>
		</td>
		<td align="left" nowrap onclick="javascript: ProcesarMonto('#data.RHMCid#');">
			<!---
			<a href="javascript:ProcesarMonto('#data.RHMCid#');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
				#data.RHMCcodigo#
			</a>
			--->
		</td>
		<td align="left" nowrap onclick="javascript: ProcesarMonto('#data.RHMCid#');">
			<!---
			<a href="javascript:ProcesarMonto('#data.RHMCid#');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
				#data.RHMCpaso#
			</a>
			--->
		</td>
		<td align="left" nowrap onclick="javascript: ProcesarMonto('#data.RHMCid#');">
			<a href="javascript:ProcesarMonto('#data.RHMCid#');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
				#data.CSdescripcion#
			</a>
		</td>
		<td align="right" nowrap onclick="javascript: ProcesarMonto('#data.RHMCid#');">
			<a href="javascript:ProcesarMonto('#data.RHMCid#');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">
				#LsCurrencyFormat(data.RHMCmonto,"none")#
			</a>
		</td>
		<td align="left" width="18" height="18" nowrap onclick="javascript: ProcesarMonto('#RHMCid#');"></td>
	</tr> 
  </cfoutput>
  
  <cfif data.RecordCount lte 0>
	<tr><td align="center" colspan="6" class="listaCorte">
		No se ha agregado ningún monto a la vigencia.
	</td></tr>
  </cfif>

</table>
<table width="0%"  border="0" cellspacing="0" cellpadding="0" align="center">

  <cfoutput>
    <tr>
	  <cfif PageNum_data GT 1>
        <td align="center">
        	<a href="#CurrentPage#?PageNum_data=1#QueryString_data##params#"><img src="/cfmx/rh/imagenes/First.gif" border=0></a>
        </td>
	  </cfif>
      <cfif PageNum_data GT 1>
	    <td align="center">
          <a href="#CurrentPage#?PageNum_data=#Max(DecrementValue(PageNum_data),1)##QueryString_data##params#"><img src="/cfmx/rh/imagenes/Previous.gif" border=0></a>
        </td>
	  </cfif>
	  <cfif PageNum_data LT TotalPages_data>
        <td align="center">
          <a href="#CurrentPage#?PageNum_data=#Min(IncrementValue(PageNum_data),TotalPages_data)##QueryString_data##params#"><img src="/cfmx/rh/imagenes/Next.gif" border=0></a>
		</td>
	  </cfif>
	  <cfif PageNum_data LT TotalPages_data>
		<td align="center">
          <a href="#CurrentPage#?PageNum_data=#TotalPages_data##QueryString_data##params#"><img src="/cfmx/rh/imagenes/Last.gif" border=0></a>
      	</td>
	  </cfif>
    </tr>
  </cfoutput>
  
</table>
--->
