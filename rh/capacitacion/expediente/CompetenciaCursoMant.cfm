<cfoutput>
<form action="SqlCompetenciasM.cfm"  method="post" name="Competencia2" >
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td width="17%" align="left" valign="top"><strong><cf_translate key="LB_Curso">Curso</cf_translate></strong></td>
			<td width="83%" valign="top">
				<cf_materias form="Competencia2" Mcodigo = "Mcodigo2" Mnombre= "Mnombre2" >
			</td>
		</tr>
		<tr>
			<td valign="top" align="left"><strong><cf_translate key="LB_FechaInicio">Fecha Inicio</cf_translate></strong></td>
			<td valign="top">
				<cfset fechai ='' >
				<cfif isdefined("form.RHCEfdesde")>
					<cfset fechai =form.RHCEfdesde >
				</cfif>				
				<cf_sifcalendario form="Competencia2" name="RHECfdesde" value="#htmleditformat(fechai)#" >
			</td>
		</tr>
		<tr>
			<td valign="top" align="left"><strong><cf_translate key="LB_FechaFinal">Fecha Final</cf_translate></strong></td>
			<td valign="top">
				<cfset fechaf ='' >
				<cfif isdefined("form.RHCEfhasta")>
					<cfset fechaf =form.RHCEfhasta >
				</cfif>
				
				<cf_sifcalendario form="Competencia2" name="RHECfhasta"  value="#htmleditformat(fechaf)#">
			</td>
		</tr>
<!--- 		
		<tr>
			<td valign="top" align="left"><strong>Nota Mínima</strong></td>
			<td valign="top">
				<input 
					name="RHEMnotamin" 
					id="RHEMnotamin" 
					type="text" 
					value="0.00" 
					maxlength="6" 
					size="6" 
					style=" text-align:right "
					onBlur="javascript:fm(this,2)" 
					onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
			</td>
		</tr>
 --->
		<td  nowrap valign="top" align="left"><strong><cf_translate key="LB_NotaObtenida">Nota Obtenida</cf_translate></strong></td>
		<td valign="top">
			<input name="RHEMnota" 
			id="RHEMnota" 
			type="text" 
			value="0.00" 
			maxlength="6" 
			size="6" 
			style=" text-align:right "
			onBlur="javascript:fm(this,2)" 
			onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
		</td>
		</tr>		
		<tr>
			<td valign="top" align="left"><strong><cf_translate key="LB_Estado">Estado</cf_translate></strong></td>
			<td valign="top">
				<select name="RHEMestado" id="RHEMestado">
					<option value="0" ><cf_translate key="LB_EnProceso">En progreso</cf_translate></option>
					<option value="10"><cf_translate key="LB_Aprobado">Aprobado</cf_translate></option>
					<option value="15"><cf_translate key="LB_Convalidado">Convalidado</cf_translate></option>
					<option value="20"><cf_translate key="LB_Perdido">Perdido</cf_translate></option>
					<option value="30"><cf_translate key="LB_Abandonado">Abandonado</cf_translate></option>
					<option value="40"><cf_translate key="LB_Retirado">Retirado</cf_translate></option>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2"><hr></td>
		</tr>	
		<tr>
			<td nowrap align="LEFT"><strong><cf_translate key="LB_DominioActual">Dominio Actual</cf_translate></strong></td>
			<td>
				&nbsp;&nbsp;<cfif isdefined("form.RHCEdominio")>#LSNumberFormat(form.RHCEdominio,'____.__')#<cfelse>0.00</cfif>
			</td>
		</tr>		
		<tr>
			<td align="LEFT"><strong>Nuevo Dominio</strong></td>
			<td>
			<cfset valor = 0.00 >
			<cfif isdefined("form.RHCEdominio")>
				<cfset valor = form.RHCEdominio >
			</cfif>
			<cf_monto name="RHCEdominio" value="#valor#" decimales="2" size="6"> &nbsp;%
			<!---
			<input type="text"
			SIZE="6" 
			MAXLENGTH="6"
			name="RHCEdominio" 
			id="RHCEdominio"
			VALUE="<cfif isdefined("form.RHCEdominio")>#LSNumberFormat(form.RHCEdominio,'____.__')#<cfelse>0.00</cfif>" 
			onBlur="javascript: fm(this,2);"  
			onFocus="javascript:this.value=qf(this); this.select();"
			style=" text-align:right "
			ONKEYUP="if(snumber(this,event,6)){ if(Key(event)=='13') {}}"
			>&nbsp;%--->
			</td>
		</tr>
		<tr>
			<td align="LEFT" valign="top"><strong>Justificaci&oacute;n</strong></td>
			<td align="left" valign="top"></td>
		</tr>
		<tr>
			<td colspan="2">
				<textarea name="RHCEjustificacion" rows="3" id="RHCEjustificacion" style="width: 100%"></textarea>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td  align="center" colspan="2" class="formButtons">
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<input type="submit" name="AltaC2"   value="Agregar" onClick="javascript:  if (window.habilitarValidacionCC) habilitarValidacionCC();">
			</td>  
		</tr>
	</table>
	<input type="hidden" name="DEid" 	value ="<cfif isdefined("DEid") and len(trim(DEid))>#DEid#</cfif>">
	<input type="hidden" name="RHOid" 	value ="<cfif isdefined("RHOid") and len(trim(RHOid))>#RHOid#</cfif>">
	<input type="hidden" name="TIPO" 	value="#form.TIPO#">
	<input type="hidden" name="idcompetencia" 	value="#form.idcompetencia#">
	<input type="hidden" name="RHCEid" 	value ="#form.RHCEid#">
	<input type="hidden" name="MODOC1" 	value="ALTA">
	<input type="hidden" name="ANOTA" 	value="S">
	<input type="hidden" name="ADDCUR" 	value="N">
</form>
</cfoutput>

<script language="javascript" type="text/javascript">
<!--//
	qFormAPI.errorColor = "#FFFFCC";
	objFormCC = new qForm("Competencia2");
	
	objFormCC.RHECfdesde.required= true;
	objFormCC.RHECfdesde.description="Fecha Inicio";	

	objFormCC.RHECfhasta.required= true;
	objFormCC.RHECfhasta.description="Fecha Final";	
	
	objFormCC.RHEMnota.required= true;
	objFormCC.RHEMnota.description="Nota Obtenida";	
	
	objFormCC.RHEMestado.required= true;
	objFormCC.RHEMestado.description="Estado";	

	objFormCC.RHCEdominio.required= true;
	objFormCC.RHCEdominio.description="Dominio";	

	objFormCC.RHCEjustificacion.required= true;
	objFormCC.RHCEjustificacion.description="Justificación";	


	function habilitarValidacionCC(){
		objFormCC.RHECfdesde.required= true;
		objFormCC.RHECfhasta.required= true;
		objFormCC.RHEMnota.required= true;
		objFormCC.RHEMestado.required= true;
		objFormCC.RHCEdominio.required= true;
		objFormCC.RHCEjustificacion.required= true;
	}
	
	function deshabilitarValidacionCC(){
		objFormCC.RHECfdesde.required= false;
		objFormCC.RHECfhasta.required= false;
		objFormCC.RHEMnota.required= false;
		objFormCC.RHEMestado.required= false;
		objFormCC.RHCEdominio.required= false;
		objFormCC.RHCEjustificacion.required= false;
	}		
//-->
</script>



