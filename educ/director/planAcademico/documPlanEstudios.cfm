<!-- Establecimiento del modo -->
<cfparam name="form.PEScodigo" default="">
<cfquery name="rsEncPlan" datasource="#Session.DSN#">
	Select PEScodigo
		, PESnombre
		, CARnombre
		, ESnombre
		, Fnombre
	from PlanEstudios pe
		, Carrera c
		, Escuela e
		, Facultad f
	where pe.PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
		and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and pe.CARcodigo=c.CARcodigo
		and c.EScodigo=e.EScodigo
		and c.Ecodigo=e.Ecodigo
		and e.Fcodigo=f.Fcodigo
		and e.Ecodigo=f.Ecodigo		
</cfquery>

<cfif isdefined('rsEncPlan') and rsEncPlan.recordCount GT 0>
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="right"><strong>#Session.parametros.Facultad#:</strong></td>
			<td>&nbsp;</td>
			<td>#rsEncPlan.Fnombre#</td>
		  </tr>
		  <tr>
			<td align="right"><strong>#Session.parametros.Escuela#:</strong></td>
			<td>&nbsp;</td>
			<td>#rsEncPlan.ESnombre#</td>
		  </tr>
		  <tr>
			<td align="right"><strong>Carrera:</strong></td>
			<td>&nbsp;</td>
			<td>#rsEncPlan.CARnombre#</td>
		  </tr>    
		  <tr>
			<td align="right"><strong>Plan:</strong></td>
			<td>&nbsp;</td>
			<td>#rsEncPlan.PESnombre#</td>
		  </tr>
		  <tr>
			<td width="17%">&nbsp;</td>
			<td width="3%">&nbsp;</td>
			<td width="80%">&nbsp;</td>
		  </tr>		  
		</table>
	</cfoutput>
</cfif>

<cfparam name="form.PDOcodigo" default="">
<cfparam name="form.modoDocum" default="LISTA">	

<cfif form.PDOcodigo EQ "">
 	<cfif isdefined('form.modoDocum') and form.modoDocum EQ 'LISTA'>
		<cfinvoke component="educ.componentes.pListas" 
				  method="pListaEdu" 
				  returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="PlanDocumentacion"/>
			<cfinvokeargument name="columnas" value="
				convert(varchar,PEScodigo) as PEScodigo
				, convert(varchar,PDOcodigo) as PDOcodigo
				, PDOtitulo
 				, EScodigo=#form.EScodigo#
				, CARcodigo=#form.CARcodigo#			
				, modoDocum='CAMBIO'
				, TabsPlan=2
				, Nivel=2"/>	
			<cfinvokeargument name="desplegar" value="PDOtitulo"/>
			<cfinvokeargument name="etiquetas" value="Titulo"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="
					PEScodigo=#form.PEScodigo# 
				order by PDOsecuencia"/>
			<cfinvokeargument name="align" value="left"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="keys" value="PDOcodigo"/>
			<cfinvokeargument name="irA" value="CarrerasPlanes.cfm"/>
			<cfinvokeargument name="Botones" value="Nueva"/>
			<cfinvokeargument name="debug" value="N"/>				
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="formName" value="formListaDocumPlan"/>
		</cfinvoke>
	<cfelse>
		<cfinclude template="documPlanEstudios_form.cfm">
	</cfif>
<cfelse>
	<cfinclude template="documPlanEstudios_form.cfm">
</cfif>

<script language="JavaScript" type="text/javascript">
	function funcNueva(){
		document.formListaDocumPlan.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';
		document.formListaDocumPlan.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';		
		document.formListaDocumPlan.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';		
		document.formListaDocumPlan.NIVEL.value= 2;
		document.formListaDocumPlan.TABSPLAN.value= 2;		
		document.formListaDocumPlan.PDOCODIGO.value= '';		
		document.formListaDocumPlan.modo.value= 'CAMBIO';
		document.formListaDocumPlan.MODODOCUM.value= 'ALTA';				
	}		
</script>		