<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Productos Ofrecidos
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ajustes de Inventario'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<br><table width="99%" align="center" border="0" cellpadding="0" cellspacing="0"><tr><td>
			<cfset filtro = "">
			<cfinclude template="Productos-filtro.cfm">
			<cfquery name="rsQuery" datasource="#session.dsn#">
				select a.PRJPPid, a.PRJPPcodigo, a.PRJPPdescripcion, a.PRJPPfechaIni, a.PRJPPfechaFin, a.Ucodigo, a.PRJPPcostoDirecto,
					   (a.PRJPPcostoDirecto * (a.PRJPPporcentajeIndirecto/100)) as Cindirecto,
					   ((a.PRJPPcostoDirecto * (a.PRJPPporcentajeIndirecto/100)) + a.PRJPPcostoDirecto) as Punit
				from PRJPproducto a 				
				where 1=1
				<cfif isdefined("Form.fPRJPPcodigo") and form.fPRJPPcodigo NEQ "all" >
					and a.PRJPPcodigo like upper('%#Form.fPRJPPcodigo#%')
				</cfif>
				<cfif isdefined("Form.fPRJPPdescripcion") and form.fPRJPPdescripcion NEQ "" >
					and upper(PRJPPdescripcion) like upper('%#Form.fPRJPPdescripcion#%')
				</cfif>
				<cfif isdefined("Form.fPRJPPfechaini") and form.fPRJPPfechaini neq "" >
				   <cfset Lfecha = LSParseDateTime(Form.fPRJPPfechaini)>
					and PRJPPfechaIni >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lfecha#">
				</cfif>
				<cfif isdefined("Form.fUcodigo") and form.fUcodigo neq "all" >
					and Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fUcodigo#">
				</cfif>				
				order by PRJPPcodigo
			</cfquery>
			<form action="PRJPproducto.cfm" method="post" name="lista" style="margin:0">

				<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsquery#"/>
					<cfinvokeargument name="desplegar" value="PRJPPcodigo, PRJPPdescripcion, PRJPPfechaini, PRJPPfechaFin, PRJPPcostoDirecto, Cindirecto, Punit"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Fecha Inicial, Fecha Final, C. Directo, C. Indirecto, P. Unitario"/>
					<cfinvokeargument name="formatos" value="V, V, D, D, M, M, M"/>
					<cfinvokeargument name="align" value="left, left, left, left, right, right, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="PRJPproducto.cfm?ban=1"/>
					<cfinvokeargument name="keys" value="PRJPPid"/>
					<cfinvokeargument name="botones" value="Nuevo"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="formname" value="lista"/>
					<cfinvokeargument name="incluyeform" value="false"/>
				</cfinvoke>
			</form>
			
			<br></td></tr></table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
