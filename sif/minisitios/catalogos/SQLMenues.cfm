<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Cambio")>
	
		<cfquery name="rsOrdenAnterior" datasource="sdc">
			select convert(varchar, MSMorden) + '-' + convert(varchar, MSMpadre) as Orden from MSMenu 
			where MSMmenu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
			  and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">		
		</cfquery>
	
	</cfif>

	<cftry>
		<cfquery name="Oficinas" datasource="sdc">
			set nocount on
			<cfif isdefined("Form.Alta")>

				update MSMenu set 
					MSMorden = MSMorden + 1
				where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
				  and MSMorden >= <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.MSMorden#">
				  and isnull(MSMpadre,-1) = 
					<cfif isDefined("Form.MSMpadre") and Len(Trim(Form.MSMpadre)) GT 0 >
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMpadre#"> <cfelse> -1 </cfif>

				insert MSMenu (Scodigo, MSPcodigo, MSMpadre, MSMtexto, MSMlink,
                	MSMorden, MSMpath, MSMprofundidad, MSMumod, MSMfmod) 
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
				<cfif isDefined("Form.MSPcodigo") and Len(Trim(Form.MSPcodigo)) GT 0 >
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MSPcodigo#"> <cfelse> , null </cfif>
				<cfif isDefined("Form.MSMpadre") and Len(Trim(Form.MSMpadre)) GT 0 >
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMpadre#"> <cfelse> , null </cfif>
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MSMtexto#">
				<cfif isDefined("Form.MSMlink") and Len(Trim(Form.MSMlink)) GT 0 >
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MSMlink#"> <cfelse>	, null  </cfif>				  
                  	, <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.MSMorden#">
                  	, '/'
                  	, 0
                  	, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">
                  	, getdate()
				  ) 
			
				<cfset modo="ALTA">
			
			<cfelseif isdefined("Form.Baja")>
			
				update MSMenu set 
					MSMorden = hermano.MSMorden - 1 
				from MSMenu hermano, MSMenu yo 
                where yo.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
                  and yo.MSMmenu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
                  and hermano.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
                  and hermano.MSMmenu != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
                  and hermano.MSMorden > yo.MSMorden 
                  and isnull(hermano.MSMpadre,-1) = isnull(yo.MSMpadre,-1) 
                  
                delete MSMenu 
                where MSMmenu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
                  and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
				  
				<cfset modo="BAJA">

			<cfelseif isdefined("Form.Cambio")>				
				<cfset ordenActual = Form.MSMorden & "-" & Form.MSMpadre >
				
				<cfif rsOrdenAnterior.Orden NEQ ordenActual >                	
					update MSMenu set 
						MSMorden = hermano.MSMorden - 1 
                    from MSMenu hermano, MSMenu yo
                    where yo.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
                      and yo.MSMmenu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
                      and hermano.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
                      and hermano.MSMmenu != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
                      and hermano.MSMorden > yo.MSMorden 
                      and isnull(hermano.MSMpadre,-1) = isnull(yo.MSMpadre,-1)				
				</cfif>
				
            	update MSMenu set 
					MSPcodigo = 
						<cfif isDefined("Form.MSPcodigo") and Len(Trim(Form.MSPcodigo)) GT 0 >
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MSPcodigo#"> <cfelse> null </cfif>,
					MSMpadre =
						<cfif isDefined("Form.MSMpadre") and Len(Trim(Form.MSMpadre)) GT 0 >
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMpadre#"> <cfelse> null </cfif>,
                  	MSMtexto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MSMtexto#">,
					MSMlink = 
						<cfif isDefined("Form.MSMlink") and Len(Trim(Form.MSMlink)) GT 0 >
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MSMlink#"> <cfelse> null </cfif>,											
                    MSMorden = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.MSMorden#">,
                    MSMumod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
                    MSMfmod = getdate()
                
				where MSMmenu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
                  and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
				  
				<cfif rsOrdenAnterior.Orden NEQ ordenActual >
					update MSMenu set 
						MSMorden = hermano.MSMorden + 1 
                    from MSMenu hermano, MSMenu yo
                    where yo.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
                      and yo.MSMmenu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
                      and hermano.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
                      and hermano.MSMmenu != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
                      and hermano.MSMorden >= yo.MSMorden 
                      and isnull(hermano.MSMpadre,-1) = isnull(yo.MSMpadre,-1)				
				</cfif>
				
				<cfset modo="CAMBIO">

			</cfif>
						
			set nocount off
		</cfquery>
		
		<!--- Preparar la jerarquía --->
		<cfif isdefined("Form.Alta") or isdefined("Form.Cambio") > 
			<cfquery name="rs2" datasource="sdc">
				set nocount on
				update MSMenu set 
					MSMpath = '.',   
					MSMprofundidad = 0
				where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
			
				update MSMenu set 
					MSMpath = convert(varchar, MSMorden)
				where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
				  and MSMpadre is null
			
				declare @noloop int
				select @noloop = 0
				while (@noloop < 100) begin	
					select @noloop = @noloop + 1
				    
					update MSMenu set 
						MSMpath = papa.MSMpath + '/' + convert(varchar, hijo.MSMorden),   
						MSMprofundidad = papa.MSMprofundidad + 1
					from MSMenu hijo, MSMenu papa
					where hijo.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
					  and papa.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
					  and papa.Scodigo = hijo.Scodigo
					  and hijo.MSMpadre = papa.MSMmenu 
					  and hijo.MSMpadre is not null 
					  and hijo.MSMpath = '.' 
					  and hijo.MSMprofundidad = 0 
					  and papa.MSMpath != '.'
					  
					if @@rowcount = 0 break
				end 
				
				update MSMenu set 
				MSMhijos = ( select count(1) from MSMenu b 
							where b.MSMpadre = MSMenu.MSMmenu 
							  and b.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#"> 
							  and b.Scodigo = MSMenu.Scodigo)
				where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">            
				
				set nocount off
				
			</cfquery>
			
		</cfif>

	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="Menues.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="MSMmenu" type="hidden" value="<cfif isdefined("Form.MSMmenu")>#Form.MSMmenu#</cfif>">		
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
