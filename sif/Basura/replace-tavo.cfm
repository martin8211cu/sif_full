	<cfloop condition = "1 = 1">   <!--- Daa --->
		<!--- select charindex('-', "#bcedulajur#") as pos--->
		<cfquery name="rsGuion" datasource="#session.DSN#">
			select {fn LOCATE('-', "#bcedulajur#" )} as pos
			from dual
		</cfquery>
		<cfset bpos = rsGuion.pos>
		<cfif bpos EQ 0>
			break
		</cfif>
			<cfquery name="rscedjurd"  datasource="#session.DSN#">
				select {fn length ("#bcedulajur#")} as tamaño
				from dual
			</cfquery>
			<cfset btamaño = rscedjurd.tamaño>
			<cfif (bpos gt 1) and (btamaño gt bpos)>
			 <!---if ((@pos > 1) and (datalength(@cedulajur ) > @pos)) --->
				<cfquery name="rscedjurd"  datasource="#session.DSN#">
					select substring("#bcedulajur#" ,1,bpos-1) || substring("#bcedulajur#", bpos+1, {fn length ("#bcedulajur#")}) as cedulajur
					from dual
				</cfquery>
				<cfset bcedulajur = rscedjurd.cedulajur>
			<cfelse>
				<cfif bpos EQ 1>
					<cfquery name="rscedj1"  datasource="#session.DSN#">
						select substring("#bcedulajur#" ,2,{fn length("#bcedulajur#")}) as cedulajur 
						from dual
					</cfquery>
					<cfset bcedulajur = rscedj1.cedulajur>
				<cfelse>
					<cfquery name="rscheck4" datasource="#session.DSN#">
						select {fn length ("#bcedulajur#")} as tamaño 
						from dual
					</cfquery>
					<cfset btamaño = rscheck4.tamaño>
					<cfif bpos EQ btamaño>
						<cfquery name="rscheck5" datasource="#session.DSN#">
							select  substring("#bcedulajur#" ,1, {fn length("#bcedulajur#")-1}) as cedulajur 
							from dual 
						</cfquery>
						<cfset bcedulajur = rscheck5.cedulajur>
					</cfif>
				</cfif>
			</cfif>
	</cfloop>