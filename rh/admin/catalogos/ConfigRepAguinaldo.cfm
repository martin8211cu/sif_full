<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConfiguracionDelReporteDeAguinaldos"
	Default="Configuraci&oacute;n del Reporte de Aguinaldos"
	returnvariable="LB_ConfiguracionDelReporteDeAguinaldos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConfiguracionDeConceptosDePago"
	Default="Configuraci&oacute;n de Conceptos de Pago"
	returnvariable="LB_ConfiguracionDeConceptosDePago"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConfiguracionDeAcciones"
	Default="Configuraci&oacute;n de Acciones"
	returnvariable="LB_ConfiguracionDeAcciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConceptoDePago"
	Default="Concepto de Pago"
	returnvariable="LB_ConceptoDePago"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoDeAccion"
	Default="Tipo de Acci&oacute;n"
	returnvariable="LB_TipoDeAccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Excluir"
	Default="Excluir"
	returnvariable="LB_Excluir"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Factor"
	Default="Factor"
	returnvariable="LB_Factor"/>	
<!--- FIN VARIABLES DE TRADUCCION --->	
<!--- VERIFICA SI EXISTE EL REPORTE PARA LA EMPRESA --->
<cfquery name="rsVerifRep" datasource="#session.DSN#">
	select rptid
	from RHErpt
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif rsVerifRep.recordcount EQ 0>
	<cfset form.rptid = 0>
<cfelse>
	<cfset form.rptid = rsVerifRep.rptid>
</cfif>
<!--- CONSULTA DE LOS TIPOS DE ACCION --->
<cfquery name="rsTipoAccion" datasource="#Session.DSN#">
	select RHTid, RHTcodigo, RHTdesc 
	from RHTipoAccion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and not exists ( select RHTid
				 from RHDrpt
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				 and rptid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rptid#">
				 and RHTid = RHTipoAccion.RHTid  )
	order by RHTcomportam, RHTcodigo
</cfquery>

<!--- SI NO EXISTE PARA LA EMPRESA ENTONCES LO CREA --->
<cfif rsVerifRep.RecordCount EQ 0>
	<cftransaction>	
		<cfquery name="InsertRpt" datasource="#session.DSN#">
			insert into RHErpt (rptcodigo, Ecodigo, rptDesc, cantmesesatras, factordiv)
			values (
				'RHAGUIN01', 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
				'Reporte de Aguinaldos', 
				0, 
				0
			)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>  
		<cf_dbidentity2 datasource="#session.DSN#" name="InsertRpt">
		<cfset form.rptid = InsertRpt.identity>
	</cftransaction>
</cfif>

<cfquery name="rsConceptosP" datasource="#session.DSN#">
	select rptid,a.CIid,CIdescripcion,Factor,Excluir
	from RHDrpt a
	inner join CIncidentes b
		on b.CIid = a.CIid
		and b.Ecodigo = b.Ecodigo
	where a.rptid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form .rptid#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and a.CIid is not null
</cfquery>

<cfquery name="rsAcciones" datasource="#session.DSN#">
	select rptid,a.RHTid,RHTdesc,Factor,Excluir
	from RHDrpt a
	inner join RHTipoAccion b
		on b.RHTid = a.RHTid
		and b.Ecodigo= a.Ecodigo
	where a.rptid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rptid#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and a.RHTid is not null
