<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario = url.formulario>
<cfelse>	
	<cfset form.formulario = form1>
</cfif>

<cfif isdefined("url.codigo") and len(trim(url.codigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select Mcodigo, Mnombre, Msiglas
		from RHMateria
		where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_integer">
			and upper(Msiglas) like '%#UCase(url.codigo)#%'
	</cfquery>	
	
	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		<cfif rs.recordCount gt 0>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Mcodigo.value = '#rs.Mcodigo#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Mnombre.value = '#rs.Mnombre#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Msiglas.value = '#rs.Msiglas#';
		<cfelse>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Mcodigo.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Mnombre.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Msiglas.value = '';
		</cfif>
		</cfoutput>
	</script>
<cfelse>		
		<script language="javascript1.2" type="text/javascript">
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Mcodigo.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Mnombre.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Msiglas.value = '';
		</script>
</cfif>



