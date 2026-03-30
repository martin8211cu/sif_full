	<cfparam name="url.form" default="form1">
	<cfparam name="url.desc" default="Mnombre">
	<cfparam name="url.fmt" default="Miso4217">
	<cfparam name="url.id" default="Mcodigo">
	<cfparam name="url.quitar" default="">

	<cfif isdefined("url.Miso4217") and url.Miso4217 NEQ "">
		<cfquery name="rs" datasource="#Session.DSN#">			
			select * from Monedas 
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">						
				and Upper(Miso4217) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(url.Miso4217)#">
				<cfif isdefined('url.quitar') and len(trim(url.quitar))>
					and Mcodigo not in (#url.quitar#)
				</cfif>				
		</cfquery>
		<cfif isdefined('rs') and rs.recordCount GT 0>
			<script language="JavaScript">
				parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.Mcodigo#</cfoutput>";
				if(parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>)
					parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.Mnombre#</cfoutput>";
			</script>
		<cfelse>
			<script language="JavaScript">
				parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";	
				if(parent.document.<cfoutput>#url.form#.#url.fmt#</cfoutput>)
					parent.document.<cfoutput>#url.form#.#url.fmt#</cfoutput>.value="";
				if(parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>)				
					parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
			</script>
		</cfif>
	 <cfelse>
		<script language="JavaScript">
			parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";	
			if(parent.document.<cfoutput>#url.form#.#url.fmt#</cfoutput>)
				parent.document.<cfoutput>#url.form#.#url.fmt#</cfoutput>.value="";
			if(parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>)				
				parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
		</script> 
	</cfif>