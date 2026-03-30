<cfif isdefined("Form.CSid") and Len(Trim(Form.CSid))>

	<cfquery name="data" datasource="#Session.DSN#">
		select coalesce(RHSPfdesde, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> ) as desde,
			   coalesce(RHMPPid, 0) as RHMPPid, 
			   coalesce(RHTTid, 0) as RHTTid, 
			   coalesce(RHCid, 0) as RHCid
		from RHSolicitudPlaza
		where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
	</cfquery>

	<cfinvoke 
	 component="rh.Componentes.RH_EstructuraSalarial"
	 method="calculaComponente"
	 returnvariable="calculaComponenteRet">
		<cfinvokeargument name="CSid" value="#Form.CSid#"/>
		<cfinvokeargument name="fecha" value="#data.desde#"/>
		<cfinvokeargument name="RHMPPid" value="#data.RHMPPid#"/>
		<cfinvokeargument name="RHTTid" value="#data.RHTTid#"/>
		<cfinvokeargument name="RHCid" value="#data.RHCid#"/>
		<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
		<cfinvokeargument name="negociado" value="#LvarNegociado EQ 1#"/>
		<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
		<cfinvokeargument name="Unidades" value="1.00"/>
		<cfinvokeargument name="MontoBase" value="0.00"/>
		<cfinvokeargument name="Monto" value="0.00"/>
		<cfinvokeargument name="TablaComponentes" value="RHCSolicitud"/>
		<cfinvokeargument name="CampoLlaveTC" value="RHSPid"/>
		<cfinvokeargument name="ValorLlaveTC" value="#Form.id#"/>
		<cfinvokeargument name="CampoMontoTC" value="Monto"/>
		<cfinvokeargument name="validarNegociado" value="false"/>
	</cfinvoke>
	
	<cfset unidades = calculaComponenteRet.Unidades>
	<cfset montobase = calculaComponenteRet.MontoBase>
	<cfset monto = calculaComponenteRet.Monto>

	<cftransaction>
		<cfquery name="insertComponente" datasource="#Session.DSN#">
			insert RHCSolicitud( RHSPid, Ecodigo, CSid, Cantidad, Monto, BMfecha, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#unidades#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#monto#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
		</cfquery>
	</cftransaction>
		<!--- Recalcular todos los componentes --->
		<cfquery name="rsComp" datasource="#Session.DSN#">
			select a.RHCSid, a.CSid, a.Cantidad, a.Monto
			from RHCSolicitud a
				inner join ComponentesSalariales b
					on b.CSid = a.CSid
			where a.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			order by b.CSorden, b.CScodigo, b.CSdescripcion
		</cfquery>
			
				<cfinvoke 
				 component="rh.Componentes.RH_EstructuraSalarial"
				 method="calculaComponente"
				 returnvariable="calculaComponenteRet">
					<cfinvokeargument name="CSid" value="#rsComp.CSid#"/>
					<cfinvokeargument name="fecha" value="#data.desde#"/>
					<cfinvokeargument name="RHMPPid" value="#data.RHMPPid#"/>
					<cfinvokeargument name="RHTTid" value="#data.RHTTid#"/>
					<cfinvokeargument name="RHCid" value="#data.RHCid#"/>
					<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
					<cfinvokeargument name="negociado" value="#LvarNegociado#"/>
					<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
					<cfinvokeargument name="Unidades" value="#rsComp.Cantidad#"/>
					<cfinvokeargument name="MontoBase" value="0.00"/>
					<cfinvokeargument name="Monto" value="#rsComp.Monto#"/>
					<cfinvokeargument name="TablaComponentes" value="RHCSolicitud"/>
					<cfinvokeargument name="CampoLlaveTC" value="RHSPid"/>
					<cfinvokeargument name="ValorLlaveTC" value="#Form.id#"/>
					<cfinvokeargument name="CampoMontoTC" value="Monto"/>
				</cfinvoke>

				<cfquery datasource="#session.DSN#">
					update RHCSolicitud
					set Cantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteRet.Unidades#">,
						Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.Monto#">
					where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComp.CSid#">
				</cfquery>



	<script language="JavaScript" type="text/javascript">
		if (window.opener.document.form1) {
			if (window.opener.document.form1.reloadPage) window.opener.document.form1.reloadPage.value = "1";
			window.opener.document.form1.action = '';
			window.opener.document.form1.submit();
			window.close();
		}
	</script>
</cfif>