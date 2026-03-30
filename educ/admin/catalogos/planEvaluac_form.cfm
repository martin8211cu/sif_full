<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- <cfdump var="#session#"> --->

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
 	<cfquery name="rsForm" datasource="#session.DSN#">
		select convert(varchar,PEVcodigo) as PEVcodigo
			,PEVnombre
			,ts_rversion
		from PlanEvaluacion
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and PEVcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEVcodigo#">
	</cfquery> 
</cfif>


<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<script language="javascript" type="text/javascript">
	function bajar(cod1, cod2) {
		document.listaConceptos.CECODIGO.value = cod1;
		document.listaConceptos.PEVCODIGO.value = cod2;
		document.listaConceptos._ActionTag.value = "pushDown";
		document.listaConceptos.action = "planEvaluac_SQL.cfm";
		document.listaConceptos.submit();
	}
	
	function subir(cod1, cod2) {
		document.listaConceptos.CECODIGO.value = cod1;
		document.listaConceptos.PEVCODIGO.value = cod2;
		document.listaConceptos._ActionTag.value = "pushUp";
		document.listaConceptos.action = "planEvaluac_SQL.cfm";
		document.listaConceptos.submit();
	}
	function irALista() {
		location.href = "PlanEvaluac.cfm";
	}	
</script>
<form action="planEvaluac_SQL.cfm" method="post" name="formPlanEvaluac">
	<cfif modo neq 'ALTA'>
		<cfoutput>	
			<cfset ts = "">	
				<input type="hidden" name="PEVcodigo" id="PEVcodigo" value="#rsForm.PEVcodigo#">
				<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
			<cfif isdefined('form.modoD') and isdefined('form.CEcodigo')>
				<input type="hidden" name="modoD" id="modoD" value="#form.modoD#">
				<input type="hidden" name="CEcodigo" id="CEcodigo" value="#form.CEcodigo#">				
			</cfif>
		</cfoutput>		
	</cfif>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3" class="tituloMantenimiento">
			<cfif modo EQ "ALTA">Nuevo <cfelse>Modificar </cfif>Plan de Evaluaci&oacute;n	
		</td>
	  </tr>
	  <tr>
		<td colspan="3">&nbsp;</td>
	  </tr>  
	  <tr>
		<td width="18%" align="right">Descripci&oacute;n</td>
		<td width="41%">
			<input name="PEVnombre" type="text" id="PEVnombre" onFocus="javascript:this.select();" size="80" maxlength="80" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.PEVnombre#</cfoutput></cfif>">
		</td>
	    <td width="41%" align="right">
			<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">		
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="2">&nbsp;</td>
	  </tr>  
	  <tr>
		<td colspan="3" align="center">
		  	<cfset mensajeDelete = "¿Desea Eliminar el Plan de Evaluaci&oacute;n?">
			<cfinclude template="/educ/portlets/pBotones.cfm">
			<input type="button" name="btnLista"  tabindex="1" value="Lista de Planes de Evaluación" onClick="javascript: irALista();">
		</td>
	  </tr>  	  
	</table>
</form>

