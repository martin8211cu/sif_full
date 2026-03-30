<cfif isdefined('url.filtro_Rcodigo') and not isdefined('form.filtro_Rcodigo')>
	<cfset form.filtro_Rcodigo = url.filtro_Rcodigo>
</cfif>
<cfif isdefined('url.filtro_Rdescripcion') and not isdefined('form.filtro_Rdescripcion')>
	<cfset form.filtro_Rdescripcion = url.filtro_Rdescripcion>
</cfif>			
<cfif isdefined('url.hfiltro_Rcodigo') and not isdefined('form.hfiltro_Rcodigo')>
	<cfset form.hfiltro_Rcodigo = url.hfiltro_Rcodigo>
</cfif>
<cfif isdefined('url.hfiltro_Rdescripcion') and not isdefined('form.hfiltro_Rdescripcion')>
	<cfset form.hfiltro_Rdescripcion= url.hfiltro_Rdescripcion>
</cfif>			
<cfset modo = 'ALTA' >
<cfif isdefined("form.Rcodigo") and len(trim(form.Rcodigo))>
	<cfset modo = 'CAMBIO' >
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsRetenciones" datasource="#Session.DSN#" >
		Select Rcodigo, Rdescripcion, Ccuentaretc, Ccuentaretp, 
		Rporcentaje,ts_rversion, Conta_MonOri,isVariable
		from Retenciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#" >		  
			order by Rdescripcion asc
	</cfquery>
	
	<cfquery name="rsCuentaRetc" datasource="#Session.DSN#">
		select Ccuenta, Cformato, Cdescripcion
		 from CContables 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRetenciones.Ccuentaretc#" null="#Len(rsRetenciones.Ccuentaretc) is 0#">
	</cfquery>

	<cfquery name="rsCuentaRetp" datasource="#Session.DSN#">
		select Ccuenta, Cformato, Cdescripcion
		 from CContables 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRetenciones.Ccuentaretp#" null="#Len(rsRetenciones.Ccuentaretp) is 0#">
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="retsimple">
select 
	<cfif modo neq 'ALTA'>
	case when rd.RcodigoDet is null then 0 else 1 end as sel, 
	<cfelse>
	0 as sel,
	</cfif>
	r.Rcodigo, r.Rdescripcion, r.Rporcentaje
from Retenciones r
	<cfif modo neq 'ALTA'>
		left join RetencionesComp rd
			on rd.RcodigoDet = r.Rcodigo
			and rd.Ecodigo = r.Ecodigo
			and rd.Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#" >		  
	</cfif>
where r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and r.Rcodigo != <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#" >		  
	</cfif>
	and not exists (
		select *
		from RetencionesComp re
		where re.Rcodigo = r.Rcodigo)
