<cfif ThisTag.ExecutionMode is 'start'>
	<div class="menu-bg">

		<cfif Attributes.navegacionUrlpage[1] neq "">
			<div class="breadcrumbs">
				<!---<img width="18" height="18" src="/cfmx/plantillas/Cloud/images/breadcrumbs-icon.png">--->
				 <a href="<cfoutput>#Attributes.navegacionUrlpage[1]#</cfoutput>"><strong><cfoutput>#Attributes.navegacionTitulo[1]#</cfoutput></strong></a>
					<cfloop index="x" from="2" to="#arrayLen(Attributes.navegacionUrlpage)#">
						 > <a href="<cfoutput>#Attributes.navegacionUrlpage[x]#</cfoutput>"><cfoutput>#Attributes.navegacionTitulo[x]#</cfoutput></a>
					</cfloop>
			</div>
      </cfif>

</cfif>
<cfif ThisTag.ExecutionMode is 'end'>


	</div>
</cfif>