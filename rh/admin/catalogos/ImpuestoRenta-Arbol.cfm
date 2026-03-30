<!--- Este Archivo Crea un Arbol que Abre sus hojas haciendo Submit. El Pintado se realiza en HTML --->
<!--- Paso cero: Forma el Path y el Nivel para todos los nodos, este paso es necesario cuando las estructuras físicas,
no almacenan estos datos para cada nodo. --->

<cf_dbfunction name="string_part" args="IRdescripcion,1,30" returnvariable="LvarIRdescripcion">
<cfquery name="rsImpuestoRenta" datasource="sifcontrol">
		select 	IRcodigo, 
				IRcodigoPadre, 
                 #LvarIRdescripcion# as IRdescripcion,
				'' as IRpath, 
				'' as IRnivel, 
				(select count(1) from ImpuestoRenta IRhijos where IRhijos.IRcodigoPadre = ImpuestoRenta.IRcodigo) as IRhijos
		from ImpuestoRenta
</cfquery>

<cfloop query="rsImpuestoRenta">
		<cfset lPath = rsImpuestoRenta.IRcodigo>
		<cfset lPadre = rsImpuestoRenta.IRcodigoPadre>
		<cfset lNivel = 0>
		<cfloop condition="len(trim(lPadre))">
				<cfquery name="rsThis" dbtype="query">
					select *
					from rsImpuestoRenta
					where IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(lPadre)#">
				</cfquery>

				<cfset lPath = rsThis.IRcodigo & '\' & lPath>
				<cfset lPadre = rsThis.IRcodigoPadre>
				<cfset lNivel = lNivel + 1>
		</cfloop>
		<cfset QuerySetCell(rsImpuestoRenta,'IRpath',lPath,CurrentRow)>
		<cfset QuerySetCell(rsImpuestoRenta,'IRnivel',lNivel,CurrentRow)>
</cfloop>

<!--- <cfdump var="#rsImpuestoRenta#"> --->
<!--- Paso uno: Forma el Query para el pintado de los nodos --->
<cfset lSel = "">
<cfif isdefined("form.IRcodigo") and len(trim(form.IRcodigo))><cfset lSel = form.IRcodigo></cfif>
<cfif isdefined("url.IRcodigo") and len(trim(url.IRcodigo))><cfset lSel = url.IRcodigo></cfif>
<cfset lPadre = lSel>
<cfset lPath  = lSel>
<cfloop condition="len(trim(lPadre))">
		<cfquery name="rsThis" dbtype="query">
				select *
				from rsImpuestoRenta
				where IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(lPadre)#">
		</cfquery>
		<cfset lPath = rsThis.IRcodigo & ',' & lPath>
		<cfset lPadre = rsThis.IRcodigoPadre>
</cfloop>
<cfquery name="Arbol" dbtype="query">
		select IRcodigo as pk, IRcodigo as codigo,  IRdescripcion as descripcion, IRnivel as nivel, IRhijos as hijos
		from rsImpuestoRenta
		where IRcodigoPadre is null 
		<cfloop list="#lPath#" index="lItem">
		or IRcodigoPadre = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(lItem)#">
		</cfloop>
		order by IRpath
</cfquery>
<!--- <cfdump var="#Arbol#"> --->
<!--- Paso dos: Realiza el pintado de los nodos --->
<style type="text/css">
	<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
	.ar1 {background-color:#D4DBF2;cursor:pointer;}
	.ar2 {background-color:#ffffff;cursor:pointer;}
</style>
<script type="text/javascript" language="javascript">
	<!--//
	function asignar(ircodigo) {
		location.href="ImpuestoRenta.cfm?IRcodigo="+ircodigo;
	}
	<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
	function eovr(row){<!--- event: MouseOver --->
		row.style.backgroundColor='#e4e8f3';
	}
	function eout(row){<!--- event: MouseOut --->
		row.style.backgroundColor='#ffffff';
	}
	function eclk(ircodigo){<!--- event: Click --->
		location.href="ImpuestoRenta.cfm?IRcodigo="+ircodigo;
	}
	//-->
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	<!--- Pinta la Raíz del Árbol --->
	<tr valign="middle"
		<cfif Len(lSel) is 0>
			class='ar1'
		<cfelse>
			class='ar2'
			onMouseOver="eovr(this)"
			onMouseOut="eout(this)"
			onClick="eclk('')"
		</cfif>
	>
		<td nowrap>
			<table width="1%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td nowrap><img src="/cfmx/rh/imagenes/Web_Users.gif" width="16" height="16" border="0" align="absmiddle"></td>
				<td nowrap>Mostrar Todo</td>
			  </tr>
			</table>
		</td>
	</tr>
	
	<!--- Pinta todos los nodos de los Centros Funcionales --->
	<cfoutput query="ARBOL">
		<tr valign="middle"
			<cfif ARBOL.pk is lSel> class='ar1'
				onclick="asignar('#ARBOL.pk#')"
			<cfelse>
				class='ar2' onMouseOver="eovr(this)"
				onMouseOut="eout(this)" 
				<cfif ARBOL.hijos>
					onClick="eclk('#ARBOL.pk#')"
				<cfelse>
					onclick="asignar('#ARBOL.pk#')"
				</cfif>
			</cfif>
			ondblclick="asignar('#ARBOL.pk#')"
		>
			<td nowrap>
				#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
				<cfif ARBOL.hijos>
					<img src="/cfmx/rh/imagenes/usuario04_T.gif" width="16" height="16" border="0" align="absmiddle">
				<cfelse>
					<img src="/cfmx/rh/imagenes/usuario01_T.gif" width="16" height="16" border="0" align="absmiddle">
				</cfif>
				#HTMLEditFormat(Trim(ARBOL.codigo))# - #HTMLEditFormat(Trim(ARBOL.descripcion))#
			</td>
		</tr>
	</cfoutput>
</table>