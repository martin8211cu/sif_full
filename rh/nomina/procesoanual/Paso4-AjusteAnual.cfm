<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AplicarNom"
	Default="Descargar archivos para la Importaci&oacute;n del ISR"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_AplicarNom"/>	
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_LayoutIncid"
	Default="Archivo para descargar archivo de Incidencia"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_LayoutIncid"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SelectConcepto"
	Default="Concepto de Pago"	
	returnvariable="LB_SelectConcepto"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaNomina"
	Default="Fecha de la Incidencia"	
	returnvariable="LB_FechaNomina"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoNomina"
	Default="Tipo de N&oacute;mina"	
	returnvariable="LB_TipoNomina"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_DescargarI"
	Default="Descargar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_DescargarI"/>	
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_LayoutDeduc"
	Default="Archivo para descargar archivo de Deducci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_LayoutDeduc"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SelectDeduccion"
	Default="Deducci&oacute;n"	
	returnvariable="LB_SelectDeduccion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DescripcionDeduc"
	Default="Descripci&oacute;n"	
	returnvariable="LB_DescripcionDeduc"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NumeroNominas"
	Default="Cantidad de n&oacute;minas a descontar"	
	returnvariable="LB_NumeroNominas"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeduccion"
	Default="Fecha de la Deducci&oacute;n"	
	returnvariable="LB_FechaDeduccion"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_DescargarD"
	Default="Descargar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_DescargarD"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aplicar"
	Default="Aplicar Ajuste Anual"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Aplicar"/>
    
<cfquery name="rsConcPago" datasource="#session.dsn#">
	select * 
    from CIncidentes
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
    order by CIdescripcion
</cfquery>

<cfquery name="rsDeduccion" datasource="#session.dsn#">
	select * 
    from  TDeduccion
     where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
    order by TDdescripcion
</cfquery>

<cfif not isdefined("form.RHAAid") and isdefined("url.RHAAid") and len(trim(url.RHAAid))>
	<cfset form.RHAAid = url.RHAAid>
</cfif>
    
