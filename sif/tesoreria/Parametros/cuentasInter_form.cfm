<!--- Solo entra en modo cambio --->
<cfset modo = 'CAMBIO'>

<cfif modo NEQ 'ALTA'>

	<!--- Selecciona los datos de la compañía que acaba de incluir --->
	<cfquery datasource="#session.dsn#" name="data">
		select CFmascaraCXC, CFmascaraCXP, ts_rversion
		from  PARcuentasIntercompania
		where Ecodigo =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>

	<!--- Selecciona las compañías hermanas --->
	<cfquery datasource="#session.dsn#" name="rsEmpresas">
		select e.Ecodigo, e.Edescripcion, c.cuentac
		from Empresas e

	            left join PARcomplementoIntercompania c
                        on c.EcodigoComplementar = e.Ecodigo

		    inner join Empresa esdc
                        on esdc.Ecodigo = e.EcodigoSDC
		where esdc.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and e.Ecodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		Order by e.Ecodigo
	</cfquery>
	
</cfif>

<cfoutput>
	<script type="text/javascript">
	<!--
		function validar(formulario)	{
			//if (!btnSelected('Nuevo',document.form1)){
				var error_input;
				var error_msg = '';
				// Validando tabla: Tesoreria - Tesorería
		
				// Columna: TESdescripcion Descripcion Tesoreria varchar(40)
				if (formulario.cfmascaracxc.value == "") {
					error_msg += "\n - La cuenta por cobrar no puede quedar en blanco.";
					error_input = formulario.cfmascaracxc;
				}
	
				// Columna: EcodigoAdm Código Empresa Administradora int
				if (formulario.cfmascaracxp.value == "") {
					error_msg += "\n - La cuenta por pagar no puede quedar en blanco.";
					error_input = formulario.cfmascaracxp;
				}
		
				// Validacion terminada
				if (error_msg.length != "") {
					alert("Por favor revise los siguiente datos:"+error_msg);
					error_input.focus();
					return false;
				}
			//}
			formulario.banmod.value=1
			return true;
		}
	//-->
	</script>
	
	<form action="cuentasInter_sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">

		<table summary="Tabla de entrada" align="center" width=500>
		<tr>
			<td class="tituloListas" colspan=2>
			Registro de Cuentas de Intercompañia
			</td>
		</tr>
		<tr>
			  <td valign="top" align="right">Mascara de la cuenta por cobrar:</td>
			  <td valign="top">
				<input name="cfmascaracxc" id="cfmascaracxc" type="text" value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.CFMascaraCXC)#</cfif>" 
					maxlength="40"
					size="40"
					onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td>
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#data.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</td>
		</tr>
		<tr>
			  <td valign="top" align="right">Mascara de la cuenta por pagar:</td>
			  <td valign="top">
			
				<input name="cfmascaracxp" id="cfmascaracxp" type="text" value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.CFMascaraCXP)#</cfif>" 
					maxlength="40"
					size="40"
					onfocus="this.select()"  >
			
			</td>
		</tr>
		<tr><td colspan=2>&nbsp;</td></tr>
		<tr>
			<td colspan=2>

				<table border=0 align="center" class="filtro" width=100% cellspacing=0 cellsppading=0>
				<tr>
					<td class="tituloListas">Empresa</td>
					<td class="tituloListas" style="width:20px">Complemento</td>
				</tr>
				<!--- Listado de las compañias hermanas --->
				<cfloop query="rsEmpresas">
				<tr> 					
					<td>#Edescripcion#</td>
					<td>
					     <input name="complemento_#Ecodigo#" id="complemento_#Ecodigo#" type="text" value="<cfif modo NEQ 'ALTA'>#cuentac#</cfif>" size="40">
					     <input name="lstempresas" id="lstempresas" type="hidden" value="#Ecodigo#">
					</td>
				</tr>
				</cfloop>
				<!--- Listado de las compañias hermanas --->
				</table>

			</td>
		</tr>
		<tr>
			<td colspan="2" class="formButtons" align="center">
				<cfif modo NEQ 'ALTA'>
					<input type="hidden" name="banmod" value=0>					
					<input type="hidden" name="modo" value='CAMBIO'>
					<input type="submit" name="mod" value='Modificar' style="width:100px">
					<!--- <cf_botones modo='CAMBIO'> --->
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
		</table>

		<!---
		<cfif modo NEQ 'ALTA'>
					
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
		</cfif>
		--->

	</form>
</cfoutput>