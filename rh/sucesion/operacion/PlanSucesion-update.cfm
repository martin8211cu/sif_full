<!---*******************************--->
<!--- proceso para agregar el cfm   --->
<!--- de los SQL según el paso      --->
<!---*******************************--->
<cfif isdefined("form.paso")>

	<cfswitch expression="#form.paso#">
		<cfcase value="1">
			<cfinclude template="SQL_PlanSucesion-paso1.cfm">
		</cfcase>
		<cfcase value="2">
			<cfinclude template="SQL_PlanSucesion-paso2.cfm">
		</cfcase>
		<cfcase value="3">
			 <!--- <cfinclude template="SQL_PlanSucesion-paso3.cfm">  --->
		</cfcase>		
	</cfswitch>
</cfif>