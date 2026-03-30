<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_CodigodeBeca" Default="Codigo de Beca" returnvariable="MSG_CodigodeBeca" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DescdeBeca" Default="Descripcion de Beca" returnvariable="MSG_DescdeBeca" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cfset includeBTN = "">
<cfif isdefined('form.RHTBid') and Len(Trim(form.RHTBid)) gt 0>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetBeca" returnvariable="rsBeca">
        <cfinvokeargument name="RHTBid" 		value="#form.RHTBid#">
    </cfinvoke>
	<cfset modo = "CAMBIO">
    <cfset includeBTN = "Formatos,Conceptos">
</cfif>
<form name="form1" method="post" action="becas-sql.cfm">
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr>
			<td align="right">#LB_Codigo#:</td>
            <td><input type="text" name="RHTBcodigo" size="11" maxlength="10" value="<cfif modo NEQ 'ALTA'>#trim(rsBeca.RHTBcodigo)#</cfif>"></td>
        </tr>
        <tr>
            <td align="right" nowrap>#LB_Descripcion#:</td>
            <td><input type="text" name="RHTBdescripcion" size="80" maxlength="80" value="<cfif modo NEQ 'ALTA'>#rsBeca.RHTBdescripcion#</cfif>"></td>
        </tr>
        <tr>
            <td align="right" nowrap>#LB_Corporativo#:</td>
            <td><input type="checkbox" name="RHTBesCorporativo" <cfif modo NEQ 'ALTA' and rsBeca.RHTBesCorporativo eq 1>checked</cfif>></td>
        </tr>
        <tr>
        	<td colspan="2">
            	<cf_botones modo="#modo#" sufijo="B" include="#includeBTN#">
				<!--- ts_rversion --->
                <cfset ts = "">	
                <cfif modo neq "ALTA">
                    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
                        <cfinvokeargument name="arTimeStamp" value="#rsBeca.ts_rversion#"/>
                    </cfinvoke>
                    <input type="hidden" name="RHTBid" value="#form.RHTBid#">
                </cfif>
                <input type="hidden" name="RHTBfecha" value="<cfif modo NEQ 'ALTA'>#rsBeca.RHTBfecha#<cfelse>#now()#</cfif>">
                <input type="hidden" name="ts_rversion" value="#ts#">
			</td>
        </tr>
	</table>
</cfoutput>
</form>
<cf_qforms form="form1" objForm="objForm">

<script language="javascript1.2" type="text/javascript">
	<cfoutput>
	objForm.RHTBcodigo.description = "#JSStringFormat('#MSG_CodigodeBeca#')#";
	objForm.RHTBdescripcion.description = "#JSStringFormat('#MSG_DescdeBeca#')#";
	
	</cfoutput>
	function funcConceptosB(){
		document.form1.action = "becas.cfm";
	}
	
	function funcFormatosB(){
		document.form1.action = "becas.cfm";
	}
	
	function deshabilitarValidacion(){
		objForm.RHTBcodigo.required = false;
		objForm.RHTBdescripcion.required = false;
	}
	
	function habilitarValidacion(){
		objForm.RHTBcodigo.required = true;
		objForm.RHTBdescripcion.required = true;
	}
	
	habilitarValidacion();
</script>