<cfsetting enablecfoutputonly="true">
<cfloop index="hiddenName" list="#Form.FIELDNAMES#">
	<cfif isdefined("Form.#hiddenName#") and len(trim(Evaluate('Form.#hiddenName#'))) gt 0>
		<cfoutput>
			<input type="hidden" name="#hiddenName#" value="#Evaluate('Form.#hiddenName#')#">
		</cfoutput>
	</cfif>
</cfloop>
<cfsetting enablecfoutputonly="false">