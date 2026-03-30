<cfif isdefined('form.CAMBIO')>
	<cfset arrMcodigoPlantilla = ListToArray(#form.McodigoPlantilla#)/>
	<cfset GEAid = #form.GEAid#>
	<cfset arrGEADtipocambio = ListToArray(#form.GEADtipocambio#)/>
	
	<cfloop index="x" from="1" to="#arrayLen(arrMcodigoPlantilla)#">
	<cfquery name="rsMonto" datasource="#session.dsn#">
	select GEADmontoviatico, GEPVid, GEADid from GEanticipoDet where GEAid=#GEAid#
				and McodigoPlantilla=<cfoutput>#arrMcodigoPlantilla[x]#</cfoutput> 
	</cfquery>			
	
	<cfloop query="rsMonto" >
		<cfquery datasource="#session.dsn#">
			update GEanticipoDet  set  
				GEADtipocambio= <cfoutput>#arrGEADtipocambio[x]#</cfoutput>,
				GEADmonto= <cfoutput>#arrGEADtipocambio[x]# * #rsMonto.GEADmontoviatico#	</cfoutput>	
				where GEAid=#GEAid#
				and McodigoPlantilla=<cfoutput>#arrMcodigoPlantilla[x]#</cfoutput>
				and GEADid=<cfoutput>#rsMonto.GEADid#</cfoutput>	
		</cfquery>
	</cfloop>	
	</cfloop>

	<cfquery datasource="#session.dsn#">
		update GEanticipo
 		   set GEAtotalOri = 
					coalesce(
					( 
						select sum(GEADmonto)
						  from GEanticipoDet
						 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
					)
					, 0)
		  where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#" null="#Len(GEAid) Is 0#">
	</cfquery>

</cfif>
<cflocation url="#form.irA#">



