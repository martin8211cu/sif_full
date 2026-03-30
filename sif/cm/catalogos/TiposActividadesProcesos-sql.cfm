<cfif isdefined("Form.Alta") and not isdefined("Form.Nuevo")>
     <cfquery name="insert" datasource="#Session.DSN#">
			insert into CMTPActividades
			       (
					   CMTPid,
					   CMTPAdescripcionActividad,
					   CMTPAduracion
				   )
			values 
			       (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMTPid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMTPDAdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CMTPAduracion#">				   
				   ) 
     </cfquery>
	<cfset modo = "ALTA">
</cfif>
   <cfif isdefined("Form.Nuevo")>
	  <cfset modo = "ALTA">  
		<form action="TiposProcesosCompras.cfm" method="post" name="sql">
			<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
			<input name="CMTPid" type="hidden" value="<cfif isdefined("form.CMTPid")><cfoutput>#form.CMTPid#</cfoutput></cfif>">
		</form>
		<HTML>
		<head>
	 	</head>
	    	<body>
		     <script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
		    </body>
		</HTML>

</cfif>

<cfif isdefined("Form.Baja")>   
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from CMTPActividades
			  where CMTPAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMTPAid#">
			     and CMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMTPid#"> 
		</cfquery>
		<cfset LvarReset = "SI"> 
		<cfset modo="ALTA">
</cfif>

<cfif isdefined("Form.Cambio")>
   <cfquery name="update" datasource="#Session.DSN#">
			update CMTPActividades set 
			    <cfif isdefined('form.CMTPDAdescripcion') >
				   	CMTPAdescripcionActividad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMTPDAdescripcion#">
				</cfif>	
			    <cfif isdefined('form.CMTPAduracion') >
				  	,CMTPAduracion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CMTPAduracion#">						                
				</cfif>				
			  where CMTPAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMTPAid#">
			     and CMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMTPid#"> 
		</cfquery> 
		<cfset modo = "CAMBIO">
</cfif>
<form action="TiposProcesosCompras.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined('form.CMTPid')>
		<input name="CMTPid" type="hidden" value="<cfif isdefined("form.CMTPid")><cfoutput>#form.CMTPid#</cfoutput></cfif>">
	</cfif>
	<cfif isdefined('form.CMTPAid')>	
		<input name="CMTPAid" type="hidden" value="<cfif isdefined("form.CMTPAid")><cfoutput>#form.CMTPAid#</cfoutput></cfif>">
	</cfif>	
	<cfif isdefined('LvarReset')>	
		<input name="LvarReset" type="hidden" value="<cfif isdefined("LvarReset")><cfoutput>#LvarReset#</cfoutput></cfif>">
	</cfif>
</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>




