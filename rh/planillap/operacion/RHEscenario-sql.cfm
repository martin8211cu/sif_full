<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into RHEscenarios( Ecodigo, 
										  RHGEid, 
										  RHEdescripcion, 
										  RHEobs, 
										  RHEidorigen, 
										  RHEfdesde, 
										  RHEfhasta, 
										  BMfecha, 
										  BMUsucodigo, 
										  CPPid,
										  RHEtipo )
					values ( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
							<cfif isdefined("Form.RHGEid") and len(trim(Form.RHGEid))><cfqueryparam value="#Form.RHGEid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
							<cfqueryparam value="#Form.RHEdescripcion#" cfsqltype="cf_sql_varchar">,
							<cfif isdefined("Form.RHEobs") and len(trim(Form.RHEobs))><cfqueryparam value="#Form.RHEobs#" cfsqltype="cf_sql_longvarchar"><cfelse>null</cfif>,
							<cfif isdefined("Form.RHEidorigen") and len(trim(Form.RHEidorigen))><cfqueryparam value="#Form.RHEidorigen#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(RHEfdesde)#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(RHEfhasta)#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#" >,
							<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#form.CPPid#" cfsqltype="cf_sql_numeric">,
							'O' )
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		</cftransaction>
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<!---=================================================================
			 	BORRADO EN CASCADA
			 =================================================================---->
		
		<!--- ****** Eliminar cortes del detalle(componentes) de la formulacion ****** ---->
        <!--- Eliminar formulacion de Otras Partidas --->
        <cfquery datasource="#session.DSN#">
        	delete RHOPDFormulacion
            from RHOPFormulacion a
            inner join RHOPDFormulacion b
            	on b.RHOPFid = a.RHOPFid
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">		
        </cfquery>

        <cfquery datasource="#session.DSN#">
        	delete RHOPFormulacion
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">		
        </cfquery>
        <!--- Eliminar Cortes de la Formulacion --->
		<cfquery name="rsCortes" datasource="#session.DSN#">
			delete RHCortesPeriodoF
			from RHCortesPeriodoF a			
				inner join RHCFormulacion b
					on a.RHCFid = b.RHCFid
					and a.Ecodigo = b.Ecodigo
			
					inner join RHFormulacion c
						on c.RHFid = b.RHFid
						and c.Ecodigo = b.Ecodigo
							
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">		
		</cfquery>
		<!--- ****** Eliminar la formulacion (Calculo) ******---->
		<cfquery datasource="#session.DSN#">
			delete RHCFormulacion 
			from RHCFormulacion a
			inner join RHFormulacion b
				on b.RHFid=a.RHFid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<!----Eliminar formulacion del escenario------>
		<cfquery datasource="#session.DSN#">
			delete 
			from RHFormulacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<!---- ****** Eliminar Ocupacion de plazas ****** ---->
		<cfquery datasource="#session.DSN#">
			delete from RHComponentesPlaza
			where RHPEid in (select RHPEid 
							from RHPlazasEscenario
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							)
		</cfquery>
		<!----Eliminar las plazas actuales importadas para el escenario---->
		<cfquery datasource="#session.DSN#">
			delete from RHPlazasEscenario
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
		</cfquery>
		<!-----****** Eliminar la situacion actual *******---->
		<cfquery datasource="#session.DSN#">
			delete from RHCSituacionActual
			where RHSAid in (select RHSAid
							from RHSituacionActual
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							)
		</cfquery>
		<!----Eliminar las plazas actuales importadas para el escenario---->
		<cfquery datasource="#session.DSN#">
			delete from RHSituacionActual
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
		</cfquery>
		<!---- ******** Eliminar Detalle de tablas del escenario ****** ---->
		<cfquery datasource="#session.DSN#">
			delete from RHDTablasEscenario 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and exists (select 1
							from RHETablasEscenario b
							where RHDTablasEscenario.RHETEid = b.RHETEid
							and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">)
		</cfquery>
		<!---Eliminar encabezado de detalle de tablas del escenario---->
		<cfquery datasource="#session.DSN#">
			delete from RHETablasEscenario 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>	

		<!--- ******Eliminar otras partidas *********--->
		<cfquery name="otras" datasource="#session.dsn#">
			delete from RHDOtrasPartidas 
			where RHOPid in (select RHOPid from RHOtrasPartidas
							  where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">)
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			delete from RHOtrasPartidas
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>	
		
		<cfquery datasource="#session.dsn#">
			delete from RHCPFormulacion 
			where Ecodigo = #Session.Ecodigo#
		      and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		
		<!--- ***************ELIMINAR Cargas Patronales ****************************----->
		<cfquery name="delete" datasource="#Session.DSN#">
			delete RHECargasPatronales
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHEid = <cfqueryparam value="#Form.RHEid#" cfsqltype="cf_sql_numeric">			  
		</cfquery> 
	
		<!--- ***************ELIMINAR ESCENARIO ****************************----->
		<cfquery name="delete" datasource="#Session.DSN#">
			delete RHEscenarios
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHEid = <cfqueryparam value="#Form.RHEid#" cfsqltype="cf_sql_numeric">			  
		</cfquery>  
		
		
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>

		<cfquery name="update" datasource="#Session.DSN#">
			update RHEscenarios 
			set RHEdescripcion 	= <cfqueryparam value="#Form.RHEdescripcion#" cfsqltype="cf_sql_varchar">,
				RHGEid		   	= <cfif isdefined("Form.RHGEid") and len(trim(Form.RHGEid))><cfqueryparam value="#Form.RHGEid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				RHEobs			= <cfif isdefined("Form.RHEobs") and len(trim(Form.RHEobs))><cfqueryparam value="#Form.RHEobs#" cfsqltype="cf_sql_longvarchar"><cfelse>null</cfif>,
				RHEidorigen		= <cfif isdefined("Form.RHEidorigen") and len(trim(Form.RHEidorigen))><cfqueryparam value="#Form.RHEidorigen#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				CPPid 			= <cfqueryparam value="#form.CPPid#" cfsqltype="cf_sql_numeric">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   	  and RHEid = <cfqueryparam value="#Form.RHEid#" cfsqltype="cf_sql_numeric">	
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="TrabajarEscenario.cfm" method="post" name="sql">	
	<input name="RHEid" type="hidden" value="<cfif isdefined("form.Cambio")>#Form.RHEid#<cfelseif isdefined("insert.identity") and len(trim(insert.identity))>#insert.identity#</cfif>">
</form>
</cfoutput>	
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>