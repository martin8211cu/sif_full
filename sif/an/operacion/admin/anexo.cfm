<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Administración de Anexos" 
returnvariable="LB_Titulo" xmlfile="anexo.xml"/>

<cfif isdefined("form.AnexoId") and not isdefined("url.AnexoId")>
	<cfset url.AnexoId = form.AnexoId>
</cfif>
<cfif isdefined("form.tab") and not isdefined("url.tab")>
	<cfset url.tab = form.tab>
</cfif>
<cfif isdefined("form.Eliminar") and not isdefined("url.Eliminar")>
	<cfset url.Eliminar = form.Eliminar>
</cfif>
<cfparam name="url.AnexoId" type="numeric" default="0">
<cfif url.AnexoId>
	<cfset form.AnexoId = url.AnexoId>
	<cfinclude template="anexo-validar-permiso.cfm">
</cfif>
<cfparam name="url.tab" type="numeric" default="1">
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		
		<cfinclude template="anexo-head.cfm">
		<cfif url.AnexoId>
			<cf_tabs width="950">
				<cf_tab text="Anexo" selected="#url.tab eq 1#">
					<cfif url.tab eq 1>
					<cfinclude template="anexo-form.cfm"></cfif>
				</cf_tab>
				<cf_tab text="Celdas" selected="#url.tab eq 2#">
					<cfif url.tab eq 2>
						<cfinclude template="anexo-rango.cfm"></cfif>
				</cf_tab>
				<cf_tab text="Permisos" selected="#url.tab eq 3#">
					<cfif url.tab eq 3>
						<cfinclude template="anexo-permisos.cfm"></cfif>
				</cf_tab>
				<cf_tab text="Empresas" selected="#url.tab eq 4#">
					<cfif url.tab eq 4>
					<cfinclude template="anexo-empresas.cfm"></cfif>
				</cf_tab>
			</cf_tabs>
		</cfif>
			
	<script type="text/javascript">
		<!--
		function tab_set_current (n){
			location.href='anexo.cfm?AnexoId=<cfoutput>#JSStringFormat(url.AnexoId)#</cfoutput>&tab='+escape(n);
			<!--- if (tab_current == n) return; --->
		}
		//-->
	</script>
	<cf_web_portlet_end>
<cf_templatefooter>
