<cfif isdefined("Form.btnGenerar")>
	<!---►►►Moneda Local◄◄◄--->	
	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select Mcodigo 
		from Empresas 
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<!---►►►Primera Conversión de Moneda de Estados Financieros B15◄◄◄--->
    <cfquery name="rsParamConversion_P" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		and Pcodigo = 3810
	</cfquery>
    <!---►►►Segunda Conversión de Moneda de Estados Financieros B15◄◄◄--->
    <cfquery name="rsParamConversion_S" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		and Pcodigo = 3900
	</cfquery>
	<!---►►►Todas las Monedas Excepto la Local◄◄◄--->
	<cfquery name="rsMonedas" datasource="#Session.DSN#">
		select Mcodigo
		  from Monedas
		where Ecodigo = #Session.Ecodigo#
		order by Miso4217
	</cfquery>
	<cftransaction>
	  <cfloop query="rsMonedas">
      	 <!---►►►Valores Insetador por el Usuario para la Primera conversión◄◄◄--->
			 <cfset compra_P   = Evaluate("form.P_TCambioC_#rsMonedas.Mcodigo#")>
             <cfset venta_P    = Evaluate("form.P_TCambioV_#rsMonedas.Mcodigo#")>
             <cfset promedio_P = Evaluate("form.P_TCambioP_#rsMonedas.Mcodigo#")>
        <!---►►►Valores Insetador por el Usuario para la Segunda conversión◄◄◄---> 
		 <cfif rsMonedas.Mcodigo EQ rsParamConversion_P.Pvalor>
         	 <cfset compra_S   = Evaluate("form.S_TCambioC_#rsMonedas.Mcodigo#")>
             <cfset venta_S    = Evaluate("form.S_TCambioV_#rsMonedas.Mcodigo#")>
             <cfset promedio_S = Evaluate("form.S_TCambioP_#rsMonedas.Mcodigo#")>
         <cfelse>
         	 <cfset compra_S   = 0>
             <cfset venta_S    = 0>
             <cfset promedio_S = 0>
         </cfif>
         
		 <!---►►►Se Elimina el Valor de los Historicos para esa Moneda/Periodo/mes, en caso de que ya existiera◄◄◄--->
         <cfquery datasource="#Session.DSN#">
            delete from HtiposcambioConversionB15
            where Ecodigo  = #Session.Ecodigo#
              and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Speriodo#">
              and Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Smes#">
              and Mcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
         </cfquery>
		 <!---►►►Inserta los nuevos tipos de cambio◄◄◄--->
		 <cfquery datasource="#Session.DSN#">
			insert into HtiposcambioConversionB15(
            	Ecodigo, Speriodo, Smes, Mcodigo, 
                TCcompra, TCventa,TCpromedio, 
                TCcompra2, TCventa2,TCpromedio2,
                BMfecha, BMUsucodigo)
			values (
				#Session.Ecodigo#, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Speriodo#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Smes#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">, 
                
				<cfqueryparam cfsqltype="cf_sql_money" value="#replace(compra_P,',','','all')#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#replace(venta_P,',','','all')#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#replace(promedio_P,',','','all')#">, 
                
                <cfqueryparam cfsqltype="cf_sql_money" value="#replace(compra_S,',','','all')#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#replace(venta_S,',','','all')#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#replace(promedio_S,',','','all')#">, 
                
				<cf_dbfunction name="now">, 
				#Session.Usucodigo#
			)
		 </cfquery> 
	</cfloop>
    <cfinvoke component="sif.Componentes.CG_EstadosFinancieros" method="CG_ConversionEF">
        <cfinvokeargument name="Periodo" 		value="#Form.Speriodo#"/>
        <cfinvokeargument name="Mes" 			value="#Form.Smes#"/>
        <cfinvokeargument name="Tipo" 			value="F"/>
    </cfinvoke> 
    <cfinvoke component="sif.Componentes.CG_EstadosFinancieros" method="CG_ConversionEF">
        <cfinvokeargument name="Periodo" 		value="#Form.Speriodo#"/>
        <cfinvokeargument name="Mes" 			value="#Form.Smes#"/>
        <cfinvokeargument name="Tipo" 			value="I"/>
    </cfinvoke> 
    </cftransaction>

<cfelseif isdefined("Form.btnActualizar")>
	<!---►►►Primera Conversión de Moneda de Estados Financieros B15◄◄◄--->
	<cfquery name="revParametros_P" datasource="#Session.DSN#">
		select Pvalor 
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 3810
	</cfquery>
    <cfif revParametros_P.recordcount EQ 1>
		<cfquery datasource="#Session.DSN#">
			update Parametros set 
				Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mcodigo_P#">,
				BMUsucodigo = #Session.Usucodigo#
			where Ecodigo = #Session.Ecodigo#
			  and Pcodigo = 3810
		</cfquery>
	<cfelse>
		<cfquery datasource="#Session.DSN#">
			insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			values (
				#Session.Ecodigo#, 
				3810, 
				'CG', 
				'Primera Conversión de Moneda de Estados Financieros B15', 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mcodigo_P#">, 
				#Session.Usucodigo#
			)
		</cfquery>
	</cfif>
    <!---►►►Segunda Conversión de Moneda de Estados Financieros B15◄◄◄--->
    <cfquery name="revParametros_S" datasource="#Session.DSN#">
		select Pvalor 
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 3900
	</cfquery>
    <cfif revParametros_S.recordcount EQ 1>
		<cfquery datasource="#Session.DSN#">
			update Parametros set 
				Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mcodigo_S#">,
				BMUsucodigo = #Session.Usucodigo#
			where Ecodigo = #Session.Ecodigo#
			  and Pcodigo = 3900
		</cfquery>
	<cfelse>
		<cfquery datasource="#Session.DSN#">
			insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			values (
				#Session.Ecodigo#, 
				3900, 
				'CG', 
				'Segunda Conversión de Moneda de Estados Financieros B15', 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mcodigo_S#">, 
				#Session.Usucodigo#
			)
		</cfquery>
	</cfif>
</cfif>

<cflocation url="ConversionEstFin_B15.cfm">