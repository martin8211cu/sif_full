
<!---Validar que si el contrato es diferente al que esta en session tons eliminar la session--->
<cfif isdefined("session.saci.cambioPQ") and form.Contratoid NEQ session.saci.cambioPQ.contrato>
	<cfset StructDelete(Session.saci, "cambioPQ")>
</cfif>

<cfif isdefined("form.Verificar") or isdefined("session.saci.cambioPQ")>
	<cfif isdefined("session.saci.cambioPQ")>
		<cfif session.saci.cambioPQ.estado EQ 0>
			<cfinclude template="/saci/das/gestion/gestion-paquetes-verifica-inconsistencias.cfm">
		</cfif>
	<cfelse>
		<cfinclude template="/saci/das/gestion/gestion-paquetes-verifica-inconsistencias.cfm">
	</cfif>
</cfif>

<cfif isdefined("session.saci.cambioPQ.estado") and session.saci.cambioPQ.estado EQ 0 and isdefined("ListVerificar") and Listlen(ListVerificar)GT 0>
	<cfinclude template="/saci/das/gestion/gestion-paquetes-verificar.cfm">
<cfelse>
	<cfinclude template="/saci/das/gestion/gestion-paquetes-interfase.cfm">
</cfif>
