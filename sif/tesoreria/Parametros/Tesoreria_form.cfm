<cfparam name="form.TESid" default="">

<cfif isdefined('form.TESid') and len(trim(form.TESid))>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select TESid,TEScodigo,TESdescripcion,CEcodigo,EcodigoAdm,t.BMUsucodigo,t.ts_rversion,Edescripcion as empAdmin,me.Miso4217
			,CPNAPnum
		from Tesoreria t
			inner join Empresas e
				inner join Monedas me
					on me.Mcodigo = e.Mcodigo
				on e.Ecodigo=t.EcodigoAdm
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
	</cfquery>
	
 	<cfquery datasource="#session.dsn#" name="rsEmpresas">
		Select e.Ecodigo,e.Edescripcion,esdc.CEcodigo,te.TESid,me.Miso4217
		  from Empresas e
			inner join Empresa esdc
				on esdc.Ecodigo=e.EcodigoSDC
			inner join Monedas me
				on me.Mcodigo=e.Mcodigo
			left outer join TESempresas te
				on te.Ecodigo=e.Ecodigo
		 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
 		order by Edescripcion
 	</cfquery>
</cfif>


<cfoutput>
	<script type="text/javascript">
	<!--
		function validar(formulario)	{
			if (!btnSelected('Nuevo',document.form1)){
				var error_input;
				var error_msg = '';
				// Validando tabla: Tesoreria - Tesorería
		
				// Columna: TESdescripcion Descripcion Tesoreria varchar(40)
				if (formulario.TESdescripcion.value == "") {
					error_msg += "\n - Descripcion Tesoreria no puede quedar en blanco.";
					error_input = formulario.TESdescripcion;
				}
	
				// Columna: EcodigoAdm Código Empresa Administradora int
				if (formulario.TEScodigo.value == "") {
					error_msg += "\n - Código de la Tesoreria no puede quedar en blanco.";
					error_input = formulario.TEScodigo;
				}
		
				// Validacion terminada
				if (error_msg.length != "") {
					alert("Por favor revise los siguiente datos:"+error_msg);
					error_input.focus();
					return false;
				}
			}

			return true;
		}
	//-->
	</script>
	<form action="Tesoreria_sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
		<table summary="Tabla de entrada" border="0" cellpadding="0" cellspacing="0">
			<tr>
			  <td colspan="2">&nbsp;</td>
			</tr>		
			<tr>
			  <td valign="top" align="right"><strong>C&oacute;digo:</strong></td>
			  <td valign="top">
			 	 &nbsp;&nbsp;
			  	<input name="TEScodigo" id="TEScodigo" type="text" value="<cfif modo NEQ "ALTA">#data.TEScodigo#</cfif>" size="4" maxlength="4" onFocus="javascript: this.select();"  >
			</td></tr>
			<tr>
			  <td valign="top" align="right"><strong>Descripcion:</strong></td>
			  <td valign="top">
				&nbsp;&nbsp;
				<input name="TESdescripcion" id="TESdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.TESdescripcion)#</cfif>" 
					maxlength="40"
					size="40"
					onfocus="this.select()"  >
			
			</td></tr>
			<cfif modo NEQ 'ALTA'>
				<tr>
					<td valign="top" align="right"><strong>Empresa Administradora:</strong></td>
					<td valign="top">
						&nbsp;&nbsp;&nbsp;<strong>#data.empAdmin#</strong>  	
					</td>
				</tr>
				<tr>
					<td valign="top" align="right"><strong>Moneda Local:</strong></td>
					<td valign="top">
						&nbsp;&nbsp;&nbsp;<strong>#data.Miso4217#</strong>  	
					</td>
				</tr>
				<tr>
					<td valign="top" align="right"><strong>NAP de Provisión:</strong></td>
					<td valign="top">
					  	&nbsp;&nbsp;&nbsp;<input name="CPNAPnum" id="CPNAPnum" type="text" value="<cfif modo NEQ "ALTA">#data.CPNAPnum#</cfif>" size="4" maxlength="4" onFocus="javascript: this.select();"  >
					</td>
				</tr>
			</cfif>
			<tr>
			  	<td colspan="2">&nbsp;</td>
			</tr>			
			<tr>
			<td colspan="2">
				<cfif modo NEQ 'ALTA'>
					<input type="hidden" name="TESid" value="#HTMLEditFormat(data.TESid)#">
					<input type="hidden" name="TEScodigoOrig" value="#data.TEScodigo#">
					<input type="hidden" name="CEcodigo" value="#HTMLEditFormat(data.CEcodigo)#">
					<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
					
					<cfset ts = "">
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
						artimestamp="#data.ts_rversion#" returnvariable="ts">
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="#ts#">
				</cfif>
			</td>
		</tr>
		<tr><td colspan="2" class="formButtons">
			<cfif modo NEQ 'ALTA'>
				<cfif data.EcodigoAdm EQ session.Ecodigo>
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones exclude='Cambio,Baja' modo='CAMBIO'>
				</cfif>
			<cfelse>
				<cf_botones modo='ALTA'>
			</cfif>
		</td></tr>
		</table>
	</form>
</cfoutput>

<cfif modo NEQ 'ALTA'>
	<cf_navegacion name="tab" default="1" session="tabs" navegacion>

	<cf_tabs width="99%" onclick="fnCambioTab">
		<cf_tab text="Empresas" selected="#form.tab EQ 1#" id=1>
			<cfinclude template="Tesoreria_Empresas.cfm">
		</cf_tab>
		<cf_tab text="Centros Funcionales" selected="#form.tab EQ 2#" id=2>
			<cfinclude template="Tesoreria_CFuncionales.cfm">
		</cf_tab>
	</cf_tabs>
	<iframe name="ifr_tab_" id="ifr_tab_" width="0" height="0">
	</iframe>
	<script language="javascript">
		function fnCambioTab(tab_id)
		{
			tab_set_current (tab_id);
			if (tab_id != 0)
				document.getElementById("ifr_tab_").src = "/cfmx/sif/Utiles/tabid.cfm?tabidname=tab&tabid=" + tab_id;
			else
				document.getElementById("ifr_tab_").src = "/cfmx/sif/Utiles/tabid.cfm?tabidname=tab&tabid=1";
		}
	</script>
</cfif>

