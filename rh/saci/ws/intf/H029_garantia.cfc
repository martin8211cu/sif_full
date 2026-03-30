<cfcomponent hint="Obtiene información sobre el depósito de garantía. Ver SACI-03-H029.doc" extends="base">

	<cffunction name="buscaDeposito" returntype="struct" output="false">
		<cfargument name="SERCLA" type="string" required="yes" hint="Identificación del  login (ISBlogin.LGlogin)">
		<cfargument name="CLTCED" type="string" required="yes" hint="Cédula del Cliente (ISBpersona.Pid)">
		<cfargument name="CINCAT" type="numeric" required="yes" hint="Categoría del Servicio (ISBpaquete.CINCAT)">
		<cfargument name="origen" type="string" default="saci">
		
		<cfset control_inicio( Arguments, 'H029', Arguments.CLTCED & ' - '  & Arguments.SERCLA & ' - ' & Arguments.CINCAT )>
		<cftry>
			<cfset control_servicio( 'siic' )>
			
  <!---select Monto = @fMontoDep, Moneda = @cDXSMOD,  PermiteCargoFijo = @cPermiteCobroCF--->
  
			
			<cfquery datasource="SACISIIC" name="buscaDeposito_q">
				exec dg011_Busca_Deposito_Login
					@cSERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SERCLA#" null="#Len(Arguments.SERCLA) is 0#">,
					@vCLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CLTCED#" null="#Len(Arguments.CLTCED) is 0#">,
					@iCINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CINCAT#" null="#Len(Arguments.CINCAT) is 0#">,
					@fMontoDep = 0
			</cfquery>
			<cfquery datasource="SACISIIC" name="tipoCambio_q">
				exec sp_CambioDolar
			</cfquery>
			<cfif buscaDeposito_q.RecordCount is 0>
				<cfthrow message="El procedimiento almacenado no regresó resultados" errorcode="SIC-0010">
			</cfif>
			<cfif tipoCambio_q.RecordCount is 0>
				<cfthrow message="El procedimiento almacenado no regresó resultados" errorcode="SIC-0010">
			</cfif>
			<cfset ret = StructNew()>
			<cfset ret.monto = buscaDeposito_q.Monto>
			<cfset ret.moneda = buscaDeposito_q.Moneda>
			<cfset ret.permitecargofijo = buscaDeposito_q.PermiteCargoFijo>
			<cfset ret.tipoCambio = tipoCambio_q.Computed_Column_1>
			<!--- convertir la moneda a ISO--->
			<cfif (ret.moneda is 'C') Or (ret.monto is 0 And Len(ret.moneda) is 0)>
				<cfset ret.moneda = 'CRC'>
			<cfelseif ret.moneda is 'D'>
				<cfset ret.moneda = 'USD'>
			<cfelseif Len(ret.moneda) is 0>
				<cfthrow message="El procedimiento de depósito no regresó moneda" errorcode="SIC-0010">
			<cfelse>
				<cfthrow message="Moneda desconocida: #buscaDeposito_q.Computed_Column_2#" errorcode="SIC-0010">
			</cfif>
			<!--- si la moneda no es USD (entonces es CRC), darle vuelta al tipo de cambio --->
			<cfif ret.moneda is'CRC' and ret.tipoCambio neq 0>
				<cfset ret.tipoCambio = 1 / ret.tipoCambio>
			</cfif>
			<cfset control_final( )>
			<cfreturn ret>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfrethrow>
		</cfcatch>
		</cftry>		
	</cffunction>
</cfcomponent>
