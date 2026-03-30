<cfset modo="ALTA">
<cfif isdefined("Form.Cid") and len(trim(form.Cid)) NEQ 0 and form.Cid GT 0
	and isdefined("Form.Ccodigo") and len(trim(form.Ccodigo)) NEQ 0 
	and isdefined("Form.Dcodigo") and len(trim(form.Dcodigo)) NEQ 0 >
	<cfset modo="CAMBIO">	
</cfif>

<cfquery name="rsCid" datasource="#Session.DSN#">
	Select Cid, ts_rversion
    from Conceptos
	where Ecodigo = #session.Ecodigo#
	 and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#">		  
</cfquery>

<cfquery name="rsConceptos" datasource="#Session.DSN#" >
	Select Cid, Ecodigo, rtrim(ltrim(Ccodigo)) as Ccodigo, Ctipo, Cdescripcion, ts_rversion
	from Conceptos
	where Ecodigo = #session.Ecodigo#
	  and Cid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">		  
	order by Cdescripcion asc
</cfquery>

<cfquery name="rsCContables" datasource="#Session.DSN#">
	select Ccuenta, Cdescripcion, Cformato 
	from CContables 
	where Ecodigo    = #session.Ecodigo#
	 and Cmovimiento ='S' 
	 and Mcodigo     = 1  
	order by Ccuenta
</cfquery>

<cfquery name="rsDeptos" datasource="#Session.DSN#">
	select Dcodigo, Ddescripcion 
	from Departamentos 
	where Ecodigo = #session.Ecodigo#
		<cfif modo EQ "ALTA">
			and Dcodigo not in (
				select Dcodigo 
				from CuentasConceptos
				where Ecodigo = #session.Ecodigo#
					and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Form.Ccodigo)#">
				)
		<cfelse>
			and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigo#">
		</cfif>
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsCtasConceptos" datasource="#Session.DSN#" >
		Select 	rtrim(ltrim(a.Ccodigo)) as Ccodigo, 
				a.Dcodigo, 
				a.Cid, 
				a.ts_rversion, 
				a.Ccuenta, 
				a.Ccuentadesc 
		from CuentasConceptos a
		where a.Ecodigo = #session.Ecodigo#
			and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Form.Ccodigo)#" >
			and a.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
			and a.Cid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#" >
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<cfoutput>
<form action="SQLCtaConcepto.cfm" method="post" name="form1">
	<input name="Pagina" 				type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="Pagina2" 				type="hidden" tabindex="-1" value="#form.Pagina2#">	
	<input name="MaxRows2" 				type="hidden" tabindex="-1" value="#form.MaxRows2#">	
	<input name="filtro_Ccodigo" 		type="hidden" value="<cfif isdefined('form.filtro_Ccodigo')>#form.filtro_Ccodigo#</cfif>">
	<input name="filtro_Cdescripcion" 	type="hidden" value="<cfif isdefined('form.filtro_Cdescripcion')>#form.filtro_Cdescripcion#</cfif>">
	<input name="hfiltro_Ccodigo" 		type="hidden" value="<cfif isdefined('form.hfiltro_Ccodigo')>#form.hfiltro_Ccodigo#</cfif>">
	<input name="hfiltro_Cdescripcion" 	type="hidden" value="<cfif isdefined('form.hfiltro_Cdescripcion')>#form.hfiltro_Cdescripcion#</cfif>">
	<input name="fTipo" 				type="hidden" value="<cfif isdefined('form.fTipo')>#form.ftipo#</cfif>">

	<table align="center" width="100%" cellpadding="1" cellspacing="0" border="0" >
    	<tr valign="baseline"> 
      		<td nowrap align="right"><strong>Concepto:</strong>&nbsp;</td>
      		<td nowrap>
          		<input name="Ccodigo" type="text" tabindex="-1" class="cajasinborde"
				value="#Trim(Form.Ccodigo)#" size="10" maxlength="10" 
				readonly alt="El campo Descripción del Concepto">
			</td>
    	</tr>
    
		<tr valign="baseline"> 
      		<td nowrap align="right"><strong>Departamento:</strong>&nbsp;</td>
      		<td nowrap>
				<cfif modo NEQ 'ALTA'>
					<strong>#rsDeptos.Dcodigo# - #rsDeptos.Ddescripcion#</strong>
					<input type="hidden" name="Dcodigo" value="#rsDeptos.Dcodigo#">	  
				<cfelse>
					<select name="Dcodigo" tabindex="1">
						<cfloop query="rsDeptos"> 
							<option value="#rsDeptos.Dcodigo#" <cfif (isDefined("rsCtasConceptos.Dcodigo") AND rsDeptos.Dcodigo EQ rsCtasConceptos.Dcodigo)>selected</cfif>>#rsDeptos.Ddescripcion#</option>
						</cfloop>
					</select>
				</cfif>
			</td>
    	</tr>

    	<tr valign="baseline"> 
      		<td nowrap align="right"><strong>Cuenta:</strong>&nbsp;</td>
      		<td mowrap>
				<cfif modo NEQ "ALTA">
					<cfquery name="rsCuenta" datasource="#session.DSN#">
						select Ccuenta, Cdescripcion, Cformato
						from CContables
						where Ecodigo = #session.Ecodigo#
						and  Ccuenta  = #rsCtasConceptos.Ccuenta#
					</cfquery>	
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuenta1" query="#rsCuenta#" tabindex="1"> 
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuenta1" tabindex="1"> 
				</cfif> 
	 		</td>
    	</tr>

		<tr valign="baseline"> 
			<td valign="middle" nowrap align="right"><strong>Cuenta de Descuentos:</strong>&nbsp;</td>
			<td valign="middle">
				<cfif modo NEQ "ALTA">
					<cfquery name="rsCC" datasource="#session.DSN#">
						select Ccuenta, Cdescripcion, Cformato
						from CContables
						where Ecodigo = #session.Ecodigo#
						and  Ccuenta  = #rsCtasConceptos.Ccuentadesc#
					</cfquery>	
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuenta2" query="#rsCC#" tabindex="3"> 
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuenta2" tabindex="3"> 
				</cfif>		  
			</td>
		</tr>

    	<tr valign="top">
			<td nowrap colspan="2">
	  			<input type="hidden" name="Cid" value="<cfif modo EQ "ALTA">#rsCid.Cid#<cfelse>#rsCtasConceptos.Cid#</cfif>">
				<input type="hidden" name="modo" value="" >	  
			</td>
		</tr>

    	<tr valign="top">
			<td nowrap colspan="2">&nbsp;</td>
    	</tr>
    
		<tr valign="baseline"> 
      		<td nowrap align="center" colspan="2"> 
				<cf_botones modo="#modo#" Regresar="#regresa#" tabindex="4">
        	</td>
    	</tr>
		
		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsCtasConceptos.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
    	</cfif>

  </table>
</form>
</cfoutput>
<cf_qforms>
<script language="JavaScript1.2" type="text/javascript">	

	objForm.Ccuenta1.required = true;
	objForm.Ccuenta1.description="Cuenta Contable";

	objForm.Ccuenta2.required = true;
	objForm.Ccuenta2.description="Cuenta Descuento";

	function deshabilitarValidacion(){
		objForm.Ccuenta1.required = false;
		objForm.Ccuenta2.required = false;
	}
	<cfif modo NEQ 'ALTA'>
		document.form1.Cmayor_Ccuenta1.focus();
	<cfelse>
		document.form1.Dcodigo.focus();
	</cfif>
</script>