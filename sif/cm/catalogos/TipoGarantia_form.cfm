<style>
	#layer1 {
	position: absolute;
	visibility: hidden;
	width: 400px;
	height: 100px;
	left: 150px;
	top: 165px;
	background-color: #ccc;
	border: 1px solid #000;
	padding: 10px;
}
#close {
	float: right;
}
</style>
<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsConsulta" datasource="#session.dsn#">
		select 
			TGid,
			Ecodigo,
			TGcodigo,
			TGdescripcion,
			TGtipo,
			TGmanejaMonto, 
			coalesce(TGmonto,0) as TGmonto, 
			coalesce(TGporcentaje,0) as TGporcentaje,  
			BMUsucodigo,
			BMfecha,
			coalesce(Mcodigo,0) as Mcodigo
		from TiposGarantia
		where TGid = #form.TGid#
	</cfquery>	
</cfif>
<form name="form1" action="TipoGarantia_sql.cfm" method="post" onsubmit="return validaCampos();">
<table width="100%" border="0" cellspacing="1" cellpadding="1">
	<tr>
		<td>
			<cfif modo EQ 'CAMBIO'><input type="hidden" name="TGid" value="<cfoutput>#form.TGid#</cfoutput>"></cfif>
			<input type="hidden" name="CampoModo" id="CampoModo" value="<cfoutput>#modo#</cfoutput>">			
			<input type="hidden" name="ManejaMonto" id="ManejaMonto" <cfif modo NEQ 'Alta'> value="<cfoutput>#rsConsulta.TGmanejaMonto#</cfoutput>" </cfif> >
		</td>
	</tr>
	<tr>
		<td>
			<strong>Código:</strong>	</td><td><input name="TGcodigo" 	 type="text" value="<cfoutput>#rsConsulta.TGcodigo#</cfoutput>" size="20" maxlength="10"> 
		</td>
	</tr>
	<tr>
		<td>
			<strong>Descripción:</strong></td><td><textarea name="TGdescripcion" cols="27"><cfoutput>#rsConsulta.TGdescripcion#</cfoutput></textarea>
		</td>
	</tr>
	<tr>
	<td><strong>Tipo:</strong></td>                        
		<td align="left">
			<select name="TGtipo" tabindex="1" id="TGtipo">
				<option value="1" <cfif modo NEQ 'Alta' and rsConsulta.TGtipo eq 1>selected="selected"</cfif>>Participación</option>
				<option value="2" <cfif modo NEQ 'Alta' and rsConsulta.TGtipo eq 2>selected="selected"</cfif>>Cumplimiento</option>
			 </select>
		</td>
	</tr>
	<tr>
	<td><strong>Maneja:</strong></td>
	<td>Porcentaje<input name="TGmanejaMonto" type="radio" value="0" onclick="showFrame()" <cfif modo EQ 'Alta'> checked="cheked"<cfelseif modo EQ 'Cambio' and #rsConsulta.TGmanejaMonto# eq 0> checked="cheked"</cfif>/> 
	Monto <input name="TGmanejaMonto" type="radio"  value="1" onclick="showFrame()" <cfif modo EQ 'Cambio' and #rsConsulta.TGmanejaMonto# eq 1> checked="cheked" </cfif>/></td>
	</tr>
	<tr id="DatoPorc">
	   <cfif modo neq 'Alta'>
   	  <td><strong>Porcentaje:</strong></td>
		<td>
	      <cf_inputNumber  name="TGporcentaje1" value="#rsConsulta.TGporcentaje#"  enteros="4" decimales="4">
	   </td>	   
	   <cfelse>
     	 <td><strong>Monto:</strong></td>
		 <td>
	      <cf_inputNumber  name="TGporcentaje1"  enteros="4" decimales="4">
	     </td>		 
	    </cfif>
	</tr>
	<tr id="DatoMonto">
	   <cfif modo neq 'Alta'>
   	  <td><strong>Monto:</strong></td>
		<td>
	      <cf_inputNumber  name="TGmonto" value="#rsConsulta.TGmonto#"  enteros="9" decimales="2">
	   </td>	   
	   <cfelse>
     	 <td><strong>Monto:</strong></td>
		 <td>
	      <cf_inputNumber  name="TGmonto"  enteros="9" decimales="2">
	     </td>		 
	    </cfif>
	</tr>
	<tr id="DatoMoneda">
       <cfif modo neq 'Alta'>
	    <td>
	      <strong>Moneda:</strong>
	    </td>
	    <td>
	      <cfquery name="rsMoneda" datasource="#session.dsn#">
		  Select Mnombre,Mcodigo from Monedas where Ecodigo = #session.ecodigo# 
		  </cfquery>
	  	 <select name="Mcodigo">
		 <cfloop query="rsMoneda">
		 <option value="<cfoutput>#rsMoneda.Mcodigo#</cfoutput>"<cfif rsConsulta.Mcodigo eq rsMoneda.Mcodigo>Selected="selected"</cfif>><cfoutput>#rsMoneda.Mnombre#</cfoutput></option>
		 </cfloop>
		 </select>
	    </td>
	   <cfelse>
	      <td>	
		  <strong>Moneda:</strong>
	      </td>
	      <td>
	      <cfquery name="rsMonedas" datasource="#session.dsn#">
		  Select Mnombre,Mcodigo from Monedas where Ecodigo = #session.ecodigo#
		  </cfquery>
         <select name="Mcodigo">
		 <cfloop query="rsMonedas">
		   <option value="<cfoutput>#rsMonedas.Mcodigo#</cfoutput>"><cfoutput>#rsMonedas.Mnombre#</cfoutput></option>
		 </cfloop>
		 </select>
	     </td>

	   </cfif>
	</tr> 
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="2"><cf_botones modo="#modo#"></td><tr>
</table>
</form>

