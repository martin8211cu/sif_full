<!--- ARBOL --->
<cfparam name="url.ARBOL_POS" default="">
<cfif REFindNoCase('^[0-9]+$', url.ARBOL_POS) Is 0>
	<cfset url.ARBOL_POS = ''>
</cfif>
<cfset path = ''>
<cfset current = url.ARBOL_POS>

<cfloop from="1" to="100" index="dummy">
	<cfif Len(current) is 0><cfbreak></cfif>
	<cfset path = ListAppend(path,current)>
	<cfquery datasource="#session.dsn#" name="siguiente">
		select Ccodigopadre as padre 
		from Clasificaciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#current#">
	</cfquery>
	<cfset current = siguiente.padre>
</cfloop>
<cfif dummy ge 100> <cf_errorCode	code = "50156" msg = "Excede la cantidad de niveles."> </cfif>
<cfset QueryString_ARBOL=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_ARBOL,"ARBOL_POS=","&")>
<cfif tempPos NEQ 0>
	<cfset QueryString_ARBOL=ListDeleteAt(QueryString_ARBOL,tempPos,"&")>
</cfif>

<cfquery datasource="#session.dsn#" name="ARBOL">
	select c.Ccodigo, c.Ccodigoclas, c.Cdescripcion, coalesce(c.Cnivel,0) as nivel,  
	       ( select count(1) 
		     from Clasificaciones c2
			 where c2.Ccodigopadre = c.Ccodigo
			   and c2.Ecodigo = c.Ecodigo ) as  hijos
	from Clasificaciones c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and ( c.Ccodigopadre is null
			<cfif Len(path)>
				or c.Ccodigopadre in (<cfqueryparam cfsqltype="cf_sql_integer" value="#path#" list="yes">)
			</cfif> )
	order by c.Cpath
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
	function eclk(arbol_pos){<!--- event: Click --->
		location.href="Clasificacion.cfm?ARBOL_POS="+arbol_pos+"<cfoutput>#JSStringFormat(QueryString_ARBOL)#</cfoutput>";
	}
</script>

<cfoutput>
<div style="width:400px;height:350px;overflow:auto;margin-top:4px">
<table cellpadding="0" cellspacing="1" border="0" width="100%">
	<tr valign="middle" 
	    <cfif Len(url.ARBOL_POS) is 0>class='ar1'
		<cfelse>class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)" onClick="eclk('')"
		</cfif> >
	
		<td nowrap>
			<img src="../../js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
			Mostrar Todo
		</td>
	</tr>
	<!--- bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
	<cfloop query="ARBOL">
		<tr valign="middle"	
			<cfif ARBOL.Ccodigoclas is url.ARBOL_POS> class='ar1'
			<cfelse>class='ar2' onMouseOver="eovr(this)" onMouseOut="eout(this)" onClick="eclk('#ARBOL.Ccodigo#')"
			</cfif> >
			<td nowrap>
				<cfif len(trim(ARBOL.nivel))>
					#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
					<cfif ARBOL.hijos and ListFind(path,ARBOL.Ccodigo)>
						<img src="../../js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
					<cfelseif ARBOL.hijos>
						<img src="../../js/xtree/images/foldericon.png" width="16" height="16" border="0" align="absmiddle">
					<cfelse>
						<img src="../../js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
					</cfif>
					#HTMLEditFormat(Trim(ARBOL.Ccodigoclas))# - #HTMLEditFormat(Trim(ARBOL.Cdescripcion))#
				</cfif>
			</td>
		</tr>
	</cfloop>
</table>
</div>
</cfoutput>

