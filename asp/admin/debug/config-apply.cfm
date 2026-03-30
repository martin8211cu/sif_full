<cfif IsDefined('form.btnActivar')>
	<cfparam name="form.activa_horas" type="numeric">
	<cfset expira = DateAdd('h', form.activa_horas, Now())>
	<cfinvoke component="home.Componentes.Politicas"
		method="modifica_parametro_global" parametro="debug.expira" valor="#expira#"/>
	<cfinvoke component="home.Componentes.DebugLogger" method="install"/>
<cfelseif IsDefined('form.btnInactivar')>
	<cfinvoke component="home.Componentes.Politicas"
		method="modifica_parametro_global" parametro="debug.expira" valor=""/>
<cfelse>
	<cfthrow message="Opción inválida">
</cfif>