<cfif modo NEQ 'ALTA'>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td align="center" colspan="3" class="<cfoutput>#Session.Preferences.Skin#</cfoutput>_thcenter">Conceptos del Plan de Evaluaci&oacute;n</td>
	  </tr>
	  <tr>
		<td width="49%" valign="top">	
			<cfinvoke component="educ.componentes.pListas" 
					  method="pListaEdu" 
					  returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="
							PlanEvaluacionConcepto	pec
							, PlanEvaluacion pe
							, ConceptoEvaluacion ce"/>
				<cfinvokeargument name="columnas" value="
					PEVnombre, 
					convert(varchar, pec.CEcodigo) as CEcodigo,
					convert(varchar, pec.PEVcodigo) as PEVcodigo,
					convert(varchar, PECporcentaje) as PECporcentaje,
					CEnombre,
					modoD='CAMBIO',
					PECorden, '#Session.JSroot#/imagenes/iconos/array_up.gif' as upImg
							, '#Session.JSroot#/imagenes/iconos/array_dwn.gif' as downImg"/>
				<cfinvokeargument name="desplegar" value="CEnombre, PECporcentaje, upImg, downImg"/>
				<cfinvokeargument name="etiquetas" value="Concepto, Porcentaje, &nbsp;, &nbsp;"/>
				<cfinvokeargument name="formatos"  value="V,V,IMG,IMG"/>
				<cfinvokeargument name="filtro" value="
						pe.Ecodigo=#session.Ecodigo# 
						and pec.PEVcodigo=#form.PEVcodigo#
						and pec.PEVcodigo=pe.PEVcodigo					
						and pe.Ecodigo=ce.Ecodigo
						and pec.CEcodigo=ce.CEcodigo
					order by PECorden,PEVnombre"/>
				<cfinvokeargument name="align" value="left,left,center,center"/>
				<cfinvokeargument name="ajustar" value="N,N,N,N"/>
				<cfinvokeargument name="funcion" value=" , , subir, bajar"/>
				<cfinvokeargument name="fparams" value="CEcodigo, PEVcodigo"/>
				<cfinvokeargument name="funcionByCols" value="true"/>
				<cfinvokeargument name="keys" value="CEcodigo, PEVcodigo"/>
				<cfinvokeargument name="irA" value="planEvaluac.cfm"/>
				<cfinvokeargument name="formName" value="listaConceptos"/>
				<cfinvokeargument name="MaxRows" value="15"/>
			</cfinvoke>
			
			<cfquery name="sumListaPlanEvalDet" datasource="#Session.DSN#">
			  set nocount on
				  select str(isnull(sum(pec.PECporcentaje),0),6,2)+' %' as Total
				  from PlanEvaluacionConcepto pec
					, ConceptoEvaluacion ce
				  where pec.PEVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEVcodigo#">
				  and pec.CEcodigo = ce.CEcodigo
			  set nocount off
			</cfquery>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				
				<cfif sumListaPlanEvalDet.Total NEQ '100.00 %'>
					<td width="10%"><strong><font size="3" color="Red">Total</font></strong></td>
					<td width="47%" align="right"><strong><font size="3" color="Red"><cfoutput>#sumListaPlanEvalDet.Total#</cfoutput></font></strong></td>
				<cfelse>
					<td width="1%"><strong><font size="3">Total</font></strong></td>
					<td width="42%" align="right"><strong><font size="3"><cfoutput>#sumListaPlanEvalDet.Total#</cfoutput></font></strong></td>
				</cfif>
			  </tr>
			  <cfif sumListaPlanEvalDet.Total NEQ '100.00 %'>
			  		<td colspan="2" align="center">
						<font size="1" color="Red"><b>El Plan estará incompleto mientras no sume el 100%, <br>
							y por tanto no podrá utilizarse.</b></font>
						<!--- <textarea name="descripcion" tabindex="3" rows="5"  style="width: 100%">El Plan estará incompleto, hasta que sume el 100%, por lo tanto no lo podrá utilizar.</textarea> --->
					</td>
			  </cfif>
			</table>

					
		</td>
	    <td width="2%" valign="top">&nbsp;</td>		
		<td width="49%" valign="top">
			<cfinclude template="DetplanEvaluac_form.cfm">
		</td>
	  </tr>
	</table>
</cfif>

<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.PEVnombre.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.PEVnombre.required = true;
	}
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formPlanEvaluac");
//---------------------------------------------------------------------------------------
	<cfif modo EQ "ALTA">
		objForm.PEVnombre.required = true;
		objForm.PEVnombre.description = "Descripción";
	<cfelseif modo EQ "CAMBIO">
		objForm.PEVnombre.required = true;
		objForm.PEVnombre.description = "Descripción";
	</cfif>	
</script>