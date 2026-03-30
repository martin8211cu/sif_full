<cfparam name="action" default="ConceptoContablePermiso.cfm">
<cfparam name="modo" default="ALTA">
<cfif not isdefined("form.btnNuevo")>
			<cfif isdefined("form.Alta")>
				<cfset UCCpermiso = 0>
				<cfif isdefined("form.PERMISO1")>
					<cfset UCCpermiso = UCCpermiso + form.PERMISO1>
				</cfif>
				<cfif isdefined("form.PERMISO2")>
					<cfset UCCpermiso = UCCpermiso + form.PERMISO2>
				</cfif>
				<cfif isdefined("form.PERMISO3")>
					<cfset UCCpermiso = UCCpermiso + form.PERMISO3>
				</cfif>
				<cfif isdefined("form.PERMISO4")>
					<cfset UCCpermiso = UCCpermiso + form.PERMISO4>
				</cfif>
				<cfquery name="RsCCP_in" datasource="#session.DSN#">
					insert into UsuarioConceptoContableE  (Ecodigo,Cconcepto,Usucodigo,UCCpermiso,BMfalta,BMUsucodigo)
					 values(
						  #session.Ecodigo# ,
						 <cfqueryparam value="#form.Cconcepto#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#form.Usuario#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#UCCpermiso#" cfsqltype="cf_sql_numeric">,	
						<cf_dbfunction name="now">,
						<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
				</cfquery>
			<cfelseif isdefined("form.Cambio")>
				<cfset UCCpermiso = 0>
				<cfif isdefined("form.PERMISO1")>
					<cfset UCCpermiso = UCCpermiso + form.PERMISO1>
				</cfif>
				<cfif isdefined("form.PERMISO2")>
					<cfset UCCpermiso = UCCpermiso + form.PERMISO2>
				</cfif>
				<cfif isdefined("form.PERMISO3")>
					<cfset UCCpermiso = UCCpermiso + form.PERMISO3>
				</cfif>	
				<cfif isdefined("form.PERMISO4")>
					<cfset UCCpermiso = UCCpermiso + form.PERMISO4>
				</cfif>		
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="UsuarioConceptoContableE" 
					redirect="ConceptoContablePermiso.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo,integer,#session.Ecodigo#"			
					field2="Cconcepto,integer,#form.Cconcepto#"
					field3="UCCid,integer,#form.UCCid#">			
				<cfquery name="rsCambio" datasource="#Session.DSN#">
					update UsuarioConceptoContableE set
						UCCpermiso = <cfqueryparam value="#UCCpermiso#" cfsqltype="cf_sql_integer">
					where Ecodigo  =  #session.Ecodigo# 
					and Cconcepto  = <cfqueryparam value="#Form.Cconcepto#" cfsqltype="cf_sql_integer">
					and UCCid      = <cfqueryparam value="#Form.UCCid#" cfsqltype="cf_sql_integer">
				</cfquery>	
				<cfset modo="CAMBIO">
			<cfelseif isdefined("form.Baja")>
			<cfquery name="RsCCP_de" datasource="#session.DSN#">
				delete from UsuarioConceptoContableE
				where Ecodigo	 =  #session.Ecodigo# 
				  and Cconcepto  = <cfqueryparam value="#form.Cconcepto#" cfsqltype="cf_sql_numeric">
				  and UCCid      = <cfqueryparam value="#form.UCCid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			</cfif>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	<input type="hidden" id="Cconcepto" name="Cconcepto" value="<cfif isdefined("form.Cconcepto") and len(trim(form.Cconcepto)) neq 0><cfoutput>#form.Cconcepto#</cfoutput></cfif>">
	<input type="hidden" id="CDESCRIPCION" name="CDESCRIPCION" value="<cfif isdefined("form.CDESCRIPCION") and len(trim(form.CDESCRIPCION)) neq 0><cfoutput>#form.CDESCRIPCION#</cfoutput></cfif>">
	<cfif isdefined("form.Cambio")>
		<input type="hidden" id="UCCid" name="UCCid" value="<cfif isdefined("form.UCCid") and len(trim(form.UCCid)) neq 0><cfoutput>#form.UCCid#</cfoutput></cfif>">
		<input type="hidden" id="Usucodigo" name="Usucodigo" value="<cfif isdefined("form.Usuario") and len(trim(form.Usuario)) neq 0><cfoutput>#form.Usuario#</cfoutput></cfif>">
		<input type="hidden" id="NOMBRE" name="NOMBRE" value="<cfif isdefined("form.NOMBRELBL") and len(trim(form.NOMBRELBL)) neq 0><cfoutput>#form.NOMBRELBL#</cfoutput></cfif>">
	</cfif>

</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>