<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario = url.formulario>
<cfelse>	
	<cfset form.formulario = form1>
</cfif>
<cfif isdefined("url.index") and not isdefined("form.index")>
	<cfset form.index = url.index>
</cfif>
<cfset filtro =''>
<cfif isdefined("url.RHCcodigo") and not isdefined("form.RHCcodigo")>
	<cfset filtro = filtro & " and upper(a.RHCcodigo) like '%" & UCase(url.RHCcodigo) & "%'">
</cfif>
<cfif isdefined("url.RHCcodigo") and len(trim(url.RHCcodigo))>
	<cfquery name="rs" datasource="#session.DSN#">
			select 	c.Mnombre,
					a.RHCnombre, 
					c.Msiglas,
					<cf_dbfunction name="date_format" args="a.RHCfdesde,DD/MM/YYYY"> as RHCfdesde,
					<cf_dbfunction name="date_format" args="a.RHCfhasta,DD/MM/YYYY"> as RHCfhasta,
					a.RHCid,
					a.RHIAid,
					a.Mcodigo,
					a.RHCcupo,
					d.RHIAnombre,
					a.RHCcodigo

		from RHCursos a
		
			inner join RHOfertaAcademica b
				on a.RHIAid = b.RHIAid
				and a.Mcodigo = b.Mcodigo

			inner join RHMateria c
				on b.Mcodigo = c.Mcodigo
			
			inner join RHInstitucionesA d
				on b.RHIAid = d.RHIAid

		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">	
		#preservesinglequotes(filtro)#
		order by a.RHCcodigo, a.RHCnombre
	</cfquery>	
	
	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		<cfif rs.recordCount gt 0>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Mcodigo<cfoutput>#form.index#</cfoutput>.value = '#rs.Mcodigo#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCcodigo<cfoutput>#form.index#</cfoutput>.value = '#rs.RHCcodigo#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCnombre<cfoutput>#form.index#</cfoutput>.value = '#rs.RHCnombre#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCid<cfoutput>#form.index#</cfoutput>.value = '#rs.RHCid#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHIAid<cfoutput>#form.index#</cfoutput>.value = '#rs.RHIAid#';			
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCfdesde<cfoutput>#form.index#</cfoutput>.value = '#rs.RHCfdesde#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCfhasta<cfoutput>#form.index#</cfoutput>.value = '#rs.RHCfhasta#';			
		<cfelse>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Mcodigo<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCcodigo<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCnombre<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCid<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHIAid<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCfdesde<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCfhasta<cfoutput>#form.index#</cfoutput>.value = '';			
		</cfif>
		</cfoutput>
	</script>
<cfelse>		
		<script language="javascript1.2" type="text/javascript">
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Mcodigo<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCcodigo<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCnombre<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCid<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHIAid<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCfdesde<cfoutput>#form.index#</cfoutput>.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.RHCfhasta<cfoutput>#form.index#</cfoutput>.value = '';	
		</script>
</cfif>



