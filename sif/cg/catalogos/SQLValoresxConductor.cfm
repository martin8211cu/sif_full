<!---<cf_dump var ="#form#">--->
<cfset action = "ValoresxConductor.cfm">
<cfset params = "">

<cfif IsDefined("form.CGCvalor")>
<cfset params = AddParam(params,'CGCvalor',form.CGCvalor)>
</cfif>

<cfif IsDefined("form.cboConductor")>
<cfset params = AddParam(params,'CGCid',form.cboConductor)>
</cfif>

<cfif IsDefined("form.CGCperiodo")>
	<cfset params = AddParam(params,'CGCperiodo',form.CGCperiodo)>
</cfif>

<cfif IsDefined("form.CGCmes")>
	<cfset params = AddParam(params,'CGCmes',form.CGCmes)>
</cfif>

<cfif IsDefined("form.HDCGCMODO") and form.HDCGCMODO eq 2>

	<cfif IsDefined("form.F_PCCDclaid")>
	<cfset params = AddParam(params,'F_Catalogo',form.F_PCCDclaid)>
	</cfif>

<cfelse>

	<cfif IsDefined("form.F_PCDcatid")>
	<cfset params = AddParam(params,'F_Catalogo',form.F_PCDcatid)>
	</cfif>

</cfif>

<cfif IsDefined("form.HDCGCMODO")>
<cfset params = AddParam(params,'HDCGCMODO',form.HDCGCMODO)>
</cfif>

<cfif IsDefined("form.filter")>
	<cfset params = AddParam(params,'filter',form.filter)>
</cfif>


<cffunction name="AddParam" returntype="string">
	<cfargument name="params" type="string" required="yes">
	<cfargument name="paramname" type="string" required="yes">
	<cfargument name="paramvalue" type="string" required="yes">
	<cfset separador = iif(len(trim(arguments.params)),DE('&'),DE('?'))>
	<cfset nuevoparam = arguments.paramname & '=' & arguments.paramvalue>
	<cfreturn arguments.params & separador & nuevoparam>
</cffunction>
<!--- SQL de ValoresxConductor *** --->
<!---Alta de Un Valor *** Implica dar de Alta a un Valor para un Conductor en un periodo, mes específico --->
<cfif isdefined("form.AltaValor")>
	
	<cfquery name="rstempV" datasource="#session.dsn#">
	Select count(1) as total
	from CGParamConductores
	where Ecodigo 	 = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
	  and CGCperiodo = <cfqueryparam value="#form.CGCperiodo#" cfsqltype="cf_sql_integer">
	  and CGCmes	 = <cfqueryparam value="#form.CGCmes#" cfsqltype="cf_sql_integer">
	  and CGCid      = <cfqueryparam value="#form.cboConductor#" cfsqltype="cf_sql_numeric">
	<cfif form.HDCGCmodo eq 1>
		<!--- Catalogo --->
		and PCDcatid = <cfqueryparam value="#form.F_PCDcatid#" cfsqltype="cf_sql_numeric">
	<cfelse>
		<!--- Clasificaciones --->
		 and PCCDclaid = <cfqueryparam value="#form.F_PCCDclaid#" cfsqltype="cf_sql_numeric">
	</cfif>	
	</cfquery>
	
	<cfif rstempV.total eq 0>
	
		<cfquery name="rstemp" datasource="#session.dsn#">
			
			insert into CGParamConductores (Ecodigo, 
											CGCperiodo, 
											CGCmes, 
											CGCid, 
											PCCDclaid, 
											PCDcatid, 
											CGCvalor, 
											BMUsucodigo)		
			
			Values (
							<cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#form.CGCperiodo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#form.CGCmes#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#form.cboConductor#" cfsqltype="cf_sql_numeric">,
							<cfif form.HDCGCmodo eq 1>
								<!--- Catalogo --->
								null,
								<cfqueryparam value="#form.F_PCDcatid#" cfsqltype="cf_sql_numeric">,
							<cfelse>
								<!--- Clasificaciones --->
								<cfqueryparam value="#form.F_PCCDclaid#" cfsqltype="cf_sql_numeric">,
								null,
							</cfif>
							<cfqueryparam value="#form.CGCvalor#" cfsqltype="cf_sql_float">,
							<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				   )		
		</cfquery>
	
	<cfelse>
		<cf_errorCode	code = "50232" msg = "Ya el Conductor tiene un valor asignado para esa Clasificación/Catálogo para ese periodo,mes">
	</cfif>
	<cfset params = "">
	
