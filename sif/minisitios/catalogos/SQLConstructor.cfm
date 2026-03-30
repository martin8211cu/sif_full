<cfparam name="Form.MSPareas" type="numeric" default="-1">
<cfset MSPareas = Form.MSPareas >

<cfif Val(MSPareas) NEQ 0>	

	<cftry>
		<cfquery name="rs" datasource="sdc" >
			set nocount on
			<cfloop index="area" from="1" to="#MSPareas#">
				<cfset contenido = Evaluate("Form.pagina" & area)>
					update MSPaginaArea
					set MSCcontenido = #contenido#
					where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
					  and MSPcodigo = '#Form.MSPcodigo#'
					  and MSPAarea = #area#
					  
					if @@rowcount = 0
					insert MSPaginaArea (Scodigo, MSPcodigo, MSPAarea, MSCcontenido, MSPAnombre) 
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
						, '#Form.MSPcodigo#'
						, #area#
						, #contenido#
						, 'Area#area#'
					) 
			</cfloop>
			
			delete MSPaginaArea
			where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
			  and MSPcodigo = '#Form.MSPcodigo#'
			  and MSPAarea > #Form.MSPareas#
			  
			set nocount off
			<cfset modo="CAMBIO">		  
		</cfquery>
	
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>

</cfif>

<form action="Constructor.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="MSMmenu" type="hidden" value="<cfif modo NEQ 'ALTA' and isdefined("Form.MSMmenu")>#Form.MSMmenu#</cfif>">
	<input name="MSMtexto" type="hidden" value="#Form.MSMtexto#">		
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">		
</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


		