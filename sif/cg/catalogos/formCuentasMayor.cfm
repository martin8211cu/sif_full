<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 21 de julio del 2005
	Motivo: Se cambiaron las consulta para agregar el nuevo campo Crevaluable 
			de la tabla CtasMayor, ademas de agregar en la forma un check 
			para indicar si la cuenta es revaluable o no.

	Modificado por Gustavo Fonseca H.
		Fecha: 23-2-2006.
		Motivo: Se modifica para corregir la navegación del formulario por tabs (Ordenado) y se actualiza para 
		que utilize el cf_botones y poder así asignarle un orden (tabindex).
		También se corrige la función valida por que permitía grabar cuentas con letras.
--->

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

<cfquery name="rsTCHistorico" datasource="#Session.DSN#">
    select TCHid,Ecodigo,TCHcodigo,TCHdescripcion
    from HtiposcambioConversionE
    where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
    
<cfif modo NEQ "ALTA">
	<cfquery name="rsCtasMayor" datasource="#Session.DSN#">
		select Cmayor, Cdescripcion, CdescripcionA, Ctipo, Csubtipo, Cbalancen, Crevaluable,CTCconversion,TCHid, ts_rversion
		  from CtasMayor
		 where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   and Cmayor = <cfqueryparam value="#Form.Cmayor#" cfsqltype="cf_sql_char">
	</cfquery>

	<cfquery name="rsVigencia" datasource="#Session.DSN#">
		select CPVid, CPVdesde, CPVhasta, PCEMid, CPVdesdeAnoMes, CPVhastaAnoMes, CPVformatoF, CPVformatoPropio, 
			(select count(1)
			   from CFinanciera c
			  where c.Ecodigo= v.Ecodigo
				and c.Cmayor = v.Cmayor
				and c.CPVid  = v.CPVid
				and c.CFformato <> c.Cmayor
			) as CPVtieneFinancieras,
			(select count(1)
			   from CContables c
			  where c.Ecodigo= v.Ecodigo
				and c.Cmayor = v.Cmayor
				and c.Cformato <> c.Cmayor
			) as CPVtieneContables,
			(select count(1)
			   from CPresupuesto c
			  where c.Ecodigo= v.Ecodigo
				and c.Cmayor = v.Cmayor
				and c.CPVid  = v.CPVid
				and c.CPformato <> c.Cmayor
			) as CPVtienePresupuesto,
			(select count(1)
			   from PCReglas c
			  where c.Ecodigo= v.Ecodigo
				and c.Cmayor = v.Cmayor
				and c.PCEMid = v.PCEMid
			) as CPVtieneReglas,
			(select count(1)
			   from CVPresupuesto c
			  where c.Ecodigo= v.Ecodigo
				and c.Cmayor = v.Cmayor
			) as CPVtieneFormulacion
		  from CPVigencia v
		 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and Cmayor = <cfqueryparam value="#Form.Cmayor#" cfsqltype="cf_sql_char">
		 order by CPVhastaAnoMes desc
	</cfquery>
</cfif>

<cfquery name="rs" datasource="#Session.DSN#">
	select ltrim(rtrim(Cmayor)) as Cmayor from CtasMayor 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	order by Cmayor
</cfquery>

<cfquery name="rsMascaras" datasource="#Session.DSN#">
	select 
		PCEMid
		, PCEMformato, PCEMformatoC, PCEMformatoP
		, PCEMplanCtas
		, PCEMdesc
	from PCEMascaras 
	where CEcodigo=<cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric"> 
	  and PCEMformato <> ' ' and PCEMformato <> 'XXXX-'
	order by PCEMdesc
</cfquery>

<cfquery name="rsCuentaDefault" datasource="#Session.DSN#">
	select Pvalor 
	  from Parametros 
	 where Pcodigo=10 
	   and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsMesConta" datasource="#Session.DSN#">
	select a.Pvalor Ano, m.Pvalor Mes
	  from Parametros a, Parametros m
	 where a.Pcodigo=30 
	   and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   and m.Pcodigo=40 
	   and m.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Btn_Idioma = t.Translate('Btn_Idioma','Idioma')>

