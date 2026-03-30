<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("Url.form") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.form#">
</cfif>

<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.filtro_Aplaca") and Len(Trim(Url.filtro_Aplaca)) NEQ 0>
	<!--- Trae las cajas que tienen relaciones --->
	<cfquery name="rs"  datasource="#session.DSN#">
		select A.Aplaca as Aplaca,A.Adescripcion as Adescripcion 
		from Activos A 
		inner join AFResponsables B 
			ON B.Aid = A.Aid 
			and B.Ecodigo = A.Ecodigo 
			and (getdate() >= B.AFRfini and getdate() <= B.AFRffin) 
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		and A.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Url.filtro_Aplaca#">  
		union
		select distinct CRDRplaca as Aplaca,A.CRDRdescripcion as Adescripcion 
		from CRDocumentoResponsabilidad A
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and A.CRDRplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Url.filtro_Aplaca#">  
	</cfquery>	
	
	<script language="JavaScript">
		<cfoutput>
			<cfif rs.recordcount gt 0>
				if(window.parent.document.#form.formulario#.#form.name#)
					window.parent.document.#form.formulario#.#form.name#.value = "#trim(rs.Aplaca)#";
				if(window.parent.document.#form.formulario#.#form.desc#)
					window.parent.document.#form.formulario#.#form.desc#.value = "#trim(rs.Adescripcion)#";
				<cfif isdefined("Url.name2") and Len(Trim(Url.name2)) NEQ 0>
					if(window.parent.document.#form.formulario#.#Url.name2#)
						window.parent.document.#form.formulario#.#Url.name2#.value = "#trim(rs.Aplaca)#";
				</cfif>		
				<cfif isdefined("Url.desc2") and Len(Trim(Url.desc2)) NEQ 0>
					if(window.parent.document.#form.formulario#.#Url.desc2#)
					window.parent.document.#form.formulario#.#Url.desc2#.value = "#trim(rs.Adescripcion)#";
				</cfif>	
				if(window.parent.document.#form.formulario#.errorFlag)
					window.parent.document.#form.formulario#.errorFlag.value="1";						
			<cfelse>
				window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
				window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
				<cfif isdefined("Url.name2") and Len(Trim(Url.name2)) NEQ 0>
					window.parent.document.#form.formulario#.#Url.name2#.value ="";
				</cfif>		
				<cfif isdefined("Url.desc2") and Len(Trim(Url.desc2)) NEQ 0>
					window.parent.document.#form.formulario#.#Url.desc2#.value="";
				</cfif>	
				if(window.parent.document.#form.formulario#.errorFlag)
					window.parent.document.#form.formulario#.errorFlag.value="0";						

				alert("la placa digitada no existe");
			</cfif>	
		</cfoutput>	
	</script>
</cfif>