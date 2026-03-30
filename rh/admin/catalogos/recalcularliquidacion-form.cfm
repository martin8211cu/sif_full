<cfinvoke key="LB_ConceptoDePagoParaAjusteDeLiquidacion" default="Concepto de Pago para ajuste de liquidaci&oacute;n"  returnvariable="LB_ConceptoDePagoParaAjusteDeLiquidacion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ConceptoDePagoUsadoEnElRecalculoDeLaLiquidacion" default="Concepto de Pago que debe ser recalculado en la liquidaci&oacute;n"  returnvariable="LB_ConceptoDePagoUsadoEnElRecalculoDeLaLiquidacion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_TITULOCONLISCONCEPTOSPAGO" default="Lista de Conceptos de Pago" returnvariable="LB_TITULOCONLISCONCEPTOSPAGO"component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_NoHayRegistrosRelacionados" default="No hay registros relacionados" returnvariable="MSG_NoHayRegistrosRelacionados" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke key="LB_CODIGO" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_DESCRIPCION" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_ConceptoDePagoParaAjusteDeLiquidacion" default="Concepto de Pago para ajuste de liquidacion"  returnvariable="MSG_ConceptoDePagoParaAjusteDeLiquidacion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="MSG_ConceptoDePagoUsadoEnElRecalculoDeLaLiquidacion" default="Concepto de Pago que debe ser recalculado en la liquidacion"  returnvariable="MSG_ConceptoDePagoUsadoEnElRecalculoDeLaLiquidacion" component="sif.Componentes.Translate"  method="Translate"/>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<cfif isdefined("Form.Cambio")>  
	<cfset modo="CAMBIO">
<cfelse>  
	<cfif not isdefined("Form.modo")>    
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>  
</cfif>

<cfset va_arrayrecalculo=ArrayNew(1)>
<cfset va_arrayresultado=ArrayNew(1)>

<cfif isdefined('form.CIidrecalculo') and len(trim(form.CIidrecalculo))>
	<cfset modo = "CAMBIO">
<!---
<cfelseif isdefined('form.RHCOid') and len(trim(form.RHCOid))>
	<cfset modo = "CAMBIO">
----->
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 	a.CIidrecalculo
				,a.CIidresultado
				,b.CIcodigo as codRecalculo
				,b.CIdescripcion as DescRecalculo
				,c.CIcodigo as codResultado
				,c.CIdescripcion as DescResultado
		from RHLiqRecalcular a
			inner join CIncidentes b
				on a.CIidrecalculo = b.CIid
			inner join CIncidentes c
				on a.CIidresultado = c.CIid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and a.CIidrecalculo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidrecalculo#">
	</cfquery>
	<cfif len(trim("rsDatos.CIidrecalculo"))>
		<cfset ArrayAppend(va_arrayrecalculo, rsDatos.CIidrecalculo)>
		<cfset ArrayAppend(va_arrayrecalculo, rsDatos.codRecalculo)>
		<cfset ArrayAppend(va_arrayrecalculo, rsDatos.DescRecalculo)>
	</cfif>
	<cfif len(trim("rsDatos.CIidresultado"))>
		<cfset ArrayAppend(va_arrayresultado, rsDatos.CIidresultado)>
		<cfset ArrayAppend(va_arrayresultado, rsDatos.codResultado)>
		<cfset ArrayAppend(va_arrayresultado, rsDatos.DescResultado)>
	</cfif>
</cfif>
<cfoutput>
<form name="form1" method="post" action="recalcularliquidacion-sql.cfm">
	<table width="98%" cellpadding="3" cellspacing="0" align="center">
		<tr>
			<td class="fileLabel">#LB_ConceptoDePagoParaAjusteDeLiquidacion#</td>
		</tr>
		<tr>
			<td>
				<cf_conlis 
					campos="CIidAjustado,CIcodigoAjustado,CIdescripcionAjustado"
					asignar="CIidAjustado, CIcodigoAjustado, CIdescripcionAjustado"
					size="0,10,40"
					desplegables="N,S,S"
					modificables="N,S,N"						
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidAjustado, CIcodigo as CIcodigoAjustado, CIdescripcion as CIdescripcionAjustado"
					filtro="Ecodigo = #Session.Ecodigo# and CIcarreracp = 0 and a.CItipo=2"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoAjustado,CIdescripcionAjustado"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"								
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					valuesArray="#va_arrayresultado#" 
					alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
				/>  	
			</td>
		</tr>
		<tr>
			<td class="fileLabel">#LB_ConceptoDePagoUsadoEnElRecalculoDeLaLiquidacion#</td>	
		</tr>
		<tr>
			<td>
				<cf_conlis 
					campos="CIidAjustar,CIcodigoAjustar,CIdescripcionAjustar"
					asignar="CIidAjustar, CIcodigoAjustar, CIdescripcionAjustar"
					size="0,10,40"
					desplegables="N,S,S"
					modificables="N,S,N"						
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidAjustar, CIcodigo as CIcodigoAjustar, CIdescripcion as CIdescripcionAjustar"
					filtro="Ecodigo = #Session.Ecodigo# and CIcarreracp = 0 and a.CItipo=3"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoAjustar,CIdescripcionAjustar"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"								
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					valuesArray="#va_arrayrecalculo#" 
					alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
				/>  	
			</td>
		</tr>		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center"><cf_botones modo="#modo#" exclude="CAMBIO"></td>
		</tr>	
	</table>	
	<cfif modo NEQ "ALTA">
		<input type="hidden" name="CIidrecalculo" value="#rsDatos.CIidrecalculo#">
	</cfif>
</form>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");	//-->
	
	function deshabilitarValidacion(){
		objForm.CIidAjustado.required = false;
		objForm.CIidAjustar.required = false;
	}
	
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CIidAjustado.required = true;
	objForm.CIidAjustado.description = "#MSG_ConceptoDePagoParaAjusteDeLiquidacion#";
	objForm.CIidAjustar.required=true;
	objForm.CIidAjustar.description = "#MSG_ConceptoDePagoUsadoEnElRecalculoDeLaLiquidacion#";
</script>
</cfoutput>