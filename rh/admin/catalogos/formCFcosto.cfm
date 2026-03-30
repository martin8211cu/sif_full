<!--- Consultas --->
<!-- Establecimiento del modo -->
<cfif isdefined("form.CFCid")>
	<cfset modo="CAMBIO_C">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA_C">
	<cfelseif form.modo EQ "CAMBIO_C">
		<cfset modo="CAMBIO_C">
	<cfelse>
		<cfset modo="ALTA_C">
	</cfif>
</cfif>

<cfif modo neq 'ALTA_C'>
	<!--- Form --->
	<cfquery name="rsFormCos" datasource="#session.DSN#">
		select c.Ccodigo, c.Cdescripcion, c.Cporc, c.Cid, cfc.CFid, cfc.ts_rversion, cfc.CFCid
		from CfuncionalConc cfc
        inner join Conceptos c
        on c.Cid = cfc.Cid
            and c.Ecodigo = cfc.Ecodigo
		where cfc.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and cfc.CFid = (select CFid from CFuncional where CFcodigo ='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#)
			and cfc.CFCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFCid#">
	</cfquery>
</cfif>
<cfset filtro = "">
<cfif modo eq 'ALTA_C'>
<cfset filtro = "and not exists (select 1 from CfuncionalConc cfco
								where cfco.Cid = c.Cid and cfco.CFid = #LvarCFid# 
								and Ecodigo = #session.Ecodigo#)">
</cfif>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<form name="formCosto" method="post" action="SQLCFuncional.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="right" nowrap="nowrap">&nbsp;<strong><cf_translate XmlFile="/rh/generales.xml" key="LB_USUARIO">Costo</cf_translate>:</strong>&nbsp;</td>
      <td>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_TITULOCONLIS"
			Default="Lista de Costos"
			returnvariable="LB_TITULOCONLIS"/>	

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CODIGO"
			Default="Codigo"
			returnvariable="LB_CODIGO"/>	
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CONCEPTO"
			Default="Concepto"
			returnvariable="LB_CONCEPTO"/>	
            
            <cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_PORCENTAJE"
			Default="Porcentaje"
			returnvariable="LB_PORCENTAJE"/>
            <cfset ValuesArray=ArrayNew(1)>
			<cfif (modo neq "ALTA_C")>
                <cfset ArrayAppend(ValuesArray,rsFormCos.Ccodigo)>
                <cfset ArrayAppend(ValuesArray,rsFormCos.Cdescripcion)>
                <cfset ArrayAppend(ValuesArray,rsFormCos.Cid)>
            </cfif>		
			<cf_conlis title="#LB_TITULOCONLIS#"
            campos = "Ccodigo, Cdescripcion, Cid, Cporc" 
            ValuesArray="#ValuesArray#"
            desplegables = "S,S,N,N" 
            modificables = "N,N,N,N" 
            size = "10,40,0"
            asignar="Ccodigo, Cdescripcion, Cid, Cporc"
            asignarformatos="S,S,S"
            tabla="Conceptos c"																	
            columnas="c.Ccodigo, c.Cdescripcion, c.Cid, c.Cporc"
            filtro="c.Ecodigo = #session.Ecodigo#
					    and c.Ctipo = 'G'
					  	and coalesce(c.Cporc,0) > 0
                        #filtro#"
            desplegar="Ccodigo, Cdescripcion, Cporc"
            etiquetas="#LB_CODIGO#, #LB_CONCEPTO#, #LB_PORCENTAJE#"
            formatos="S,S,V"
            align="left,left,left"
            showEmptyListMsg="true"
            form="formCosto"
            width="800"
            height="500"
         	>
	  </td>
    </tr>
    

	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">
	<cfif isdefined ('form.CFcodigo') and len(trim(form.CFcodigo)) gt 0>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select CFid from CFuncional where CFcodigo='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsCFid.recordcount gt 0>
			<input type="hidden" name="CFid" value="#rsCFid.CFid#" />
			<cfset LvarCFid=#rsCFid.CFid#>
		</cfif>
	</cfif>
	
		<cfif modo neq "ALTA_C">
			<cf_botones modo="CAMBIO" sufijo="Cos" exclude="Cambio">
		<cfelse>
			<cf_botones modo="ALTA" sufijo="Cos">
		</cfif>
	</td></tr>
	<tr>
		<td colspan="2" align="center">&nbsp;</td>
	</tr>
	<cfset ts = "">	
	<input type="hidden" name="modo" value="#modo#" />
	<cfif modo neq "ALTA_C">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsFormCos.ts_rversion#"/>
		</cfinvoke>
        <input type="hidden" name="CFCid" value="<cfoutput>#rsFormCos.CFCid#</cfoutput>">
	</cfif>

	<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA_C'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
  </table>  
  </cfoutput>
 </form>

<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_COSTO"
	Default="Costo"
	returnvariable="LB_COSTO"/>
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formCosto");
	
	objForm.Ccodigo.required = true;
	objForm.Ccodigo.description="<cfoutput>#LB_COSTO#</cfoutput>";	

	function deshabilitarValidacion(){
		objForm.Ccodigo.required = false;
	}
	function habilitarValidacion(){
		objForm.Ccodigo.required = true;
	}	
	function limpiar() {
		objForm.reset();
	}
	
	function funcRegresarDet(id){
		document.location.href = 'CFuncional.cfm?CFcodigo1=' & id;
	}

</script> 



























