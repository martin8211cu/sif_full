<script language="javascript1.2" type="text/javascript">
	window.parent.document.form1.fid_direccion.length = 0;
</script>
<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) >
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="data_direcciones" datasource="#session.DSN#">
		select b.id_direccion, c.direccion1 #_Cat# ' / ' #_Cat# c.direccion2 as direccion
		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#"> 
	</cfquery>
	<cfif data_direcciones.recordcount gt 0 >
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			var combo = window.parent.document.form1.fid_direccion;
			combo.length = 0;
			combo.length++;
			combo.options[0].value = '';
			combo.options[0].text = '- Todos -';	
			
			<cfloop query="data_direcciones">
				combo.length++;
				combo.options[combo.length-1].value = '#trim(data_direcciones.id_direccion)#';
				combo.options[combo.length-1].text = '#JSStringFormat(data_direcciones.direccion)#';	
			</cfloop>
		</script>
		</cfoutput>		
	</cfif>
</cfif>