<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CuentasPorExcepcionPorTransaccionesDeCxC" default = "Cuentas por excepci&oacute;n por Transacciones de CxC" returnvariable="LB_CuentasPorExcepcionPorTransaccionesDeCxC" xmlfile = "SocioCuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CuentasPorExcepcionPorTransaccionesDeCxP" default = "Cuentas por excepci&oacute;n por Transacciones de CxP" returnvariable="LB_CuentasPorExcepcionPorTransaccionesDeCxP" xmlfile = "SocioCuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Transaccion" default = "Transacci&oacute;n" returnvariable="LB_Transaccion" xmlfile = "SocioCuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CuentaFinanciera" default = "Cuenta Financiera" returnvariable="LB_CuentaFinanciera" xmlfile = "SocioCuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_NoHayCuentasPorExcepcion" default = "No hay cuentas por excepcion" returnvariable="MSG_NoHayCuentasPorExcepcion" xmlfile = "SocioCuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Agregar" default = "Agregar" returnvariable="BTN_Agregar" xmlfile = "SocioCuentas.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Cuenta" default = "Cuenta" returnvariable="LB_Cuenta" xmlfile = "SocioCuentas.xml">

<cfparam name="LvarCxC" default="true">
<cfif LvarCxC>
	<cfset LvarTipoT = "CC">
	<cfset LvarTituloT = "#LB_CuentasPorExcepcionPorTransaccionesDeCxC#">
<cfelse>
	<cfset LvarTipoT = "CP">
	<cfset LvarTituloT = "#LB_CuentasPorExcepcionPorTransaccionesDeCxP#">
</cfif>
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfif LvarCxC>
		<cfquery name="rsTransacciones" datasource="#Session.DSN#">
		<!---
			los parentesis en el segundo case se
			requieren por el driver de jdbc de sybase
			--->
			select 
					CCTcodigo as Tcodigo, 
					{fn concat ({fn concat (
					rtrim(CCTdescripcion) 
						, (case when CCTtipo='D' then ' (DB)' else ' (CR)' end) )}
						, (case when CCTvencim < 0 then ' (Contado)' else ' ' end ) )}
					as Tdescripcion
			  from CCTransacciones t
			 where Ecodigo   = #session.Ecodigo#
			   and CCTpago <> 1
			   and not exists
			   	(
					select 1
					  from SNCCTcuentas stc
					 where stc.Ecodigo   	= #session.Ecodigo#
					   and stc.SNcodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >
					   and stc.CCTcodigo 	= t.CCTcodigo
				)
		</cfquery>
		<cfquery name="rsSNTcuentas" datasource="#Session.DSN#">
			select 
				t.CCTcodigo			as Tcodigo, 
				{fn concat (rtrim(t.CCTdescripcion) , case when t.CCTtipo='D' then ' (DB)' else ' (CR)' end )} as Tdescripcion, 
				c.CFcuenta			as CFcuenta, 
				c.CFdescripcion		as CFdescripcion, 
				c.CFformato			as CFformato
			  from SNCCTcuentas stc
				inner join CCTransacciones t
					 on t.Ecodigo   = stc.Ecodigo
					and t.CCTcodigo = stc.CCTcodigo
				inner join CFinanciera c
					 on c.CFcuenta = stc.CFcuenta
					and c.Ecodigo  = stc.Ecodigo
			 where stc.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and stc.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
		</cfquery>	
	<cfelse>
		<cfquery name="rsTransacciones" datasource="#Session.DSN#">
			select CPTcodigo as Tcodigo, 
				{fn concat ( rtrim(CPTdescripcion) ,  case when CPTtipo='D' then ' (DB)' else ' (CR)' end )} as Tdescripcion
			  from CPTransacciones t
			 where Ecodigo   = #session.Ecodigo#
			   and CPTpago <> 1
			   and not exists
			   	(
					select 1
					  from SNCPTcuentas stc
					 where stc.Ecodigo   = #session.Ecodigo#
					   and stc.SNcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >
					   and stc.CPTcodigo = t.CPTcodigo
				)
		</cfquery>
		<cfquery name="rsSNTcuentas" datasource="#Session.DSN#">
			select 
				t.CPTcodigo			as Tcodigo, 
				{fn concat (rtrim(t.CPTdescripcion) , case when t.CPTtipo='D' then ' (DB)' else ' (CR)' end )} as Tdescripcion, 
				c.CFcuenta			as CFcuenta, 
				c.CFdescripcion		as CFdescripcion, 
				c.CFformato			as CFformato
			  from SNCPTcuentas stc
				inner join CPTransacciones t
					 on t.Ecodigo   = stc.Ecodigo
					and t.CPTcodigo = stc.CPTcodigo
				inner join CFinanciera c
					 on c.CFcuenta = stc.CFcuenta
					and c.Ecodigo  = stc.Ecodigo
			 where stc.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and stc.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
		</cfquery>	
	</cfif>