order by r.Rcodigo
</cfquery>
<cfif modo neq 'ALTA'>
<cfquery datasource="#session.dsn#" name="retcomp">
	select count(1) as cant
	from RetencionesComp
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Rcodigo#" >		  
</cfquery>
</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<cfoutput>
<form action="SQLRetenciones.cfm" method="post" name="form1">
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
	<input name="Empresa" type="hidden" tabindex="-1" value="<cfif isdefined('form.Empresa')>#form.Empresa#</cfif>">
	<input name="filtro_Rcodigo" type="hidden" value="<cfif isdefined('form.filtro_Rcodigo')>#form.filtro_Rcodigo#</cfif>">
	<input name="filtro_Rdescripcion" type="hidden" value="<cfif isdefined('form.filtro_Rdescripcion')>#form.filtro_Rdescripcion#</cfif>">

	
	<table width="67%" height="38%" align="center" cellpadding="1" cellspacing="0">
	<tr> 
			<td align="right" nowrap>C&oacute;digo:&nbsp;</td>
			<td>
				<input name="Rcodigo" tabindex="1" type="text" size="5" maxlength="2"  alt="El Código de la Retención" 
					<cfif modo NEQ 'ALTA'>class="cajasinborde" readonly</cfif> onfocus="this.select();"
					value="<cfif modo neq 'ALTA'>#htmleditFormat(rsRetenciones.Rcodigo)#</cfif>" >			  
					
				<label id="lblretcomp">
				<input type="checkbox" name="retcomp" value="1" onclick="mostar_detalle_ret(this)" <cfif modo neq 'ALTA' AND retcomp.cant neq 0>checked="checked"</cfif> />
				Compuesta&nbsp;
				</label>	  
				
				<label id="lblConta_MonOri">
				<input type="checkbox" name="Conta_MonOri" value="1" <cfif modo neq 'ALTA' AND rsRetenciones.Conta_MonOri eq 1>checked="checked"</cfif> />
				Contabiliza moneda origen&nbsp;
				</label>		   
			
			
				<label>
					<input type="checkbox" id="chkRetVar" name="chkRetVar" value="1"
						onclick="mostar_detalle_comp(this)"
						<cfif modo neq 'ALTA' AND rsRetenciones.isVariable eq 1>checked="checked" </cfif> <cfif modo neq 'ALTA'> disabled</cfif> />
					Retenci&oacute;n variable
				</label>
			
			
			
			
			
			
			</td>
		</tr>
		<tr> 
			<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td>
				<input name="Rdescripcion" tabindex="1" type="text" size="40" maxlength="80"  
				value="<cfif modo NEQ "ALTA">#htmleditFormat(rsRetenciones.Rdescripcion)#</cfif>" 
				  onfocus="this.select();" alt="La Descripción del Tipo de Transacción">			</td>
		</tr>

		<tr id='tr_cuentacobro' style="<cfif modo neq 'ALTA' AND retcomp.cant NEQ 0>display:none</cfif>"> 
			<td align="right" nowrap>Cuenta de Cobro:&nbsp;</td>
			<td align="left" nowrap>
				<cfif modo NEQ "ALTA">
					<cf_cuentas form="form1" tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCuentaRetc#" auxiliares="N" movimiento="S" frame="frame1" ccuenta="Ccuentaretc" cdescripcion="Cdescripcionretc" cformato="Cformatoretc">	  
				<cfelse>
					<cf_cuentas form="form1" tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" frame="frame1" ccuenta="Ccuentaretc" cdescripcion="Cdescripcionretc" cformato="Cformatoretc">
				</cfif>			</td>
		</tr>

		<tr id='tr_cuentapago' style="<cfif modo NEQ 'ALTA' AND retcomp.cant NEQ 0>display:none</cfif>"> 
			<td valign="middle" nowrap align="right">Cuenta de Pago:&nbsp;</td>
			<td>
				<cfif modo NEQ "ALTA">
					<cf_cuentas form="form1" tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCuentaRetp#" auxiliares="N" movimiento="S" frame="frame2" ccuenta="Ccuentaretp" cdescripcion="Cdescripcionretp" cformato="Cformatoretp">	  	  
				<cfelse>
					<cf_cuentas form="form1" tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" frame="frame2" ccuenta="Ccuentaretp" cdescripcion="Cdescripcionretp" cformato="Cformatoretp">	  	  		
				</cfif>			</td>
		</tr>

		<tr> 
			<td nowrap align="right">Porcentaje:&nbsp;</td>
			<td>
				<input name="Rporcentaje" id="Rporcentaje" tabindex="1" type="text" onBlur="javascript: fm(this,4);" 
				<cfif modo neq 'ALTA' and retcomp.cant neq 0>readonly="readonly"</cfif>
				<cfif modo neq 'ALTA' AND rsRetenciones.isVariable eq 1> disabled </cfif>
				value="<cfif modo NEQ "ALTA">#rsRetenciones.Rporcentaje#<cfelse>0.0000</cfif>" 
				size="8" maxlength="8"  style="text-align: right;" onfocus="javascript:this.value=qf(this); this.select();"  
				onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" alt="El Porcentaje de la Retención">			</td>
		</tr>

		<tr valign="top"><td colspan="2">&nbsp;</td></tr>


		<tr id="detalle_ret1"  style="<cfif modo is 'ALTA' OR retcomp.cant is 0>display:none</cfif>"> 
			<td colspan="2" class="subtitulo">			Retenci&oacute;n compuesta&nbsp;</td>
		</tr>
		
		<tr id="detalle_ret"  style="<cfif modo is 'ALTA' OR retcomp.cant is 0>display:none</cfif>"> 
			<td colspan="2">
			  <table width="481" border="0">
                <tr>
                  <td valign="top">&nbsp;</td>
                  <td valign="top">&nbsp;</td>
                  <td valign="top">&nbsp;</td>
                  <td valign="top">&nbsp;</td>
                </tr>
                <tr>
                  <td valign="top">&nbsp;</td>
                  <td colspan="3" valign="top">Indique las composición de esta retención cuando sea compuesta. </td>
                </tr>
			  <cfloop query="retsimple">
                <tr>
                  <td width="22" valign="top">&nbsp;</td>
                  <td width="22" valign="top"><input type="checkbox" name="retsimple" value="#HTMLEditFormat(retsimple.Rcodigo)#"  onchange="sum_pct()"
				  	id="retsimple_#HTMLEditFormat(Trim(retsimple.Rcodigo))#" <cfif retsimple.sel>checked="checked"</cfif>></td>
                  <td width="38" valign="top" style="cursor:pointer" onclick="clicheck(form1.retsimple_#HTMLEditFormat(Trim(retsimple.Rcodigo))#)">#HTMLEditFormat(retsimple.Rcodigo)#</td>
                  <td width="381" valign="top" style="cursor:pointer" onclick="clicheck(form1.retsimple_#HTMLEditFormat(Trim(retsimple.Rcodigo))#)">#HTMLEditFormat(retsimple.Rdescripcion)#</td>
                </tr></cfloop>
                            </table></td>
		</tr>
		<tr valign="top"><td colspan="2">&nbsp;</td></tr>

		<tr> 
			<td colspan="2" align="center" nowrap>
				<cf_botones modo="#modo#" tabindex="1">			</td>
		</tr>
	</table>

	<cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsRetenciones.ts_rversion#"/>
		</cfinvoke>
	</cfif>  
	<input tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">
