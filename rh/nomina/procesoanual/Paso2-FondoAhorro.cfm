<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ImporteInteresGenerado"
	Default="Captura de Importe de Inter&eacute;s Generado"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_ImporteInteresGenerado"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ImporteInteresG"
	Default="Importe de Inter&eacute;s Generado"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_ImporteInteresG"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ImportePrestamos"
	Default="Importe de Inter&eacute;s de Pr&eacute;stamos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_ImporteInteres"/>
    
<cfoutput>   

<cfif isdefined('url.RHCFOAid') and len(trim(url.RHCFOAid)) GT 0>
	<cfset RHCFOAid = #url.RHCFOAid#>
<cfelseif isdefined('form.RHCFOAid') and len(trim(form.RHCFOAid)) GT 0>
	<cfset RHCFOAid = #form.RHCFOAid#>
</cfif>

<cfquery name="rsFOAPrestamo" datasource="#session.DSN#">
	select 'Importe de Inter&eacute;s de Pr&eacute;stamos' as Descripcion, RHCFOAprestamo
    from RHCierreFOA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
</cfquery>

<cfquery name="rsFOAPaso2" datasource="#session.DSN#">
	select 'Importe de Inter&eacute;s' as Descripcion, RHCFOAInteres 
    from RHCierreFOA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
</cfquery>

<!---<cfquery name="rsDeducciones" datasource = "#session.DSN#">
	select RHCFOAdeduc
	from RHCierreFOA 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
</cfquery>--->
                                     
<form name= "form2" method="post" style="margin: 0;" action="FondoAhorro-sql.cfm">
<input type="hidden" name="RHCFOAid" value="#RHCFOAid#">
<!---<input type="hidden" name="RHCFOAdeduc" value="#rsDeducciones.RHCFOAdeduc#">--->
<table width="100%">
	<tr>
		<td align="center">
        	<table width="90%">
            	<tr>
                    <td colspan="2" align="center"> 
						<strong>#LB_ImporteInteresGenerado#</strong>
                    </td>
                    <td width="50%" align="left"> 
                    </td>
                </tr>
                <tr>
                	<td width="25%"> 
                    </td>
                    <td width="25%" align="right"> 
                    	#LB_ImporteInteresG#:
                    </td>
                    <td width="50%" align="left"> 
                    	<input type="text" name="txtImporteInteres" id="txtImporteInteres" size="20" value="">
                        <input name="btnAgregar" id = "btnAgregar" type="submit" value="Agregar" onclick="return funcAlta();"> 
                    </td>
                </tr>
                <tr>
                	<td colspan= "3" align="center">
                    	<hr>                    	
                    </td>
                </tr>
                <cfloop query ="rsFOAPaso2">
                <tr>
                	<td width="25%"> 
                    </td>
                    <td width="25%" align="right"><strong>#rsFOAPaso2.Descripcion#:</strong></td>
                    <td width="50%" align="left"> 
                    	#rsFOAPaso2.RHCFOAInteres#
                  </td>
                </tr>
                </cfloop>
                <cfloop query ="rsFOAPrestamo">
                <tr>
                	<td width="25%"> 
                    </td>
                    <td width="25%" align="right"><strong>#rsFOAPrestamo.Descripcion#:<strong></td>
                    <td width="50%" align="left"> 
                    	#rsFOAPrestamo.RHCFOAprestamo#
                  </td>
                </tr>
                </cfloop>
                <tr>
                	<td colspan= "3" align="center">
                    	<input name="btnContinuar" type="submit" value="Continuar">                     	
                    </td>
                </tr>
            </table>
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cf_qforms form="form2" objForm="objForm">
<script language="javascript" type="text/javascript">
	function funcAlta(){
		<cfoutput>
		var x=document.forms["form2"]["txtImporteInteres"].value;
		if (x==null || x=="")
  			{
  				alert("Escribe un importe de interes");
  		return false;
  		}
			<!---alert('Aqui estoy');
			objForm.txtImporteInteres.required = true;
			objForm.txtImporteInteres.description = "Importe de interes";--->
			
		</cfoutput>
	}
</script>