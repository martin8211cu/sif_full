<!--- FORM DE LAS PROVISINES RELACIONADAS CON LA CARGA --->
<cfset modo = 'ALTA'>
<cfif isdefined('form.DClinea') and isdefined('form.CIidL') and LEN(TRIM(form.CIidL))>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select a.CIid,CIcodigo,CIdescripcion,a.ts_rversion
		from DCTDeduccionExcluir a
		inner join CIncidentes b
		   on b.CIid= a.CIid
		  and b.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		where a.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
		  and a.CIid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidL#">
	</cfquery>
	<cfset ts = "">
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
	</cfinvoke>
</cfif>
<cfoutput> 
<form  name="form1" action="SQLProvisiones.cfm" method="post" style="margin:0; ">
	<input type="hidden" name="ECid" value="<cfif isdefined('form.ECid')>#form.ECid#</cfif>"> 
	<input type="hidden" name="DClinea" value="<cfif isdefined('form.DClinea')>#form.DClinea#</cfif>"> 
	<cfif modo neq "ALTA">
		<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
	</cfif>
	
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="1">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
			<td align="right">#LB_ConceptoDePago#:&nbsp;</td>
			<td nowrap>
				<cfset valuesArray = ArrayNew(1)>
				<cf_conlis 
					campos="CIid, CIcodigo, CIdescripcion"
					asignar="CIid, CIcodigo, CIdescripcion"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"						
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid, CIcodigo, CIdescripcion, CInegativo"
					filtro="Ecodigo = #Session.Ecodigo# and CIcarreracp = 0"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigo,CIdescripcion"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"								
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					valuesArray="#valuesArray#" 					
				/>  	
			</td>
		</tr>
		<tr><td colspan="2"><cf_botones modo="#modo#" Exclude="Cambio,Limpiar,Nuevo" regresar="#Regresar#"></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
    </table>
</form>
</cfoutput> 
<cf_qforms form='form1'>
	<cf_qformsrequiredfield args="CIcodigo, #MSG_ConceptoDePago#">
</cf_qforms>

