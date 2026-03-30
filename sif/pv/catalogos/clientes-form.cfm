<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 01 de Setiembre del 2005
	Motivo: Permitir que se ingrese el dato de identificación aun cuando no se haya definido el formato para la identificacion,
			en administación del sistema- Parametros Adicionales.  Si es el caso que se defina el formato entonces si hace la validacion.
	Línea: 219
 --->
<cfif isdefined('url.CDCcodigo') and not isdefined('form.CDCcodigo')>
	<cfparam name="form.CDCcodigo" default="#url.CDCcodigo#">
</cfif>

<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>

<cfset modo = 'ALTA'>

<cfif isdefined('form.CDCcodigo') and len(trim(form.CDCcodigo))>
 	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select CDCcodigo, CDCidentificacion, CDCtipo, CDCnombre,  CDCdireccion,CDCfechaNac, Ppais, CDCtelefono, 
		CDCFax, CDCporcdesc, CDCExentoImp, CDCemail, LOCidioma,  CDCfecha, ts_rversion, SNMid 
		from ClientesDetallistasCorp 
		where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">
		and CDCcodigo = <cfqueryparam  value="#form.CDCcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
    <cfset LvarSNMid = data.SNMid>
</cfif> 

<!---- Mascara--->
<cfparam name="LvarCDCtipo" default="">

<cfquery name="rsMasks" datasource="#Session.dsn#">
	select J.Pvalor Juridica, F.Pvalor Fisica
	from Parametros J, Parametros F
	where J.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and J.Pcodigo = 620
	  and F.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and F.Pcodigo = 630
</cfquery>

<!--- QUERY PARA EL tag combo de idioma--->
<cfquery name="rsIdiomas" datasource="sifcontrol">
	select rtrim(Icodigo) as LOCIdioma, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>

