<cfinvoke key="LB_ConceptoDePagoOrigen" 		default="Concepto Origen (S. A.) "    returnvariable="LB_ConceptoDePagoOrigen" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ConceptoDePagoDestino" 		default="Concepto Destino (Inc.)"  returnvariable="LB_ConceptoDePagoDestino" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ConceptoDePagoEquivalencia" 	default="Concepto Equivalencia (Inc.)"  returnvariable="LB_ConceptoDePagoEquivalencia" component="sif.Componentes.Translate"  method="Translate"/>

<cfinvoke key="LB_TITULOCONLISCONCEPTOSPAGO" default="Lista de Conceptos de Pago" returnvariable="LB_TITULOCONLISCONCEPTOSPAGO"component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_NoHayRegistrosRelacionados" default="No hay registros relacionados" returnvariable="MSG_NoHayRegistrosRelacionados" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke key="LB_CODIGO" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_DESCRIPCION" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>	



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

<cfset va_arrayOrigen=ArrayNew(1)>
<cfset va_arrayDestino=ArrayNew(1)>
<cfset va_arrayEquivalencia=ArrayNew(1)>

<cfif isdefined('form.CIidEmpOrigen') and len(trim(form.CIidEmpOrigen))>
	<cfset modo = "CAMBIO">

</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 	a.CIidEmpOrigen
				,a.CIidEmpDestino
				,a.CIidEquivalencia
				,b.CIcodigo as codOrigen
				,b.CIdescripcion as DescOrigen
				,c.CIcodigo as codDestino
				,c.CIdescripcion as DescDestino
				,d.CIcodigo as codEquivalencia
				,d.CIdescripcion as DescEquivalencia		
		from RHTransferIncidencia a
			inner join CIncidentes b
				on a.CIidEmpOrigen = b.CIid
			inner join CIncidentes c
				on a.CIidEmpDestino = c.CIid
			inner join CIncidentes d
				on a.CIidEquivalencia = d.CIid	
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and a.CIidEmpOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIidEmpOrigen#">
	</cfquery>



	
