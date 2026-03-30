<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonCambiar"
	Default="Modificar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonCambiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonBorrar"
	Default="Eliminar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonBorrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonNuevo"
	Default="Nuevo"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonNuevo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonAgregar"
	Default="Agregar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonAgregar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Regresar"
	Default="Regresar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="Regresar"/>	

<!--- Asigna modos Concepto Deduc y Detalle Cconcepto Dedudccion (ConceptoDeduc/DConceptoDeduc)--->
<cfif isDefined("Form.CDid") and len(trim(Form.CDid)) gt 0>
	<cfset emodo = "CAMBIO">
</cfif>
<cfif isDefined("Form.EIRid") and len(trim(Form.EIRid)) gt 0>
	<cfset dmodo = "CAMBIO">
</cfif>
<cfif not isdefined("Form.emodo")>
	<cfset emodo='ALTA'>
<cfelseif Form.emodo EQ "CAMBIO">
	<cfset emodo="CAMBIO">
<cfelse>
	<cfset emodo='ALTA'>
</cfif>
<cfif not isdefined("Form.dmodo")>
	<cfset dmodo='ALTA'>
<cfelseif Form.dmodo EQ "CAMBIO">
	<cfset dmodo="CAMBIO">
<cfelse>
	<cfset dmodo='ALTA'>
</cfif>

<!--- Consultas Concepto Deduc y Detalle Cconcepto Dedudccion --->

<cfif dmodo eq "CAMBIO">
	<cfquery name="rsCD" datasource="sifcontrol">
		select CDid, IRcodigo, CDcodigo, CDdescripcion, ts_rversion 
		from ConceptoDeduc
		where CDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#">
	</cfquery>
	
	<cfquery name="rsDCD" datasource="sifcontrol">
		select CDid, EIRid, DCDvalor, esporcentaje, ts_rversion, Dfamiliar
		from DConceptoDeduc
		where CDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#">
		and EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
	</cfquery>
</cfif>

<cfif emodo eq "CAMBIO">
	<!--- lista --->
	<cfquery name="rsDCDlista" datasource="sifcontrol">
		select a.CDid, a.CDcodigo, a.CDdescripcion, b.DCDvalor, b.EIRid, a.IRcodigo, b.esporcentaje, b.Dfamiliar
		from ConceptoDeduc a
			inner join DConceptoDeduc b
			on a.CDid = b.CDid
			and b.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		where a.IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#"> 
	</cfquery>
</cfif>

<script language="JavaScript" type="text/javascript">
	function Deliminar(id) {
		if (confirm('¿Desea Eliminar la Relación entre el Periodo y el Concepto ?')) {
			document.form.CDid.value = id;
			document.form.Accion.value='DBaja';
			fnNoValidar();
			document.form.submit();
			return true;
		}
		return false;
	}
	function DModificar(id1, id2) {
		document.form.CDid.value = id1;
		document.form.EIRid.value = id2;
		document.form.Accion.value = 'DModificar';
		fnNoValidar();
		document.form.submit();
	}
	
	function Conceptos(opc) {
		if (opc=='1')
			document.formDeduc.frame.value = 'IR';
		else
			document.formDeduc.frame.value = 'CD';
		document.formDeduc.submit();
	}
</script>

