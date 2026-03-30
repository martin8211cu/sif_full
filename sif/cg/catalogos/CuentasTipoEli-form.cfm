<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegación del form por tabs para que tenga un orden lógico.
 --->
 
<cfif isdefined("form.CGARepid") and Len(Trim(form.CGARepid))>
	<cfparam name="Form.fCGARepid" default="#form.CGARepid#">
</cfif>

<cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))>
	<cfset modo2 = 'CAMBIO'>
<cfelse>
	<cfset modo2 = 'ALTA'>
</cfif>

<cfquery name="rsOfis" datasource="#session.DSN#">
	select 
	Ocodigo, 
	Oficodigo, 
	Odescripcion, 
	Ecodigo 
	from Oficinas
</cfquery>

<cfoutput>
	<form name="form2" method="post" action="CuentasTipoEli-sql.cfm" style="margin: 0;">
		<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>		  
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#" tabindex="-1">
		<cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum#" tabindex="-1">
		</cfif>

		<input type="hidden" name="CGARepid" value="#rsTiposRep.CGARepid#" tabindex="-1">
		<cfif isdefined("Form.fCGARepid") and Len(Trim(Form.fCGARepid))>		  
		  <input type="hidden" name="fCGARepid" value="#Form.fCGARepid#" tabindex="-1">
		</cfif>

		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td style="background-color:##CCCCCC"><strong>Empresa / Cuenta</strong></td>
			<td style="background-color:##CCCCCC"><strong>Oficina</strong></td>
		  </tr>
		  <tr>
		  	<td>
				<!----Empresas de la corporacion(Todas las empresas de la corporacion (session.CEcodigo) exepto la en la que se esta)---->
				<cfquery name="rsEmpresas" datasource="#session.DSN#">
					select a.Ecodigo,a.Edescripcion
					from Empresas a 
					where a.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value = "#session.CEcodigo#">
						and a.Ecodigo != <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
				</cfquery>
				<cfif modo2 Neq "ALTA">
					<cfparam name="form.Ccuenta" default="1">
					<cfparam name="form.Ocodigo" default="1">
				
					<cfquery name="rsCuenta" datasource="#Session.DSN#">
						select c.Cformato, c.Cdescripcion,
							a.Ecodigo, a.Ocodigo,
							a.Ccuenta
						from CGAreasTipoRepCtasEliminar a
							inner JOIN CContables c 
								ON c.Ccuenta = a.Ccuenta
						where a.Ccuenta= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">
							and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
					</cfquery>
				</cfif>
			  
		  		<cfif modo2 NEQ "ALTA">
					<cf_cuentas Intercompany='yes' Ccuenta="Ccuenta2" Cdescripcion="Cdescripcion2" Cformato="Cformato2" CFcuenta="CFcuenta2" Cmayor="Cmayor2" conexion="#Session.DSN#" form="form2" conlis="S" query="#rsCuenta#" auxiliares="C" movimiento="S" frame="frame2" descwidth="23" onchangeIntercompany="CambiarOficina(this);" tabindex="1" realonly="true">
				<cfelse>
					<cf_cuentas Intercompany='yes' Ccuenta="Ccuenta2" Cdescripcion="Cdescripcion2" Cformato="Cformato2" CFcuenta="CFcuenta2" Cmayor="Cmayor2" conexion="#Session.DSN#" form="form2" conlis="S" auxiliares="C" movimiento="S" frame="frame2" descwidth="23" onchangeIntercompany="CambiarOficina(this);" tabindex="1">
				</cfif>	
			</td>
			<td width="15%">
			<!----Oficinas---->
			<cfif modo2 NEQ 'ALTA'>
				<cfquery name="rsOficinas" datasource="#session.DSN#">
					select Ocodigo, Oficodigo, Odescripcion
					from Oficinas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.Ecodigo#" >
					and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
				</cfquery>
				<input name="Ocodigo" type="hidden" value="#form.Ocodigo#">
				#rsOficinas.Odescripcion#
			<cfelse>
				<cfquery name="rsOficinas" datasource="#session.DSN#">
					select Ocodigo, Oficodigo, Odescripcion
					from Oficinas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.Ecodigo#" >
				</cfquery>
					<select name="Ocodigo" tabindex="2" <cfif modo2 EQ 'CAMBIO'>disabled</cfif> >
						<cfloop query="rsOficinas">
							<option value="#rsOficinas.Ocodigo#" <cfif modo2 eq 'CAMBIO' and rsCuenta.Ocodigo EQ rsOficinas.Ocodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
						</cfloop>
					</select>
			</cfif>
			</td>
		  </tr>
		  <tr>
			<td colspan="4">	
				<cfif modo2 NEQ "ALTA">
					<cf_botones values="Eliminar,Nuevo" tabindex="2">
				<cfelse>
					<cf_botones values="Agregar" tabindex="2">
				</cfif>			
				
				
			</td>
		  </tr>
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>
		</table>
	</form>
</cfoutput>

<cf_qforms form="form2" objForm="objForm2">
<script language="JavaScript" type="text/javascript">
	objForm2.CGARepid.required = true;
	objForm2.CGARepid.description = 'Tipo de Reporte';
	objForm2.Cmayor2.required = true;
	objForm2.Cmayor2.description = 'Cuenta Mayor';
	objForm2.Ccuenta2.required = true;
	objForm2.Ccuenta2.description = 'Cuenta';
	
	<cfif not isDefined("Form.NuevoE")>
		if(document.form2.Ecodigo_Ccuenta){
			function CambiarOficina(){
				var oCombo   = document.form2.Ocodigo;
				var EcodigoI = document.form2.Ecodigo_Ccuenta.value;
				var cont = 0;
				oCombo.length=0;
				<cfoutput query="rsOfis">
				if ('#Trim(rsOfis.Ecodigo)#' == EcodigoI ){
					oCombo.length=cont+1;
					oCombo.options[cont].value='#Trim(rsOfis.Ocodigo)#';
					oCombo.options[cont].text='#Trim(rsOfis.Odescripcion)#';
					<cfif  isdefined("rsLinea") and rsLinea.Ocodigo eq rsOficinas.Ocodigo >
						oCombo.options[cont].selected = true;
					</cfif>
				cont++;
				};
				</cfoutput>
			}
			CambiarOficina();
		}	
	</cfif>
</script>
