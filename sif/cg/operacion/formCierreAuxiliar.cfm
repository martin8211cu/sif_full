<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ProcCierre" default="Desea procesar el cierre de mes de auxiliares para la empresa" returnvariable="LB_ProcCierre" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoA" default="Per&iacute;odo Auxiliar" 
returnvariable="LB_PeriodoA" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MesA" default="Mes Auxiliar" 
returnvariable="LB_MesA" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" 
returnvariable="LB_Moneda" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Compra" default="Compra" 
returnvariable="LB_Compra" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Venta" default="Venta" 
returnvariable="LB_Venta" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Promedio" default="Promedio" 
returnvariable="LB_Promedio" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_TipoCH" default="Tipo de Cambio Hist&oacute;rico" 
returnvariable="BTN_TipoCH" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_ProcCierreA" default="Procesar Cierre de Auxiliares" 
returnvariable="BTN_ProcCierreA" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ProcesoExitoso" default="Cierre de Mes de Auxiliares Procesado con Exito" returnvariable="MSG_ProcesoExitoso" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_Seguro" default="Está seguro de efectuar el cierre de auxiliares" returnvariable="MSG_Seguro" xmlfile="formCierreAuxiliar.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_SinTC" default="No hay monedas sin tipo de cambio"
 returnvariable="MSG_SinTC" xmlfile="formCierreAuxiliar.xml"/>
 <cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_TCinvalido" default="Tipo de cambio inválido, digite un tipo de cambio válido para continuar"  returnvariable="MSG_TCinvalido" xmlfile="formCierreAuxiliar.xml"/>
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
    <cfelseif #Form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
    <cfelse>
		<cfset modo="ALTA">
    </cfif>
</cfif>

<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion, Mcodigo from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfinclude template="Funciones.cfm">
<cfset periodo = get_val(50).Pvalor >
<cfset mes = get_val(60).Pvalor >

<!---
<cfquery datasource="#Session.DSN#" name="rsTipoCambio">
	select distinct Mcodigo
	from Documentos
	
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Dsaldo <> 0
	and Mcodigo!=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Mcodigo#">
	
	union
	
	select distinct Mcodigo
	from  EDocumentosCP
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Mcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Mcodigo#">
	
	union 
	
	select distinct Mcodigo
	from CuentasBancos
		
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	
	  and Mcodigo!=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Mcodigo#">
</cfquery>
--->

<cfset monedas = '' >

<cfset LvarTodasLasMonedas = true>
<cfif LvarTodasLasMonedas>
	<cfquery datasource="#Session.DSN#" name="rsMonedasCC">
		select distinct Mcodigo
		  from Monedas
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and Mcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Mcodigo#">
	</cfquery>
	<cfif rsMonedasCC.recordCount gt 0 >
		<cfset monedas = ValueList(rsMonedasCC.Mcodigo) >
	</cfif>
