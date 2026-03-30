<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">
<cfparam name="PageNum_Lista" default="1">
<cfparam name="PageIndex" default="">
<cfparam name="QueryString_lista" default="">
<cfquery name="Lista" datasource="minisif">
	select a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, b.Ddocumento, b.Dtotal, b.Dsaldo
	from SNegocios a
	inner join Documentos b
		on b.SNcodigo = a.SNcodigo
		and b.Ecodigo = a.Ecodigo
		and b.Dsaldo > 0
		and b.Dvencimiento 
		between <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(year(now()),month(now()),01)#">
		and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
	order by SNnombre 
	<cfif isdefined("url.orderbyDdocumento")>
		,Ddocumento
	<cfelseif isdefined("url.orderbyDdocumentoDesc")>
		,Ddocumento desc
	<cfelseif isdefined("url.orderbyTotal")>
		,Dtotal
	<cfelseif isdefined("url.orderbyTotalDesc")>
		,Dtotal desc
	<cfelseif isdefined("url.orderbySaldo")>
		,Dsaldo
	<cfelseif isdefined("url.orderbySaldoDesc")>
		,Dsaldo desc
	</cfif>
</cfquery>
<cfset MaxRows_Lista=10>
<cfset StartRow_Lista=Min((PageNum_Lista-1)*MaxRows_Lista+1,Max(Lista.RecordCount,1))>
<cfset EndRow_Lista=Min(StartRow_Lista+MaxRows_Lista-1,Lista.RecordCount)>
<cfset TotalPages_Lista=Ceiling(Lista.RecordCount/MaxRows_Lista)>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <th scope="col">Documento</th>
    <th scope="col">Total</th>
    <th scope="col">Saldo</th>
  </tr>
  <cfoutput query="Lista" startrow="#StartRow_Lista#" maxrows="#MaxRows_Lista#">
  <tr>
    <td>#Ddocumento#</td>
    <td>#Dtotal#</td>
    <td>#Dsaldo#</td>
  </tr>
  </cfoutput>
  <cfoutput>
  <tr> 
	<td align="center" colspan="3">
	<cfif PageNum_lista GT 1>
	<a href="#CurrentPage#?PageNum_lista#PageIndex#=1#QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/First.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista GT 1>
	<a href="#CurrentPage#?PageNum_lista#PageIndex#=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista LT TotalPages_lista>
	<a href="#CurrentPage#?PageNum_lista#PageIndex#=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a> 
	</cfif>
	<cfif PageNum_lista LT TotalPages_lista>
	<a href="#CurrentPage#?PageNum_lista#PageIndex#=#TotalPages_lista##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a> 
	</cfif> 
  </td>
  </tr>
  </cfoutput>
</table>