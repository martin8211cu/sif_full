<cfset litem = "0">
<cfset ruta  = "0">
<cfoutput>
<cfif isdefined("Form.RHCid")>
	<cfset litem = Form.RHCid>
	<cfset ruta =  Form.RHCid>
<cfelseif isdefined("url.RHCid")>
	<cfset litem = url.RHCid>
	<cfset ruta =  url.RHCid>
</cfif>
<cfset n=0>
<cfloop condition="litem neq 0 and n lt 50">
	<cfset n=n+1>
	<cfquery datasource="#session.dsn#" name="papa">
		select coalesce(RHCidpadre,0) as ancestro
		from RHCategoria
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#litem#">
	</cfquery>
	<cfset ruta = ruta & iif(len(trim(ruta)),DE(','),DE('')) & papa.ancestro>
	<cfset litem = papa.ancestro>
</cfloop>
<cfset ruta = ruta & iif(len(trim(ruta)),DE(','),DE('')) & "0">

<!--- trae todos los items por pintar --->
<cf_translatedata name="get" tabla="RHCategoria" col="c.RHCdescripcion" returnvariable="LvarRHCdescripcion">
<cfquery datasource="#session.dsn#" name="lista" maxrows="200">
	select c.RHCid as item, <cf_dbfunction name="concat" args="rtrim(c.RHCcodigo)°' - '°#LvarRHCdescripcion#" delimiters="°"> as name, coalesce(c.RHCidpadre,0) as ancestro, 
		(select 
			count(*) from RHCategoria h
			where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and h.RHCidpadre = c.RHCid) as hijos
	from RHCategoria c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and coalesce(RHCidpadre,0) in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ruta#" list="yes">)
	  and RHCid != 0
	order by path
</cfquery>
<cfset path=ruta>
<cfif IsDefined('form.RHCid')>
	<cfset url.ARBOL_pos = form.RHCid>
<cfelse>
	<cfset url.ARBOL_POS = ''>
</cfif>

<cf_translatedata name="get" tabla="RHCategoria" col="c.RHCdescripcion" returnvariable="LvarRHCdescripcion">
<cfquery datasource="#session.dsn#" name="ARBOL">
	select c.RHCid as pk, c.RHCcodigo as codigo, #LvarRHCdescripcion# as descripcion, c.nivel as nivel,  
		(select count(1) from RHCategoria c2
			where c2.RHCidpadre = c.RHCid
			  and c2.Ecodigo = c.Ecodigo) AS  hijos
	from RHCategoria c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and (c.RHCidpadre is null
	  	<cfif Len(path)>
			or c.RHCidpadre in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#path#" list="yes">)
		</cfif>
	  )
	order by c.path
</cfquery>
	<style type="text/css">
	<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
	.ar1 {background-color:##D4DBF2;cursor:pointer;}
	.ar2 {background-color:##ffffff;cursor:pointer;}
	</style>
	<script type="text/javascript" language="javascript">
	<!--
	<!--- Recibe conexion, form, name y desc --->
	function Asignar(id,name,desc) {
		location.href='RHCategoria.cfm?RHCid=' + escape(id);
	}
	<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
	function eovr(row){<!--- event: MouseOver --->
		row.style.backgroundColor='##e4e8f3';
	}
	function eout(row){<!--- event: MouseOut --->
		row.style.backgroundColor='##ffffff';
	}
	function eclk(arbol_pos){<!--- event: Click --->
		location.href="RHCategoria.cfm?RHCid="+arbol_pos;
	}
	//-->
	</script>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MostrarTodo" Default="Mostrar todo" XmlFile="/rh/generales.xml" returnvariable="LB_MostrarTodo"/>


	<table cellpadding="1" cellspacing="0" border="0" width="100%">
		<tr valign="middle"
				<cfif Len(url.ARBOL_POS) is 0>
				class='ar1'
				<cfelse>
				class='ar2'
				onMouseOver="eovr(this)"
				onMouseOut="eout(this)"
				onClick="eclk('0')"
				</cfif> ><td nowrap colspan="1">
				<img src="/cfmx/rh/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
				<cfoutput>#LB_MostrarTodo#</cfoutput>
		</td></tr>
		<!--- bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
		<cfloop query="ARBOL">
			<tr valign="middle"	<cfif ARBOL.pk is url.ARBOL_POS> class='ar1'
			onclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"
			<cfelse>class='ar2' onMouseOver="eovr(this)"
			onMouseOut="eout(this)" <cfif ARBOL.hijos>onClick="eclk('#ARBOL.pk#')"<cfelse>onclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"</cfif>
			</cfif>
			ondblclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')">
				<td nowrap>
					<cfif isdefined ('ARBOL.nivel') and len(trim(ARBOL.nivel)) gt 0>
					#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
					</cfif>
					<cfif ARBOL.hijos and ListFind(path,ARBOL.pk)>
						<img src="/cfmx/rh/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
					<cfelseif ARBOL.hijos>
						<img src="/cfmx/rh/js/xtree/images/foldericon.png" width="16" height="16" border="0" align="absmiddle"> 
					<cfelse>
						<img src="/cfmx/rh/js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
					</cfif>
					#HTMLEditFormat(Trim(ARBOL.codigo))# - #HTMLEditFormat(Trim(ARBOL.descripcion))#
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>

