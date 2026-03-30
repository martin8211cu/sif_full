<cfquery name="rsJerarquia" datasource="#Session.DSN#">
	select rtrim(c.CFpath) as CFpath , a.RHPcodigo 
	from LineaTiempo a
	
	inner join RHPlazas b
	on a.Ecodigo = b.Ecodigo
	and a.RHPid = b.RHPid
	
	inner join CFuncional c
	on b.Ecodigo = c.Ecodigo
	and b.CFid = c.CFid
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between a.LTdesde and a.LThasta
</cfquery>
<cfoutput>
<cfif isdefined("rsJerarquia.CFpath") and Len(Trim(rsJerarquia.CFpath))>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_VerPerfilDelPuesto"
	Default="Descriptivo del Puesto"
	returnvariable="LB_VerPerfilDelPuesto"/> 

	<cf_boton index="2"  texto="#LB_VerPerfilDelPuesto#" funcion="Trae_descriptivo('#rsJerarquia.RHPcodigo#')" estilo="8" size="200">
	<cfset centros = ListToArray(rsJerarquia.CFpath, '/')>
	<table cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="#ArrayLen(centros)+1#" align="center" style="border-bottom: 1px solid black; "><strong><cf_translate key="JerarquiaDeLaPlaza">Jerarqu&iacute;a de la Plaza</cf_translate></strong></td>
	</tr>
	<cfloop from="1" to="#ArrayLen(centros)#" index="i">
		<cfquery name="rsCentroFuncional" datasource="#Session.DSN#">
			select 
			{fn concat(rtrim(CFcodigo),{fn concat(' - ',CFdescripcion)})} as centro
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#centros[i]#">
		</cfquery>
		<tr>
			<td colspan="#i#" align="right">
				<img src="/cfmx/rh/js/xtree/images/L.png" border="0">
			</td>
			<td colspan="#(ArrayLen(centros)+1)-i#">
				<cfif i EQ ArrayLen(centros)>
				<strong>#rsCentroFuncional.centro#</strong>
				<cfelse>
				#rsCentroFuncional.centro#
				</cfif>
			</td>
		</tr>
	</cfloop>
	<tr>
	<cfloop from="1" to="#ArrayLen(centros)#" index="i">
		<td>&nbsp;</td>
	</cfloop>
	</tr>
	</table>
</cfif>
</cfoutput>

<script language="javascript" type="text/javascript">
	function Trae_descriptivo(valor){
		var PARAM  = "/cfmx/rh/admin/catalogos/PopupReporteP.cfm?imprimir=1&RHPcodigo="+ valor
		open(PARAM,'','left=25,top=100,scrollbars=yes,resizable=yes,width=975,height=600')

	}
</script>