<table border="0" cellspacing="0" cellpadding="0" align="center" style="margin-left: 10px; margin-right: 10px;">
	<tr><td nowrap colspan="3">&nbsp;</td></tr>

	<cfif emodo neq 'ALTA'>
	  <tr><td nowrap colspan="3">
	  
	  	  <!--- Mantenimiento --->
		  <table width="100%" border="0" cellspacing="0" cellpadding="0"align="center">		  
			  <tr bgcolor="FAFAFA"> 
				<td nowrap class="filelabel">&nbsp;Código :</td>
				<td nowrap class="filelabel">&nbsp;Descripci&oacute;n :</td>
				<td nowrap class="filelabel">&nbsp;Es Porcentaje ?:</td>
			 </tr>			  
			  <tr>
				<cfoutput>
				<td nowrap>
					<cfif dmodo neq 'ALTA'>
						&nbsp;<input type="text" name="CDcodigo" tabindex="3" size="10" maxlength="5" value="#rsCD.CDcodigo#" readonly disabled>&nbsp;
					<cfelse>
						&nbsp;<input type="text" name="CDcodigo" tabindex="3" size="10" maxlength="5">&nbsp;											
					</cfif>
					<input type="hidden" name="CDid" value="<cfif dmodo NEQ 'ALTA'>#rsCD.CDid#</cfif>">
				</td>
				<td nowrap>
					<cfif dmodo neq 'ALTA'>
						&nbsp;<input type="text" name="CDdescripcion" tabindex="3" size="40" maxlength="80" value="#rsCD.CDdescripcion#" >&nbsp;
					<cfelse>
						&nbsp;<input type="text" name="CDdescripcion" tabindex="3" size="40" maxlength="80">&nbsp;											
					</cfif>					
				</td>				
				<td nowrap>
					<cfif dmodo neq 'ALTA' and rsDCD.esporcentaje eq 1>
						&nbsp;<input type="checkbox" name="esporcentaje" tabindex="3" checked>&nbsp;
					<cfelse>
						&nbsp;<input type="checkbox" name="esporcentaje" tabindex="3" >&nbsp;											
					</cfif>					
				</td>
			</tr>
			<tr>
				<td nowrap class="filelabel">&nbsp;Familiar:</td>
				<td nowrap class="filelabel">&nbsp;Monto :</td>
				<td nowrap>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<input type="checkbox" name="Dfamiliar" <cfif (dmodo neq 'ALTA' and rsDCD.Dfamiliar EQ 1) or dmodo eq 'ALTA'>checked</cfif>>
				</td>
				<td nowrap>
					<cfif dmodo neq 'ALTA'>
						&nbsp;<input name="DCDvalor" type="text" size="20" maxlength="18" style="text-align: right"  
								onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
								onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								value="#LSCurrencyFormat(rsDCD.DCDvalor,'none')#" 
								tabindex="3" >&nbsp;
					<cfelse>
						&nbsp;<input name="DCDvalor" type="text" size="20" maxlength="18" style="text-align: right"  
								onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
								onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								value="0.00" 
								tabindex="3" >&nbsp;
					</cfif>
				</td>
				<td nowrap align="center">
					<cfif dmodo neq 'ALTA'>						
						&nbsp;<input type="submit" alt="9" name='DCambio' value="#BotonCambiar#" onClick="javascript: return setBtn(this);" tabindex="3">						
						<input type="submit" alt="11" name="DNuevo" value="#BotonNuevo#" onClick="javascript: return setBtn(this);" tabindex="3">
					<cfelse>
						&nbsp;<input type="submit" alt="8" name='DAlta' value="#BotonAgregar#" onClick="javascript: return setBtn(this);" tabindex="3">					
					</cfif>						
				</td>
								
				<cfif dmodo neq 'ALTA'>
					<!--- ts_rversion del encabezado --->
					<cfset tsE = "">
					<cfinvoke
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="tsE">
						<cfinvokeargument name="arTimeStamp" value="#rsCD.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="CDtimestamp" value="<cfoutput>#tsE#</cfoutput>">

					<!--- ts_rversion del Detalle --->			
					<cfset ts = "">
					<cfinvoke
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsDCD.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="DCDtimestamp" value="<cfoutput>#ts#</cfoutput>">
				</cfif>
				</cfoutput>
			  </tr>		  		  
		  </table>
		  <!--- /mantenimiento --->
		  
	  </td>
	</tr>
	<tr><td nowrap colspan="3">&nbsp;</td></tr>
	<tr><td nowrap colspan="3">
	
		<!--- Lista --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0"align="center">
			<tr bgcolor="FAFAFA"> 				
				<td nowrap>&nbsp;<b>Código</b></td>
				<td nowrap>&nbsp;<b>Descripción</b></td>
				<td nowrap>&nbsp;<b>Es Porcentaje ?</b></td>
				<td nowrap>&nbsp;<b>Familiar</b></td>
				<td nowrap align="right">&nbsp;<b>Monto Fijo</b></td>
				<td nowrap>&nbsp;</td>
				<td nowrap>&nbsp;</td>
			</tr>
			<cfoutput query="rsDCDlista">
			<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>				
				<td nowrap><a href="javascript: document.form.IRcodigo.disabled = false; DModificar(#CDid#,#EIRid#);">&nbsp;#CDcodigo#</a></td>
				<td nowrap><a href="javascript: document.form.IRcodigo.disabled = false; DModificar(#CDid#,#EIRid#);">&nbsp;#CDdescripcion#</a></td>
				<td nowrap align="center"><cfif rsDCDlista.esporcentaje eq 1><img src="/cfmx/rh/imagenes/checked.gif"><cfelse><img src="/cfmx/rh/imagenes/unchecked.gif"></cfif></td>
				<td nowrap align="center"><cfif rsDCDlista.Dfamiliar eq 1><img src="/cfmx/rh/imagenes/checked.gif"><cfelse><img src="/cfmx/rh/imagenes/unchecked.gif"></cfif></td>
				<td nowrap align="right"><a href="javascript: document.form.IRcodigo.disabled = false; DModificar(#CDid#,#EIRid#);">&nbsp;#LSCurrencyFormat(DCDvalor,'none')#</a></td>
				<td nowrap>
				  <input name="btnDBorrar#CDid#" type="image" alt="Eliminar elemento" 
						onClick="javascript: return Deliminar(#CDid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">
				  <input name="btnDEditar#CDid#" type="image" alt="Editar elemento" 
						onClick="javascript: return DModificar(#CDid#,#EIRid#);" src="/cfmx/rh/imagenes/edit_o.gif" width="16" height="16">					
				</td>
				<td nowrap>&nbsp;</td>
				<td nowrap>&nbsp;</td>
			</tr>
			</cfoutput>			
		</table>
		<!--- /lista --->
		
	  </td>
	</tr>
	<tr><td nowrap colspan="3">&nbsp;</td></tr>
	</cfif>
</table>
