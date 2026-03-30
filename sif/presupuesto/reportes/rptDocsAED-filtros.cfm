<!---=================EXTRAE EL PERIODO POR DEFECTO=================--->
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
   select CPPid
     from CPresupuestoPeriodo p
   where p.Ecodigo = #Session.Ecodigo#
     and p.CPPestado <> 0
</cfquery>
<cfparam name="form.CPPid"	default="#rsPeriodos.CPPid#">
<cfset session.CPPid = form.CPPid>

<cfquery name="rsAnexoGOTipo" datasource="#Session.DSN#">
   select GOTid, GOTnombre
     from AnexoGOTipo p
   where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsCPDocumentoAE" datasource="#Session.DSN#">
	select CPDAEcodigo, CPDAEdescripcion from CPDocumentoAE where Ecodigo = #session.Ecodigo#
</cfquery>

<form name="form1" method="post" action="rptDocsAED-imprimir.cfm" onSubmit="return sbSubmit();">
<table width="100%" border="0" align="center">
<!---=============Período Presupuestario=============--->
	<tr>
    	<td width="18%">Período Presupuestario:</td>
    	<td width="43%"><cf_cboCPPid value="#session.CPPid#" CPPestado="1,2"></td>
        <td width="39%">&nbsp;</td>
	</tr>
<!---=============Centro Funcional Origen=============--->    
    <tr>
   	 	<td>Centro Funcional Inicial:</td>
        <td>
        	<cfparam name="form.CFidIni" default="">
            <cf_CPSegUsu_cboCFid name="CFidIni" value="#form.CFidIni#" Consultar="false">
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>Centro Funcional Final:</td>
        <td>
        	<cfparam name="form.CFidFin" default="">
            <cf_CPSegUsu_cboCFid name="CFidFin" value="#form.CFidFin#" Consultar="false"> 
        </td>
        <td>&nbsp;</td>				
	</tr>
<!---=============Numero Documento=============--->  
    <tr>
        <td>Numero Documento:</td>
        <td>
        	 <select name="CPDAEcodigo" id="CPDAEcodigo">
             	 <option value="">Seleccione el Numero Documento</option>
                  <cfloop query="rsCPDocumentoAE">
                       <cfoutput><option value="#rsCPDocumentoAE.CPDAEcodigo#">#rsCPDocumentoAE.CPDAEdescripcion#</option></cfoutput>
                  </cfloop>
             </select>
        </td>
        <td>&nbsp;</td>				
	</tr>
<!---=============Mostrar detalle de cuentas=============--->  
    <tr>
    	<td>Mostrar Grupo de Oficina:
        </td>
        <td>
        	<table>
            	<tr><td><input type="checkbox" name="TypeGO" id="TypeGO" onclick="viewTGO()"/></td>
                <td id = "divTypeGO">
                        <select name="GOTid" id="GOTid">
                                <option value="">Seleccione un Tipo de Grupos de Oficinas</option>
                            <cfloop query="rsAnexoGOTipo">
                               <cfoutput><option value="#rsAnexoGOTipo.GOTid#">#rsAnexoGOTipo.GOTnombre#</option></cfoutput>
                            </cfloop>
                        </select>
                    </td>
                    </tr>
           </table>
       </td>
        <td>&nbsp;</td>
    </tr>
<!---=============Botones de Acción=============--->   
	<tr>
      	<cf_btnImprimir name="rptDocsAED" TipoPagina="Carta Horizontal (Letter Landscape)">
	</tr>
</table>
</form>
<cf_qforms>
     <cf_qformsRequiredField name="CPPid"   description="Período Presupuestario">
      <cf_qformsRequiredField name="CFidIni"  description="Centro Funcional Inicial">
       <cf_qformsRequiredField name="CFidFin"   description="Centro Funcional Final">
        <cf_qformsRequiredField name="CPDAEcodigo" description="Numero Documento">
         <cf_qformsRequiredField name="GOTid"   description="Tipo de Grupos de Oficinas">
</cf_qforms>
<script language="javascript" type="text/javascript">
	var divTypeGO = document.getElementById("divTypeGO");
	var GvarSubmit = false;
	divTypeGO.style.display = "";
	function viewTGO()
	{
		if(document.form1.TypeGO.checked)
		{
			divTypeGO.style.display= "";
			document.form1.GOTid.focus();
			objForm.GOTid.required=true;
		}
		else
		{
			divTypeGO.style.display  = "none";
			objForm.GOTid.required=false;
		}
	}
	function sbSubmit()
	{
		GvarSubmit = true;
		return true;
	}
	function fnbtnCancelar()
	{
		objForm.CPPid.required=false;
		objForm.CFidIni.required=false;
		objForm.CFidFin.required=false;
		objForm.CPDAEcodigo.required=false;
		objForm.GOTid.required=false;
	}
	viewTGO();
</script>