<cfoutput>
<form name="form3" method="post" action="AjusteAnual-sql.cfm">
<input type="hidden" name="RHAAid" value="#form.RHAAid#">
<!---<input type="hidden" name="hdAccion" id="hdAccion" value=""/>
<input type="hidden" name="hdTcodigo" id="hdTcodigo" value=""/>--->
	<table width="100%">
    	<tr height="30px">
        	<td colspan="100%" align="center" cellspacing="0" cellpadding="0">
				<strong>
                	#LB_AplicarNom#
                </strong>
            </td>
        </tr>
        <tr height="30px">
        	<td colspan="2" align="right" cellspacing="0" cellpadding="0">
				<strong>
                	#LB_LayoutIncid#
                </strong>
            </td>
            <td width="25%" align="left" cellspacing="0" cellpadding="0">
				
            </td>
            <td width="25%" align="left" cellspacing="0" cellpadding="0">
				
            </td>
        </tr>
    	<tr height="20px">
        	<td width = "25%">
            	
            </td>
            <td width = "25%" align="right" cellspacing="0" cellpadding="0">
            	#LB_SelectConcepto#
            </td>
            <td width = "25%" align="left">
            	<select name="Concepto" id="concepto">
                	<option value="-1" style="text-align:center"  selected>--- Seleccionar Concepto ---</option>	
						<cfloop query="rsConcPago">
							<option value="<cfoutput>#rsConcPago.CIcodigo#</cfoutput>"> #CIdescripcion# </option>	
						</cfloop>
				</select>	
            </td>
            <td width = "25%">
            </td>
        </tr>
        <tr height="20px">
        	<td width = "25%">
            </td>
            <td width = "25%" align="right">
            	#LB_FechaNomina#
            </td>
            <td width = "25%" align="left">
            	<!--<cf_sifmaskstring form="form3" name="CPcodigo" id="CPcodigo" formato="****-**-***" size="15" maxlenght="11" mostrarmascara="false">-->
                <cf_sifcalendario form="form3" name="FechaAplica" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
            </td>
            <td width = "25%" align="center">
            	
            </td>
        </tr>
        <tr height="20px">
        	<td width = "25%">
            </td>
            <td width = "25%" align="right">
            	#LB_TipoNomina#
            </td>
            <td width = "25%" align="left">
            	<input type="radio" name="groupNomina" value="0" checked="checked"/> Normal
                <input type="radio" name="groupNomina" value="1" /> Especial
            </td>
            <td width = "25%" align="center">
            	
            </td>
        </tr>
        <tr height="20px">
        	<td width = "25%">
            </td>
            <td width = "25%" align="center" colspan="2">
            	<input type="submit" name="BTN_DescargarI" id="BTN_DescargarI" value="#BTN_DescargarI#">
            </td>
            <td width = "25%" align="center">
            </td>
        </tr>
        <!---Termina la importacion de Incidencia--->
       	<tr>
        	<td colspan="100%">
            	<hr />
            </td>
        </tr>
        <tr height="30px">
        	<td colspan="2" align="right" cellspacing="0" cellpadding="0">
				<strong>
                	#LB_LayoutDeduc#
                </strong>
            </td>
            <td width="25%" align="left" cellspacing="0" cellpadding="0">
				
            </td>
            <td width="25%" align="left" cellspacing="0" cellpadding="0">
				
            </td>
        </tr>
    	<tr height="20px">
        	
        	<td width = "25%">
            	
            </td>
            <td width = "25%" align="right" cellspacing="0" cellpadding="0">
            	#LB_SelectDeduccion#
            </td>
            <td width = "30%" align="left">
            	<select name="Deduccion" id="Deduccion">
                	<option value="-1" style="text-align:center"  selected>--- Seleccionar Deduccion ---</option>	
						<cfloop query="rsDeduccion">
							<option value="<cfoutput>#rsDeduccion.TDcodigo#</cfoutput>"> #TDdescripcion# </option>	
						</cfloop>
				</select>
				<input type="radio" name="groupDeduccion" value="0" checked="checked"/> A Favor
                <input type="radio" name="groupDeduccion" value="1" /> A cargo	
			</td>
        </tr>
        <tr height="20px">
        	<td width = "25%">
            </td>
            <td width = "25%" align="right">
            	#LB_DescripcionDeduc#
            </td>
            <td width = "25%" align="left">
				<input type="text" name="txtDescripcion" id="txtDescripcion" size="32"  maxlength="30"/>
            </td>
            <td width = "25%" align="center">
            	
            </td>
        </tr>
        <tr height="20px">
        	<td width = "25%">
            </td>
            <td width = "25%" align="right">
            	#LB_NumeroNominas#
            </td>
            <td width = "25%" align="left">
            	<input type="text" name="txtCantidad" id="txtCantidad" size="10"  maxlength="20" />
            </td>
            <td width = "25%" align="center">
            	
            </td>
        </tr>
        <tr height="20px">
        	<td width = "25%">
            </td>
            <td width = "25%" align="right">
            	#LB_FechaDeduccion#
            </td>
            <td width = "25%" align="left">
            	<!--<cf_sifmaskstring form="form3" name="CPcodigo" id="CPcodigo" formato="****-**-***" size="15" maxlenght="11" mostrarmascara="false">-->
                <cf_sifcalendario form="form3" name="FechaAplicaD" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
            </td>
            <td width = "25%" align="center">
            	
            </td>
        </tr>
        <tr height="20px">
        	<td width = "25%">
            </td>
            <td width = "25%" align="center" colspan="2">
            	<input type="submit" name="BTN_DescargarD" id="BTN_DescargarD" value="#BTN_DescargarD#">
            </td>
            <td width = "25%" align="center">
            </td>
        </tr>
        <!---Termina la importacion de Deducciones--->
       	<tr>
        	<td colspan="100%">
            	<hr />
            </td>
        </tr>
        <tr>
        	<td colspan="100%" align="center">
            	<input type="submit" name="BTN_Aplicar" id="BTN_Aplicar" value="#BTN_Aplicar#" >
            </td>
       	</tr>
        
       <!--- <tr>
        	<td colspan="100%" align="center">
            	<table width="70%">
                	<tr>
        				<td colspan="4">
                        <hr />
						</td>
        			</tr>
               		<cfif isdefined("form.RHAAid") and len(trim(form.RHAAid))>
        				<cfquery name = "rsSelectNomina" datasource ="#session.DSN#">
    						select rhaan.RHAAid,rhaan.Tcodigo,tn.Tdescripcion,rhaan.CPcodigo
							from RHAjusteAnualNomina rhaan inner join RHAjusteAnual rhaa on rhaa.RHAAid= rhaan.RHAAid
								inner join TiposNomina tn on tn.Tcodigo=rhaan.Tcodigo and rhaa.Ecodigo=tn.Ecodigo
							where rhaa.Ecodigo = #session.Ecodigo#
								and rhaan.RHAAid = '#form.RHAAid#'
							group by rhaan.RHAAid,rhaan.Tcodigo,tn.Tdescripcion,rhaan.CPcodigo
						</cfquery>                      
					</cfif>
        		<cfif isdefined("rsSelectNomina") and rsSelectNomina.recordcount GT 0 > 
        			<cfloop query="rsSelectNomina">
                   	<tr height="20px">
            			<td width="30%" align="right" cellspacing="0" cellpadding="0" >
							#rsSelectNomina.Tdescripcion#
               			</td>
			    		<td align="center" cellspacing="0" cellpadding="0">	
                    		#rsSelectNomina.CPcodigo#		
						</td>	
						<td  nowrap="nowrap">
							<input name="BTN_BajaN" id="BTN_BajaN" type="image" src="/cfmx/rh/imagenes/Borrar01_S.gif" width="16" height="16" onClick="javascript: return EliminarN('#rsSelectNomina.Tcodigo#');">
						</td>
            		</tr>
           			</cfloop> 
        		</cfif>		
            	</table>
            </td>
        </tr>
        <cfif isdefined("rsSelectNomina") and rsSelectNomina.recordcount GT 0>
        <tr>
    		<td align="center" colspan="4">
        		<table width="100%">--->
            		
            	<!---</table>
         	</td>
   		</tr> 	
        <cfelseif isdefined("rsSelectNomina") and rsSelectNomina.recordcount EQ 0>
         <tr>
    		<td align="center" colspan="4">
        		<table width="100%">
            		<tr>
                    	<td width="100%" align="center">
                    		<strong>
                            	#LB_DefinirNom#
                            </strong>
                    	</td>
               		</tr>
            	</table>
         	</td>
   		 </tr>
        </cfif>--->
	</table>
</form>
</cfoutput>


<script language="javascript" type="text/javascript">
 function funcAltaN(){
		<cfoutput>
			document.form3.CPcodigo.required = true;
<!---			objForm.CPcodigo.description = "C�digo de N�mina";	
			objForm.CPcodigo.validateCodigo();--->
		</cfoutput>
	}

 function EliminarN(id) {
		<cfoutput>
			document.form3.hdTcodigo.value = id;
			document.form3.hdAccion.value = "BAJAN";
			return true;
		</cfoutput>
	}
	

</script>