<cfelse>
	<cfquery datasource="#Session.DSN#" name="rsMonedasCC">
		select distinct Mcodigo
		  from Documentos
		 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and Dsaldo <> 0
		   and Mcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Mcodigo#">
		  <cfif len(trim(monedas))>
			  and Mcodigo not in (#monedas#)
		  </cfif>
	</cfquery>
	<cfif rsMonedasCC.recordCount gt 0 >
		<cfset monedas = ValueList(rsMonedasCC.Mcodigo) >
	</cfif>
	
	<cfquery datasource="#Session.DSN#" name="rsMonedasCP">
		select distinct Mcodigo
		from  EDocumentosCP
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Mcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Mcodigo#">
		  <cfif len(trim(monedas))>
			  and Mcodigo not in (#monedas#)
		  </cfif>
	</cfquery>
	<cfif rsMonedasCP.recordCount gt 0 >
		<cfif len(trim(monedas))>
			<cfset monedas = monedas & ',' & ValueList(rsMonedasCP.Mcodigo) >
		<cfelse>
			<cfset monedas = ValueList(rsMonedasCP.Mcodigo) >
		</cfif>
	</cfif>
	
	<cfquery datasource="#Session.DSN#" name="rsMonedasBancos">
		select distinct Mcodigo
		from CuentasBancos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
          and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		  and Mcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Mcodigo#">
		  <cfif len(trim(monedas))>
			  and Mcodigo not in (#monedas#)
		  </cfif>
	</cfquery>
	<cfif rsMonedasBancos.recordCount gt 0 >
		<cfif len(trim(monedas))>
			<cfset monedas = monedas & ',' & ValueList(rsMonedasBancos.Mcodigo) >
		<cfelse>
			<cfset monedas = ValueList(rsMonedasBancos.Mcodigo) >
		</cfif>
	</cfif>
</cfif>

<cfset cuenta = ListLen(monedas,',')  >

<cfif len(trim(monedas))>
	<cfquery name="rsMonedas" datasource="#session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Mcodigo in (#monedas#)
	</cfquery>
<cfelse>
	<cfset rsMonedas = QueryNew('Mcodigo,Mnombre')>
</cfif>


<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script> 
<script language="JavaScript" type="text/javascript">
	function Valida(obj){
		if (new Number(obj.count.value) != 0){
			if (new Number(obj.count.value) == 1){
				
				if(new Number(obj.TC.value) <= 0){
					alert("<cfoutput>#MSG_TCinvalido#</cfoutput>!");
					obj.TC.focus();
					return false     
				}
				
				if (confirm('<cfoutput>#MSG_Seguro#</cfoutput>?')){
					obj.TC.value = qf(obj.TC.value);
					return true
				}     
				else{
					return false   
				}
			}
			else{
				var num=new Number(obj.count.value);
				for(var i=0; i < num; i++){
					if(new Number(obj.TC[i].value) <= 0){
						alert("<cfoutput>#MSG_TCinvalido#</cfoutput>!");
						obj.TC[i].focus();
						return false     
					}
				}  
			
				if (confirm('<cfoutput>#MSG_Seguro#</cfoutput>?')){
					for(var i=0; i < num; i++){
						obj.TC[i].value = qf(obj.TC[i].value);
					}

					return true
				}     
				else{
					return false   
				}
			}
		}
		else{
			if (confirm('<cfoutput>#MSG_Seguro#</cfoutput>?')){
				return true
			}     
			else{
				return false   
			}
		}
	}
</script>
<form method="post" name="form1" onSubmit="return Valida(this);" action="SQLCierreAuxiliar.cfm">
	<input type="hidden" name="count" value="<cfoutput>#cuenta#</cfoutput>" />
	<table border="0" cellpadding="2" cellspacing="0" width="90%">
		<tr>
			<td width="40%" align="right" style="padding-right: 20px" nowrap>
				<b><cfoutput>#LB_PeriodoA#</cfoutput></b>			</td>
			<td align="left" style="padding-right: 10px">
				<cfoutput>#periodo#</cfoutput>
				<input type="hidden" name="anno" value="<cfoutput>#periodo#</cfoutput>" />			</td>
			<td align="right" style="padding-left: 10px; padding-right: 20px" nowrap>
				<b><cfoutput>#LB_MesA#</cfoutput></b>			</td>
			<td align="left">
				<cfoutput>#mes#</cfoutput>
				<input type="hidden" name="mes" value="<cfoutput>#mes#</cfoutput>" />			</td>
			<td width="20%" align="left">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="5">&nbsp;			</td>
		</tr>
		<cfif cuenta EQ 0>
			<tr>
				<td colspan="5" align="center">
					<b><cfoutput>#MSG_SinTC#</cfoutput>!</b>				</td>
			</tr>
			<tr>
				<td colspan="5">&nbsp;				</td>
			</tr>
		<cfelse>
			<tr><cfoutput>
				<td colspan="1" align="right" style="padding-right: 20px">
					<strong>#LB_Moneda#</strong>				
				</td>
				<td colspan="1" align="right" >
					<strong>#LB_Compra#</strong>				
				</td>
				<td colspan="1" align="right" >
					<strong>#LB_Venta#</strong>				
				</td>
				<td colspan="1" align="right" >
					<strong>#LB_Promedio#</strong>				
				</td>
				<td>&nbsp;
					</cfoutput>
				</td>
			</tr>		
			<cfoutput query="rsMonedas">
				<cfif rsMonedas.Mcodigo neq rsEmpresa.Mcodigo>
					<cfquery name="rsTipoCambio" datasource="#session.DSN#">
						select TCEtipocambio,TCEtipocambioventa,TCEtipocambioprom
						from TipoCambioEmpresa 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
						  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
						  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
					</cfquery>

				
					<tr>
						<td colspan="1" align="right" style="padding-right: 20px">
							#rsMonedas.Mnombre#
							<input type="hidden" name="MON" value="#rsMonedas.Mcodigo#" />
						</td>
						<td colspan="1" align="left" >
							<input type="text" name="TC" value="<cfif rsTipoCambio.recordCount gt 0 and len(trim(rsTipoCambio.TCEtipocambio))>#LSNumberFormat(rsTipoCambio.TCEtipocambio,',9.00')#<cfelse>0.0000</cfif>" size="20" maxlength="20" style="text-align: right;" onblur="javascript:fm(this,4);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" /></td>
						<td colspan="1" align="left" >
							<input type="text" name="TCcambioventa" value="<cfif rsTipoCambio.recordCount gt 0 and len(trim(rsTipoCambio.TCEtipocambioventa))>#LSNumberFormat(rsTipoCambio.TCEtipocambioventa,',9.00')#<cfelse>0.0000</cfif>" size="20" maxlength="20" style="text-align: right;" onblur="javascript:fm(this,4);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}">						</td>
						<td colspan="1" align="left" >
							<input type="text" name="TCcambioprom" value="<cfif rsTipoCambio.recordCount gt 0 and len(trim(rsTipoCambio.TCEtipocambioprom))>#LSNumberFormat(rsTipoCambio.TCEtipocambioprom,',9.00')#<cfelse>0.0000</cfif>" size="20" maxlength="20" style="text-align: right;" onblur="javascript:fm(this,4);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}">						</td>
					</tr>
				</cfif>
			</cfoutput>
			<tr>
				<td colspan="5">&nbsp;				</td>
			</tr>
		</cfif>
		<tr>
			<td align="center" colspan="5">
				<cfif isdefined("Form.showMessage")>
					<script language="JavaScript" type="text/javascript">
						alert("#MSG_ProcesoExitoso#!");
					</script>
				</cfif>
                <cfoutput>#LB_ProcCierre#</cfoutput>
				 <b><cfoutput query="rsEmpresa">#rsEmpresa.Edescripcion#</cfoutput></b>?			</td>
		</tr>
		<tr>
			<td align="center" colspan="5">
				<br/><cfoutput>
				<input type="button" name="btnTCH" value="#BTN_TipoCH#" onclick="location.href='SQLCierreAuxiliar.cfm?btnTCH';" />
				<input type="submit" name="btnCierre" value="#BTN_ProcCierreA#" />	</cfoutput>		
		</td>
		</tr>
	</table>
</form>