</form>
</cfoutput>
<cf_qforms>
<script language="JavaScript1.2">

//------------------------------------------------------------------------
//VALIDACIONES DE CAMPOS
	_allowSubmitOnError = false;
	
	function _Field_isRango(low, high){
	if (_allowSubmitOnError!=true){
	var low=_param(arguments[0], 0, "number");
	var high=_param(arguments[1], 9999999, "number");
	var iValue=parseFloat(qf(this.value));
	if(isNaN(iValue))iValue=0;
	if((low>iValue)||(high<iValue)){this.error="El porcentaje de Retención debe ser un número entre "+low+" y "+high+".";
	}}}
	_addValidator("isRango", _Field_isRango);


	function _Field_isCompuesto(){
		if (_allowSubmitOnError!=true){
			if (!document.form1.retcomp.checked) return; // OK, no es compuesto
			var cant = 0;
			<cfoutput query="retsimple">
			if (document.form1.retsimple_#HTMLEditFormat(Trim(retsimple.Rcodigo))#.checked) cant++;
			</cfoutput>
			if(cant < 2){
				this.error="Debe seleccionar al menos dos componentes para la retención.";
			}
		}
	}
	_addValidator("isCompuesto", _Field_isCompuesto);

	objForm.Rcodigo.required = true;
	objForm.Rcodigo.description="Código";
	objForm.Rdescripcion.required = true;
	objForm.Rdescripcion.description="Descripción";
	objForm.Ccuentaretc.required = <cfif modo neq 'ALTA' AND retcomp.cant neq 0>false<cfelse>true</cfif>;
	objForm.Ccuentaretc.description="Cuenta de Cobro";
	objForm.Ccuentaretp.required = <cfif modo neq 'ALTA' AND retcomp.cant neq 0>false<cfelse>true</cfif>;
	objForm.Ccuentaretp.description="Cuenta de Pago";
	objForm.Rporcentaje.required = true;
	objForm.Rporcentaje.description="Porcentaje";
	objForm.Rporcentaje.validateRango('0','100');
	objForm.retcomp.required = false;
	objForm.retcomp.description = "Compuesto";
	objForm.retcomp.validateCompuesto();
	
	function deshabilitarValidacion(){
		objForm.Rcodigo.required = false;
		objForm.Rdescripcion.required = false;
		objForm.Ccuentaretc.required = false;
		objForm.Ccuentaretp.required = false;
		objForm.Rporcentaje.required = false;
		_allowSubmitOnError = true;
	}
	function habilitarValidacion(){
		objForm.Rcodigo.required = true;
		objForm.Rdescripcion.required = true;
		objForm.Ccuentaretc.required = (!document.form1.retcomp.checked);
		objForm.Ccuentaretp.required = (!document.form1.retcomp.checked);
		objForm.Rporcentaje.required = true;
	}

function clicheck(c)
{
	c.checked=!c.checked;
	sum_pct();
}
function mostar_detalle_comp(ch)
{
	document.getElementById("retcomp").checked=false;
	document.getElementById("lblretcomp").style.display=(ch.checked)?"none":"";
	document.getElementById("Rporcentaje").value="0.0000";
	mostar_detalle_ret(true);
}
function mostar_detalle_ret(ch)
{
	document.getElementById("detalle_ret").style.display=(ch.checked)?"":"none";
	document.getElementById("detalle_ret1").style.display=(ch.checked)?"":"none";
	document.getElementById("tr_cuentacobro").style.display=(!ch.checked)?"":"none";
	document.getElementById("tr_cuentapago").style.display=(!ch.checked)?"":"none";
	document.getElementById("Rporcentaje").readonly=(ch.checked);
	habilitarValidacion();	
}
function sum_pct()
{
	var newpct = 0;
	
	<cfoutput query="retsimple">
		if (document.form1.retsimple_#HTMLEditFormat(Trim(retsimple.Rcodigo))#.checked)
			newpct += #NumberFormat(retsimple.Rporcentaje,"_.____")#;
	</cfoutput>
	document.form1.Rporcentaje.value = newpct;
	fm(document.form1.Rporcentaje,4);
}



//------------------------------------------------------------------------
<cfif modo NEQ 'ALTA'>
	document.form1.Rdescripcion.focus();
<cfelse>
	document.form1.Rcodigo.focus();
</cfif>
</script>