<!--- QUERY PARA EL TAG combo DE PAIS--->
<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<cfoutput>
<form name="form1" method="post" action="clientes-sql.cfm">
	<cfif isdefined('form.CDCidentificacion_F') and len(trim(form.CDCidentificacion_F))>
		<input type="hidden" name="CDCidentificacion_F" value="#form.CDCidentificacion_F#">	
	</cfif>
	<cfif isdefined('form.CDCnombre_F') and len(trim(form.CDCnombre_F))>
		<input type="hidden" name="CDCnombre_F" value="#form.CDCnombre_F#">	
	</cfif>	

	<cfif modo eq 'CAMBIO'>
		<input type="hidden" name="CDCcodigo" value="#data.CDCcodigo#">
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">	
	</cfif>
	
	<table width="100%" border="0" cellpadding="3" cellspacing="0">
		<tr><td colspan="4">&nbsp;</td></tr>
    	<tr>
        	<td align="right" valign="top"><strong>Tipo:&nbsp;</strong></td>
        	<td align="left" valign="top">
				<cfif #modo# EQ "ALTA"> <!--- se manda el campo como hidden para poder deshabilitarlo en cambio --->
					<cfset LvarCDCtipo = rsMasks.Fisica>
					<select name="CDCtipo" id="CDCtipo" onChange="getMask(false,SNMid)" tabindex="1">
						<option value="F" <cfif (isDefined("data.CDCtipo") AND "F" EQ data.CDCtipo)>selected</cfif>>Física</option>
						<option value="J" <cfif (isDefined("data.CDCtipo") AND "J" EQ data.CDCtipo)>selected</cfif>>Jurídica</option>
                        <option value="E" <cfif (isDefined("data.CDCtipo") AND "E" EQ data.CDCtipo)>selected</cfif>>Extranjero</option>
					</select>
				<cfelse>
					<cfif (isDefined("data.CDCtipo") AND "F" EQ data.CDCtipo)>
						<cfset LvarCDCtipo = rsMasks.Fisica>
						<input type="hidden" value="F" name="CDCtipo" id="CDCtipo">
						<input type="text" readonly value="Física" size="10" tabindex="-1" style="border:none;">
					<cfelseif (isDefined("data.CDCtipo") AND "J" EQ data.CDCtipo)>
						<cfset LvarCDCtipo = rsMasks.Juridica>
						<input type="hidden" value="J" name="CDCtipo" id="CDCtipo">
						<input type="text" readonly value="Jurídica" size="10" tabindex="-1" style="border:none;">
					<cfelseif (isDefined("data.CDCtipo") AND "E" EQ data.CDCtipo)>
						<cfset LvarCDCtipo = RepeatString("*", 30)>
						<input type="hidden" value="E" name="CDCtipo" id="CDCtipo">
						<input type="text" readonly value="Extranjero" size="10" tabindex="-1" style="border:none;">
					</cfif>
				</cfif>
                 <!---►►►►MASCARAS DE LOS SOCIOS DE NEGOCIO◄◄◄◄--->
                    <cfinvoke component="sif.Componentes.SocioNegocios" method="GetSNMascaras" returnvariable="rsSNMascaras"></cfinvoke>
                    <script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
                    <BR>&nbsp;&nbsp;
                    <select tabindex="1" name="SNMid" id="SNMid" onChange="getMask('true',this.value)">
                        <option value="">--Ninguno--</option>
                    </select>
			</td>
        	<td align="right" valign="top"><strong>Identificaci&oacute;n</strong></td>
       		<td>
				<input type="text" name="CDCidentificacion" id="CDCidentificacion" size="30" maxlength="30" tabindex="2" 
					value="<cfif modo neq 'ALTA'>#trim(data.CDCidentificacion)#</cfif>"><br>
          		<input type="text" name="SNmask" id="SNmask" size="30" readonly value="#LvarCDCtipo#" style="border:none;">
			</td>
      	</tr>
      	<tr>
        	<td align="right"><strong>Nombre:&nbsp;</strong></td>
        	<td align="left">
				<input type="text" name="CDCnombre" size="27" maxlength="255" tabindex="3" value="<cfif modo neq 'ALTA'>#data.CDCnombre#</cfif>">
			</td>
        	<td align="right"><strong>Direcci&oacute;n:&nbsp;</strong></td>
           	<td>
				<input type="text" name="CDCdireccion" size="30" maxlength="255" tabindex="4" value="<cfif modo neq 'ALTA'>#data.CDCdireccion#</cfif>">
			</td>
      	</tr>
      	<tr>
			<td align="right" nowrap><strong>Fecha de Nac:&nbsp;</strong></td>
			<td align="left">
				<cfif modo neq "ALTA">
					<cf_sifcalendario tabindex="5" form="form1" value="#LSDateFormat(data.CDCfechaNac,'dd/mm/yyyy')#" name="CDCfechanac">
				<cfelse>
					<cf_sifcalendario tabindex="5" form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="CDCfechanac">
				</cfif>	
			</td>
			<td align="right" nowrap><strong>Tel&eacute;fono:&nbsp;</strong></td>
			<td>
				<input type="text" tabindex="6" name="CDCtelefono" size="30" maxlength="30" value="<cfif modo neq 'ALTA'>#data.CDCtelefono#</cfif>">
		   </td>
	   </tr>
       <tr>
       	   <td align="right"><strong>Fax:&nbsp;</strong></td>
       	   <td align="left">
				<input type="text" name="CDCFax" size="27" maxlength="30" tabindex="7" value="<cfif modo neq 'ALTA'>#data.CDCFax#</cfif>">
		   </td>
           <td align="right"><strong>E-mail:&nbsp;</strong></td>
           <td>
				<input type="text" name="CDCemail" size="30" maxlength="100" tabindex="8" value="<cfif modo neq 'ALTA'>#data.CDCemail#</cfif>">
		   </td>
      </tr>
      <tr>
		  <td width="12%" align="right"><p><strong>Descuento:</strong>&nbsp;</p></td>
		  <td width="33%" align="left">
			  <strong>
				  <input type="text" name="CDCporcdesc" size="10" maxlength="8" tabindex="9" value="<cfif modo neq 'ALTA'>#data.CDCporcdesc#</cfif>"> &nbsp;% 
			  </strong>
		  </td>
		  <td width="11%" align="right" nowrap>
			  <input name="CDCExentoImp" type="checkbox" tabindex="10" <cfif modo NEQ "ALTA" and data.CDCExentoImp eq "1"> checked</cfif>>
		  </td>
		  <td width="44%" nowrap><strong>Cliente Exento de Impuesto</strong></td>
      </tr>
      <tr>
		  <td align="right"><strong>Pa&iacute;s:&nbsp;</strong></td>
		  <td align="left" nowrap>
			  <select name="Pais" tabindex="11">
				  <option value="">-seleccionar-</option>
				  <cfloop query="rsPais">
					  <option value="#rsPais.Ppais#"<cfif modo NEQ 'ALTA' and Trim(data.Ppais) EQ Trim(rsPais.Ppais)> selected </cfif>>#rsPais.Pnombre#</option>
				  </cfloop>
			  </select>
		  </td>
		  <td align="right"><strong>Idioma:&nbsp;</strong></td>
		  <td align="left" nowrap>
			  <select name="LOCIdioma" tabindex="12">
				  <option value="">-seleccionar-</option>
				  <cfloop query="rsIdiomas">
					  <option value="#rsIdiomas.LOCIdioma#"<cfif modo NEQ 'ALTA' and Trim(data.LOCidioma) EQ Trim(rsIdiomas.LOCIdioma)> selected </cfif>>#rsIdiomas.LOCIdescripcion#</option>
				  </cfloop>
			  </select>
		  </td>
   	  </tr>
    <tr>
    	<td colspan="4">&nbsp;</td>
	</tr>
    <tr>
    	<td colspan="4" >
			<cf_botones formName='form1' modo='#modo#'>	  
		</td>
   </tr>
   <tr>
    	<td colspan="4">&nbsp;</td>
   </tr>
  </table>
