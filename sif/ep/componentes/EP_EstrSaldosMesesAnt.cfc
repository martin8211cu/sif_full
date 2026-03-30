<!---
	Realizado por: Rosalba Vargas Díaz
	Fecha : 09/Junio/2014
	Motivo:	Creación de la tabla temporal para los reportes de saldos presupuestales
--->

<cfcomponent output="no">
	<cffunction name="SaldosAnteriores" access="public" output="no" returntype="array">
		<cfargument name="IDEstrPro" 	type="numeric" 	required="yes">
		<cfargument name="PerInicio" 	type="numeric" 	required="yes">
		<cfargument name="MesInicio" 	type="numeric" 	required="yes">
		<cfargument name="PerFin" 		type="numeric" 	required="yes">
		<cfargument name="MesFin" 		type="numeric" 	required="yes">
		<cfargument name="PerIniPP" 	type="numeric" 	required="yes">
		<cfargument name="MesIniPP" 	type="numeric" 	required="yes">
		<cfargument name='MonedaLoc' 	type='boolean' 	required="yes">
		<cfargument name="Mcodigo" 		type="numeric" 	required="yes">
		<cfargument name="GvarConexion" type="string"   required="yes">
        <cfargument name="PeriodoMesActual" type="string"   required="no" default="S">
        <cfargument name="TipoCta" type="string"   required="yes" default="contable"> <!---valores(contables,presupuesto)--->

        <cfset MesesAnteriores = ArrayNew(1)>

		  <cfif "#Arguments.PeriodoMesActual#" eq "S">
		  			<cfif "#Arguments.TipoCta#" eq "presupuesto">

		                    <cfinvoke returnvariable="rsEPQuery" component="sif.ep.componentes.EP_EstrSaldosPr" method="CG_EstructuraSaldo">
		                          <cfinvokeargument name="IDEstrPro"	value="#Arguments.IDEstrPro#">
		                          <cfinvokeargument name="PerInicio" 	value="#Arguments.PerInicio#">
		                          <cfinvokeargument name="MesInicio" 	value="#Arguments.MesInicio#">
		                          <cfinvokeargument name="PerFin" 	value="#Arguments.PerFin#">
		                          <cfinvokeargument name="MesFin" 	value="#Arguments.MesFin#">
		                          <cfinvokeargument name="PerIniPP" 	value="#Arguments.PerIniPP#">
		                          <cfinvokeargument name="MesIniPP" 	value="#Arguments.MesIniPP#">
		                          <cfinvokeargument name="MonedaLoc" 	value="#Arguments.MonedaLoc#">
		                          <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
		                    </cfinvoke>

		                    <cfset arrayappend(MesesAnteriores ,#rsEPQuery#)>

		            <cfelse>

		                    <cfinvoke returnvariable="rsEPQuery" component="sif.ep.componentes.EP_EstructuraRep" method="CG_EstructuraSaldo">
		                          <cfinvokeargument name="IDEstrPro"	value="#Arguments.IDEstrPro#">
		                          <cfinvokeargument name="PerInicio" 	value="#Arguments.PerInicio#">
		                          <cfinvokeargument name="MesInicio" 	value="#Arguments.MesInicio#">
		                          <cfinvokeargument name="PerFin" 		value="#Arguments.PerFin#">
		                          <cfinvokeargument name="MesFin" 		value="#Arguments.MesFin#">
		                          <cfinvokeargument name="MonedaLoc" 	value="#Arguments.MonedaLoc#">
		                          <cfinvokeargument name="Mcodigo" 		value="#Arguments.Mcodigo#">
		                          <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
		                    </cfinvoke>


		           			 <cfset arrayappend(MesesAnteriores ,#rsEPQuery#)>

		            </cfif>

			</cfif>

            <cfquery name="rsConfigMesesAnteriores" datasource="#Gvarconexion#">
                select * from CGEstrProgConfigSaldo
                where ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
            </cfquery>

			<cfquery name="rsMesCierre" datasource="#Gvarconexion#">
				select Pvalor from Parametros
				where Pcodigo = 45
				and Ecodigo = #session.Ecodigo#
			</cfquery>

            <cfloop  query="rsConfigMesesAnteriores">

					<cfif #TipoAplica# EQ "1">
						<cfset aI = rsConfigMesesAnteriores.Cant\12>
						<cfset aF = fix(rsConfigMesesAnteriores.Cant/12)>
						<cfset periodoI = Arguments.PerInicio - aI>
						<cfset periodoPI = Arguments.PerIniPP - aI>
						<cfset periodoF = Arguments.PerFin - aF>

						<cfset mesesAnt = rsConfigMesesAnteriores.Cant%12>

						<cfset mInicia =  MesInicio - mesesAnt>
						<cfset mTermina = MesFin - mesesAnt>

	                    <cfif mInicia lte 0>
	                        <cfset MesI = (12 + mInicia)>
	                    <cfelse>
	                        <cfset MesI = mInicia>
	                    </cfif>
	                    <cfif mTermina lte 0>
	                        <cfset MesF = (12 + mTermina)>
	                    <cfelse>
	                        <cfset MesF = mTermina>
	                    </cfif>


	                    <cfif "#Arguments.TipoCta#" eq "presupuesto">
					        	<cfinvoke returnvariable="rsEPQuery" component="sif.ep.componentes.EP_EstrSaldosPr" method="CG_EstructuraSaldo">
			                      <cfinvokeargument name="IDEstrPro"	value="#Arguments.IDEstrPro#">
			                      <cfinvokeargument name="PerInicio" 	value="#periodoI#">
			                      <cfinvokeargument name="MesInicio" 	value="#MesI#">
			                      <cfinvokeargument name="PerFin" 	value="#periodoF#">
			                      <cfinvokeargument name="MesFin" 	value="#MesF#">
			                      <cfinvokeargument name="PerIniPP" 	value="#periodoPI#">
			                      <cfinvokeargument name="MesIniPP" 	value="#Arguments.MesIniPP#">
			                      <cfinvokeargument name="MonedaLoc" 	value="#Arguments.MonedaLoc#">
			                      <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
			                    </cfinvoke>

			                    <cfset arrayappend(MesesAnteriores ,#rsEPQuery#)>

			            <cfelse>

								<cfinvoke returnvariable="rsEPQuery" component="sif.ep.componentes.EP_EstructuraRep" method="CG_EstructuraSaldo">
			                          <cfinvokeargument name="IDEstrPro"	value="#Arguments.IDEstrPro#">
			                          <cfinvokeargument name="PerInicio" 	value="#periodoI#">
			                      	  <cfinvokeargument name="MesInicio" 	value="#MesI#">
			                          <cfinvokeargument name="PerFin" 		value="#periodoF#">
			                          <cfinvokeargument name="MesFin" 		value="#MesF#">
			                          <cfinvokeargument name="MonedaLoc" 	value="#Arguments.MonedaLoc#">
			                          <cfinvokeargument name="Mcodigo" 		value="#Arguments.Mcodigo#">
			                          <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
			                    </cfinvoke>


			           			 <cfset arrayappend(MesesAnteriores ,#rsEPQuery#)>

			            </cfif>

	                <cfelse>
	                	<cfset Mes =  rsMesCierre.Pvalor>
	                	<cfset Periodo = (Arguments.PerInicio - rsConfigMesesAnteriores.Cant) >


	                	<cfif "#Arguments.TipoCta#" eq "presupuesto">
					        	<cfinvoke returnvariable="rsEPQuery" component="sif.ep.componentes.EP_EstrSaldosPr" method="CG_EstructuraSaldo">
			                      <cfinvokeargument name="IDEstrPro"	value="#Arguments.IDEstrPro#">
			                      <cfinvokeargument name="PerInicio" 	value="#Periodo#">
			                      <cfinvokeargument name="MesInicio" 	value="#Mes#">
			                      <cfinvokeargument name="PerFin" 	value="#Periodo#">
			                      <cfinvokeargument name="MesFin" 	value="#Mes#">
			                      <cfinvokeargument name="PerIniPP" 	value="#Periodo#">
			                      <cfinvokeargument name="MesIniPP" 	value="#Mes#">
			                      <cfinvokeargument name="MonedaLoc" 	value="#Arguments.MonedaLoc#">
			                      <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
			                    </cfinvoke>

			                    <cfset arrayappend(MesesAnteriores ,#rsEPQuery#)>

			            <cfelse>
								<cfinvoke returnvariable="rsEPQuery" component="sif.ep.componentes.EP_EstructuraRep" method="CG_EstructuraSaldo">
			                          <cfinvokeargument name="IDEstrPro"	value="#Arguments.IDEstrPro#">
			                          <cfinvokeargument name="PerInicio" 	value="#Periodo#">
			                      	  <cfinvokeargument name="MesInicio" 	value="#Mes#">
			                          <cfinvokeargument name="PerFin" 		value="#Periodo#">
			                          <cfinvokeargument name="MesFin" 		value="#Mes#">
			                          <cfinvokeargument name="MonedaLoc" 	value="#Arguments.MonedaLoc#">
			                          <cfinvokeargument name="Mcodigo" 		value="#Arguments.Mcodigo#">
			                          <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
			                    </cfinvoke>


			           			 <cfset arrayappend(MesesAnteriores ,#rsEPQuery#)>

			            </cfif>

	                </cfif>
			  </cfloop>


            <cfreturn MesesAnteriores>
	</cffunction>

</cfcomponent>

