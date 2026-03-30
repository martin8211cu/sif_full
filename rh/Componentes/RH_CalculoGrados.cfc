<cfcomponent>
	
	<cffunction name="CalculoGrados" access="public">
		
			<cfargument 	name="Ecodigo"  		required="false" 	default="#session.Ecodigo#"	type="numeric">	<!--- Nombre del Ecodigo --->
			<cfargument 	name="Conexion"  		required="false" 	default="#session.DSN#" 	type="string">	<!--- Nombre del session --->
			<cfargument 	name="RHFid"  			required="false" 	default="-1"			 	type="numeric">	<!--- Factor --->
			<!--- Factor : si el valor es -1 Asume que se van a procesar todos los factores--->

			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="ERR_NoSePuedeRealizarElCalculoDeGradosPorQueNoEstaDefinidaLaProgresionEnParametrosGenerales"
				Default="No se puede realizar el c&aacute;lculo de grados por que no esta definida la progresi&oacute;n en par&aacute;metros generales"
				returnvariable="Error1"/>
			
			<!--- Busca en parametros de RH el valor correspondiente al tipo de Progresion --->
			
			<cfquery name="rsProgresion" datasource="#Arguments.Conexion#">
				Select Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="680">
			</cfquery>
			
			<cfif rsProgresion.recordCount EQ 0 or (isdefined("rsProgresion") and len(trim(rsProgresion.Pvalor)) EQ 0)>
				<cfthrow detail="#Error1#">
			<cfelse>
				<cfset Progresion = rsProgresion.Pvalor>
			</cfif>
			 
			 <!--- verifica si el argumento RHFid es igual a -1, si es afirmativo busca todos los factores creados para la empresa --->
			<cfquery name="rsFactores" datasource="#Arguments.Conexion#">
				select RHFid,sum(RHFponderacion) as  TRHFponderacion, sum( Puntuacion ) as Puntuacion
				from RHFactores 
				where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				<cfif isdefined("Arguments.RHFid") and Arguments.RHFid neq -1>
					and RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHFid#">
				</cfif>
				group by RHFid
			</cfquery>
			<!--- <cfif (Arguments.Conexion eq -1 and rsFactores.TRHFponderacion eq 100) or Arguments.RHFid neq -1 > --->
				<!--- hace un ciclo por factor para calcular los grados --->
				<cfset llavefactor = -1>
				<cfif rsFactores.recordCount GT 0> 
					<cfloop query="rsFactores">
						<cfset llavefactor = rsFactores.RHFid>
						<cfquery name="rsGrados" datasource="#Arguments.Conexion#">
							select RHGid from RHGrados 
							where RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llavefactor#">
							order by RHGid
						</cfquery>
						<cfif rsGrados.recordCount GT 0>
							<cfset Pmax 		  = rsFactores.Puntuacion> 				    <!---Puntos máximos  --->
							<cfset Pmin 		  = (rsFactores.Puntuacion * 0.10 )>  	    <!---Puntos mínimos  --->
							<cfset CantGrados     = rsGrados.recordCount>					<!---Cantidad grados --->
							<cfset valoranterior  = 0>										<!---puntos de grado anterior --->
							<cfset gradoActual    = 0>										<!---grado actual     --->
							<cfset valorcalculado = 0>										<!---puntos de grado actual --->
							<cfif rsGrados.recordCount eq 1>
								<!--- Como solo existe un registro se asume que grado MINIMO --->
								<cfquery name="upGrados" datasource="#Arguments.Conexion#">
									update RHGrados set RHGporcvalorfactor = <cfqueryparam cfsqltype="cf_sql_float" value="#Pmin#">
									where RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llavefactor#">
									and   RHGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrados.RHGid#">	
								</cfquery>	
							<cfelse>
								<cfloop query="rsGrados">
									<cfif rsGrados.currentRow eq 1> 
										<cfquery name="upGrados" datasource="#Arguments.Conexion#">
											update RHGrados set RHGporcvalorfactor = <cfqueryparam cfsqltype="cf_sql_float" value="#Pmin#">
											where RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llavefactor#">
											and   RHGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrados.RHGid#">	
										</cfquery>
										<cfset valoranterior  = Pmin>
									<cfelseif  rsGrados.currentRow eq rsGrados.recordCount>
										<cfquery name="upGrados" datasource="#Arguments.Conexion#">
											update RHGrados set RHGporcvalorfactor = <cfqueryparam cfsqltype="cf_sql_float" value="#Pmax#">
											where RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llavefactor#">
											and   RHGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrados.RHGid#">	
										</cfquery>
									<cfelse>
										<cfif Progresion eq 'A'>
											<cfset valorcalculado = valoranterior + ((Pmax -Pmin)/(CantGrados -1))>
										<cfelseif  Progresion eq 'G'>
											<cfset valorcalculado = valoranterior * exp(log(CantGrados -1)/(Pmax/Pmin))>
										</cfif>
										<cfquery name="upGrados" datasource="#Arguments.Conexion#">
											update RHGrados set RHGporcvalorfactor = <cfqueryparam cfsqltype="cf_sql_float" value="#valorcalculado#">
											where RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llavefactor#">
											and   RHGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrados.RHGid#">	
										</cfquery>
										<cfset valoranterior  = valorcalculado>
										<cfset valorcalculado = 0>	
									</cfif>
								</cfloop>
							</cfif>
						</cfif> 
					</cfloop>
				</cfif>
			<!--- </cfif> --->
	</cffunction>
</cfcomponent>