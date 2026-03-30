<cfset msg = ''>
<cftry>

<cfquery datasource="asp" name="shortcut">
	select s.id_shortcut
	from SShortcut s
		left join SMenuItem i
			on i.id_item = s.id_item
	where s.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and(s.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and s.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
	  and s.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.p#">
	   or i.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and i.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
	  and i.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.p#">)
</cfquery>

<cfif Len(shortcut.id_shortcut)>
	<cfquery datasource="asp">
		update SShortcut
		set descripcion_shortcut = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.t#">
		,   SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
		,   SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
		,   SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.p#">
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and id_shortcut = <cfqueryparam cfsqltype="cf_sql_numeric" value="#shortcut.id_shortcut#">
	</cfquery>
	<cfset id_shortcut = shortcut.id_shortcut>
<cfelse>
	<cftransaction>
		<cfquery datasource="asp" name="inserted">
			insert into SShortcut (Usucodigo, descripcion_shortcut, SScodigo, SMcodigo, SPcodigo, BMfecha, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.t#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.p#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
			<cf_dbidentity1 datasource="asp" name="inserted">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="inserted">
	</cftransaction>
	<cfset id_shortcut = inserted.identity>
</cfif>
<cfcatch type="any"><cfset msg = cfcatch.Message & " " & cfcatch.Detail></cfcatch>
</cftry>
<cfoutput>
	<html><head>
	<script type="text/javascript">
	<!--
	<cfif Len(msg) Is 0>
		<cfif Len(id_shortcut)>
			var favmod = document.all ? document.all.mlm_TdFavoritos_#id_shortcut# :
						document.getElementById("mlm_TdFavoritos_#id_shortcut#");
			if (favmod) {
				favmod.innerHTML = '#JSStringFormat(url.t)#';
			} else
		</cfif>
			{
				var tb = document.all ? window.parent.document.all.mlm_TableFavoritos : window.parent.document.getElementById('mlm_TableFavoritos');
				var tr = document.createElement("TR");
				var td = document.createElement("TR");
				td.className = 'mlm_item';
				//td.onmouseover= "mlm_over(this,1)"; 
				//td.onmouseout="mlm_out(this,1)";
				//td.onclick="location.href='/cfmx/home/menu/portal.cfm?_nav=1&amp;s=#URLEncodedFormat(url.s)#&amp;m=#URLEncodedFormat(url.m)#&amp;p=#URLEncodedFormat(url.p)#'";
				//td.onmousemove = new Function ( " alert('evento');eval ( 'mlm_move(this,1)' ) " );
				td.id = "mlm_TdFavoritos_#id_shortcut#";
				var innertext = document.createTextNode('_#JSStringFormat(url.t)# ');
				td.appendChild(innertext);
				tr.appendChild(td);
				tb.appendChild(tr);
			}

		alert ('#JSStringFormat(url.t)# agregado a Favoritos.');
		
	<cfelse>
		alert ('#JSStringFormat(msg)#');
	</cfif>
	//-->
	</script>
	</head><body></body></html>
</cfoutput>