<cf_qforms>
	<cf_qformsRequiredField name="TGcodigo" 		description="Codigo">
	<cf_qformsRequiredField name="TGdescripcion" description="Descripción">
	<cf_qformsRequiredField name="TGtipo" 	 		description="Tipo">
</cf_qforms>
<cfoutput>
<script language="javascript">
function showFrame(){
        
	Modo = document.getElementById('CampoModo').value;
	if(Modo == 'CAMBIO')
    {
	  manejaMonto = document.getElementById('ManejaMonto').value;
	}
	else
	{
	  manejaMonto = 0;
	}
	
	
	var i;	
	   for (i=0;i<document.form1.TGmanejaMonto.length;i++){
       if (document.form1.TGmanejaMonto[i].checked)
          break;
    }
    myVar= document.form1.TGmanejaMonto[i].value;
    
	if(myVar == '1')
	{
	 document.getElementById('DatoMonto').style.display = '';
	 document.getElementById('DatoMoneda').style.display = '';
	 document.getElementById('DatoPorc').style.display = 'none';
	}
	if(myVar == '0')
	{
	 document.getElementById('DatoMonto').style.display = 'none';
	 document.getElementById('DatoMoneda').style.display = 'none';
	 document.getElementById('DatoPorc').style.display = '';
	}
} 
function validaCampos()
{ 
    var i;
    for (i=0;i<document.form1.TGmanejaMonto.length;i++)
	{
       if (document.form1.TGmanejaMonto[i].checked)
         break;
    }
  
    myVar= document.form1.TGmanejaMonto[i].value;
	datoMontoForm= document.getElementById('TGmonto').value;
	datoPorcForm= document.getElementById('TGporcentaje1').value;

    if(myVar == 1)
	 {
       if( datoMontoForm == '')
         {
		  alert("El campo de monto es requerido");	  
	      return false;		 
		 }
		 
	 }
	else if (myVar ==  0)
	 {
	   if(datoPorcForm == '')
         {
		  alert("El campo Porcentaje es requerido");	
		  return false;   		  
		 } 
 	 }	
	 else
	 return true;	  
}

function EscondeCampos()
{
    Modo = document.getElementById('CampoModo').value;
	if(Modo == 'CAMBIO')
    {
	 manejaMonto = document.getElementById('ManejaMonto').value;
	 if(manejaMonto == 0)
	 {
	  document.getElementById('DatoMonto').style.display = 'none';
      document.getElementById('DatoMoneda').style.display = 'none';
	  document.getElementById('DatoPorc').style.display = '';
	 }	 
	 if(manejaMonto == 1)
	 {
	  document.getElementById('DatoMonto').style.display = '';
      document.getElementById('DatoMoneda').style.display = '';
      document.getElementById('DatoPorc').style.display = 'none';
	 }	 
	}
	else
	{
	 document.getElementById('DatoMonto').style.display = 'none';
	 document.getElementById('DatoMoneda').style.display = 'none';
	 document.getElementById('DatoPorc').style.display = '';
    }
}
  EscondeCampos();
</script>
</cfoutput>