</form>

<cfif modo eq 'CAMBIO'>
	<fieldset><legend><strong>Clientes de Créditos</strong></legend>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinclude template="clientes_cred.cfm">
				</td>								
			</tr>
		</table>
	</fieldset>			
</cfif>
	
<cf_qforms>
<script language="JavaScript" type="text/javascript">
	<!--//
	objForm.CDCidentificacion.description = "Identificación";
	objForm.CDCtipo.description = "Tipo";
	objForm.CDCnombre.description = "Nombre";
	objForm.CDCporcdesc.description = "Porcentaje de Descuento";
	
	function habilitarValidacion(){
	    objForm.CDCidentificacion.required = true;
		objForm.CDCtipo.required = true;
		objForm.CDCnombre.required = true;
		objForm.CDCporcdesc.required = true;
	}
	function deshabilitarValidacion(){
		objForm.CDCidentificacion.required = false;
		objForm.CDCtipo.required = false;
		objForm.CDCnombre.required = false;
		objForm.CDCporcdesc.required = false;
	}
	habilitarValidacion();
	
	var f = document.form1;
	<cfoutput>
	var oCedulaMask = new Mask("#replace(trim(LvarCDCtipo),'X','##','ALL')#", "string");
	oCedulaMask.attach(document.form1.CDCidentificacion, oCedulaMask.mask, "string");

<!---
Formato del js Mask: x=letras, #=Numeros *=Ambos  
Formato del usuario: X=letras, ?=Numeros *=Ambos  
--->
function getMask(seleccionar,SNMid)
{
	<cfwddx action="cfml2js" input="#rsSNMascaras#" topLevelVariable="SNMascaras"> 
	var inpSNtipo   = document.getElementById("CDCtipo");
	var inpSNMid    = document.getElementById("SNMid");
	var inpIdenti   = document.getElementById("CDCidentificacion");
	var SNmask   	= document.getElementById("SNmask");
	
	var CantCombo   = 0;
 	var nRows       = SNMascaras.getRowCount(); 
	var usarMaskPar = true;

	//Elimina Todos los Valor del combo de Mascaras Extendidas, excepto el Index 0
	for(row = 1; row < inpSNMid.length; ++row)
		inpSNMid.options[row] = null
	//Si existen mascaras extendidas para la empresa	
 	if(nRows > 0)
	{
			for(row = 0; row < nRows; ++row)
			{
				//Si la mascara extendida es del tipo de indentificacion del Socio de Negocio Actual
				if (SNMascaras.getField(row, "SNtipo") == inpSNtipo.value)
				{
					//Si La mascara Extendida Actual es la que ya posse el SN, por lo que se coloca como seleccionada, de lo contrario coloca el defaultSelected
					if(seleccionar && SNMid == SNMascaras.getField(row, "SNMid"))
						selected = true;
					else
						selected = false;
					CantCombo++;
					valorCombo = new Option(SNMascaras.getField(row, "SNMDescripcion"),SNMascaras.getField(row, "SNMid"),0,selected)
					inpSNMid.options[inpSNMid.length] = valorCombo;
					if (selected)
					{
						usarMaskPar 	 = false;
						masktemp         = SNMascaras.getField(row,"SNMascara").replace(/X/g,'x');
						oCedulaMask.mask = masktemp.replace(/\?/g,'##');
						SNmask.value 	 = SNMascaras.getField(row,"SNMascara");
					}
				}
			}
			//Si posse Mascaras Extendidas para el tipo de Indentificacion pinta el combo de lo contrario lo oculta
			if(CantCombo > 0)
				inpSNMid.style.display = "";	
			else 
				inpSNMid.style.display = "none";	
	}
	//No existen mascaras extenidas para la empresa
	else
		inpSNMid.style.display   = "none";	
	//Aplica la mascara de los parametros
		 if (usarMaskPar)
		 {
			if (inpSNtipo.value == 'F')
			{
				oCedulaMask.mask = "#replace(replace(rsMasks.Fisica,'X','x','ALL'),'?','##','ALL')#";
				SNmask.value     = "#rsMasks.Fisica#";
			}
			else if (inpSNtipo.value == 'J')
			{
				oCedulaMask.mask = "#replace(replace(rsMasks.Juridica,'X','x','ALL'),'?','##','ALL')#";
				SNmask.value     = "#rsMasks.Juridica#";
			}
			else if (inpSNtipo.value== 'E')
			{			
				oCedulaMask.mask = "#RepeatString("*", 30)#";
				SNmask.value     = "";
			}
		 }
		 inpIdenti.onblur();
}

<cfif modo EQ 'CAMBIO' AND LEN(LvarSNMid)>
	getMask('true',#LvarSNMid#);
<cfelse>
	getMask('false',-1);
</cfif>
	</cfoutput>
//-->
</script>
</cfoutput>