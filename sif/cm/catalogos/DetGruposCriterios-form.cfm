<cfquery name="rsCriterios" datasource="#Session.DSN#"> 
	select CCid, CCdesc 
	from CCriteriosCM
</cfquery>

<cfquery name="rsCriteriosAsociados" datasource="#Session.DSN#"> 
	select a.CCid, b.CCdesc, a.CGpeso
	from CriteriosGrupoCM a
	inner join CCriteriosCM b
	on a.CCid = b.CCid
	where a.GCcritid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GCcritid#">
</cfquery>

<cfquery name="rsSumaCriteriosAsociados" datasource="#Session.DSN#"> 
	select sum(CGpeso) as total
	from CriteriosGrupoCM 
	where GCcritid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GCcritid#">
</cfquery>

<cfoutput>
<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="javascript1.2" type="text/javascript">
	function asignar(id, desc, peso){
		document.getElementById("boton").name = 'Modificar';	
		document.getElementById("boton").value = 'Modificar';	
		document.form2.action.value = 'update';
		document.form2.CCid.disabled = true;
		document.form2.CCid.value = id;
		document.form2.CGpeso.value = peso;
		fm(document.form2.CGpeso, 2);
	}

	function eliminar(id, desc, peso){
		if ( confirm('Desea eliminar el registro?') ){
			asignar(id, desc, peso);
			document.form2.action.value = 'delete';
			document.form2.CCid.disabled=false;
			document.form2.submit();
		}
	}	
	
	function nuevo(){
		document.getElementById("boton").name = 'Agregar';	
		document.getElementById("boton").value = ' Agregar  ';	
		document.form2.action.value = '';
		document.form2.CCid.disabled = false;
		document.form2.CCid.value = '';
		document.form2.CGpeso.value = '';
	}
	
</script>

<form name="form2" action="GruposCriterios-sql.cfm" method="post" onSubmit="javascript:document.form2.CCid.disabled=false;">
<input type="hidden" name="GCcritid" value="#form.GCcritid#">
<input type="hidden" name="action" value="">
 <input type="hidden" name="btnSel" value="">
<table width="95%" align="center">
	<tr>
		<td align="center">
	<fieldset style="width:100%"><legend><strong>&nbsp;Criterios por Grupo&nbsp;</strong></legend>
		<table width="100%" cellpadding="4" cellspacing="0" border="0" >	
			<tr>
				<td align="right"><strong>Criterio:</strong>&nbsp;</td>
				<td>
					<select name="CCid">
						<option value=""></option>
						<cfloop query="rsCriterios">
							<option value="#rsCriterios.CCid#">#rsCriterios.CCdesc#</option>
						</cfloop>
					</select>
				</td>
				<td align="right"><strong>Peso:</strong>&nbsp;</td>
				<td>
					<input type="text" name="CGpeso" value="" size="8" maxlength="8" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
				</td>	
				<td>
					<table width="100%">
						<tr>
							<td>
								<input type="submit" id="boton" value="Agregar" onClick="javascript: this.form.btnSel.value = this.name;" name="Agregar">
							</td>
							<td>
								<input type="button" value="Nuevo" name="Nuevo" onClick="javascript:this.form.btnSel.value = this.name; nuevo();">
							</td>
						</tr>
					</table>
				</td>
			</tr>
		<tr>
			<td colspan="5" align="center">
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr class="tituloListas"><td><strong>Criterio</strong></td><td align="right"><strong>Peso</strong></td><td colspan="2">&nbsp;</td></tr>	
					<cfloop query="rsCriteriosAsociados">
						<tr style="cursor:hand; "  class="<cfif rsCriteriosAsociados.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>" >
							<td onClick="javascript:asignar('#rsCriteriosAsociados.CCid#','#rsCriteriosAsociados.CCdesc#','#rsCriteriosAsociados.CGpeso#');" >#rsCriteriosAsociados.CCdesc#</td>
							<td align="right" onClick="javascript:asignar('#rsCriteriosAsociados.CCid#','#rsCriteriosAsociados.CCdesc#','#rsCriteriosAsociados.CGpeso#');">#LSCurrencyFormat(rsCriteriosAsociados.CGpeso, 'none')#</td>
							<td width="1%"><img align="right" border="0" src="../../imagenes/iedit.gif" onClick="javascript:asignar('#rsCriteriosAsociados.CCid#','#rsCriteriosAsociados.CCdesc#','#rsCriteriosAsociados.CGpeso#');" ></td>
							<td width="1%" align="left"><img align="left" border="0" src="../../imagenes/Borrar01_S.gif" onClick="javascript:eliminar('#rsCriteriosAsociados.CCid#','#rsCriteriosAsociados.CCdesc#','#rsCriteriosAsociados.CGpeso#');"></td>
						</tr>
					</cfloop>
					<tr>
						<td align="right"><strong>Total:</strong>&nbsp;</td>
						<td align="right"><strong>#LSCurrencyFormat(rsSumaCriteriosAsociados.total, 'none')#</strong></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>

		<tr>
			<td colspan="5" align="center">
				<table width="100%" align="center" class="ayuda">
					<tr><td>Si va a agregar un registro que ya existe, el sistema va a modificar el peso del registro existente con los datos que desea agregar. </td></tr>
				</table>
			</td>
		</tr>
		

	</table>
	</fieldset>
	</td>
	</tr>
</table> 	

</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	//qFormAPI.errorColor = "#FFFFCC";
	objForm2 = new qForm("form2");
	objForm2.CCid.required = true;
	objForm2.CCid.description="Criterio";

	objForm2.CGpeso.required = true;
	objForm2.CGpeso.description="Peso";

	function deshabilitarValidacion(){
		objForm2.CCid.required = false;
		objForm2.CGpeso.required = false;
	}
</script>