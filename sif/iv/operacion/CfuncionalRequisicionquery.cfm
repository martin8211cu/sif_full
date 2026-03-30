<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and len(trim(url.dato)) and isdefined("url.EcodigoRequi") and len(trim(url.EcodigoRequi))>
	<cfscript>
		LCFid = "";
		LCFcodigo  = "";
		LCFdescripcion = "";
	</cfscript>
	<cftry>
		<cfquery name="rs" datasource="#session.DSN#">
			select Ecodigo,CFid, rtrim(ltrim(CFcodigo)) as CFcodigo, CFdescripcion
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EcodigoRequi#">
			and rtrim(ltrim(upper(CFcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">			
		</cfquery>
		<cfscript>
			if (rs.Recordcount){
				if (len(rs.CFid)) LCFid = rs.CFid;
				if (len(rs.CFcodigo)) LCFcodigo = rs.CFcodigo;
				if (len(rs.CFdescripcion)) LCFdescripcion = rs.CFdescripcion;
			}
		</cfscript>
		<cfcatch>
			<script language="javascript" type="text/javascript">
				alert("<cfoutput>#cfcatch.Message#</cfoutput>");
			</script>
		</cfcatch>
	</cftry>
	<script language="JavaScript">
		var descAnt = window.parent.document.requisicion.CFdescripcion.value;
		window.parent.document.requisicion.CFidR.value="<cfoutput>#LCFid#</cfoutput>";
		window.parent.document.requisicion.CFcodigoR.value="<cfoutput>#trim(LCFcodigo)#</cfoutput>";
		window.parent.document.requisicion.CFdescripcionR.value="<cfoutput>#trim(LCFdescripcion)#</cfoutput>";		
	</script>
</cfif>