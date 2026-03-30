<cfinvoke component="rh.admintalento.Componentes.RH_FinalizarRelacion" method="init" returnvariable="finalizar"/>	
<cfloop list="#form.chk#" index="id">	
	<cfset finalizar.funcCalculaNota(id)>
</cfloop>
<cflocation url="evaluar_des-lista.cfm?tipo=#url.tipo#">