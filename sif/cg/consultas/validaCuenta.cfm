<cfif isdefined("url.Cmayor") and url.Cmayor NEQ "" >
	<cfquery name="rsmascara" datasource="#session.dsn#">
		select CPVformatoF from CPVigencia
		where Cmayor  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Cmayor#">
		and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between CPVdesde and CPVhasta
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfquery name="rs" datasource="#session.dsn#">
		SELECT Ccuenta,Cmayor,Cformato,Cdescripcion 
		FROM CContables 
		where Cmayor  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Cmayor#">
		<cfif isdefined("url.Cformato") and url.Cformato NEQ "">
			and Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Cformato#">
		<cfelse>
			and Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Cmayor#">
		</cfif>
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<script language="JavaScript">
		<cfif not isdefined("Url.Campo")>
			<cfif rsmascara.recordcount gt 0>
				var mascara = "<cfoutput>#trim(rsmascara.CPVformatoF)#</cfoutput>";
				if(window.parent.document.form1.Mascara)
					window.parent.document.form1.Mascara.value=mascara.substring(5,mascara.length);
				if(window.parent.document.form1.MascaraM)	
					window.parent.document.form1.MascaraM.value ='XXXX'
			<cfelse>
				if(window.parent.document.form1.Mascara)
					window.parent.document.form1.Mascara.value="";
				if(window.parent.document.form1.MascaraM)	
					window.parent.document.form1.MascaraM.value ="";
			</cfif>
			
			<cfif rs.recordcount gt 0>
				if(window.parent.document.form1.Ccuenta)
					window.parent.document.form1.Ccuenta.value="<cfoutput>#trim(rs.Ccuenta)#</cfoutput>";
				if(window.parent.document.form1.Cmayor)
					window.parent.document.form1.Cmayor.value="<cfoutput>#trim(rs.Cmayor)#</cfoutput>";
				<cfif isdefined("url.Cformato")>
					var formato = "<cfoutput>#trim(rs.Cformato)#</cfoutput>"
					if(window.parent.document.form1.Cformato)
					window.parent.document.form1.Cformato.value= formato.substring(5,formato.length);
				</cfif>
				if(window.parent.document.form1.Cdescripcion)
					window.parent.document.form1.Cdescripcion.value="<cfoutput>#trim(rs.Cdescripcion)#</cfoutput>";
				<cfif isdefined("url.Cformato")>
					if(window.parent.document.form1.Periodos)
						window.parent.document.form1.Periodos.focus();
				<cfelse>
					if(window.parent.document.form1.Cformato)
						window.parent.document.form1.Cformato.focus();
				</cfif>
			<cfelse>
				<cfif NOT isdefined("url.Cformato")>
					if(window.parent.document.form1.Ccuenta)
						window.parent.document.form1.Ccuenta.value="";
					if(window.parent.document.form1.Cmayor)
						window.parent.document.form1.Cmayor.value="";
					if(window.parent.document.form1.Mascara)
						window.parent.document.form1.Mascara.value="";
				</cfif>
				if(window.parent.document.form1.Cformato)
					window.parent.document.form1.Cformato.value="";
				if(window.parent.document.form1.Cdescripcion)
					window.parent.document.form1.Cdescripcion.value="";
				
				alert("Cuenta invalida");
			</cfif>
			<cfelseif #Url.Campo# EQ 1>
				<cfif rsmascara.recordcount gt 0>
					var mascara = "<cfoutput>#trim(rsmascara.CPVformatoF)#</cfoutput>";
					if(window.parent.document.form1.Mascara1)
						window.parent.document.form1.Mascara1.value=mascara.substring(5,mascara.length);
					if(window.parent.document.form1.MascaraM1)	
						window.parent.document.form1.MascaraM1.value ='XXXX'
				<cfelse>
					if(window.parent.document.form1.Mascara1)
						window.parent.document.form1.Mascara1.value="";
					if(window.parent.document.form1.MascaraM1)	
						window.parent.document.form1.MascaraM1.value ="";
				</cfif>
				
				<cfif rs.recordcount gt 0>
					if(window.parent.document.form1.Ccuenta1)
						window.parent.document.form1.Ccuenta1.value="<cfoutput>#trim(rs.Ccuenta)#</cfoutput>";
					if(window.parent.document.form1.Cmayor1)
						window.parent.document.form1.Cmayor1.value="<cfoutput>#trim(rs.Cmayor)#</cfoutput>";
					<cfif isdefined("url.Cformato")>
						var formato = "<cfoutput>#trim(rs.Cformato)#</cfoutput>"
						if(window.parent.document.form1.Cformato1)
						window.parent.document.form1.Cformato1.value= formato.substring(5,formato.length);
					</cfif>
					if(window.parent.document.form1.Cdescripcion1)
						window.parent.document.form1.Cdescripcion1.value="<cfoutput>#trim(rs.Cdescripcion)#</cfoutput>";
					<cfif isdefined("url.Cformato")>
						if(window.parent.document.form1.Periodos1)
							window.parent.document.form1.Periodos1.focus();
					<cfelse>
						if(window.parent.document.form1.Cformato1)
							window.parent.document.form1.Cformato1.focus();
					</cfif>
				<cfelse>
					<cfif NOT isdefined("url.Cformato")>
						if(window.parent.document.form1.Ccuenta1)
							window.parent.document.form1.Ccuenta1.value="";
						if(window.parent.document.form1.Cmayor1)
							window.parent.document.form1.Cmayor1.value="";
						if(window.parent.document.form1.Mascara1)
							window.parent.document.form1.Mascara1.value="";
					</cfif>
					if(window.parent.document.form1.Cformato1)
						window.parent.document.form1.Cformato1.value="";
					if(window.parent.document.form1.Cdescripcion1)
						window.parent.document.form1.Cdescripcion1.value="";
					
					alert("Cuenta invalida");
				</cfif>
			<cfelse>
				<cfif rsmascara.recordcount gt 0>
					var mascara = "<cfoutput>#trim(rsmascara.CPVformatoF)#</cfoutput>";
					if(window.parent.document.form1.Mascara2)
						window.parent.document.form1.Mascara2.value=mascara.substring(5,mascara.length);
					if(window.parent.document.form1.MascaraM2)	
						window.parent.document.form1.MascaraM2.value ='XXXX'
				<cfelse>
					if(window.parent.document.form1.Mascara2)
						window.parent.document.form1.Mascara2.value="";
					if(window.parent.document.form1.MascaraM2)	
						window.parent.document.form1.MascaraM2.value ="";
				</cfif>
				
				<cfif rs.recordcount gt 0>
					if(window.parent.document.form1.Ccuenta2)
						window.parent.document.form1.Ccuenta2.value="<cfoutput>#trim(rs.Ccuenta)#</cfoutput>";
					if(window.parent.document.form1.Cmayor2)
						window.parent.document.form1.Cmayor2.value="<cfoutput>#trim(rs.Cmayor)#</cfoutput>";
					<cfif isdefined("url.Cformato")>
						var formato = "<cfoutput>#trim(rs.Cformato)#</cfoutput>"
						if(window.parent.document.form1.Cformato2)
						window.parent.document.form1.Cformato2.value= formato.substring(5,formato.length);
					</cfif>
					if(window.parent.document.form1.Cdescripcion2)
						window.parent.document.form1.Cdescripcion2.value="<cfoutput>#trim(rs.Cdescripcion)#</cfoutput>";
					<cfif isdefined("url.Cformato")>
						if(window.parent.document.form1.Periodos2)
							window.parent.document.form1.Periodos2.focus();
					<cfelse>
						if(window.parent.document.form1.Cformato2)
							window.parent.document.form1.Cformato2.focus();
					</cfif>
				<cfelse>
					<cfif NOT isdefined("url.Cformato")>
						if(window.parent.document.form1.Ccuenta2)
							window.parent.document.form1.Ccuenta2.value="";
						if(window.parent.document.form1.Cmayor2)
							window.parent.document.form1.Cmayor2.value="";
						if(window.parent.document.form1.Mascara2)
							window.parent.document.form1.Mascara2.value="";
					</cfif>
					if(window.parent.document.form1.Cformato2)
						window.parent.document.form1.Cformato2.value="";
					if(window.parent.document.form1.Cdescripcion2)
						window.parent.document.form1.Cdescripcion2.value="";
					
					alert("Cuenta invalida");
				</cfif>															
		</cfif>		
	</script>
</cfif>

