<!--- LIMPIA EL COMBO --->
<script language="javascript1.2" type="text/javascript">
	window.parent.document.form1.id_direccionEnvio.options.length = 1;
	window.parent.document.form1.existenDocumentos.value = '#trim(rsExisten.total)#';
</script>

<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
	<cfquery name="data" datasource="#session.dsn#">
		select a.SNcuentacxc as Ccuenta, b.Cmayor, b.Cdescripcion, b.Cformato
		from SNegocios a, CContables b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#" >
		  and a.SNcuentacxc=b.Ccuenta
	</cfquery>
	
	<cfif data.recordcount gt 0>
		<cfset formato = mid(data.Cformato, len(data.Cmayor)+2, len(data.Cformato)) >
		<script language="javascript1.2" type="text/javascript">
			<cfoutput>
			window.parent.document.form1.id_direccionEnvio.focus();
			window.parent.document.form1.cmayor2.value = '#trim(data.Cmayor)#';
			window.parent.document.form1.Cformato2.value = '#trim(formato)#';
			window.parent.document.form1.Cfdescripcion2.value = '#trim(data.Cdescripcion)#';
			window.parent.document.form1.Ccuenta2.value = '#data.Ccuenta#';
			</cfoutput>
		</script>
	</cfif>

	<!--- llena el combo de direcciones --->
    <cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="data" datasource="#session.DSN#">
		select b.id_direccion, c.direccion1 #_Cat# ' / ' #_Cat# c.direccion2 as texto_direccion
		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#" >
	</cfquery>

	<cfif data.recordcount gt 0>
		<script language="javascript1.2" type="text/javascript">
			var i = 0;
			<cfoutput query="data">
				window.parent.document.form1.id_direccionEnvio.options.length += 1;
				i = window.parent.document.form1.id_direccionEnvio.options.length;
				window.parent.document.form1.id_direccionEnvio.options[i-1].value = '#JSStringFormat(data.id_direccion)#';
				window.parent.document.form1.id_direccionEnvio.options[i-1].text = '#JSStringFormat(data.texto_direccion)#';
			</cfoutput>
		
		
		
		</script>
	</cfif>

	<!--- Revisa la bitacora, para ver si hay documentos con el mismo socio en estado 0  --->
	<cfquery name="rsExisten" datasource="#session.DSN#">
		select count(1) as total
		from RCBitacora
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#" >
		  and RCBestado = 0
	</cfquery>
	<cfif rsExisten.recordcount gt 0 >
		<script language="javascript1.2" type="text/javascript">
			window.parent.document.form1.existenDocumentos.value = '<cfoutput>#trim(rsExisten.total)#</cfoutput>';
		</script>
	</cfif>
</cfif>