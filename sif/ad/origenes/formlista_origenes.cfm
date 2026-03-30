<cfif not isdefined("Form.Oorigen") and  isdefined("url.Oorigen")>
	<cfset Form.Oorigen = url.Oorigen>
</cfif>


<cfif isdefined("Form.modo")>
	<cfset modo=Form.modo>
<cfelse>
	<cfif not isdefined("Form.modo") and  isdefined("url.modo")>
		<cfset modo=url.modo>
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rs" datasource="#Session.DSN#">
		select OPtablaMayor,ODactivo,OPconst,ts_rversion from OrigenDocumentos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
	</cfquery>
</cfif>

<cfquery datasource="#Session.DSN#" name="rsCtas">
    select Cmayor,Cdescripcion from CtasMayor cm
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
    order by Cmayor
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsOrigenes">
	select Oorigen,Cdescripcion
	from ConceptoContable
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Oorigen not in (select Oorigen from OrigenDocumentos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
	order by Oorigen
</cfquery>

<cfif not isdefined("Form.Oorigen") and not isdefined("url.Oorigen") >
	<cfset Form.Oorigen = rsOrigenes.Oorigen>
</cfif>

<cfif not isdefined("Form.Oorigen") and  isdefined("url.Oorigen") >
	<cfset Form.Oorigen = url.Oorigen>
</cfif>

<cfquery datasource="sifcontrol" name="rsTablas">
	select OPtabla
	from OrigenProv 
	where Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oorigen#">
	order by OPtabla
</cfquery>
 
<form method="post" name="form1"  action="SQLlista_origenes.cfm">
	<cfoutput>
	<table width="453" align="center">
		<!--- ***************************************************************************** --->
		<tr valign="baseline"> 
			<td width="145" align="right" nowrap>Origen:&nbsp;</td>
			<td width="296">
				<cfif modo NEQ "ALTA">
					<cfquery name="rsOrigenC" datasource="#Session.DSN#">
					select Cdescripcion from ConceptoContable 
					where Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
					and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

					</cfquery>
					<b>#rsOrigenC.Cdescripcion#</b>
					<input type="hidden" name="Oorigen" value="<cfoutput>#Form.Oorigen#</cfoutput>">
				<cfelse>
					<select name="Oorigen" onChange="javascript: this.form.action='lista_origenes.cfm'; this.form.submit();">
					<cfloop query="rsOrigenes"> 
                    <cfset descr = HTMLEditFormat( rsOrigenes.Oorigen & '-' & rsOrigenes.Cdescripcion)>
					<option value="#rsOrigenes.Oorigen#" 
					<cfif isdefined("Form.Oorigen") and rsOrigenes.Oorigen EQ Form.Oorigen>selected</cfif>>#descr#</option>
					</cfloop>
					</select>
				</cfif>
			</td>
		</tr>
		<!--- ***************************************************************************** --->
		<tr valign="baseline">
		  <td align="right">Cuenta Mayor :</td>
		  <td><select name="OPtablaMayor" style="width:240px">
          <optgroup label="Concepto">
		    <cfloop query="rsTablas">
		      <option value="T,#rsTablas.OPtabla#" 
				<cfif modo NEQ "ALTA"  and rsTablas.OPtabla EQ rs.OPtablaMayor>selected</cfif>>#rsTablas.OPtabla#</option>
	        </cfloop>
</optgroup><optgroup label="Cuenta Fija">
		    <cfloop query="rsCtas">
		      <cfset descrip = HTMLEditFormat(rsCtas.Cmayor & " " & rsCtas.Cdescripcion)>
		      <option value="C,#rsCtas.Cmayor#" 
				<cfif modo NEQ "ALTA"  and rsCtas.Cmayor EQ rs.OPconst>selected</cfif>>#descrip#</option>
	        </cfloop></optgroup>
	      </select></td>
      </tr>
		<!--- ***************************************************************************** --->
	  <tr valign="baseline"> 
			<td nowrap align="right"></td>
			<td><label><input type="checkbox" name="ODactivo"  <cfif  modo NEQ "ALTA"  and rs.RecordCount gt 0 and rs.ODactivo eq 1 >checked</cfif>>Activar Origen</label></td>
		</tr>
		
		<!--- ***************************************************************************** --->
		<tr valign="baseline"> 
			<td colspan="2" align="center">
			<cfif modo EQ "ALTA">
				<input type="submit" name="Alta" 		value="Agregar">
				<input type="reset" name="Limpiar"	 	value="Limpiar">
			<cfelse>
				<input type="submit" name="Cambio"	 	value="Modificar">
				<input type="submit" name="Baja" 		value="Eliminar" onclick="javascript: if ( confirm('Est seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">				
				<input type="submit" name="Nuevo" 		value="Nuevo" onClick="javascript: if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
				<input type="button" name="Cuentas" 	value="Ver Cuentas" onClick="javascript: location.href = 'Ctas_origenes.cfm?Oorigen=#Form.Oorigen#';">

			</cfif>
			</td>
		</tr>
	</table>
	
	<cfset ts = "">	
<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rs.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">
  </cfoutput>
</form>

<cf_qforms>
<script language="javascript" type="text/javascript">
	objForm.Oorigen.required = true;
	objForm.Oorigen.description="Origen";	
	objForm.OPtablaMayor.required = true;
	objForm.OPtablaMayor.description="Tabla";		
	
	function deshabilitarValidacion(){
		objForm.Oorigen.required = false;
		objForm.OPtablaMayor.required = false;
	}
	
	function habilitarValidacion(){
		objForm.Oorigen.required = true;
		objForm.OPtablaMayor.required = true;
	}	

</script>
