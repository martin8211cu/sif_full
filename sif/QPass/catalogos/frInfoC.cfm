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
				a.QPcteDireccion,
				a.QPcteTelefono1,
				a.QPcteTelefono2,
				a.QPcteTelefonoC,
				a.QPcteCorreo,
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
					window.parent.document.form1.QPcteDireccion.value = "#rsBuscaCliente.QPcteDireccion#";
					window.parent.document.form1.QPcteTelefono1.value = "#rsBuscaCliente.QPcteTelefono1#";
					window.parent.document.form1.QPcteTelefono2.value = "#rsBuscaCliente.QPcteTelefono2#";
					window.parent.document.form1.QPcteTelefonoC.value = "#rsBuscaCliente.QPcteTelefonoC#";
					window.parent.document.form1.QPcteCorreo.value = "#rsBuscaCliente.QPcteCorreo#";
					window.parent.document.form1.QPcteid.value = "#rsBuscaCliente.QPcteid#";
					window.parent.document.form1.action="";
					window.parent.document.form1.submit();
					window.parent.document.form1.QPcteNombre.focus();
				</script>
			</cfoutput>
		</cfif>
	</cfif>
	
	<cfif not LvarBanderaWS and isdefined("rsBuscaCliente") and rsBuscaCliente.recordcount EQ 0>
		<cfoutput>
			<script language="javascript" type="text/javascript">
				window.parent.document.form1.QPcteNombre.value = "";
				window.parent.document.form1.QPcteDireccion.value = "";
				window.parent.document.form1.QPcteTelefono1.value = "";
				window.parent.document.form1.QPcteTelefono2.value = "";
				window.parent.document.form1.QPcteTelefonoC.value = "";
				window.parent.document.form1.QPcteCorreo.value = "";
				window.parent.document.form1.QPcteid.value = "";
				window.parent.document.form1.QPcteNombre.focus();
			</script>
		</cfoutput>
	</cfif>
</cfif>
