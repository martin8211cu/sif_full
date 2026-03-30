<cfif isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>
<cfif IsDefined('url.tab')>
	<cfset form.tab = url.tab>
<cfelse>
	<cfparam name="form.tab" default="1">
</cfif>
<cfif not ( isdefined("form.tab") and ListContains('1,2', form.tab) )>
	<cfset form.tab = 1 >
</cfif>

<table width="100%" cellpadding="2" cellspacing="0">
	<TR><TD valign="top">
		<cf_tabs width="100%" onclick="tab_set_current_param">
			<cf_tab text="Tipos de Movimiento" id="1" selected="#form.tab is '1'#">
				<cfif isdefined('form.tab') and form.tab EQ '1'>
					<cfinclude template="RHtipoMov-form.cfm">
				</cfif>
			</cf_tab>
			<cfif isdefined('form.RHTMid') and form.RHTMid NEQ ''>
				<cf_tab text="Permisos" id="2" selected="#form.tab is '2'#">
					<cfif isdefined('form.tab') and form.tab EQ '2'>
						<cfinclude template="RHUsuariosTipoMovCF.cfm">
					</cfif>
				</cf_tab>
			</cfif>
		</cf_tabs>
	</TD></TR>
</table>



<script language="javascript" type="text/javascript">
	function tab_set_current_param (n){
		var params = "";
		<cfif isdefined('form.RHTMid') and form.RHTMid NEQ ''>
			params = "&RHTMid=<cfoutput>#form.RHTMid#</cfoutput>";
		</cfif>		
		
		location.href='RHtabsTipoMov.cfm?tab='+escape(n) + params;
	}		
</script>