</cfif>

<cfoutput>
<fieldset style="border:1px solid ##CCCCCC"><legend><strong><cfoutput>#LvarTituloT#</cfoutput></strong></legend>
<table width="400" border="0" align="center" cellpadding="0" cellspacing="0" >

	<tr>
		<td width="39">&nbsp;</td><td width="357">&nbsp;</td><td width="4">&nbsp;</td>
	</tr>

	<tr>
	  <td nowrap align="right" >&nbsp;</td>
	  <td nowrap><cfoutput>#LB_Transaccion#&nbsp;</cfoutput>#LvarTipoT#</td>
	  <td>&nbsp;</td>
	</tr>

	<tr> 
		<td nowrap align="right" >&nbsp;</td>
		<td nowrap> 
			<select name="#LvarTipoT#Tcodigo" id="#LvarTipoT#Tcodigo">
				<cfloop query="rsTransacciones">
				<option value="#rsTransacciones.Tcodigo#">#rsTransacciones.Tcodigo# - #rsTransacciones.Tdescripcion#</option>
				</cfloop>
			</select>
			&nbsp;
			
		<cfif LvarCxC>
			<input type="submit" name="btnAgregar#LvarTipoT#T" value="#BTN_Agregar#" class="btnGuardar" onClick="MM_validateForm('#LvarTipoT#Tcodigo','','R','CFcuenta#LvarTipoT#T','','R');return document.MM_returnValue;">
		<cfelse>
			<input type="submit" name="btnAgregar#LvarTipoT#T" value="#BTN_Agregar#" class="btnGuardar" onClick="MM_validateForm('#LvarTipoT#Tcodigo','','R','CFcuenta#LvarTipoT#T','','R');return document.MM_returnValue;">
		</cfif>
			
		</td>
		<td>&nbsp;</td>
	</tr>

	<tr>
	  <td nowrap align="right" >&nbsp;</td>
	  <td nowrap colspan="2"><cfoutput>#LB_CuentaFinanciera#</cfoutput></td>
	</tr>
	
	<tr> 
		<td nowrap align="right" >&nbsp;</td>
		<td nowrap> 
			<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form3"
				frame="frame#LvarTipoT#T" Ccuenta="Ccuenta#LvarTipoT#T" CFcuenta="CFcuenta#LvarTipoT#T" Cdescripcion="Cdescripcion#LvarTipoT#T" Cformato="Cformato#LvarTipoT#T"
			>
		</td>
		<td>&nbsp;</td>
	</tr>

	<tr>
		<td nowrap colspan="2">&nbsp;</td><td>&nbsp;</td>
	</tr>

	<tr>
		<td colspan="2">
			<!--- Lista de cuentas del socio --->
			<table width="85%" border="0" align="center" cellpadding="0" cellspacing="0" id="lista1">
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfif rsSNTcuentas.RecordCount eq 0>
				<tr>
					<td class="tituloListas" colspan="2" align="center">
						<cfoutput>#MSG_NoHayCuentasPorExcepcion#</cfoutput>
					</td>
				</tr>
	<cfelse>
				<tr class="tituloListas">
					<td nowrap>&nbsp;</td>
					<td nowrap><strong>#LB_Transaccion#</strong></td>
					<td nowrap><strong>#LB_Cuenta#</strong></td>
				</tr>

					<cfloop query="rsSNTcuentas">
						<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
							<td nowrap>
								<input  name="btnBorrar" type="image" alt="Eliminar elemento" onClick="javascript: sbBorrar#LvarTipoT#T('#Tcodigo#'); return false;" src="../../imagenes/Borrar01_T.gif" width="16" height="16">
							</td>
							<td nowrap>#Tcodigo# - #Tdescripcion#</td>
							<td nowrap title="#CFdescripcion#">#CFformato#</td>
						</tr>
					</cfloop>
	</cfif>
</cfif>
				<tr><td>&nbsp;</td></tr>	
			</table>
		</td>
 		<td>&nbsp;</td>
	</tr>
</table>
</fieldset>

<script language="javascript" type="text/javascript">
<cfif modo neq 'ALTA'>
	var ff = document.form3;
		function sbBorrar#LvarTipoT#T(data) {
			location.href="SociosIContable-sql.cfm?btnBorrar#LvarTipoT#T=1&SNcodigo=#form.SNcodigo#&#LvarTipoT#Tcodigo=" + data;
		}
		document.form3.#LvarTipoT#Tcodigo.alt = "El campo Transacción";
		document.form3.CFcuenta#LvarTipoT#T.alt = "El campo Cuenta";
</cfif>
</script>

</cfoutput>