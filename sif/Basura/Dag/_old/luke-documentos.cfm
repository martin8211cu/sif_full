<style >
 .table_border_gray{border:1px solid #ccc;}
</style>
<!--- 
	Consola Principal de Administración de CXC.
	Esta sección define la consulta que pinta la lista principal de la consola de cxc.
	Configuración de la Consulta:
	1. Lista de Socios de Negocios con totales y saldos actuales de documentos con saldos > 0.
	2. Lista de Documentos con documentos con saldos > 0 que vencen en el mes.
	3. Lista de Documentos con documentos con saldos > 0.
 --->
<cffunction 
	name="LSMonthAsString" 
	output="true"
	returntype="string">
	<cfargument name="Month" required="true">
	<cfquery name="rsMonthAsString" datasource="sifcontrol">
		select min(b.VSdesc) as Month
		from Idiomas a
			inner join VSidioma b
			on b.Iid = a.Iid
			and b.VSvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Month#">
			and b.VSgrupo = 1
		where a.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Idioma#">
	</cfquery>
	<cfif rsMonthAsString.recordcount>
		<cfreturn rsMonthAsString.Month>
	</cfif>
</cffunction>
<cfif isdefined("url.alldocs")>
	<!--- 3. --->
	<cfquery name="Lista" datasource="#session.dsn#">
		select a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, b.Ddocumento, b.Dtotal, b.Dsaldo, b.Mcodigo
		from SNegocios a
		inner join Documentos b
			on b.SNcodigo = a.SNcodigo
			and b.Ecodigo = a.Ecodigo
			and b.Dsaldo > 0
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
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
	<cfset ListaDisplay = 3>
<cfelseif isdefined("url.docs")>
	<!--- 2. --->
	<cfquery name="Lista" datasource="#session.dsn#">
		select a.SNid, a.SNcodigo, a.SNnombre, a.SNnumero, b.Ddocumento, b.Dtotal, b.Dsaldo, b.Mcodigo
		from SNegocios a
		inner join Documentos b
			on b.SNcodigo = a.SNcodigo
			and b.Ecodigo = a.Ecodigo
			and b.Dsaldo > 0
			and b.Dvencimiento 
			between <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(year(now()),month(now()),01)#">
			and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by SNnombre, Mcodigo 
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
	<cfset ListaDisplay = 2>
<cfelse>
	<!--- 1. Lista de Socios de Negocios con totales y saldos actuales de documentos con saldos > 0. --->
	<cfquery name="Lista" datasource="#session.dsn#">
		select a.SNid, a.SNcodigo, a.SNnumero, a.SNnombre,
		( 	select round(coalesce(sum(Dtotal*Dtcultrev),0.00),2)
			from Documentos b
			where b.SNcodigo = a.SNcodigo
			and b.Ecodigo = a.Ecodigo
			and b.Dsaldo > 0
			and b.Dvencimiento 
			between <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(year(now()),month(now()),01)#">
			and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
		) as Total,
		( 	select round(coalesce(sum(Dsaldo*Dtcultrev),0.00),2)
			from Documentos b
			where b.SNcodigo = a.SNcodigo
			and b.Ecodigo = a.Ecodigo
			and b.Dsaldo > 0
			and b.Dvencimiento 
			between <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(year(now()),month(now()),01)#">
			and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
		) as Saldo
		from SNegocios a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and ( 	select round(coalesce(sum(Dsaldo*Dtcultrev),0.00),2)
			from Documentos b
			where b.SNcodigo = a.SNcodigo
			and b.Ecodigo = a.Ecodigo
			and b.Dsaldo > 0
			and b.Dvencimiento 
			between <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(year(now()),month(now()),01)#">
			and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
		) > 0.00
		<cfif isdefined("url.orderbySNnombre")>
			order by SNnombre 
		<cfelseif isdefined("url.orderbySNnombreDesc")>
			order by SNnombre desc
		<cfelseif isdefined("url.orderbyTotal")>
			order by Total
		<cfelseif isdefined("url.orderbyTotalDesc")>
			order by Total desc
		<cfelseif isdefined("url.orderbySaldo")>
			order by Saldo
		<cfelseif isdefined("url.orderbySaldoDesc")>
			order by Saldo desc
		<cfelse>
			order by SNnombre
		</cfif>
	</cfquery>
	<cfset ListaDisplay = 1>
</cfif>
<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">
<cfparam name="PageNum_Lista" default="1">
<cfparam name="PageIndex" default="">
<cfparam name="QueryString_lista" default="">
<cfset MaxRows_Lista=10>
<cfset StartRow_Lista=Min((PageNum_Lista-1)*MaxRows_Lista+1,Max(Lista.RecordCount,1))>
<cfset EndRow_Lista=Min(StartRow_Lista+MaxRows_Lista-1,Lista.RecordCount)>
<cfset TotalPages_Lista=Ceiling(Lista.RecordCount/MaxRows_Lista)>
<cfset QueryString_lista=Iif(Len(Trim(CGI.QUERY_STRING)),DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista#PageIndex#=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>
<table width="100%"  border="0" cellspacing="2" cellpadding="0">
	<tr>
	<td>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="table_border_gray">
	<cfoutput>
		<tr>
		  <td class="smenu1" colspan="4" align="center">
			Vencimientos de Saldos de #LSMonthAsString(Month(Now()))#
		  </td>
		</tr>
		<tr>
			<td class="smenu2" align="left"><a href="##"onclick="javascript: location.href ='luke.cfm?docs&<cfif ListaDisplay eq 1><cfif isdefined("url.orderbySNnombre")>orderbySNnombreDesc<cfelse>orderbySNnombre</cfif><cfelse><cfif isdefined("url.orderbySNnombre")>orderbyDdocumentoDesc<cfelse>orderbyDdocumento</cfif></cfif>';"class="smenu2"><strong><cfif ListaDisplay eq 1>Socio<cfelse>Documento</cfif></strong></a></td>
			<td class="smenu2" align="right"><a href="##"onclick="javascript: location.href ='luke.cfm?docs&<cfif isdefined("url.orderbyTotal")>orderbyTotalDesc<cfelse>orderbyTotal</cfif>';"class="smenu2"><strong>Total</strong></a></td>
			<td class="smenu2" align="right"><a href="##"onclick="javascript: location.href ='luke.cfm?docs&<cfif isdefined("url.orderbySaldo")>orderbySaldoDesc<cfelse>orderbySaldo</cfif>';"class="smenu2"><strong>Saldo</strong></a></td>
		</tr>
		<!--- filtros --->
		<cfif ListaDisplay eq 3>
			<tr class="Areafiltro">
				<td> <input type="text" name="fDdocumento" <cfif isdefined("form.fDdocumento")>value="#form.fDdocumento#"</cfif>> </td>
				<td>  </td>
				<td align="right"> <input type="button" name="Filtrar" value="Filtrar"> </td>				
			</tr>
		</cfif>
	</cfoutput>
	<cfif ListaDisplay eq 1>
		<cfoutput query="Lista" startrow="#StartRow_Lista#" maxrows="#MaxRows_Lista#">
			<cfset LvarListaNon = (CurrentRow MOD 2)>
			<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				<td class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="left">#SNnombre#</td>
				<td class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="right"><font color="##FF0000">#LsCurrencyFormat(Total,"none")#</font></td>
				<td class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="right"><font color="##FF0000">#LsCurrencyFormat(Saldo,"none")#</font></td>
			</tr>
		</cfoutput>
	<cfelse>
		<cfset LastSNid = 0>
		<cfoutput query="Lista" startrow="#StartRow_Lista#" maxrows="#MaxRows_Lista#">
			<cfset LvarListaNon = (CurrentRow MOD 2)>
			<cfif SNid neq LastSNid>
				<cfset LastSNid = SNid>
				<tr>
					<td class="smenu4" align="left" colspan="3"><strong>#SNnombre#</strong></td>
				</tr>
			</cfif>
			<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				<td class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="left">#Ddocumento#</td>
				<td class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="right"><font color="##FF0000">#LsCurrencyFormat(Dtotal,"none")#</font></td>
				<td class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="right"><font color="##FF0000">#LsCurrencyFormat(Dsaldo,"none")#</font></td>
			</tr>
		</cfoutput>
	</cfif>
	<cfoutput>
	<tr> 
		<td align="center" colspan="4">
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
	</td>
	</tr>
</table>