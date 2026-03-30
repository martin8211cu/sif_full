<!--- ARBOL --->
<cfparam name="url.id_item" default="">
<cfif REFindNoCase('^[0-9]+$', url.id_item) Is 0>
	<cfset url.id_item = ''>
</cfif>
<cfset path = ''>

<!--- hacer en path una lista de ancestros --->
<cfif Len(url.id_item)>
	<cfquery datasource="asp" name="ancestros">
		select id_padre as id_item
		from SRelacionado
		where id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_item#">
	</cfquery>
	<cfset path = ValueList(ancestros.id_item)>
</cfif>

<cfset QueryString_ARBOL=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"id_item=","&")>
<cfif tempPos NEQ 0>
	<cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>
<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"id_menu=","&")>
<cfif tempPos NEQ 0>
	<cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<cfquery datasource="asp" name="ARBOL">
	select c.id_item as id_item, c.etiqueta_item as descripcion, x.profundidad as nivel,  
	       ( select count(1) 
		     from SRelacionado c2
			 where c2.id_padre = c.id_item
			   and c2.profundidad >= 1 ) as  hijos
	from SMenuItem c
		join SRelacionado x
			on c.id_item = x.id_hijo
	where x.id_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.root#">
	order by x.ruta, x.posicion
</cfquery>

<!--- /ARBOL --->

<style type="text/css">
	<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
	.ar1 {background-color:#D4DBF2;cursor:pointer;}
	.ar2 {background-color:#ffffff;cursor:pointer;}
</style>

<script language="JavaScript" type="text/javascript">
	<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
	function eovr(row){<!--- event: MouseOver --->
		row.style.backgroundColor='#e4e8f3';
	}
	function eout(row){<!--- event: MouseOut --->
		row.style.backgroundColor='#ffffff';
	}
	function eclk(id_item){<!--- event: Click --->
		location.href="SMenuItem.cfm?id_menu=<cfoutput>#form.id_menu#</cfoutput>&id_item="+id_item+"<cfoutput>#JSStringFormat(QueryString_ARBOL)#</cfoutput>";
	}
</script>

<cfoutput>
<div style="width:400px;height:350px;overflow:auto;margin-top:4px">
<table cellpadding="0" cellspacing="1" border="0" width="100%">
	<tr valign="middle" 
	    <cfif Len(url.id_item) is 0>class='ar1'
		<cfelse>class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)" onClick="eclk('')"
		</cfif> >
	
		<td nowrap>
			<img src="openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
			Mostrar Todo
		</td>
	</tr>
	<!--- bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
	<cfloop query="ARBOL">
		<tr valign="middle"	
			<cfif ARBOL.id_item is url.id_item> class='ar1'
			<cfelse>class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)" onClick="eclk('#ARBOL.id_item#')"
			</cfif> >
			<td nowrap>
				<cfif len(trim(ARBOL.nivel))>
					#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
					<cfif ARBOL.hijos and ListFind(path,ARBOL.id_item)>
						<img src="openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
					<cfelseif ARBOL.hijos>
						<img src="foldericon.png" width="16" height="16" border="0" align="absmiddle">
					<cfelse>
						<img src="file.png" width="16" height="16" border="0" align="absmiddle">
					</cfif>
					#HTMLEditFormat(Trim(ARBOL.descripcion))#
				</cfif>
			</td>
		</tr>
	</cfloop>
</table>
</div>
</cfoutput>