</cfif>
<cfoutput>
<form name="form1" method="post" action="TrasladoConceptos-sql.cfm">
	<table width="98%" cellpadding="3" cellspacing="0" align="center">
		<tr>
			<td class="fileLabel">#LB_ConceptoDePagoOrigen#</td>
		</tr>
		<tr>
			<td>
				<cfif modo EQ "ALTA">
					<cf_conlis 
						campos="CIidOrigen,CIcodigoOrigen,CIdescripcionOrigen"
						asignar="CIidOrigen, CIcodigoOrigen, CIdescripcionOrigen"
						size="0,10,40"
						desplegables="N,S,S"
						modificables="N,S,N"						
						title="#LB_TITULOCONLISCONCEPTOSPAGO#"
						tabla="ConceptosTipoAccion a, CIncidentes b , RHTipoAccion c"
						columnas="distinct b.CIid as CIidOrigen, b.CIcodigo as CIcodigoOrigen, b.CIdescripcion as CIdescripcionOrigen"
						filtro="c.Ecodigo = #rsParam.Pvalor# and b.CIcarreracp = 0 and b.CItipo=3 and a.RHTid = c.RHTid  and a.CIid = b.CIid 
								and b.CIid not in (select CIidEmpOrigen from RHTransferIncidencia where Ecodigo = #Session.Ecodigo#)"
						filtrar_por="CIcodigo,CIdescripcion"
						desplegar="CIcodigoOrigen,CIdescripcionOrigen"
						etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
						formatos="S,S"
						align="left,left"								
						asignarFormatos="S,S,S"
						form="form1"
						showEmptyListMsg="true"
						EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
						valuesArray="#va_arrayOrigen#" 
						alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
					/> 				
				<cfelse>
						#rsDatos.codOrigen#-#rsDatos.DescOrigen#
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="fileLabel">#LB_ConceptoDePagoEquivalencia#</td>	
		</tr>
		<tr>
			<td>	
				<cfif modo EQ "ALTA">
					<cf_conlis 
						campos="CIidEquivalencia,CIcodigoEquivalencia,CIdescripcionEquivalencia"
						asignar="CIidEquivalencia, CIcodigoEquivalencia, CIdescripcionEquivalencia"
						size="0,10,40"
						desplegables="N,S,S"
						modificables="N,S,N"						
						title="#LB_TITULOCONLISCONCEPTOSPAGO#"
						tabla="ConceptosTipoAccion a, CIncidentes b , RHTipoAccion c"
						columnas="distinct b.CIid as CIidEquivalencia, b.CIcodigo as CIcodigoEquivalencia, b.CIdescripcion as CIdescripcionEquivalencia"
						filtro="c.Ecodigo = #Session.Ecodigo# and b.CIcarreracp = 0 and b.CItipo=3 and a.RHTid = c.RHTid  and a.CIid = b.CIid"
						filtrar_por="CIcodigo,CIdescripcion"
						desplegar="CIcodigoEquivalencia,CIdescripcionEquivalencia"
						etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
						formatos="S,S"
						align="left,left"								
						asignarFormatos="S,S,S"
						form="form1"
						showEmptyListMsg="true"
						EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
						valuesArray="#va_arrayEquivalencia#" 
						alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
					/> 
				<cfelse>
						#rsDatos.codEquivalencia#-#rsDatos.DescEquivalencia#
				</cfif>	

			</td>
		</tr>	
		<tr>
			<td class="fileLabel">#LB_ConceptoDePagoDestino#</td>	
		</tr>
		<tr>
			<td>
				<cfif modo EQ "ALTA">
					<cf_conlis 
						campos="CIidDestino,CIcodigoDestino,CIdescripcionDestino"
						asignar="CIidDestino, CIcodigoDestino, CIdescripcionDestino"
						size="0,10,40"
						desplegables="N,S,S"
						modificables="N,S,N"						
						title="#LB_TITULOCONLISCONCEPTOSPAGO#"
						tabla="CIncidentes a"
						columnas="CIid as CIidDestino, CIcodigo as CIcodigoDestino, CIdescripcion as CIdescripcionDestino"
						filtro="Ecodigo = #Session.Ecodigo# and CIcarreracp = 0 and a.CItipo=2"
						filtrar_por="CIcodigo,CIdescripcion"
						desplegar="CIcodigoDestino,CIdescripcionDestino"
						etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
						formatos="S,S"
						align="left,left"								
						asignarFormatos="S,S,S"
						form="form1"
						showEmptyListMsg="true"
						EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
						valuesArray="#va_arrayOrigen#" 
						alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
					/>  
				<cfelse>
						#rsDatos.codDestino#-#rsDatos.DescDestino#
				</cfif>							
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" class="ayuda">
					<tr> 
						<td>
							<cf_translate  key="LB_AYUDA1">
							&nbsp;<b>*Concepto Origen (S. A.):</b> &nbsp;Concepto de pago de tipo c&aacute;lculo que se trasladara a Inc.</cf_translate>
						</td>
					</tr>	
					<tr> 
						<td>
							<cf_translate  key="LB_AYUDA2">
							&nbsp;<b>*Concepto Equivalencia (Inc.):</b> &nbsp;Concepto de pago de tipo c&aacute;lculo equivalente en Inc.</cf_translate>
						</td>
					</tr>
					<tr> 
						<td>
							<cf_translate  key="LB_AYUDA3">
							&nbsp;<b>*Concepto Destino (Inc.):</b> &nbsp;Concepto de pago de tipo inporte en Inc. donde almacenar&aacute; el concepto importado.</cf_translate>
						</td>
					</tr>			
				</table>
			</td>
		</tr>
	
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center"><cf_botones modo="#modo#" exclude="CAMBIO"></td>
		</tr>	
	</table>	
	<cfif modo NEQ "ALTA">
		<input type="hidden" name="CIidEmpOrigen" value="#rsDatos.CIidEmpOrigen#">
	</cfif>
</form>
<script language="JavaScript">
	<cfif modo EQ "ALTA">
	
		<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");	//-->
		
		function deshabilitarValidacion(){
			objForm.CIidOrigen.required = false;
			objForm.CIidDestino.required = false;
		}
		
		qFormAPI.errorColor = "##FFFFCC";
		objForm = new qForm("form1");
	
		objForm.CIidOrigen.required = true;
		objForm.CIidOrigen.description = "#LB_ConceptoDePagoOrigen#";
		objForm.CIidDestino.required=true;
		objForm.CIidDestino.description = "#LB_ConceptoDePagoDestino#";
		objForm.CIidEquivalencia.required=true;
		objForm.CIidEquivalencia.description = "#LB_ConceptoDePagoEquivalencia#";

	</cfif>
</script>
</cfoutput>