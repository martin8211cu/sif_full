<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfparam name="url.FPEPid" default="-1">
<cfquery datasource="#session.dsn#" name="rsClasificaciones">
	select Pla.FPCCid , Cat.FPCCcodigo
		from FPDPlantilla Pla
			inner join FPCatConcepto Cat
				on Cat.FPCCid = Pla.FPCCid
	where Pla.FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FPEPid#">
</cfquery>
<cfset PCG_ConceptoGastoIngreso = createobject("component","sif.Componentes.PCG_ConceptoGastoIngreso")>
		<cfset filtroFPCCid ="">
<cfloop query="rsClasificaciones">
		<cfset filtroFPCCid &= PCG_ConceptoGastoIngreso.fnListaClasificaciones(rsClasificaciones.FPCCcodigo)>
	<cfif rsClasificaciones.currentRow NEQ rsClasificaciones.recordcount>
		<cfset filtroFPCCid &= ','>
	</cfif>
</cfloop>
<cfif isdefined("url.dato") and len(trim(url.dato))>
	<cfquery name="rs" datasource="#session.DSN#">
		select c.Cid, c.Ccodigo, c.Cdescripcion, coalesce(c.Ucodigo, '') as Ucodigo, cc.cuentac
		from Conceptos c
		inner join CConceptos cc
			on cc.CCid=c.CCid
		inner join CConceptos b
			inner join FPCatConcepto fpcc
				on fpcc.FPCCTablaC = b.CCid and fpcc.FPCCid in (#filtroFPCCid#)
			on c.CCid=b.CCid
		where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and upper(c.Ccodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(url.dato))#">
		<cfif isdefined("url.tipo") and len(trim(url.tipo))>
			and upper(c.Ctipo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Ucase(url.tipo))#">
		</cfif>
		<cfif isdefined("url.filtroextra") and len(trim(url.filtroextra))>
			#url.filtroextra#
		</cfif>
	</cfquery>
	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			if(window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value='<cfoutput>#rs.Cid#</cfoutput>';
			if(window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>)	
				window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value='<cfoutput>#rs.Ccodigo#</cfoutput>';
			if(window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value='<cfoutput>#rs.Cdescripcion#</cfoutput>';
			if(window.parent.document.<cfoutput>#url.formulario#.Ucodigo_#url.name#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.Ucodigo_#url.name#</cfoutput>.value='<cfoutput>#trim(rs.Ucodigo)#</cfoutput>';
			if(window.parent.document.<cfoutput>#url.formulario#.#url.cuentac#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.cuentac#</cfoutput>.value='<cfoutput>#rs.cuentac#</cfoutput>';	
			<cfoutput>
				if(window.parent.func#url.name#)
					window.parent.func#url.name#();			
				<cfif isdefined('url.FuncJSalCerrar') and Len(Trim(url.FuncJSalCerrar)) GT 0 > 
					if(window.parent.#url.FuncJSalCerrar#)
						window.parent.#url.FuncJSalCerrar#;	
				</cfif>
			</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			if(window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			if(window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>)	
				window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="";
			if(window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			if(window.parent.document.<cfoutput>#url.formulario#.Ucodigo_#url.name#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.Ucodigo_#url.name#</cfoutput>.value="";
			if(window.parent.document.<cfoutput>#url.formulario#.#url.cuentac#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.cuentac#</cfoutput>.value="";	
		</script>
	</cfif>
</cfif>