<cfif isDefined("Form.Aceptar")>
	<!--- Inserta un registro en la tabla de Parámetros --->
	<cffunction name="insertDato" >		
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="mcodigo" type="string" required="true">
		<cfargument name="pdescripcion" type="string" required="true">
		<cfargument name="pvalor" type="string" required="true">			
		<cfquery name="insDato" datasource="#Session.DSN#">
		set nocount on
			if not exists (select 1 
						from Parametros 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">) 
				begin
					insert Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
						)
				end
				else begin
					update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
				end
			set nocount off						
		</cfquery>			
		<cfreturn true>
	</cffunction>
	
	<!--- Actualiza los datos del registro según el pcodigo --->
	<cffunction name="updateDato" >					
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="pvalor" type="string" required="true">			
		<cfquery name="updDato" datasource="#Session.DSN#">
		set nocount on
			update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		set nocount off
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cftransaction>
	<cftry>	
		<cfquery name="ParametrosCG" datasource="#Session.DSN#">
		set nocount on
			<cfif isdefined("Form.Mcodigo") and Len(trim(Form.Mcodigo)) GT 0>
				update Empresas set Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfif>

			<cfif isDefined("Form.hayFormatoCuentasContables") and Len(Trim(hayFormatoCuentasContables)) GT 0>
				<cfif Form.hayFormatoCuentasContables EQ "1">
					<cfset a = updateDato(10,Form.mascara)>
 				<cfelseif Form.hayFormatoCuentasContables EQ "0">
					<cfset b = insertDato(10,'CO','Formato de Cuentas Contables',Form.mascara)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayInterfazConta") and Len(Trim(hayInterfazConta)) GT 0>
				<cfset a = insertDato(20,'GN','Interfaz con Contabilidad',Form.InterfazConta)>
			</cfif>
			
			<cfif isDefined("Form.hayPeriodo") and Len(Trim(hayPeriodo)) GT 0>
				<cfif Form.hayPeriodo EQ "1">
					<cfset a = updateDato(30,Form.periodo)>
 				<cfelseif Form.hayPeriodo EQ "0">
					<cfset b = insertDato(30,'CG','Periodo Contable',Form.periodo)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayMes") and Len(Trim(hayMes)) GT 0>
				<cfif Form.hayMes EQ "1">
					<cfset a = updateDato(40,Form.mes)>
 				<cfelseif Form.hayMes EQ "0">
					<cfset b = insertDato(40,'CG','Mes Contable',Form.mes)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayPeriodoAux") and Len(Trim(hayPeriodoAux)) GT 0>
				<cfif Form.hayPeriodoAux EQ "1">
					<cfset a = updateDato(50,Form.periodoAux)>
 				<cfelseif Form.hayPeriodoAux EQ "0">
					<cfset b = insertDato(50,'GN','Periodo Auxiliares',Form.periodoAux)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayMesAux") and Len(Trim(hayMesAux)) GT 0>
				<cfif Form.hayMesAux EQ "1">
					<cfset a = updateDato(60,Form.mesAux)>
 				<cfelseif Form.hayMesAux EQ "0">
					<cfset b = insertDato(60,'GN','Mes Auxiliares',Form.mesAux)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayMesFiscal") and Len(Trim(hayMesFiscal)) GT 0>
				<cfif Form.hayMesFiscal EQ "1">
					<cfset a = updateDato(45,Form.mesFiscal)>
 				<cfelseif Form.hayMesFiscal EQ "0">
					<cfset b = insertDato(45,'CG','Primer Mes Fiscal Contable',Form.mesFiscal)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayUsaConlis") and Len(Trim(hayUsaConlis)) GT 0>
				<cfset a = insertDato(280,'CG','¿Usa Conlis?',Form.UsaConlis)>
			</cfif>

			<cfif isDefined("Form.hayFormatoPlacas") and Len(Trim(hayFormatoPlacas)) GT 0>
				<cfif Form.hayFormatoPlacas EQ "1">
					<cfset a = updateDato(250,Form.mascaraPlacas)>
 				<cfelseif Form.hayFormatoPlacas EQ "0">
					<cfset b = insertDato(250,'AF','Formato de Máscara de Placas',Form.mascaraPlacas)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayParametrosDefinidos") and Len(Trim(hayParametrosDefinidos)) GT 0>
				<cfif Form.hayParametrosDefinidos EQ "1">
					<cfset a = updateDato(5,Form.ParametrosDefinidos)>
 				<cfelseif Form.hayParametrosDefinidos EQ "0">
					<cfset b = insertDato(5,'GN','Parametrización del Sistema ya definida',Form.ParametrosDefinidos)>
				</cfif>
			</cfif>
			
			<!--- Insercion del Socio de Negocios Generico, siempre lo hace --->
			if not exists( select 1 from SNegocios where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and SNcodigo=9999 ) begin
				insert SNegocios ( Ecodigo, SNcodigo, SNidentificacion, SNtiposocio, SNnombre, SNFecha, SNtipo, SNnumero)
					       values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							       9999,
								   '9999',         
								   'A', 
								   'Socio de Negocios Genérico', 
								   getDate(),    
								   'F', 
								   '999-9999')
			end
				
			select 1
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>
<form action="ParametrosAD.cfm" method="post" name="sql">
</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>




