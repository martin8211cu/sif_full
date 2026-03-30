<cfif form.rol NEQ 'DAS'><!---Esta condicion es por ahora, pues el cambio de password solo se esta admitiendo para el cliente--->
	<cfif IsDefined('url.ok') and url.ok eq 1>
		<cfinclude template="/home/menu/micuenta/usuario-form5ok.cfm">
	<cfelse>
		<form method="post" name="f" action="gestion-cambioPasswords-apply.cfm" onSubmit="return valida(this, &quot;# HTMLEditFormat( JSStringFormat(session.usuario)) #&quot;);" >
		 <cfinclude template="gestion-hiddens.cfm">
		 <cfinclude template="/home/menu/micuenta/usuario-form5ch-inter.cfm">
		</form>
	</cfif>
</cfif>