<!---Cambio de un Valor *** Implica Cambiar un Valor para un conductor en un periodo y mes dados --->
<cfelseif isdefined("form.CambioValor")>
	
	 <cfquery name="rstemp" datasource="#session.dsn#">
		Delete from CGParamConductores
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
          and CGCperiodo = <cfqueryparam value="#form.CGCperiodo#" cfsqltype="cf_sql_integer"> 
          and CGCmes = <cfqueryparam value="#form.CGCmes#" cfsqltype="cf_sql_integer"> 
          and CGCid = <cfqueryparam value="#form.cboConductor#" cfsqltype="cf_sql_numeric">
		  <cfif form.HDCGCmodo eq 1>
          	and PCDcatid = <cfqueryparam value="#form.F_PCDcatid#" cfsqltype="cf_sql_numeric">
		  <cfelse>	
			and PCCDclaid = <cfqueryparam value="#form.F_PCCDclaid#" cfsqltype="cf_sql_numeric">
          </cfif>
	</cfquery>		
	<cfquery name="rstemp" datasource="#session.dsn#">
		
		insert into CGParamConductores (Ecodigo, 
										CGCperiodo, 
										CGCmes, 
										CGCid, 
										PCCDclaid, 
										PCDcatid, 
										CGCvalor, 
										BMUsucodigo)		
		
		Values (
						<cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#form.CGCperiodo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#form.CGCmes#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#form.cboConductor#" cfsqltype="cf_sql_numeric">,
						<cfif form.HDCGCmodo eq 1>
							<!--- Catalogo --->
							null,
							<cfqueryparam value="#form.F_PCDcatid#" cfsqltype="cf_sql_numeric">,
						<cfelse>
							<!--- Clasificaciones --->
							<cfqueryparam value="#form.F_PCCDclaid#" cfsqltype="cf_sql_numeric">,
							null,
						</cfif>
						<cfqueryparam value="#form.CGCvalor#" cfsqltype="cf_sql_float">,
						<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			   )		
	</cfquery>
	<cfset params = "">
<!---Baja de Un Valor *** Implica dar de Baja un Índice para todas las Categorías Clases de la Compañía (si no viene la categoría / clase)--->
<cfelseif isdefined("form.BajaValor")>
	<cfquery name="rstemp" datasource="#session.dsn#">
		delete from CGParamConductores
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and CGCperiodo = <cfqueryparam value="#Form.CGCperiodo#" cfsqltype="cf_sql_integer">
		  and CGCmes = <cfqueryparam value="#Form.CGCmes#" cfsqltype="cf_sql_integer">
          and CGCid = <cfqueryparam value="#form.cboConductor#" cfsqltype="cf_sql_numeric">
		  <cfif form.HDCGCmodo eq 1>
			  <!--- Catalogo --->
			  and PCDcatid = <cfqueryparam value="#form.F_PCDcatid#" cfsqltype="cf_sql_numeric">
		  <cfelse>
			  <!--- Clasificaciones --->
			  and PCCDclaid = <cfqueryparam value="#form.F_PCCDclaid#" cfsqltype="cf_sql_numeric">
		  </cfif>	
	</cfquery>
<!--- ******************************************************************************************************** --->		
<!--- Elimina multi-selección desde la lista --->
<cfelseif isdefined("form.BotonSel") and form.BotonSel eq "btnEliminar">
	<cftransaction action="begin">
	<cfloop collection="#Form#" item="i">
		
		<cfif FindNoCase("chkHijo_", i) NEQ 0 and Form[i] NEQ 0>
			<cfset MM_columns = ListToArray(form[i],",")>
			
			<cfif isdefined('MM_columns') and ArrayLen(MM_columns) GT 0>
				<cfset j = ArrayLen(MM_columns)>
				
				<cfloop index = "k" from = "1" to = #j#>				
				
					 <cfset LvarLista = ListToArray(MM_columns[k],"|")>
					 <cfset LvarCGCperiodo = ListToArray(LvarLista[1],"|")>
					 <cfset LvarCGCmes = ListToArray(LvarLista[2],"|")>
					 <cfset LvarCGCvalor = ListToArray(LvarLista[3],"|")>
					 <cfset LvarCGCid = ListToArray(LvarLista[4],"|")>
					 <cfset LvarCGCcid = ListToArray(LvarLista[5],"|")>
					 <cfset LvarModo = ListToArray(LvarLista[6],"|")>

					<cfquery datasource="#session.dsn#">
						delete from CGParamConductores
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and CGCperiodo = <cfqueryparam value="#LvarCGCperiodo[1]#" cfsqltype="cf_sql_integer">
						  and CGCmes = <cfqueryparam value="#LvarCGCmes[1]#" cfsqltype="cf_sql_integer">
						  and CGCid = <cfqueryparam value="#LvarCGCid[1]#" cfsqltype="cf_sql_numeric">
						  and CGCvalor = <cfqueryparam value="#LvarCGCvalor[1]#" cfsqltype="cf_sql_float">
						  <cfif LvarModo[1] eq 1>
							  <!--- Catalogo --->
							  and PCDcatid = <cfqueryparam value="#LvarCGCcid[1]#" cfsqltype="cf_sql_numeric">
						  <cfelse>
							  <!--- Clasificaciones --->
							  and PCCDclaid = <cfqueryparam value="#LvarCGCcid[1]#" cfsqltype="cf_sql_numeric">				
						  </cfif>
					</cfquery>
					
					<cfset j = j - 1>
				</cfloop>
				
				
			</cfif>
		</cfif>
		
	</cfloop>
	
	</cftransaction>
	
