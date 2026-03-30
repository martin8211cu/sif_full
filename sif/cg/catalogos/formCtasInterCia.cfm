<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegación del form por tabs para que tenga un orden lógico.
 --->

<!----Conceptos contables---->
<cfquery name="rsConceptos" datasource="#session.DSN#">
	select Ecodigo, Cconcepto, Cdescripcion
	from ConceptoContableE
</cfquery>
<!----Oficinas---->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Oficodigo, Odescripcion
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
</cfquery>
<!----Empresas de la corporacion(Todas las empresas de la corporacion (session.CEcodigo) exepto la en la que se esta)---->
<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select a.Ecodigo,a.Edescripcion
	from Empresas a 
	where a.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value = "#session.CEcodigo#">
		and a.Ecodigo != <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
</cfquery>

<cfoutput>
	<cfset modo='ALTA'>
	<cfif isdefined("form.Ecodigodest") and len(trim(form.Ecodigodest))>
		<cfset modo = 'CAMBIO'> 
	</cfif>
	<cfif modo NEQ 'ALTA'>		
		<cfquery name="rsdata" datasource="#session.DSN#">
			select Cconceptodest, Ecodigodest, Ocodigo, CFcuentacxp, CFcuentacxc, ts_rversion
			from CIntercompany
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#">
				and Ecodigodest = <cfqueryparam cfsqltype="cf_sql_integer" value = "#form.Ecodigodest#">
		</cfquery>
	</cfif>

	<form name="form1" method="post" action="SQLCtasInterCia.cfm" onSubmit="javascritp: return funcValidar()">
		<input type="hidden" tabindex="-1" name="Ecodigodest2" value="<cfif modo NEQ 'ALTA'>#rsdata.Ecodigodest#</cfif>">
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
		<table width="100%" border="0">
			<tr>
				<td align="right" nowrap><strong>Oficina:&nbsp;</strong> </td>	
				<td>
					<select name="Ocodigo" id="Ocodigo" tabindex="1">
						<cfloop query="rsOficinas">
							<option value="#rsOficinas.Ocodigo#" <cfif modo NEQ 'ALTA' and rsOficinas.Ocodigo EQ rsdata.Ocodigo>selected</cfif>>#HTMLEditFormat(rsOficinas.Oficodigo)# - #HTMLEditFormat(rsOficinas.Odescripcion)#</option>
						</cfloop>
					</select>
				</td>	
			</tr>		
			<tr>
				<td align="right" nowrap><strong>Cuenta por Cobrar:&nbsp;</strong> </td>	
				<td>
					<cfif modo NEQ 'ALTA'>
						<cfquery name="rsCuenta" datasource="#session.DSN#">
							select b.Ccuenta, b.Cdescripcion, b.Cformato, a.CFcuentacxc
							from CIntercompany a
								inner join CContables b
									on a.Ecodigo = b.Ecodigo
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and  a.CFcuentacxc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CFcuentacxc#">
						</cfquery>	
						<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxc" CFcuenta="CFcuentacxc" query="#rsCuenta#" tabindex="1">
					<cfelse>
						<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxc" CFcuenta="CFcuentacxc" tabindex="1"> 
					</cfif>
				</td>	
			</tr>		
			<tr>
				<td align="right" nowrap><strong>Cuenta por Pagar:&nbsp;</strong> </td>	
				<td>
					<cfif modo NEQ 'ALTA'>
						<cfquery name="rsCuenta" datasource="#session.DSN#">
							select b.Ccuenta, b.Cdescripcion, b.Cformato, a.CFcuentacxp
							from  CIntercompany a
								inner join CContables b
									on a.Ecodigo = b.Ecodigo
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.CFcuentacxp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CFcuentacxp#">
						</cfquery>	
						<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxp" CFcuenta="CFcuentacxp" query="#rsCuenta#" tabindex="2">
					<cfelse>
						<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxp" CFcuenta="CFcuentacxp" tabindex="2"> 
					</cfif>
				</td>	
			</tr>			
			<tr>
				<td align="right" nowrap><strong>Empresa Destino:&nbsp;</strong> </td>	
				<td>					
					<select name="Ecodigodest" id="Ecodigodest" onChange="javascript: CambiarConcepto();" tabindex="3">
						<cfloop query="rsEmpresas">
							<option value="#rsEmpresas.Ecodigo#" <cfif modo NEQ 'ALTA' and rsEmpresas.Ecodigo EQ rsdata.Ecodigodest>selected</cfif>>#HTMLEditFormat(rsEmpresas.Edescripcion)#</option>
						</cfloop>
					</select>
				</td>	
			</tr>		
			<tr>
				<td  width="31%" align="right" nowrap><strong>Concepto Contable Destino:&nbsp;</strong></td>	
				<td>					
					<select name="Cconceptodest" id="Cconceptodest" tabindex="3">
					</select>
				</td>	
			</tr>
			<tr>
				<td colspan="2" align="center">
					<!--- <cfset tabindex=3>	
					<cfinclude template="../../portlets/pBotones.cfm"> --->
					<cf_botones modo="#modo#" tabindex="3">
				</td>	
		   </tr>
	</table>
	<cfif modo NEQ "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsdata.ts_rversion#" returnvariable="ts">
		</cfinvoke>
         <input type="hidden" name = "ts_rversion" value ="#ts#">		
	</cfif>
</form> 
<script language="JavaScript1.2" type="text/javascript">
	function CambiarConcepto(){
		var oCombo   = document.form1.Cconceptodest;
		var EcodigoI = document.form1.Ecodigodest.value;
		var cont = 0;
		oCombo.length=0;
		<cfloop query="rsConceptos">
		if ('#Trim(rsConceptos.Ecodigo)#' == EcodigoI ){
			oCombo.length=cont+1;
			oCombo.options[cont].value='#Trim(rsConceptos.Cconcepto)#';
			oCombo.options[cont].text='#Trim(rsConceptos.Cdescripcion)#';
			<cfif isdefined("rsdata") and rsdata.Cconceptodest eq rsConceptos.Cconcepto>
				oCombo.options[cont].selected = true;
			</cfif>
		cont++;
		};
		</cfloop>
	}


	function funcValidar(){
		if (document.form1.Ccuentacxc.value == ''){
			alert("Debe seleccionar una cuenta por cobrar");
			return false
		}
		if (document.form1.Ccuentacxp.value == ''){
			alert("Debe seleccionar una cuenta por pagar");
			return false
		}
		if (document.form1.Ecodigodest.value == ''){
		alert("Debe seleccionar una Empresa Destino");
		return false
		}
		if (document.form1.Cconceptodest.value == ''){
		alert("Debe seleccionar un Concepto Contable Destino");
		return false
		}	
		return true
	}	
	
	CambiarConcepto();
	document.form1.Ocodigo.focus();
</script>
</cfoutput>
			


