<!---Metodos por calculo y regla--->
<cfif isdefined("Form.CSid") and Len(Trim(Form.CSid))>
	<cfquery name="data" datasource="#Session.DSN#">
		select fdesdeplaza as desde,
        		fhastaplaza as hasta,
			   coalesce(RHMPPid, 0) as RHMPPid, 
			   coalesce(RHTTid, 0) as RHTTid, 
			   coalesce(RHCid, 0) as RHCid,
               coalesce(RHEid, 0) as RHEid 
		from RHSituacionActual
		where RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
	</cfquery>
    <cfif form.CSusatabla eq 2>
    	<cfset lvarVariables = StructNew()>
        <cfset StructInsert(lvarVariables,"Antig0",form.agnos)>
        <cfset StructInsert(lvarVariables,"Antig1",form.agnos)>
        <cfset StructInsert(lvarVariables,"Antig2",form.agnos)>
        <cfset StructInsert(lvarVariables,"Antig3",form.agnos)>
        <cfset StructInsert(lvarVariables,"categoriaEmp",form.RHCcodigo)>
    </cfif>
	<cfinvoke 
	 component="rh.Componentes.RH_EstructuraSalarial"
	 method="calculaComponente"
	 returnvariable="calculaComponenteRet">
		<cfinvokeargument name="CSid" value="#Form.CSid#"/>
		<cfinvokeargument name="fecha" value="#data.desde#"/>
        <cfinvokeargument name="fechah" value="#data.hasta#"/>
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
        <cfif form.CSusatabla eq 2>
        	<cfinvokeargument name="DEid" value="-1"/>
        	<cfinvokeargument name="FijarVariable" value="#lvarVariables#"/>
        </cfif>
        <cfinvokeargument name="TablaSalarial" value="E"/>
        <cfinvokeargument name="Escenario" value="#data.RHEid#"/>
	</cfinvoke>

	<cfset unidades = calculaComponenteRet.Unidades>
	<cfset montobase = calculaComponenteRet.MontoBase>
	<cfset monto = calculaComponenteRet.Monto>
	<cftransaction>
		<cfquery name="rsComplemento" datasource="#session.DSN#">
			select CScomplemento
			from ComponentesSalariales
			where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">
		</cfquery>
		<cfquery name="insertComponente" datasource="#Session.DSN#">
			insert RHCSituacionActual( RHSAid, Ecodigo, CSid, Cantidad, Monto, CFformato,BMfecha, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#unidades#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#monto#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsComplemento.CScomplemento#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
		</cfquery>

	</cftransaction>

	<script language="JavaScript" type="text/javascript">
		<cfoutput>
		if (window.opener.document.#form.formName#) {
			if (window.opener.document.#form.formName#.reloadPage) window.opener.document.#form.formName#.reloadPage.value = "1";
			window.opener.document.#form.formName#.action = '';
			window.opener.document.#form.formName#.submit();
			window.close();
		}
		</cfoutput>
	</script>
</cfif>
