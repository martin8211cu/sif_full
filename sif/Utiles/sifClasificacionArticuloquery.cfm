<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and len(trim(url.dato))>
	<cfquery name="rs" datasource="#session.DSN#">
		select Ccodigo, Ccodigoclas, Cdescripcion, Cnivel, CAid, coalesce(Cconsecutivo,0) as Cconsecutivo
		from Clasificaciones
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(Ccodigoclas) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
	</cfquery>
    <cfif isdefined("Url.conse") and not isdefined("Form.conse")>
		<cfparam name="Form.conse" default="#Url.conse#">
       
        <cfquery name="rsCodigoArt" datasource="#session.DSN#">
            select coalesce(Pvalor,'0') as Pvalor
            from Parametros
            where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and Pcodigo=5300
        </cfquery>
	</cfif>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			function trim(dato) {
				dato = dato.replace(/^\s+|\s+$/g, '');
				return dato;
			}

			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.Ccodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="<cfoutput>#rs.Ccodigoclas#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#rs.Cdescripcion#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.nivel#</cfoutput>.value="<cfoutput>#rs.Cnivel#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.CAid_#url.name#</cfoutput>.value="<cfoutput>#rs.CAid#</cfoutput>";
			<cfoutput>
			<cfif isdefined("form.conse") and form.conse eq "yes">
				var DVmascara = "#rsCodigoArt.Pvalor#";
				var varConse = #rs.Cconsecutivo#;
				if(varConse == 0){
					con = 1 ;
				}
				else{	
					con = parseInt(#rs.Cconsecutivo#) +1 ;
				}
				Cconsecutivo = con+"";
				codigos = trim("#rs.Ccodigoclas#");
				vari = (DVmascara.length - (codigos.length + Cconsecutivo.length));
				for (i=0; i < vari ;i++){
					codigos = codigos+"0";
				}
				codigos=codigos+""+Cconsecutivo;
				window.parent.document.#url.formulario#.Acodigo.value = trim(codigos);
			</cfif>
			if (window.parent.func#url.name#) {window.parent.func#url.name#();}			
			</cfoutput>
			
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.nivel#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.CAid_#url.name#</cfoutput>.value="";
			<cfoutput>
			<cfif isdefined("form.conse") and form.conse eq "yes">
				window.parent.document.<cfoutput>#url.formulario#</cfoutput>.Acodigo.value = "";
			</cfif>
			</cfoutput>
		</script>
	</cfif>
</cfif>