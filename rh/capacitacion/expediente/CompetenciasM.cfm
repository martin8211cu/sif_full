<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Competencias"
	Default="Competencias"
	returnvariable="LB_Competencias"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Experiencia"
	Default="Experiencia"
	returnvariable="LB_Experiencia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Educacion"
	Default="Educaci&oacute;n"
	returnvariable="LB_Educacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HistorialDeLaCompetencia"
	Default="Historial de la competencia"
	returnvariable="LB_HistorialDeLaCompetencia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_"
	Default=""
	returnvariable="LB_"/>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfset MODOC1 = 'ALTA'>
<cfset ANOTA = 'N'>
<cfset ADDCUR = 'N'>

<cfif isdefined("url.MODOC1") and not isdefined("form.MODOC1")>
	<cfset MODOC1 = url.MODOC1 >
</cfif>
<cfif isdefined("form.MODOC1") and not isdefined("url.MODOC1")>
	<cfset MODOC1 = form.MODOC1 >
</cfif>
<cfif isdefined("url.ANOTA") and not isdefined("form.ANOTA")>
	<cfset ANOTA = url.ANOTA >
</cfif>
<cfif isdefined("form.ANOTA") and not isdefined("url.ANOTA")>
	<cfset ANOTA = form.ANOTA >
</cfif>
<!--- ******************* --->
<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset DEid = url.DEid >
</cfif>
<cfif isdefined("form.DEid") and not isdefined("url.DEid")>
	<cfset DEid = form.DEid >
</cfif>
<cfif isdefined("url.RHOid") and not isdefined("form.RHOid")>
	<cfset RHOid = url.RHOid >
</cfif>
<cfif isdefined("form.RHOid") and not isdefined("url.RHOid")>
	<cfset RHOid = form.RHOid >
</cfif>
<cfif isdefined("form.ADDCUR") and not isdefined("url.ADDCUR")>
	<cfset ADDCUR = form.ADDCUR >
</cfif>
<cfif isdefined("url.ADDCUR") and not isdefined("form.ADDCUR")>
	<cfset ADDCUR = url.ADDCUR >
</cfif>
<!--- ******************* --->

<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//utiles</script>
<cfif ANOTA eq 'N'>
	 <table width="100%" border="0">
	    <tr>
			<td valign="top" id="CompList" colspan="2" <cfif MODOC1 eq 'CAMBIO' or isdefined("Form.changes")> style="display:none" </cfif> >
				<cf_web_portlet_start border="true" titulo="#LB_Competencias#" skin="#Session.Preferences.Skin#">
						<cfinclude template="CompetenciaList.cfm">
				<cf_web_portlet_end>
			</td>
	    </tr>
		<tr>
			<td valign="top" id="CompMant" colspan="2" <cfif MODOC1 neq 'CAMBIO'> style="display:none" </cfif>>
				<cf_web_portlet_start border="true" titulo="#LB_Competencias#" skin="#Session.Preferences.Skin#">
					<cfinclude template="CompetenciaMant.cfm">
				<cf_web_portlet_end>
			</td>
	  </tr>
	  <tr>
		<td valign="top">
			<cf_web_portlet_start border="true" titulo="#LB_Experiencia#" skin="#Session.Preferences.Skin#">
				<cfinclude template="experiencia-resumen.cfm">
			<cf_web_portlet_end>			
		</td>
		<td valign="top">
			<cf_web_portlet_start border="true" titulo="#LB_Educacion#" skin="#Session.Preferences.Skin#">
				<cfinclude template="educacion-resumen.cfm">
			<cf_web_portlet_end>		
		</td>
	  </tr>
	</table>
 <cfelse>
	<table width="100%" border="0">

			<tr>
				<td valign="top" colspan="2">
					<cf_web_portlet_start border="true" titulo="#LB_HistorialDeLaCompetencia#" skin="#Session.Preferences.Skin#">
					<table width="100%" border="0">
						<tr>
							<td width="70%"  rowspan="2" valign="top"><cfinclude template="CompetenciaHistoriaM.cfm"></td>
							<td width="30%" valign="top">
							<cfif ADDCUR eq 'S'>						
									<cfinclude template="CompetenciaCursoMant.cfm">
							</cfif>
							</td>
					</tr>
					<tr>
						<td valign="top"><cfinclude template="CompetenciaHistoriaG.cfm"></td> 
					</tr>
				</table>
				<cf_web_portlet_end>	
			</td>
		</tr>
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" titulo="#LB_Experiencia#" skin="#Session.Preferences.Skin#">
					<cfinclude template="experiencia-resumen.cfm">
				<cf_web_portlet_end>		
			</td>
			<td valign="top">
				<cf_web_portlet_start border="true" titulo="#LB_Educacion#" skin="#Session.Preferences.Skin#">
					<cfinclude template="educacion-resumen.cfm">
				<cf_web_portlet_end>	
			</td>
		</tr>
		<!--- <tr>
			<td valign="top" colspan="2">
				<cf_web_portlet_start border="true" titulo="Evaluaciones Realizadas" skin="#Session.Preferences.Skin#">
					<cfinclude template="CompetenciaEval.cfm">
				<cf_web_portlet_end>		
			</td>
		</tr> --->
	</table>
</cfif>

<script type="text/javascript" language="javascript1.2" >
<cfif ANOTA eq 'N'>
	function AddMantenimiento(){
		var CompList = document.getElementById("CompList");
		var CompMant = document.getElementById("CompMant");
        CompList.style.display = 'none';
        CompMant.style.display = ''
	}
	
	function AddLista(){
		<cfif ANOTA eq 'N'>
			var CompList = document.getElementById("CompList");
			var CompMant = document.getElementById("CompMant");
			CompMant.style.display = 'none';
			CompList.style.display = ''; 
		</cfif>	
	}	
	<cfif isdefined("Form.VERLIST") or (isdefined("Form.EditaCompetencia") and trim(form.EditaCompetencia) eq 1) or isdefined("Form.changes")>
		AddMantenimiento(); 
	<cfelse>
		AddLista();
	</cfif>
</cfif>
	
</script>