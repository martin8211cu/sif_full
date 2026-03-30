<cfset modo = "CAMBIO">
	<cftry>			
		<cfif isdefined("Form.btnAgregarReq") and form.btnAgregarReq EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on
					insert MateriaRequisito (Mcodigo, MRTsecuencia, McodigoRequisito)
					values (
						<cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">
						, 1
						, <cfqueryparam value="#form.McodigoRequisito#" cfsqltype="cf_sql_numeric">
					)
				set nocount off
			</cfquery>
		</cfif>			

		<cfif isdefined("Form.btnBorrarReq") and form.btnBorrarReq EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on			
					delete MateriaRequisito
					where Mcodigo = <cfqueryparam value="#Form.Mcodigo#"   cfsqltype="cf_sql_numeric">
						and McodigoRequisito = <cfqueryparam value="#Form.IdReqBorrar#"   cfsqltype="cf_sql_numeric">						
				set nocount off	
			</cfquery>						
		</cfif>

		<!--- Si se realiz[o un ALTA o un BAJA de requisitos entonces se actualiza el campo de Mrequisitos de la tabla de Materia --->		
		<cfif (isdefined("Form.btnBorrarReq") and form.btnBorrarReq EQ 1) or (isdefined("Form.btnAgregarReq") and form.btnAgregarReq EQ 1)>
			<cfquery name="rsMRequisitos" datasource="#Session.DSN#">
				Select 	MRTsecuencia
						, m.Mcodificacion
				from	MateriaRequisito mr
						, Materia m
				where mr.Mcodigo = <cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">
					and mr.McodigoRequisito = m.Mcodigo
				order by m.Mcodificacion
			</cfquery>
			
			<cfset varMrequi = "">
			<cfset varSecuenc = "">			
			<cfif isdefined('rsMRequisitos') and rsMRequisitos.recordCount GT 0>
				<cfloop query="rsMRequisitos">
					<cfif varSecuenc NEQ rsMRequisitos.MRTsecuencia>
						<cfset varSecuenc = rsMRequisitos.MRTsecuencia>
						<cfif varMrequi EQ ''>
							<cfset varMrequi = varMrequi & rsMRequisitos.Mcodificacion>
						<cfelse>
							<cfset varMrequi = varMrequi & " o " & rsMRequisitos.Mcodificacion>
						</cfif>
					<cfelse>
						<cfif varMrequi EQ ''>
							<cfset varMrequi = varMrequi & rsMRequisitos.Mcodificacion>
						<cfelse>
							<cfset varMrequi = varMrequi & " " & rsMRequisitos.Mcodificacion>
						</cfif>					
					</cfif> 
				</cfloop>
			</cfif>
			<!--- Realiza la actualizacion del campo en la tabla de Materia --->
			<cfquery name="AB_MatRequisitos" datasource="#Session.DSN#">			
				set nocount on			
					Update Materia 
					set Mrequisitos = <cfqueryparam value="#varMrequi#" cfsqltype="cf_sql_varchar">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
						and Mcodigo=<cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">
				set nocount off				
			</cfquery>				
		</cfif>		
	<cfcatch type="any">
		<cfinclude template="/educ/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	
<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
	<cfset fAction = "CarrerasPlanes.cfm">
	<cfset modo = "MPcambio">
<cfelse>
	<cfset fAction = "materia.cfm">	
</cfif>	

<form action="<cfoutput>#fAction#</cfoutput>" method="post" name="sql">
	<cfoutput>
		<!--- Parametros del mantenimiento de Materia Plan --->
		<cfif isdefined('form.CILcodigo') and form.CILcodigo NEQ ''>
			<input name="CILcodigo" type="hidden" value="#form.CILcodigo#">
		</cfif>
		<cfif isdefined('form.CARcodigo') and form.CARcodigo NEQ ''>
			<input name="CARcodigo" type="hidden" value="#form.CARcodigo#">
		</cfif>
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			<input name="PEScodigo" type="hidden" value="#form.PEScodigo#">
		</cfif>
		<cfif isdefined('form.PBLsecuencia') and form.PBLsecuencia NEQ ''>
			<input name="PBLsecuencia" type="hidden" value="#form.PBLsecuencia#">
		</cfif>
		<input name="nivel" type="hidden" value="2">
		<input name="TabsPlan" type="hidden" value="3">
		 <!--- ********************************* --->
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="Mcodigo" type="hidden" value="<cfif isdefined("Form.Mcodigo") and modo NEQ 'ALTA'>#Form.Mcodigo#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
		<input name="T" type="hidden" value="<cfif isdefined("form.Mtipo") and form.Mtipo NEQ ''>#form.Mtipo#<cfelse>M</cfif>">		
	</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>