<!--- ******************************************************************************************************** --->	
	
<!---Alta Individual de Un Índice *** Implica dar de Alta un Índice --->
<cfelseif isdefined("form.Alta")>
	<cfquery name="rstemp" datasource="#session.dsn#">
		insert into CGParamConductores (Ecodigo, 
										CGCperiodo, 
										CGCmes, 
										CGCid, 
										PCCDclaid, 
										PCDcatid, 
										CGCvalor, 
										BMUsucodigo)		
		
		Values (
						<cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#form.CGCperiodo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#form.CGCmes#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#form.cboConductor#" cfsqltype="cf_sql_numeric">,
						<cfif form.HDCGCmodo eq 1>
							<!--- Catalogo --->
							null,
							<cfqueryparam value="#form.F_PCDcatid#" cfsqltype="cf_sql_numeric">,
						<cfelse>
							<!--- Clasificaciones --->
							<cfqueryparam value="#form.F_PCCDclaid#" cfsqltype="cf_sql_numeric">,
							null,
						</cfif>
						<cfqueryparam value="#form.CGCvalor#" cfsqltype="cf_sql_float">,
						<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			   )		
	</cfquery>
	<cfset params = AddParam(params,'CGCmes',form.CGCmes)>
<!---Cambia Individual  de Un Valor *** Implica dar CAMBIO a un Valor --->
<cfelseif isdefined("form.Cambio")>

	<cfquery name="rstemp" datasource="#Session.DSN#">

		update CGParamConductores set 
			CGCvalor = <cfqueryparam value="#Form.CGCvalor#" cfsqltype="cf_sql_float">
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and CGCperiodo = <cfqueryparam value="#Form.CGCperiodo#" cfsqltype="cf_sql_integer">
		  and CGCmes = <cfqueryparam value="#Form.CGCmes#" cfsqltype="cf_sql_integer">
		  and CGCid = <cfqueryparam value="#Form.cboConductor#" cfsqltype="cf_sql_numeric">
		  <cfif form.HDCGCmodo eq 1>
			  <!--- Catalogo --->
			  and PCDcatid = <cfqueryparam value="#form.F_PCDcatid#" cfsqltype="cf_sql_numeric">,
		  <cfelse>
			  <!--- Clasificaciones --->
			  and PCCDclaid = <cfqueryparam value="#form.F_PCCDclaid#" cfsqltype="cf_sql_numeric">,				
		  </cfif>	
		  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)

	</cfquery>	  
	<cfset params = AddParam(params,'CGCmes',form.CGCmes)>
<!---Baja Individual  de Un Valor *** Implica dar de BAJA a un Valor --->
<cfelseif isdefined("form.Baja")>

	<cfquery name="rstemp" datasource="#session.dsn#">
		delete from CGParamConductores
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and CGCperiodo = <cfqueryparam value="#Form.CGCperiodo#" cfsqltype="cf_sql_integer">
		  and CGCmes = <cfqueryparam value="#Form.CGCmes#" cfsqltype="cf_sql_integer">
		  and CGCid = <cfqueryparam value="#form.cboConductor#" cfsqltype="cf_sql_numeric">
		  <cfif form.HDCGCmodo eq 1>
			  <!--- Catalogo --->
			  and PCDcatid = <cfqueryparam value="#form.F_PCDcatid#" cfsqltype="cf_sql_numeric">,
		  <cfelse>
			  <!--- Clasificaciones --->
			  and PCCDclaid = <cfqueryparam value="#form.F_PCCDclaid#" cfsqltype="cf_sql_numeric">,				
		  </cfif>		
	</cfquery>
	<cfset params = AddParam(params,'CGCmes',form.CGCmes)>

<cfelseif isdefined("form.BOTONSELVALOR") and form.BOTONSELVALOR eq "NuevoValor">
	<cfset params = "">
</cfif>

<cfset params = trim(params)>

<cflocation url="#action##params#">