<form method="post" name="form1" action="SQLCuentasMayor.cfm" onSubmit="javascript: return valida(); ">
  <cfoutput>
  <cfif isdefined("Form.PageNum10") and Len(Trim(Form.PageNum10))>
  	<input type="hidden" name="PageNum_lista10" value="#Form.PageNum10#" />
  <cfelseif isdefined("Form.PageNum_lista10") and Len(Trim(Form.PageNum_lista10))>
  	<input type="hidden" name="PageNum_lista10" value="#Form.PageNum_lista10#" />
  </cfif>
  <cfif isdefined("Form.CmayorF") and Len(Trim(Form.CmayorF))>
  	<input type="hidden" name="CmayorF" value="#Form.CmayorF#" />
  </cfif>
  <cfif isdefined("Form.CdescripcionF") and Len(Trim(Form.CdescripcionF))>
  	<input type="hidden" name="CdescripcionF" value="#Form.CdescripcionF#" />
  </cfif>
  <cfif isdefined("Form.CtipoF") and Len(Trim(Form.CtipoF))>
  	<input type="hidden" name="CtipoF" value="#Form.CtipoF#" />
  </cfif>
  </cfoutput>
  <table border="0" cellpadding="2" cellspacing="0">
    <tr>
      <td align="right"><strong>Cuenta:</strong>&nbsp;</td>
      <td colspan="1"><input name="Cmayor"  size="4" maxlength="4" tabindex="1" onBlur="if ((this.value != '') && (!validaNumero(document.form1.Cmayor.value))) document.form1.Cmayor.select();" type="text" <cfif modo NEQ "ALTA"> readonly </cfif> value="<cfif modo NEQ "ALTA"><cfoutput>#rsCtasMayor.Cmayor#</cfoutput></cfif>">
      </td>
    </tr>
    <tr>
      <td align="right"><strong>Descripci&oacute;n:</strong>&nbsp;</td>
      <td>
	  	<input name="Cdescripcion" type="text" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsCtasMayor.Cdescripcion#</cfoutput></cfif>" size="50" maxlength="80" tabindex="1">
	  </td>
    </tr>
    <tr>
      <td align="right"><strong>Descripci&oacute;n Altena:</strong>&nbsp;</td>
      <td>
	  	<input name="CdescripcionA" type="text" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsCtasMayor.CdescripcionA#</cfoutput></cfif>" size="50" maxlength="80" tabindex="1">
	  </td>
    </tr>
    <tr>
      <td align="right"><strong>Tipo:&nbsp;</strong></td>
      <td colspan="1">
		   <table cellpadding="2" cellspacing="0">
			  <tr>
				<td>
				  <select name="Ctipo" id="Ctipo" onChange="javascript: changeTipo(this);" tabindex="1">
					<option value="A" <cfif modo NEQ "ALTA" and rsCtasMayor.Ctipo EQ 'A'>selected</cfif>>Activo</option>
					<option value="P" <cfif modo NEQ "ALTA" and rsCtasMayor.Ctipo EQ 'P'>selected</cfif>>Pasivo</option>
					<option value="C" <cfif modo NEQ "ALTA" and rsCtasMayor.Ctipo EQ 'C'>selected</cfif>>Capital</option>
					<option value="I" <cfif modo NEQ "ALTA" and rsCtasMayor.Ctipo EQ 'I'>selected</cfif>>Ingreso</option>
					<option value="G" <cfif modo NEQ "ALTA" and rsCtasMayor.Ctipo EQ 'G'>selected</cfif>>Gasto</option>
					<option value="O" <cfif modo NEQ "ALTA" and rsCtasMayor.Ctipo EQ 'O'>selected</cfif>>Orden</option>
				  </select>
				</td>
			</tr>
			
		  	</table>
		</td>
    </tr>
	<tr>
		<td id="tdSubtipo1" style="display: none; " align="right"><strong>Subtipo:</strong>&nbsp;</td>
		<td id="tdSubtipo2" style="display: none; ">
		  <select name="Csubtipo1" id="Csubtipo1" tabindex="1">
			<option value="1"<cfif modo NEQ "ALTA" and rsCtasMayor.Csubtipo EQ 1> selected</cfif>>Ventas o Ingresos</option>
			<option value="4"<cfif modo NEQ "ALTA" and rsCtasMayor.Csubtipo EQ 4> selected</cfif>>Otros Ingresos Gravables</option>
			<option value="6"<cfif modo NEQ "ALTA" and rsCtasMayor.Csubtipo EQ 6> selected</cfif>>Ingresos no Gravables</option>
		  </select>
		</td>
		<td id="tdSubtipo3" style="display: none; ">
		  <select name="Csubtipo2" id="Csubtipo2" tabindex="1">
			<option value="2"<cfif modo NEQ "ALTA" and rsCtasMayor.Csubtipo EQ 2> selected</cfif>>Costos de Operaci&oacute;n</option>
			<option value="3"<cfif modo NEQ "ALTA" and rsCtasMayor.Csubtipo EQ 3> selected</cfif>>Gastos de Operaci&oacute;n y Administrativos</option>
			<option value="5"<cfif modo NEQ "ALTA" and rsCtasMayor.Csubtipo EQ 5> selected</cfif>>Otros Gastos Deducibles</option>
			<option value="7"<cfif modo NEQ "ALTA" and rsCtasMayor.Csubtipo EQ 7> selected</cfif>>Gastos no Deducibles</option>
			<option value="8"<cfif modo NEQ "ALTA" and rsCtasMayor.Csubtipo EQ 8> selected</cfif>>Impuestos</option>
		  </select>
		</td>
	</tr>
    <tr>
      <td align="right" nowrap><strong>Balance Normal:&nbsp;</strong></td>
      <td colspan="1"><select name="Cbalancen" id="select3" tabindex="1">
          <option value="D" <cfif modo NEQ "ALTA" and rsCtasMayor.CBalancen EQ "D">selected</cfif>>D&eacute;bito</option>
          <option value="C" <cfif modo NEQ "ALTA" and rsCtasMayor.CBalancen EQ "C">selected</cfif>>Cr&eacute;dito</option>
      </select></td>
    </tr>
    <tr>
    <cfif MODO EQ "ALTA">
        <td nowrap align="right"><strong>Vigente Desde:&nbsp;</strong></td>
        <td colspan="1"> Mes
            <cfset LVarCPVmes = 1>
            <select name="CPVmes" id="CPVmes" tabindex="1">
              <option value="1" <cfif LvarCPVmes EQ 1>selected</cfif>>Enero</option>
              <option value="2" <cfif LvarCPVmes EQ 2>selected</cfif>>Febrero</option>
              <option value="3" <cfif LvarCPVmes EQ 3>selected</cfif>>Marzo</option>
              <option value="4" <cfif LvarCPVmes EQ 4>selected</cfif>>Abril</option>
              <option value="5" <cfif LvarCPVmes EQ 5>selected</cfif>>Mayo</option>
              <option value="6" <cfif LvarCPVmes EQ 6>selected</cfif>>Junio</option>
              <option value="7" <cfif LvarCPVmes EQ 7>selected</cfif>>Julio</option>
              <option value="8" <cfif LvarCPVmes EQ 8>selected</cfif>>Agosto</option>
              <option value="9" <cfif LvarCPVmes EQ 9>selected</cfif>>Setiembre</option>
              <option value="10" <cfif LvarCPVmes EQ 10>selected</cfif>>Octubre</option>
              <option value="11" <cfif LvarCPVmes EQ 11>selected</cfif>>Noviembre</option>
              <option value="12" <cfif LvarCPVmes EQ 12>selected</cfif>>Diciembre</option>
            </select>
        Año
        <input name="CPVano" id="CPVano" value="<cfoutput>#rsMesConta.Ano#</cfoutput>" size="4" maxlength="4" tabindex="1">
        <select name="CPVid" id="CPVid" style="display:none" tabindex="1">
            <option value="-1"> ALTA </option>
        </select>
        </td>
	<cfelse>
        <td nowrap align="right"><strong>Vigencia:</strong>&nbsp;</td>
        <td colspan="1" style="width:10%">
          <select name="CPVid" id="CPVid" tabindex="1">
            <cfoutput query="rsVigencia">
              <option value="#CPVid#" <cfif rsMesConta.Ano*100+rsMesConta.Mes GTE CPVdesdeAnoMes AND rsMesConta.Ano*100+rsMesConta.Mes LTE CPVhastaAnoMes>selected</cfif>
					> Desde #dateFormat(CPVdesde,'DD-MM-YYYY')#
              <cfif CPVhastaAnoMes LT 300012>
                hasta #dateFormat(CPVhasta,'DD-MM-YYYY')#
              </cfif>
              </option>
            </cfoutput>
          </select>
        </td>
    </cfif>
    </tr>
	<tr>
		<td align="right"><strong>M&aacute;scara:&nbsp;</strong></td>
		<td colspan="1">
			<select name="PCEMid" id="PCEMid" onChange="javascript: fnCambiaPCEMid(this)" disabled tabindex="1">
				<option value=""> -- Parametros -- </option>
				<option value="0"> -- Propia -- </option>
				<cfoutput query="rsMascaras">
					<option value="#rsMascaras.PCEMid#">
					<cfif PCEMplanCtas EQ 1>
						Con Plan:
					<cfelse>
						Sin Plan:
					</cfif>
				#rsMascaras.PCEMdesc# </option>
			</cfoutput>
		</select>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<!--- ********************************************************************************* --->	
	<tr>
		
		<td colspan="2"><fieldset><legend><strong>Formatos de la Cuenta Mayor:</strong></legend>
			<table>
			
    <tr>
      <td colspan="2"> <!--- <strong>&nbsp;Formatos de la Cuenta Mayor:</strong> --->
          <input name="Cmascara" type="hidden" id="Cmascara" value="">
	  </td>
    </tr>
    <tr>
      <td nowrap align="right"><strong>Financiero:&nbsp;</strong></td>
      <td colspan="1">
        <input  name="CPVformatoF" type="text" id="CPVformatoF" size="50" maxlength="100" value="" style="text-transform:uppercase;" 
			onChange="
				this.value = this.value.replace(new RegExp('-{2,}','g'),'-'); 
				if(this.value.substring(0,1) == '-') this.value=this.value.substring(1); 
				if(this.value.substring(this.value.length-1) == '-') 
					this.value=this.value.substring(0,this.value.length-1); 
				this.value=this.value.toUpperCase(); 
				document.getElementById('FormatoC').value=this.value;
				document.getElementById('Cmascara').value=this.value;
				"
			onKeyPress="var LvarKey = (event.charCode) ? event.charCode : ((event.which) ? event.which : event.keyCode); if (LvarKey != 88 && LvarKey != 120 && LvarKey != 45) return false;"
			tabindex="-1">
      </td>
    </tr>
    <tr>
      <td nowrap align="right"><strong>Contable:&nbsp;</strong></td>
      <td colspan="1"><input name="FormatoC" type="text" id="FormatoC" style="border:0" readonly size="50" maxlength="100" value="" tabindex="-1"></td>
    </tr>
    <tr>
      <td nowrap align="right"><strong>Presupuestario:&nbsp;</strong></td>
      <td colspan="1"><input name="FormatoP" type="text" id="FormatoP" style="border:0" readonly size="50" maxlength="100" value="" tabindex="-1"></td>
    </tr>
    <!---►►►Tipo de Cambio para estados Financieros◄◄◄--->
    <tr>
      <td nowrap align="right"><strong>TC en Conversión de&nbsp;<br />Estados Financieros:&nbsp;</strong></td>
      <td valign="middle">
	  <select name="CTCconversion" id="CTCconversion" tabindex="1" onchange="TCHistorico();">
          <option value="0" <cfif modo NEQ "ALTA" and rsCtasMayor.CTCconversion EQ "0">selected</cfif>>No Aplica</option>
          <option value="1" <cfif modo NEQ "ALTA" and rsCtasMayor.CTCconversion EQ "1">selected</cfif>>Utilizando el tipo de cambio Compra</option>
          <option value="2" <cfif modo NEQ "ALTA" and rsCtasMayor.CTCconversion EQ "2">selected</cfif>>Utilizando el tipo de cambio venta</option>
          <option value="3" <cfif modo NEQ "ALTA" and rsCtasMayor.CTCconversion EQ "3">selected</cfif>>Utilizando el tipo de cambio promedio</option>
          <option value="4" <cfif modo NEQ "ALTA" and rsCtasMayor.CTCconversion EQ "4">selected</cfif>>Tipo de Cambio Hist&oacute;rico</option>
      </select>
      </td>
    </tr>
    
    <tr id="TCHidD" <cfif modo NEQ "ALTA" and rsCtasMayor.CTCconversion NEQ "4">style="visibility:hidden; position:absolute"</cfif>>
      <td nowrap align="right"><strong>Tipo de Cambio&nbsp;<br/>Hist&oacute;rico:&nbsp;</strong></td>
      <td valign="middle">
	  	<select name="TCHid" id="TCHid" tabindex="1">
			<cfif rsTCHistorico.recordcount gt 0>
				<cfoutput query="rsTCHistorico">
                    <option value="#rsTCHistorico.TCHid#" <cfif modo NEQ "ALTA" and rsCtasMayor.CTCconversion EQ "4" and rsCtasMayor.TCHid eq rsTCHistorico.TCHid>selected</cfif>>
                    #rsTCHistorico.TCHdescripcion# 
                    </option>
                </cfoutput>
            <cfelse>
            	<option value="-1">-Sin Tipos de Cambio Historicos-</option>	    
            </cfif>
		</select>
      </td>
    </tr>
  
    <tr>
      <td nowrap align="right"><strong>Revaluar:&nbsp;</strong></td>
      <td valign="middle">
	  <select name="Revaluable" id="Revaluable" tabindex="1">
          <option value="0" <cfif modo NEQ "ALTA" and rsCtasMayor.Crevaluable EQ "0">selected</cfif>>No Aplica</option>
          <option value="1" <cfif modo NEQ "ALTA" and rsCtasMayor.Crevaluable EQ "1">selected</cfif>>Utilizando el tipo de cambio Compra</option>
          <option value="2" <cfif modo NEQ "ALTA" and rsCtasMayor.Crevaluable EQ "2">selected</cfif>>Utilizando el tipo de cambio venta</option>
          <option value="3" <cfif modo NEQ "ALTA" and rsCtasMayor.Crevaluable EQ "3">selected</cfif>>Utilizando el tipo de cambio promedio</option>
      </select>
      </td>
    </tr>
    <tr>
      <cfif MODO EQ "ALTA">
        <!--- <td colspan="1">  
        <td colspan="-2"> --->
          <cfelse>
        <td nowrap align="right"  id="CPVcuentaUtilizada"><strong>Cuenta Mayor posee:</strong></td>
        <td colspan="1" style="color:#FF0000"> 
		<span id="CPVtieneFinancieras"> &nbsp;&nbsp;Cuentas Financieras<br>
          </span> <span id="CPVtieneContables"> &nbsp;&nbsp;Cuentas Contables<br>
          </span> <span id="CPVtienePresupuesto"> &nbsp;&nbsp;Cuentas de Presupuesto<br>
          </span> <span id="CPVtieneReglas"> &nbsp;&nbsp;Reglas por Máscara<br>
        </span> <span id="CPVtieneFormulacion"> &nbsp;&nbsp;Version de Formulación Presupuestaria</span> </td>
      </cfif>
    </tr>
	<!--- ********************************************************************************* --->
			</table></fieldset>
		</td>
	</tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td nowrap="nowrap" colspan="2" align="center" style="width:10%">
	  <cf_botones modo="#modo#" form="form1" tabindex="1">
        <!--- <cfinclude template="../../portlets/pBotones.cfm"> --->
        <!---<cf_sifayuda name="imAyuda" imagen="3" Tip="true" width="500" url="/cfmx/sif/Utiles/sifayudahelp.cfm" tipo="0">--->
      </td>
    </tr>
    <tr>
      <td colspan="2" nowrap="nowrap" align="center" style="width:10%">
        <cfif modo NEQ "ALTA" >
		  <cf_botones form="form1" values="Cuentas_Financieras,Cuentas_Contables,Cuentas_Presupuestarias" functions="CuentasF(document.form1.Cmayor.value);,CuentasC(document.form1.Cmayor.value);,CuentasP(document.form1.Cmayor.value);" tabindex="1">
          <!--- <input name="Financieras" id="Financieras" type="button" value="Cuentas Financieras" onClick="CuentasF(document.form1.Cmayor.value);" tabindex="1">
          <input name="Cuentas" id="Cuentas" type="button" value="Cuentas Contables" onClick="CuentasC(document.form1.Cmayor.value);" tabindex="1">
          <input name="Presupuestarias" id="Presupuestarias" type="button" value="Cuentas Presupuestarias" onClick="CuentasP(document.form1.Cmayor.value);" tabindex="1"> --->
        </cfif>
        <cfset ts = "">
        <cfif modo NEQ "ALTA">
          <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsCtasMayor.ts_rversion#" returnvariable="ts">
          </cfinvoke>
        </cfif>
        <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
      </td>
    </tr>
    <tr>
      <td colspan="2"  nowrap="nowrap" align="center"  style="width:10%">
        <cfif modo NEQ "ALTA">
          <!--- <input name="reglas" id="reglas" type="button" value="Reglas por M&aacute;scara" onClick="ReglasXMascaraC();" tabindex="1"> --->
		  <cf_botones form="form1" values="Reglas_por_Mascara,#Btn_Idioma#" functions="ReglasXMascaraC();,goCatDescIdioma();" tabindex="1">
        </cfif>
  &nbsp; </td>
	</tr>
  </table>