</cfquery>
<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start titulo="#LB_ConfiguracionDelReporteDeAguinaldos#">
		<form style="margin: 0; " name="form1" method="post" action="ConfigRepAguinaldo_SQL.cfm">
			<input name="rptid" type="hidden" value="<cfoutput>#form.rptid#</cfoutput>" tabindex="-1">
			<input name="EliminarC" type="hidden" value="0" tabindex="-1">
			<input name="EliminarA" type="hidden" value="0" tabindex="-1">
			<cfoutput>
			<table width="100%" cellpadding="2" cellspacing="2" align="center">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td width="50%" valign="top">
						<cf_web_portlet_start titulo="#LB_ConfiguracionDeConceptosDePago#">
						
						<table width="90%" cellpadding="0" cellspacing="0" align="center">
							<tr><td colspan="3">&nbsp;</td></tr>
							<tr>
								<td align="right" nowrap><strong>#LB_ConceptoDePago#:</strong>&nbsp;</td>
								<td><cf_rhCIncidentes tabindex="1"></td>
								<td align="left"><cf_botones values="Agregar" names="AgregarC" tabindex="1"></td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<tr>
								<td colspan="3">
									<table width="100%" cellpadding="0" cellspacing="2" align="center">
										<tr class="tituloListas">
											<td>#LB_ConceptoDePago#</td>
											<td align="center">#LB_Factor#</td>
											<td align="center">#LB_Excluir#</td>
											<td>&nbsp;</td>
										</tr>
										<cfloop query="rsConceptosP">
											<tr>
												<td>#CIdescripcion#</td>
												<td align="center"><input type='text' name='FactorC_#CIid#' value='#LSCurrencyFormat(Factor,"none")#' onkeyup='javascript:if(snumber(this,event,-1)){ if(Key(event)=="&13&") {this.blur();}}' onblur='javascript: fm(this,2);' maxlength='5' size='5'></td>
												<td align="center"><input type="checkbox" name="ExcluirC_#CIid#" <cfif Excluir EQ 1>checked</cfif>></td>
												<td align="center"><a href="javascript: EliminarC('#form.rptid#','#CIid#');"><img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0"></a></td>
											</tr>
										</cfloop>
									</table>
								</td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<tr><td colspan="3"><cf_botones values="Modificar" names="ModificarC" tabindex="1"></td></tr>
						</table>
						<cf_web_portlet_end>
					</td>
					<td width="50%" valign="top">
						<cf_web_portlet_start titulo="#LB_ConfiguracionDeAcciones#">
						
						<table width="90%" cellpadding="0" cellspacing="0" align="center">
							<tr><td colspan="3">&nbsp;</td></tr>
							<tr>
								<td align="right" nowrap><strong>#LB_TipoDeAccion#:</strong>&nbsp;</td>
								<td>
									<select name="RHTid">
										<option value="-1"></option>
										<cfloop query="rsTipoAccion">
											<option value="#rsTipoAccion.RHTid#">#rsTipoAccion.RHTdesc#</option>
										</cfloop>
									</select>
									<input type="hidden" name="_RHTid" value="-1" />
								</td>
								<td align="left"><cf_botones values="Agregar" names="AgregarA" tabindex="1"></td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<tr>
								<td colspan="3">
									<table width="100%" cellpadding="0" cellspacing="2" align="center">
										<tr class="tituloListas">
											<td>#LB_TipoDeAccion#</td>
											<td align="center">#LB_Factor#</td>
											<td align="center">#LB_Excluir#</td>
											<td>&nbsp;</td>
										</tr>
										<cfloop query="rsAcciones">
											<tr>
												<td>#RHTdesc#</td>
												<td align="center"><input type='text' name='FactorA_#RHTid#' value='#LSCurrencyFormat(Factor,"none")#' onkeyup='javascript:if(snumber(this,event,-1)){ if(Key(event)=="&13&") {this.blur();}}' onblur='javascript: fm(this,2);' maxlength='5' size='5'></td>
												<td align="center"><input type="checkbox" name="ExcluirA_#RHTid#" <cfif Excluir EQ 1>checked</cfif>></td>
												<td align="center"><a href="javascript: EliminarA('#form.rptid#','#RHTid#');"><img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0"></a></td>
											</tr>
										</cfloop>
									</table>
								</td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<tr><td colspan="3"><cf_botones values="Modificar" names="ModificarA" tabindex="1"></td></tr>
						</table>
						<cf_web_portlet_end>
					</td>
				</tr>
			</table>
			</cfoutput>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarElRegistro"
	Default="Desea eliminar el Registro?"
	returnvariable="MSG_DeseaEliminarElRegistro"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnConcepto"
	Default="Debe seleccionar un Concepto"
	returnvariable="MSG_DebeSeleccionarUnConcepto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnaAccion"
	Default="Debe seleccionar una Acción"
	returnvariable="MSG_DebeSeleccionarUnaAccion"/>

<!--- FIN VARIABLES DE TRADUCCION --->	
<script language="javascript" type="text/javascript">
	function EliminarC(rptid,CIid){
		if ( confirm('<cfoutput>#MSG_DeseaEliminarElRegistro#</cfoutput>') ){		
			document.form1.CIid.value = CIid;
			document.form1.EliminarC.value = 1;
			document.form1.submit();
		}
	}
	function EliminarA(rptid,RHTid){
		if ( confirm('<cfoutput>#MSG_DeseaEliminarElRegistro#</cfoutput>') ){		
			document.form1._RHTid.value = RHTid;
			document.form1.EliminarA.value = 1;
			document.form1.submit();
		}
	}
	function funcAgregarC(){
		if (document.form1.CIid.value == ''){
			alert('<cfoutput>#MSG_DebeSeleccionarUnConcepto#</cfoutput>');
			return false;
		}
		return true;
	}
	function funcAgregarA(){
		if (document.form1.RHTid.value == -1){
			alert('<cfoutput>#MSG_DebeSeleccionarUnaAccion#</cfoutput>');
			return false;
		}
		return true;
	}
</script>