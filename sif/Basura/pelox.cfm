<cfsavecontent variable="xxx">

			uno   dos    tres
			
			
fe	  	dd
</cfsavecontent>

<xmp><cfoutput>#REReplace(xxx,'([ \t\r\n])+',' ','all')#</cfoutput></xmp>