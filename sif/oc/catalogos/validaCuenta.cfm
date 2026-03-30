<cfif isdefined("url.Cmayor") and url.Cmayor NEQ "">
	<cfquery name="rsmascara" datasource="#session.dsn#">
		select CPVformatoF from CPVigencia
		where Cmayor  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Cmayor#">
		and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between CPVdesde and CPVhasta
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfquery name="rs" datasource="#session.dsn#">
		SELECT Cmayor,Cformato,Cdescripcion 
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
		
		<cfif rsmascara.recordcount gt 0>
			var mascara = "<cfoutput>#trim(rsmascara.CPVformatoF)#</cfoutput>";
			if(window.parent.document.form2.Mascara)
				window.parent.document.form2.Mascara.value=mascara.substring(5,mascara.length);
			if(window.parent.document.form2.MascaraM)	
				window.parent.document.form2.MascaraM.value ='XXXX'
		<cfelse>
			if(window.parent.document.form2.Mascara)
				window.parent.document.form2.Mascara.value="";
			if(window.parent.document.form2.MascaraM)	
				window.parent.document.form2.MascaraM.value ="";
		</cfif>
		
		<cfif rs.recordcount gt 0>
			if(window.parent.document.form2.Cformato)
				window.parent.document.form2.Cformato.value="<cfoutput>#trim(rs.Cformato)#</cfoutput>";
			if(window.parent.document.form2.Cmayor)
				window.parent.document.form2.Cmayor.value="<cfoutput>#trim(rs.Cmayor)#</cfoutput>";
			<cfif isdefined("url.Cformato")>
				var formato = "<cfoutput>#trim(rs.Cformato)#</cfoutput>"
				if(window.parent.document.form2.CDetalle)
				window.parent.document.form2.CDetalle.value= formato.substring(5,formato.length);
			</cfif>
			if(window.parent.document.form2.Cdescripcion)
				window.parent.document.form2.Cdescripcion.value="<cfoutput>#trim(rs.Cdescripcion)#</cfoutput>";
			<cfif isdefined("url.Cformato")>
				if(window.parent.document.form2.Periodos)
					window.parent.document.form2.Periodos.focus();
			<cfelse>
				if(window.parent.document.form2.CDetalle)
					window.parent.document.form2.CDetalle.focus();
			</cfif>
			//var btn  = window.parent.document.getElementById("Consultar");
			//if(btn)
			//	btn.disabled = false;
		<cfelse>
			<cfif NOT isdefined("url.Cformato")>
				if(window.parent.document.form2.Cformato)
					window.parent.document.form2.Cformato.value="";
				if(window.parent.document.form2.Cmayor)
					window.parent.document.form2.Cmayor.value="";
				if(window.parent.document.form2.Mascara)
					window.parent.document.form2.Mascara.value="";
			</cfif>
			if(window.parent.document.form2.CDetalle)
				window.parent.document.form2.CDetalle.value="";
			if(window.parent.document.form2.Cdescripcion)
				window.parent.document.form2.Cdescripcion.value="";
			
			alert("Cuenta invalida");
			//var btn  = window.parent.document.getElementById("Consultar");
			//if(btn)
			//	btn.disabled = false;
		</cfif>			
	</script>
</cfif>

