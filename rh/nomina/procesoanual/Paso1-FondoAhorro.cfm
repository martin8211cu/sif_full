<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	returnvariable="LB_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaInicio"
	Default="Fecha Inicio"
	returnvariable="LB_FechaInicio"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaFinal"
	Default="Fecha Final"
	returnvariable="LB_FechaFinal"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Deduccion"
	Default="Considerar Deduccion"
	returnvariable="LB_Deduccion"/>

<!---<cf_dump var = "#form#">--->
<cfif isdefined('url.RHCFOAid') and len(trim(url.RHCFOAid)) GT 0>
	<cfset RHCFOAid = #url.RHCFOAid#>
<cfelseif isdefined('form.RHCFOAid') and len(trim(form.RHCFOAid)) GT 0>
	<cfset RHCFOAid = #form.RHCFOAid#>
</cfif>

<cfif modoE EQ "CAMBIO">
	<cfquery name="rsFOAPaso1" datasource="#session.DSN#">
		select RHCFOAid, RHCFOAcodigo,RHCFOAdesc,RHCFOAfechaInicio,RHCFOAfechaFinal, 
		case  when RHCFOAEstatus = 0 then 'En Proceso'
			  else 'Aplicado'
		end as Estatus
		from RHCierreFOA
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
	</cfquery>
</cfif>

<cfoutput>       
<form name= "form1" method="post" style="margin: 0;" action="FondoAhorro-sql.cfm">
<input type="hidden" name="RHCFOAid" value="#RHCFOAid#">
<table width="100%">
	<tr>
		<td align="center">
        	<table width="90%">
            	<tr>
                	<td width="25%"> 
                    </td>
                    <td width="15%" align="left"> 
						#LB_Codigo#:
                    </td>
                    <td width="60%" align="left"> 
                    	<cfif modoE EQ "CAMBIO">
                			<input type="text" name="txtCodigo" id="txtCodigo" size="15" value="#HTMLEditFormat(rsFOAPaso1.RHCFOAcodigo)#"/>
                		<cfelse>
               			 <input type="text" name="txtCodigo" size="15" maxlength="20" value=""/>
                		</cfif>  
                    </td>
                </tr>
                <tr>
                	<td width="25%"> 
                    </td>
                    <td width="15%" align="left"> 
                    	#LB_Descripcion#:
                    </td>
                    <td width="60%"> 
                    	<cfif modoE EQ "CAMBIO">
                			<input type="text" name="txtDescripcion" id="txtDescripcion" size="20" value="#HTMLEditFormat(rsFOAPaso1.RHCFOAdesc)#"/>
                		<cfelse>
               			 <input type="text" name="txtDescripcion" size="20" maxlength="20" value=""/>
                		</cfif>
                    </td>
                </tr>
                <tr>
                	<td width="25%"> 
                    </td>
                    <td width="15%" align="left"> 
                    	#LB_FechaInicio#:
                    </td>
                    <td width="60%"> 
                    	<cfset fdesde = "">
                		<cfif modoE EQ "CAMBIO">
                    		<cfset fdesde = LSDateFormat(rsFOAPaso1.RHCFOAfechaInicio, 'dd/mm/yyyy')>
                		</cfif>
                    	<cf_sifcalendario form="form1" name="FechaDesde" value= "#fdesde#">
                    </td>
                </tr>
                <tr>
                	<td width="25%"> 
                    </td>
                    <td width="15%" align="left"> 
                    	#LB_FechaFinal#:
                    </td>
                    <td width="60%"> 
                    	 <cfset fhasta = "">
                		 <cfif modoE EQ "CAMBIO">
                    		<cfset fhasta = LSDateFormat(rsFOAPaso1.RHCFOAfechaFinal, 'dd/mm/yyyy')>
               	 		 </cfif>
                    	<cf_sifcalendario form="form1" name="FechaHasta" value="#fhasta#">
                    </td>
                </tr>
                <!---<tr>
                	<td width="20%"> 
                    </td>
                    <td width="20%" align="left"> 
                    	#LB_Deduccion#:
                    </td>
                    <td width="60%"> 
                    	 <input type="checkbox" name = "chkDeduccion" id="chkDeduccion"/>
                    </td>
                </tr>--->
                <tr>
                    <td colspan="3" align="center"> 
                    	<cfset LvarExclude= ''>
            			<cfif modoE eq 'CAMBIO'>
                			<cfset LvarExclude= 'Nuevo'>
            			</cfif>
                    	<cf_botones form ='form1' modo=#modoE# include="Regresar" exclude = "#LvarExclude#">
                    </td>
                </tr>
            </table>
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cf_qforms form="form1" objForm="objForm">
<script language="javascript" type="text/javascript">
	function funcAlta(){
		<cfoutput>
			objForm.txtCodigo.required = true;
			objForm.txtCodigo.description = "Código";
			
			objForm.txtDescripcion.required = true;
			objForm.txtDescripcion.description = "Descripción";
			
			objForm.FechaDesde.required = true;
			objForm.FechaDesde.description = "Fecha Rige";
			
			objForm.FechaHasta.required = true;
			objForm.FechaHasta.description = "Fecha Vence";
			
		</cfoutput>
	}
</script>