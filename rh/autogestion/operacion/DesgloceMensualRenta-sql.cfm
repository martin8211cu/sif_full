<cfif isdefined('URL.UpdDesg')>
	<script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<script>
		<cfquery name="rsIRsCal" datasource="#session.DSN#">
			 update RHDLiquidacionRenta set
			   <cfif URL.column EQ 'MontoEmpleado'>
					MontoEmpleado	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(URL.valor,',','','all')#" scale="2">,
					IGSSEmp 		 = PorcCargaSocial * (#Replace(URL.valor,',','','all')/100#),
			   <cfelseif URL.column EQ 'PorcCargaSocial'>
					PorcCargaSocial  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(URL.valor,',','','all')#" scale="2">,
					IGSSEmp 		 = MontoEmpleado   * (#Replace(URL.valor,',','','all')/100#),
					IGSSAut 		 = MontoAutorizado * (#Replace(URL.valor,',','','all')/100#),
				<cfelseif URL.column EQ 'MontoAutorizado'>
					 MontoAutorizado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(URL.valor,',','','all')#" scale="2">,
					 IGSSAut 		 = PorcCargaSocial * (#Replace(URL.valor,',','','all')/100#),
				<cfelseif URL.column EQ 'Observaciones'>
					Observaciones	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.valor#">,
			   </cfif>
					BMfechaalta 	 = <cf_dbfunction name="now">,
					BMUsucodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			 where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RHRentaId#">
			   and RHCRPTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RHCRPTid#">
			   and Periodo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.Periodo#">
			   and Mes 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.Mes#">
		   </cfquery>
		   <cfif listfind('MontoEmpleado,MontoAutorizado',URL.column)>
			  <cfquery name="rsTotales" datasource="#session.DSN#">
					select sum(coalesce(b.MontoEmpleado,0)) as MontoEmpleado,
						   sum(coalesce(b.MontoAutorizado,0)) as MontoAutorizado
					  from RHDLiquidacionRenta b 
					  where b.RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RHRentaId#">
					    and b.RHCRPTid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RHCRPTid#">
			   </cfquery>
			   <cfoutput>
					<cfif listfind('MontoEmpleado',URL.column)>
						window.parent.document.form1.TotalE.value = fm(#rsTotales.MontoEmpleado#,2,true,false,0.00);
				    <cfelseif listfind('MontoAutorizado',URL.column)>
						window.parent.document.form1.TotalA.value = fm(#rsTotales.MontoAutorizado#,2,true,false,0.00);
				    </cfif>
			   </cfoutput>
		   </cfif>
		  <cfquery name="rsIGSSEmp" datasource="#session.DSN#">
				select b.IGSSEmp, b.IGSSAut
				   from RHDLiquidacionRenta b 
				  where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RHRentaId#">
					and RHCRPTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RHCRPTid#">
					and Periodo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.Periodo#">
					and Mes 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.Mes#">
		   </cfquery>
			   	if(window.parent.document.form1.TotalIGSS_<cfoutput>#URL.Periodo##URL.Mes#</cfoutput>)
					<cfoutput>window.parent.document.form1.TotalIGSS_#URL.Periodo##URL.Mes#.value = fm(#rsIGSSEmp.IGSSEmp#,2,true,false,0.00);</cfoutput>
				if(window.parent.document.form1.TotalIGSS_AUT_<cfoutput>#URL.Periodo##URL.Mes#</cfoutput>)
					<cfoutput>window.parent.document.form1.TotalIGSS_AUT_#URL.Periodo##URL.Mes#.value = fm(#rsIGSSEmp.IGSSAut#,2,true,false,0.00);</cfoutput>
	</script>
<cfelseif isdefined('URL.UpdOrig')>
	<cfquery datasource="#session.DSN#">
    	update RHRentaOrigenes 
		<cfif url.column EQ 'NIT'>
			set NIT 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.valor#">
        <cfelseif url.column EQ 'FechaIni'>
            set FechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSPARSEDATETIME(URL.valor)#">
        <cfelseif url.column EQ 'FechaFin'>
           	set FechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSPARSEDATETIME(URL.valor)#">
        <cfelse>
            <cfthrow message="Actualización de Columna #url.column#  no implementado">
        </cfif>
        where RHROid = #url.RHROid#
    </cfquery>
</cfif>