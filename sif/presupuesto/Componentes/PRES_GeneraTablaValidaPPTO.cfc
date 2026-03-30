<cfcomponent>

	<cffunction name="CreaTablaValPresupuesto" output="no" returntype="string" access="public">
		<cfargument name='Conexion' type='string' required='false'>
		

		<cfif not isdefined("Arguments.Conexion")>
			<cfset Arguments.Conexion = session.DSN>
		</cfif>
		<cfset LvarNombre = "ValPre_15">
    		<cfset LvarNombre1 = "ValPre_15A">


		<cfquery name="rsConfig" datasource="#Arguments.Conexion#">
			select	b.CPVid, REPLACE(b.Descripcion,' ','_') Descripcion, a.PCEcatid as Catalogo,
					a.Valor
			from CPValidacionConfiguracion a
			inner join CPValidacionValores b
				on a.CPVid = b.CPVid
			Where b.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
			
		
			
		
		<cfset arrQuery = ArrayNew(1)>

	
	
		<cfloop query="rsConfig">
			<cfswitch expression="#Valor#">
			    <cfcase value="Clasificacion">
			        <cfset ArrayAppend(arrQuery,
						"SELECT 	b.PCEcatid, f.PCCDvalor AS #Descripcion#, d.CPcuenta, d.PCDCniv, h.CPCCmascara
						FROM CPValidacionConfiguracion a
						INNER JOIN PCDCatalogo b
							ON a.PCEcatid = b.PCEcatid
							and a.Valor = 'Clasificacion'
						INNER JOIN PCDCatalogoCuentaP d
							ON d.PCEcatid = a.PCEcatid
							AND b.PCDcatid = d.PCDcatid
						INNER JOIN PCDClasificacionCatalogo e
							ON d.PCDcatid = e.PCDcatid
						INNER JOIN PCClasificacionD f
							ON e.PCCDclaid = f.PCCDclaid
						INNER JOIN CPresupuestoComprAut h
							ON d.CPcuenta = h.CPcuenta
						WHERE a.CPVid = #CPVid#")>
			    </cfcase>
			    <cfcase value="Valor">
			        <cfset ArrayAppend(arrQuery,
						"SELECT  b.PCEcatid, b.PCDvalor  AS #Descripcion#, d.CPcuenta, d.PCDCniv, h.CPCCmascara
						FROM          dbo.CPValidacionConfiguracion AS a
						INNER JOIN	dbo.PCDCatalogo AS b
							ON a.PCEcatid = b.PCEcatid
							AND a.Valor = 'Valor'
						INNER JOIN PCDCatalogoCuentaP d
							ON d.PCEcatid = a.PCEcatid
							AND b.PCDcatid = d.PCDcatid
						INNER JOIN CPresupuestoComprAut h
							ON d.CPcuenta = h.CPcuenta
						WHERE a.CPVid = #CPVid#")>
			    </cfcase>
			    <cfcase value="Referencia">
			        <cfset ArrayAppend(arrQuery,
						"SELECT  c.PCEcatid, c.PCDvalor  AS #Descripcion#, d.CPcuenta, d.PCDCniv, h.CPCCmascara
					    FROM          dbo.CPValidacionConfiguracion AS a
					    INNER JOIN dbo.PCDCatalogo AS b
							ON a.PCEcatid = b.PCEcatid
							AND a.Valor = 'Referencia'
					    INNER JOIN dbo.PCDCatalogo AS c
							ON b.PCEcatidref = c.PCEcatid
						INNER JOIN PCDCatalogoCuentaP d
							ON d.PCEcatid = c.PCEcatid
							AND c.PCDcatid = d.PCDcatid
						INNER JOIN CPresupuestoComprAut h
							ON d.CPcuenta = h.CPcuenta
						WHERE a.CPVid = #CPVid#")>
			    </cfcase>
			    <cfdefaultcase>

			    </cfdefaultcase>
			</cfswitch>

		</cfloop>


	
	
		<cfsavecontent variable="content" >
		<cfoutput>SELECT	Table#arrayLen(arrQuery)#.CPcuenta,
							Table#arrayLen(arrQuery)#.CPCCmascara,
				<cfset union = "">
				<cfloop query="rsConfig">
					<cfoutput> #union# #Descripcion# </cfoutput>
					<cfset union = ",">
				</cfloop>
				<cfset union = ",">
				<cfloop query="rsConfig">
					<cfoutput> #PreserveSingleQuotes(union)# #Descripcion# </cfoutput>
					<cfset union = "+'-'+">
				</cfloop> Grupo
				FROM </cfoutput>
		<cfloop from="1" index="i" to="#arrayLen(arrQuery)#">
			<cfoutput> (#arrQuery[i]#) AS Table#i# </cfoutput>
			<cfif i GTE 2 and i LTE arrayLen(arrQuery)>
					<cfoutput> ON Table#i#.CPcuenta = Table#i-1#.CPcuenta </cfoutput>
				</cfif>
				<cfif i GTE 1 and i LT arrayLen(arrQuery)>
					<cfoutput> INNER JOIN </cfoutput>
				</cfif>
		</cfloop>
		</cfsavecontent>
		<!---
<cf_dump var="#content#">
 --->
		<cf_dbtemp name="#LvarNombre#" returnvariable="CP_Valida_Presupuesto_NAME" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="CPcuenta" 		type="numeric"      mandatory="no">
			<cf_dbtempcol name="CPFormato" 		type="varchar(100)"      mandatory="no">
				<cfloop query="rsConfig">
				<cf_dbtempcol name="#Descripcion#"	type="varchar(25)"  mandatory="no">
				</cfloop>
			<cf_dbtempcol name="Grupo" 		type="varchar(100)"      mandatory="no">
		</cf_dbtemp>
	
		
	
<cf_dbtemp name="#LvarNombre1#" returnvariable="CP_Valida_Presupuesto_NAME1" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="CPcuenta" 		type="numeric"      mandatory="no">
			<cf_dbtempcol name="CPFormato" 		type="varchar(100)"      mandatory="no">

			<cfloop query="rsConfig">
				<cf_dbtempcol name="#Descripcion#"	type="varchar(25)"  mandatory="no">
			</cfloop>
			<cf_dbtempcol name="Grupo" 		type="varchar(100)"      mandatory="no">
		</cf_dbtemp>

		<cftry>
			<cfquery name="rsLLenaTabla" datasource="#Arguments.Conexion#">
				insert into #CP_Valida_Presupuesto_NAME#
				<cfoutput>#preservesinglequotes(content)#</cfoutput>
			</cfquery>
		<cfcatch type="any">
			<cfthrow message="Error en la configuración de validación">
		</cfcatch>
		</cftry>


        	<cfquery name="rsLLenaTabla1" datasource="#Arguments.Conexion#">
               insert into  #CP_Valida_Presupuesto_NAME1#
				select distinct * from #CP_Valida_Presupuesto_NAME#
			</cfquery>
<!---<cfdump var="#rsLLenaTabla1#" >--->
        <cfreturn CP_Valida_Presupuesto_NAME1>


	</cffunction>
	
		
	
</cfcomponent>