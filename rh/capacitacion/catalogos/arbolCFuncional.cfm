<!--- Este Árbol pinta 1 item y todos sus ancestros, y todos los items de la raíz --->
<!--- <cfparam name="form.CFpk" default="0" type="numeric"> --->
<!--- busqueda recursiva de los ancestros del item... se espera que los ancestros sean cuando mucho unos 4...  si son mas de 10 hay que cambiar esta solución. --->

<cfif not ( isdefined("form.CFpk") or isdefined("url.CFpk") )>
	<cfquery name="raiz" datasource="#session.DSN#" maxrows="1">
		select CFid 
		from CFuncional 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
		  and CFnivel=0 
		  order by CFpath
	</cfquery>
	<cfif len(trim(raiz.CFid))>
		<cfset url.CFpk = raiz.CFid >
	</cfif> 
</cfif>

<cfset litem = "0">
<cfset ruta  = "0">
<cfif isdefined("Form.CFpk")>
	<cfset litem = Form.CFpk>
	<cfset ruta =  Form.CFpk>
<cfelseif isdefined("url.CFpk")>
	<cfset litem = url.CFpk>
	<cfset ruta =  url.CFpk>
</cfif>
<cfset n=0>
<cfloop condition="litem neq 0 and n lt 50">
	<cfset n=n+1>
	<cfquery datasource="#session.dsn#" name="papa">
		select coalesce(CFidresp,0) as ancestro
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#litem#">
	</cfquery>
	<cfset ruta = ruta & iif(len(trim(ruta)),DE(','),DE('')) & papa.ancestro>
	<cfset litem = papa.ancestro>
</cfloop>
<cfset ruta = ruta & iif(len(trim(ruta)),DE(','),DE('')) & "0">

<!--- trae todos los items por pintar --->
<cfquery datasource="#session.dsn#" name="lista" maxrows="200">
	select c.CFid as item,
	{fn concat(rtrim(c.CFcodigo),{fn concat(' - ',c.CFdescripcion)})} as name,
	coalesce(c.CFidresp,0) as ancestro, 
		(select 
			count(*) from CFuncional h
			where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and h.CFidresp = c.CFid) as hijos
	from CFuncional c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and coalesce(CFidresp,0) in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ruta#" list="yes">)
	  and CFid != 0
	order by CFpath
</cfquery>
<cfset path=ruta>
<cfif IsDefined('form.CFpk')>
	<cfset url.ARBOL_pos = form.CFpk>
<cfelse>
	<cfset url.ARBOL_POS = ''>
</cfif>

<cfquery datasource="#session.dsn#" name="ARBOL">
	select c.CFid as pk, c.CFcodigo as codigo, c.CFdescripcion as descripcion, c.CFnivel as nivel,  
		(select count(1) from CFuncional c2
			where c2.CFidresp = c.CFid
			  and c2.Ecodigo = c.Ecodigo) AS  hijos
	from CFuncional c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and (c.CFidresp is null
	  	<cfif Len(path)>
			or c.CFidresp in (<cfqueryparam cfsqltype="cf_sql_integer" value="#path#" list="yes">)
		</cfif>
	  )
	order by c.CFpath
</cfquery>
<cfoutput>

	<style type="text/css">
	<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
	.ar1 {background-color:##D4DBF2;cursor:pointer;}
	.ar2 {background-color:##ffffff;cursor:pointer;}
	</style>
	<script type="text/javascript" language="javascript">
	<!--
	<!--- Recibe conexion, form, name y desc --->
	function Asignar(id,name,desc) {
		location.href='programas-cf.cfm?CFpk=' + escape(id);
	}
	<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
	function eovr(row){<!--- event: MouseOver --->
		row.style.backgroundColor='##e4e8f3';
	}
	function eout(row){<!--- event: MouseOut --->
		row.style.backgroundColor='##ffffff';
	}
	function eclk(arbol_pos){<!--- event: Click --->
		location.href="programas-cf.cfm?CFpk="+arbol_pos;
	}
	//-->
	</script>

	<table cellpadding="1" cellspacing="0" border="0" width="100%">
		<tr valign="middle"
				<cfif Len(url.ARBOL_POS) is 0>
				class='ar1'
				<cfelse>
				class='ar2'
				onMouseOver="eovr(this)"
				onMouseOut="eout(this)"
				onClick="eclk('')"
				</cfif> ><td nowrap colspan="1">
			<img src="/cfmx/rh/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
				Mostrar Todo
		</td></tr>
		<!--- bloque sin indentar para reducir el tamaño del HTML con listas largas de categorias --->
	<cfloop query="ARBOL">
	<tr valign="middle"	<cfif ARBOL.pk is url.ARBOL_POS> class='ar1'
	onclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"
	<cfelse>class='ar2' onMouseOver="eovr(this)"
	onMouseOut="eout(this)" <cfif ARBOL.hijos>onClick="eclk('#ARBOL.pk#')"<cfelse>onclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"</cfif>
	</cfif>
	ondblclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"
	 ><td nowrap>
	#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
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