<cfif isdefined("url.CTEidentificacion") and isdefined("url.CTEtipo")>
	<cfif len(trim(url.CTEidentificacion)) eq 0>
		<cfset url.CTEidentificacion = -1>
	</cfif>

	<cfif len(trim(url.CTEtipo)) eq 0>
		<cfset url.CTEtipo = -1>
	</cfif>

	<cfset LvarBanderaWS = false>

	<cfif not LvarBanderaWS>

		<cfquery name="rsBuscaCliente" datasource="#session.dsn#">
			select distinct
				a.QPcteid,
				a.QPcteDocumento,
				a.QPcteNombre,
				a.QPcteDireccion,
				a.QPcteTelefono1,
				a.QPcteTelefono2,
				a.QPcteTelefonoC,
				a.QPcteCorreo
			from QPcliente a
				inner join QPtipoCliente b
				on b.QPtipoCteid = a.QPtipoCteid
			where a.Ecodigo = #session.Ecodigo#
			and a.QPtipoCteid = #url.CTEtipo#
			and a.QPcteDocumento = '#url.CTEidentificacion#'		
		</cfquery>
	
		<cfif rsBuscaCliente.recordcount gt 0>
			<cfoutput>
			<script language="javascript" type="text/javascript">
					window.parent.document.form1.QPcteNombre.value = "#rsBuscaCliente.QPcteNombre#";
					window.parent.document.form1.QPcteNombre.focus();
				</script>
			</cfoutput>
		</cfif>

	</cfif>
	<cfif not LvarBanderaWS and isdefined("rsBuscaCliente") and rsBuscaCliente.recordcount EQ 0>
		<cfoutput>
			<script language="javascript" type="text/javascript">
				window.parent.document.form1.QPcteNombre.value = "";
				window.parent.document.form1.QPcteNombre.focus();
			</script>
		</cfoutput>
	</cfif>
</cfif>
