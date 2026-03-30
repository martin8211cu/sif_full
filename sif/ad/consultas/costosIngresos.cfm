		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
			<tr>
				<td valign="top">
					<cfset params = '' >
					<cfif isdefined("url.empresa") and not isdefined("form.empresa") >
						<cfset form.empresa = url.empresa >
					</cfif>
					<cfif isdefined("url.fCFid") and not isdefined("form.fCFid") >
						<cfset form.fCFid = url.fCFid >
					</cfif>
					<cfif isdefined("url.Cid") and not isdefined("form.Cid") >
						<cfset form.Cid = url.Cid >
					</cfif>
                    <cfif isdefined("url.Cid2") and not isdefined("form.Cid2") >
						<cfset form.Cid2 = url.Cid2 >
					</cfif>
					<cfif isdefined("url.IngPorc") and not isdefined("form.IngPorc") >
						<cfset form.IngPorc = url.IngPorc >
					</cfif>
                    
					<cfif isdefined("form.empresa") and len(trim(form.empresa))>
						<cfset params = params & "&empresa=#form.empresa#">
					</cfif>
                    <cfif isdefined("form.fCFid") and len(trim(form.fCFid))>
						<cfset params = params & "&CFid=#form.fCFid#">
					</cfif>
                    <cfif isdefined("form.Cid") and len(trim(form.Cid))>
						<cfset params = params & "&Cid=#form.Cid#">
					</cfif>
					<cfif isdefined("form.Cid2") and len(trim(form.Cid2))>
						<cfset params = params & "&Cid2=#form.Cid2#">
					</cfif>
                    <cfif isdefined("form.IngPorc") and len(trim(form.IngPorc))>
						<cfset params = params & "&IngPorc=#form.IngPorc#">
					</cfif>
					
                    <cfset Title           = "Reporte Detallado de Costos e Ingresos Automaticos">
					<cfset FileName        = "Costos&Ingresos#LSDateFormat(now(),'yyyymmdd')#">
                    <cfset FileName 	   = FileName & ".xls">
                    <cf_htmlreportsheaders title="#Title#" filename="#FileName#" download="yes" ira="costosIngresos-filtro.cfm?#params#">
                        
					<cfinclude template="costosIngresos-form.cfm">
				</td>
			</tr>
		</table>