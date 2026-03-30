
<!--- Establecimiento del modo --->
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

<cfquery name="rsDepartamentoSIF" datasource="#session.DSN#">
    select Dcodigo, Deptocodigo, Ddescripcion
    from Departamentos
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif isdefined("Session.Ecodigo") AND isdefined("Form.APcodigo") AND Len(Trim(Form.APcodigo)) GT 0 >
	<cfquery name="rsProdArea" datasource="#Session.DSN#">
		select Ecodigo, APcodigo, APDescripcion, Dcodigo, APinterno, ts_rversion  
		from Prod_Area 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and APcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.APcodigo#">
	</cfquery>
</cfif>

<form method="post" name="form1" action="SQLProdArea.cfm" onSubmit="javascript: return valida(this)">

	<input type="hidden" name="filtro_APcodigo" value="<cfif isdefined('form.filtro_APcodigo') and form.filtro_APcodigo NEQ ''>#form.filtro_APcodigo#</cfif>">
	<input type="hidden" name="filtro_APDescripcion" value="<cfif isdefined('form.filtro_APDescripcion') and form.filtro_APDescripcion NEQ ''>#HTMLEditFormat(trim(form.filtro_APDescripcion))#</cfif>">	
    
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr> 
			<td nowrap align="right"><strong>C&oacute;digo :&nbsp;</strong></td>
            <cfif modo NEQ "ALTA">
				<td><input name="APcodigo" tabindex="1" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsProdArea.APcodigo)#</cfoutput></cfif>" size="2" maxlength="2" onfocus="javascript:this.select();" readOnly></td>
        	<cfelse>
            	<td><input name="APcodigo" tabindex="1" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsProdArea.APcodigo)#</cfoutput></cfif>" size="2" maxlength="2" onfocus="javascript:this.select();"></td>
            </cfif>
   		</tr>

		<tr> 
			<td nowrap align="right"><strong>Descripci&oacute;n :&nbsp;</strong></td>
			<td>
                <input name="Descripcion" tabindex="1" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(trim(rsProdArea.APDescripcion))#</cfoutput></cfif>" size="50" maxlength="50" onfocus="javascript:this.select();">
            </td>
		</tr>
        <tr>
            <td align="right" nowrap valign="middle"><strong>Departamento Contable:&nbsp;</strong></td>
            <td>
                <cfoutput>
                <cfif modo neq 'ALTA'> 
                    <cf_sifDepartamentos query="#rsDepartamentoSIF#" id=#rsProdArea.Dcodigo# name="Deptocodigo" desc="Ddescripcion" tabindex="1">
                <cfelse>
                    <cf_sifDepartamentos name="Deptocodigo" desc="Ddescripcion" tabindex="1">
                </cfif>
                </cfoutput>
            </td>
        </tr>
   
        <tr>
        	<td></td>
            <td>
            	<table align="left" width="50%">
                    <tr>
                        <td>
                        	<input type="radio" name="Reporte" value="1" id="Reporte1" onclick='setvalues(this.value,this.form)'
                            <cfif modo EQ "ALTA" or #rsProdArea.APinterno# EQ 1>checked</cfif>>
                            <label for="Reporte1">Interno</label>
                        </td>
                        <td>
                        	<input type="radio" name="Reporte" value="0" id="Reporte2" onclick='setvalues(this.value,this.form)'
                            <cfif modo NEQ "ALTA" and #rsProdArea.APinterno# EQ 0>checked</cfif>>
                            <label for="Reporte2">Externo</label>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>    
		<tr> 
			<td colspan="2" align="center" nowrap>
				<cfset ts = "">
                <cfif modo NEQ "ALTA">
                    <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsProdArea.ts_rversion#" returnvariable="ts"></cfinvoke>
                </cfif>		  
                <input  tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">	  
                <cfset tabindex= 2 >
                <cfinclude template="../../../sif/portlets/pBotones.cfm">
			</td>
		</tr>
	</table>
</form>
<!----*************************************************************--->
<script language="JavaScript1.2" type="text/javascript">
	function valida(formulario){
		var error = false;
		var mensaje = "Se presentaron los siguientes errores:\n";
		if (formulario.APcodigo.value == "" ){
			error = true;
			mensaje += " - El campo Codigo es requerido.\n";
		}
		if (formulario.Descripcion.value == "" ){
			error = true;
			mensaje += " - El campo Descripcion es requerido.\n";
		}
		if (formulario.Dcodigo.value == "" ){
			error = true;
			mensaje += " - El campo Departamento Contable es requerido.\n";
		}
		if ( error ){
			alert(mensaje);
			return false;
		}else{
			return true;
		}
	}
</script>