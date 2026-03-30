	
	
<cfif isdefined("url.NUP")>	
	<cfquery name="rsGetNUP" datasource="#session.DSN#">
		select DEidentificacion, DEnombre, DEapellido1,DEapellido2
		from  DatosEmpleado 
		where Ecodigo = #session.Ecodigo# 
		and upper(rtrim(ltrim(NUP))) = '#ucase(trim(url.NUP))#'
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
	</cfquery>
	<cfif rsGetNUP.RecordCount gt 0 >
		
		<label style="color:#FF0000; font-family:Arial, Helvetica, sans-serif; font-style:normal; font-size:11px">NUP replicado: <br> <cfoutput>#rsGetNUP.DEidentificacion# -#rsGetNUP.DEnombre# #rsGetNUP.DEapellido1# #rsGetNUP.DEapellido2#</cfoutput></label>	
		<script language="javascript" type="text/javascript">
			<cfif url.modo eq 'ALTA'>
				window.parent.document.formDatosEmpleado.Alta.disabled=true;
			<cfelse>
				window.parent.document.formDatosEmpleado.Cambio.disabled=true;
			</cfif>
		
		</script>
		
	<cfelse>
		<script language="javascript" type="text/javascript">
			<cfif url.modo eq 'ALTA'>
				window.parent.document.formDatosEmpleado.Alta.disabled=false;
			<cfelse>
				window.parent.document.formDatosEmpleado.Cambio.disabled=false;
			</cfif>
		</script>
	</cfif>
</cfif>
<cfif isdefined("url.NIT")>	

	<cfquery name="rsGetNIT" datasource="#session.DSN#">
		select DEidentificacion, DEnombre, DEapellido1,DEapellido2
		from  DatosEmpleado 
		where Ecodigo = #session.Ecodigo# 
		and upper(rtrim(ltrim(NIT))) = '#ucase(trim(url.NIT))#'
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
	</cfquery>
	<cfif rsGetNIT.RecordCount gt 0 >
		
		<label style="color:#FF0000; font-family:Arial, Helvetica, sans-serif; font-style:normal; font-size:11px">NIT replicado: <br> <cfoutput>#rsGetNIT.DEidentificacion# -#rsGetNIT.DEnombre# #rsGetNIT.DEapellido1# #rsGetNIT.DEapellido2#</cfoutput></label>
		<script language="javascript" type="text/javascript">
			<cfif url.modo eq 'ALTA'>
				window.parent.document.formDatosEmpleado.Alta.disabled=true;
			<cfelse>
				window.parent.document.formDatosEmpleado.Cambio.disabled=true;
			</cfif>
		
		</script>
		
	<cfelse>
		<script language="javascript" type="text/javascript">
			<cfif url.modo eq 'ALTA'>
				window.parent.document.formDatosEmpleado.Alta.disabled=false;
			<cfelse>
				window.parent.document.formDatosEmpleado.Cambio.disabled=false;
			</cfif>
		</script>
	</cfif>
</cfif>

<cfif isdefined("url.DEtarjeta")>	

	<cfquery name="rsGetTarjeta" datasource="#session.DSN#">
		select DEidentificacion, DEnombre, DEapellido1,DEapellido2
		from  DatosEmpleado 
		where Ecodigo = #session.Ecodigo# 
		and upper(rtrim(ltrim(DEtarjeta))) = '#ucase(trim(url.DEtarjeta))#'
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
	</cfquery>
	<cfif rsGetTarjeta.RecordCount gt 0 >
		
		<label style="color:#FF0000; font-family:Arial, Helvetica, sans-serif; font-style:normal; font-size:11px">ID Tarjeta replicada: <br> <cfoutput>#rsGetTarjeta.DEidentificacion# -#rsGetTarjeta.DEnombre# #rsGetTarjeta.DEapellido1# #rsGetTarjeta.DEapellido2#</cfoutput></label>
		<script language="javascript" type="text/javascript">
			<cfif url.modo eq 'ALTA'>
				window.parent.document.formDatosEmpleado.Alta.disabled=true;
			<cfelse>
				window.parent.document.formDatosEmpleado.Cambio.disabled=true;
			</cfif>
		
		</script>
		
	<cfelse>
		<script language="javascript" type="text/javascript">
			<cfif url.modo eq 'ALTA'>
				window.parent.document.formDatosEmpleado.Alta.disabled=false;
			<cfelse>
				window.parent.document.formDatosEmpleado.Cambio.disabled=false;
			</cfif>
		</script>
	</cfif>
</cfif>