</form>
<script language="JavaScript1.2">document.form1.Cmayor.focus();</script>
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>

<script language="JavaScript" type="text/javascript">
	function changeTipo(ctl) {
		<cfif modo EQ "ALTA">
			// Escoge el balance según el tipo de cuenta
			ctl.form.Cbalancen.selectedIndex = (ctl.value == 'A' || ctl.value == 'G') ? 0 : 1;
			// Si la cuenta es de tipo ingreso o gasto solicita un subtipo para éstas
			var a = document.getElementById("tdSubtipo1");
			var b = document.getElementById("tdSubtipo2");
			var c = document.getElementById("tdSubtipo3");
			if (ctl.value == 'I' || ctl.value == 'G') {
				if (a) a.style.display = ""; 
				if (ctl.value == 'I') {
					if (b) b.style.display = "";
					if (c) c.style.display = "none";
				} else {
					if (b) b.style.display = "none";
					if (c) c.style.display = "";
				}
			} else { 
				if (a) a.style.display = "none";
				if (b) b.style.display = "none";
				if (c) c.style.display = "none";
			}
		</cfif>
	}

	function objCPVid (PCEMid, CPVformatoF, CPVformatoPropio, CPVcuentaUtilizada, 
						CPVtieneFinancieras, CPVtieneContables, CPVtienePresupuesto, 
						CPVtieneReglas, CPVtieneFormulacion)
	{
		this.PCEMid					= PCEMid;
		this.CPVformatoF			= CPVformatoF;
		this.CPVformatoPropio		= CPVformatoPropio;
		this.CPVcuentaUtilizada		= CPVcuentaUtilizada;
		this.CPVtieneFinancieras	= CPVtieneFinancieras;
		this.CPVtieneContables		= CPVtieneContables;
		this.CPVtienePresupuesto	= CPVtienePresupuesto;
		this.CPVtieneReglas			= CPVtieneReglas;
		this.CPVtieneFormulacion	= CPVtieneFormulacion;
	}
	function objPCEMid (formatoF, formatoC, formatoP)
	{
		this.formatoF = formatoF;
		this.formatoC = formatoC;
		this.formatoP = formatoP;
	}
	var LarrCPVid = new Array();
	var LarrPCEMid = new Array();
	
	<cfif MODO EQ "ALTA">
		<cfoutput>
		LarrCPVid[0] = new objCPVid ("-1", "#rsCuentaDefault.Pvalor#", "#rsCuentaDefault.Pvalor#", "0", "");
		</cfoutput>
	<cfelse>
		<cfoutput query="rsVigencia">
			LarrCPVid[#currentRow-1#] = new objCPVid ("#PCEMid#","#CPVformatoF#","#CPVformatoPropio#","<cfif (CPVtieneFinancieras+CPVtieneContables+CPVtienePresupuesto+CPVtieneReglas+CPVtieneFormulacion GT 0)>1</cfif>","<cfif CPVtieneFinancieras GT 0>1</cfif>","<cfif CPVtieneContables GT 0>1</cfif>","<cfif CPVtienePresupuesto GT 0>1</cfif>","<cfif CPVtieneReglas GT 0>1</cfif>","<cfif CPVtieneFormulacion GT 0>1</cfif>");
		</cfoutput>
	</cfif>
	<cfoutput>
	LarrPCEMid[0] = new objPCEMid ("#rsCuentaDefault.Pvalor#","#rsCuentaDefault.Pvalor#","");
	</cfoutput>
	LarrPCEMid[1] = new objPCEMid ("","","");
	<cfoutput query="rsMascaras">
	LarrPCEMid[#currentRow+1#] = new objPCEMid ("#PCEMformato#","#PCEMformatoC#","#PCEMformatoP#");
	</cfoutput> 

	function fnCambiaCPVid(pCPVid){
		var opc = pCPVid.selectedIndex;
		var cboPCEMid = document.getElementById("PCEMid");
		LarrPCEMid[1].formatoF = LarrCPVid[opc].CPVformatoF;
		LarrPCEMid[1].formatoC = LarrCPVid[opc].CPVformatoF;
		LarrPCEMid[1].formatoP = "";
		if (LarrCPVid[opc].PCEMid == "")
			cboPCEMid.selectedIndex = parseInt(LarrCPVid[opc].CPVformatoPropio);
		else
			for (var i=0; i < cboPCEMid.options.length; i++)
				if (cboPCEMid.options[i].value == LarrCPVid[opc].PCEMid)
				{
					cboPCEMid.selectedIndex = i;
					break;
				}

		cboPCEMid.disabled = (LarrCPVid[opc].CPVcuentaUtilizada == "1");
		<cfif MODO NEQ "ALTA">
			document.getElementById("CPVcuentaUtilizada").style.display 	= (LarrCPVid[opc].CPVcuentaUtilizada != "1") ? "none" : "";

			document.getElementById("CPVtieneFinancieras").style.display 	= (LarrCPVid[opc].CPVtieneFinancieras != "1") ? "none" : "";
			document.getElementById("CPVtieneContables").style.display 		= (LarrCPVid[opc].CPVtieneContables != "1") ? "none" : "";
			document.getElementById("CPVtienePresupuesto").style.display 	= (LarrCPVid[opc].CPVtienePresupuesto != "1") ? "none" : "";
			document.getElementById("CPVtieneReglas").style.display 		= (LarrCPVid[opc].CPVtieneReglas != "1") ? "none" : "";
			document.getElementById("CPVtieneFormulacion").style.display 	= (LarrCPVid[opc].CPVtieneFormulacion != "1") ? "none" : "";
			document.getElementById("Ctipo").disabled 						= (LarrCPVid[opc].CPVtienePresupuesto == "1");
		</cfif>
		fnCambiaPCEMid(cboPCEMid);
	}

	function fnCambiaPCEMid(pPCEMid)
	{
		var opc = pPCEMid.selectedIndex;
		pPCEMid.form.Cmascara.value									= LarrPCEMid[opc].formatoF;
		document.getElementById("CPVformatoF").disabled				= (opc != 1 || pPCEMid.disabled);
		document.getElementById("CPVformatoF").value 				= LarrPCEMid[opc].formatoF;
		document.getElementById("FormatoC").value 					= LarrPCEMid[opc].formatoC;
		document.getElementById("FormatoP").value 					= LarrPCEMid[opc].formatoP;
		<cfif MODO NEQ "ALTA">
		document.form1.btnCuentas_Financieras.style.display 		= (opc <= 1) ? "none" : "";
		<!--- document.form1.btnCuentas_Contables.style.display 			= (opc <= 1) ? "none" : ""; --->
		document.form1.btnCuentas_Presupuestarias.style.display 	= (trim(LarrPCEMid[opc].formatoP) == "") ? "none" : "";
		document.form1.btnReglas_por_Mascara.style.display          = (opc <= 1) ? "none" : "";
		</cfif>
	}
	
	//Verifica si un valor es numerico (soporta unn punto para los decimales unicamente)
	function ESNUMERO(aVALOR)
	{
		//var NUMEROS="0123456789."
		var NUMEROS="0123456789"
		var CARACTER=""
		var CONT=0
		//var PUNTO="."
		var VALOR = aVALOR.toString();
		
		for (var i=0; i<VALOR.length; i++)
			{	
			CARACTER =VALOR.substring(i,i+1);
			if (NUMEROS.indexOf(CARACTER)<0) {
				return false;
				} 
			}
		if (CONT>1) {
			return false;
		}
		
		return true;
	}

	function validaNumero(dato) {
		dato = trim(dato);
		document.form1.Cmayor.value = dato;
		var tam = dato.length;
		if (tam > 0) {
			if (ESNUMERO(dato)) {
				if (tam==3) dato = "0"+dato;
				if (tam==2)	dato = "00"+dato;
				if (tam==1)	dato = "000"+dato;
				if (tam==0)	dato = "0000"+dato;
				document.form1.Cmayor.value = dato;				
				return true;
			}		
			else {
				alert('Debe ser numérico.');							
				return false;
			}
		}
		return false;	
	}

	function ReglasXMascaraC() {
		document.form1.PCEMid.disabled = false;
		document.form1.action = "ReglasXMascaraCuenta.cfm";
		document.form1.submit();
	}
	
	function CuentasC(data) {
		if(document.form1.Cmascara.value != ""){
			var vformat = document.form1.Cmascara.value;
			var vTipoMasck = "";			

			for(var i=0; i<vformat.length;i++){
				newstr = vformat.replace("X", "0");
				vformat = newstr;
			}

			<cfif modo NEQ 'ALTA'>
					vTipoMasck = document.form1.PCEMid.value;
			</cfif>			
			
			document.form1.action="CuentasContables.cfm?Cmayor="+
							data+
							"&Formato="+
							vformat+
							"&tipoMascara=" +
							vTipoMasck;
							 
			document.form1.submit();
		}else{
			alert('Error, no se ha seleccionado o digitado el detalle de la máscara');
		}
		
		return false;
	}

	function CuentasF(data) {
		if(document.form1.Cmascara.value != ""){
			var vformat = document.form1.Cmascara.value;
			var vTipoMasck = "";			

			for(var i=0; i<vformat.length;i++){
				newstr = vformat.replace("X", "0");
				vformat = newstr;
			}

			<cfif modo NEQ 'ALTA'>
					vTipoMasck = document.form1.PCEMid.value;
			</cfif>			
			
			document.form1.action="CuentasFinancieras.cfm?Cmayor="+
							data+
							"&Formato="+
							vformat+
							"&tipoMascara=" +
							vTipoMasck;
							 
			document.form1.submit();
		}else{
			alert('Error, no se ha seleccionado o digitado el detalle de la máscara');
		}
		
		return false;
	}

	function CuentasP(data) {
		if(document.form1.Cmascara.value != ""){
			var vformat = document.form1.Cmascara.value;
			var vTipoMasck = "";			

			for(var i=0; i<vformat.length;i++){
				newstr = vformat.replace("X", "0");
				vformat = newstr;
			}

			<cfif modo NEQ 'ALTA'>
					vTipoMasck = document.form1.PCEMid.value;
			</cfif>			
			
			document.form1.action="CuentasPresupuesto.cfm?Cmayor="+
							data+
							"&Formato="+
							vformat+
							"&tipoMascara=" +
							vTipoMasck;
							 
			document.form1.submit();
		}else{
			alert('Error, no se ha seleccionado o digitado el detalle de la máscara');
		}
		
		return false;
	}

	function existeFormatoCuenta(dato) {
		var Existe_formato = false;
		<cfloop query="rs">
			if (dato == "<cfoutput>#rs.Cmayor#</cfoutput>") 
				Existe_formato = true;		
		</cfloop>
		return Existe_formato;
	}
	
	function TCHistorico() {
		var indice = document.form1.CTCconversion.selectedIndex 
   		var valor = document.form1.CTCconversion.options[indice].value 
		if (valor == 4){
			document.getElementById("TCHidD").style.position = "relative";
			document.getElementById("TCHidD").style.visibility = "visible";
		}
		else{
			document.getElementById("TCHidD").style.position = "absolute";
			document.getElementById("TCHidD").style.visibility = "hidden";
		}
	}
	
	//ELIMINA LOS ESPACIOS EN BLANCO DE LA IZQUIERDA DE UN CAMPO
	function ltrim(tira)
	{
		var CARACTER="",HILERA=""
		 if (tira.name)
		   {VALOR=tira.value}
		  else
		   {VALOR=tira}
		 
		HILERA=VALOR
		INICIO = VALOR.lastIndexOf(" ")
		if(INICIO>-1){
		  for (var i=0; i<VALOR.length; i++)
		   { 
			 CARACTER=VALOR.substring(i,i+1);
			 if (CARACTER!=" ")
			 {
			   HILERA = VALOR.substring(i,VALOR.length)
			   i = VALOR.length      
			 }
		  }
		}
		return HILERA
	}
	
	
	function trim(tira)
	{
		return ltrim(rtrim(tira))
	}
	
	//ELIMINA LOS ESPACIOS EN BLANCO DE LA DERECHA DE UN CAMPO 
	function rtrim(tira)
	{
		if (tira.name)
			VALOR=tira.value
		else
			VALOR=tira
		var CARACTER=""
		var HILERA=VALOR
		INICIO = VALOR.lastIndexOf(" ")
		if (INICIO>-1)
		{
			for(var i=VALOR.length; i>0; i--)
			{  
				CARACTER= VALOR.substring(i,i-1)
				if(CARACTER==" ")
					HILERA = VALOR.substring(0,i-1)
				else
					i=-200
			}
		}
		return HILERA
	}

	function valida()
	{
		
		if (!ValTCH()){
			return false;
		}
		
		if (btnSelected("Alta",document.form1)) {	
			if (existeFormatoCuenta(document.form1.Cmayor.value)) {
				alert('Cuenta Mayor ya existe'); 
				
				return false;
			}
			
			if(document.form1.Cmascara.value != ''){
				if(!revisaFormato(document.form1.Cmascara.value))
					return false;
			}
		}

		document.form1.Ctipo.disabled = false;
		document.form1.PCEMid.disabled = false;
		document.form1.CPVformatoF.disabled = false;
		if (validaNumero(document.form1.Cmayor.value)){
			return true;		}
		else
			{
			return false;
			}
	}
//------------------------------------------------------------------------------------------							
	function revisaFormato(cadena){
		var error = false;
		
		if(cadena.length < 5){
			error = true;
		}else{
			if(cadena.substring(0,5) == 'XXXX-'){
				var band = 0;								
				my_array = stringToArray(cadena);
				
				for (i = 5; i < my_array.length; i++){
					if(my_array[i] == 'X' || my_array[i] == '-'){
						if(my_array[i] == '-'){
							if(band == 0){
								band++;
							}else{
								error = true;							
							}
						}
						
						if(my_array[i] == 'X')
							band=0;
					}else{
						error = true;							
					}
				}
				if(my_array[my_array.length-1] == '-'){
					error = true;											
				}
			}else{
				error = true;										
			}
		}
		
		if(error){
			alert("Formato de Máscara '" + cadena + "' inválido. Ejemplo: 'XXXX-XXX-XX-X'");			
			return false;
		}else{
			return true;
		}
	}
//------------------------------------------------------------------------------------------							
	function stringToArray(formato){
		var my_array = new Array();
		for (var i = 0; i < formato.length; i++){
			my_array[i] = formato.substring(i,i+1);
		}

		return my_array;
	}
//------------------------------------------------------------------------------------------							
	function deshabilitarValidacion(){
		objForm.Cmayor.required = false;
		objForm.Cdescripcion.required = false;
		objForm.Cmascara.required= false;
		objForm.CPVformatoF.required= false;
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		objForm.Cmayor.required = true;
		objForm.Cdescripcion.required = true;
		objForm.Cmascara.required= true;
		objForm.CPVformatoF.required= false;
	}	
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");	
//------------------------------------------------------------------------------------------	
	objForm.Cmayor.required = true;
	objForm.Cmayor.description="Cuenta";				
	objForm.Cdescripcion.required= true;
	objForm.Cdescripcion.description="Descripción";
	objForm.CPVformatoF.required= true;
	objForm.CPVformatoF.description="Formato Financiero de la Cuenta";		
	fnCambiaCPVid(document.getElementById("CPVid"));
	changeTipo(document.form1.Ctipo);
//------------------------------------------------------------------------------------------		
function ValTCH() {
	var indice = document.form1.TCHid.selectedIndex;
	var valor = document.form1.TCHid.options[indice].value;
	
	var indice2 = document.form1.CTCconversion.selectedIndex;
	var valor2 = document.form1.CTCconversion.options[indice2].value;
	
	if (valor2 == 4 && valor == -1){
		document.getElementById("TCHid").style.backgroundColor = "#FFFFCC";
		alert ('No existen Tipos de Cambio Historicos, seleccione otro tipo de conversion');
		return false;
	}
	else{
		return true;
	}
}
//------------------------------------------------------------------------------------------
//	function ReglasXMascaraC() {
//		document.form1.PCEMid.disabled = false;
//		document.form1.action = "ReglasXMascaraCuenta.cfm";
//		document.form1.submit();
//	}


function goCatDescIdioma() {
	document.form1.PCEMid.disabled = false;
	document.form1.action = 'CtasMayorIdioma.cfm';
	document.form1.submit();
}
</script>



