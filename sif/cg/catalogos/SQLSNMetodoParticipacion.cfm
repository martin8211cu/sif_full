<cfif not isdefined("Form.Nuevo")>
	 <cfif isdefined("Form.CCuenta1") and len(Form.CCuenta1) gt 0>
     	<cfset formatoCuentaC='#form.cmayor_ccuenta1#-#form.cformato1#'>
     </cfif>
     <cfif isdefined("Form.CCuenta2") and len(Form.CCuenta2) gt 0>
     	<cfset formatoCuentaD='#form.cmayor_ccuenta2#-#form.cformato2#'>
     </cfif>




	<cftry>


			<cfif isdefined("Form.Alta")>

				<cfif isdefined('Form.SNcodigo')>
				<cfquery name="rsSocios" datasource="#session.DSN#">
					select * from SNegocios
					where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfquery name="rsValidaS" datasource="#session.DSN#">
					select * from SNMetodoParticipacion
					where SNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocios.SNid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
		        </cfif>

               <cfif rsValidaS.recordcount eq 0>
				<cfquery name="SNMetodoPartInsert" datasource="#Session.DSN#">
				Insert 	SNMetodoParticipacion(SNid,Ecodigo)
						values	(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocios.SNid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
				</cfquery>
				<cfelse>
				<script> alert('El Socio de Participacion ya Existe.');</script>
				</cfif>
			</cfif>
	<cfquery name="SNMetodoParticipacion" datasource="#Session.DSN#">
				set nocount on
				Select 1
				<cfset modo="ALTA">
			<cfif isdefined("Form.Cambio")>
				Update 	SNMetodoParticipacion
					set SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNid#">
				where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				      and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNid#">
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete SNMetodoParticipacion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
				     and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNid#">
				<cfset modo="BAJA">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>

</cfif>

<form action="../../cg/catalogos/SNMetodoParticipacion.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="SNid" type="hidden" value="<cfif isdefined("Form.SNid")><cfoutput>#Form.SNid#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>