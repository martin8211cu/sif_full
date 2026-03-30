	<cfparam name="url.EVTcodigo" default="">
	<cfparam name="url.EVvalor" default="">
	<cfparam name="url.EVequivalencia" default="">
	<cfparam name="url.modo" default="">

	<cfif isdefined("url.EVTcodigo") and url.EVTcodigo NEQ "" and isdefined("url.EVvalor") and url.EVvalor NEQ "">
		<cfquery name="rs1" datasource="#Session.Edu.DSN#">
			select isnull(count(a.EVvalor),0) as valor 
			from EvaluacionValores a,EvaluacionValoresTabla b 
			where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
			  and a.EVTcodigo=b.EVTcodigo  
			  and a.EVTcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EVTcodigo#">
			  and a.EVvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.EVvalor#">
			  <cfif modo EQ "CAMBIO">
			  	and a.EVequivalencia != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EVequivalencia#">
			
			  </cfif> 
		</cfquery>
		<script language="JavaScript">
		//alert(<cfoutput>#rs1.valor#</cfoutput>);
			<cfif Trim(rs1.valor) GT 0>
				parent.form1.ExisteEVvalor.value="S";
			<cfelse>
				parent.form1.ExisteEVvalor.value="N";
			</cfif>
		</script>
	</cfif>

	
	<cfif isdefined("url.EVTcodigo") and url.EVTcodigo NEQ "" and isdefined("url.EVequivalencia") and url.EVequivalencia NEQ "">
			<cfquery name="rs2" datasource="#Session.Edu.DSN#">
			select isnull(count(a.EVequivalencia),0) as Equivalencia 
			from EvaluacionValores a,EvaluacionValoresTabla b 
			where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
			  and a.EVTcodigo=b.EVTcodigo  
			  and a.EVTcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EVTcodigo#">
			  and a.EVequivalencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EVequivalencia#">
 		  	 
			  <cfif modo EQ "CAMBIO">
			  	and a.EVvalor != <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.EVvalor#">
			  </cfif>
		</cfquery>
		<script language="JavaScript">
		//alert(<cfoutput>#rs2.Equivalencia#</cfoutput>);
			<cfif Trim(rs2.Equivalencia) GT 0>
				parent.form1.ExisteEVequivalencia.value="S";
			<cfelse>
				parent.form1.ExisteEVequivalencia.value="N";
			</cfif>
		</script>
	</cfif>