<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Se corrige la navegación del form en la pantalla por tabs para que tenga un orden lógico.
 --->

<!--- Definición del modo --->
<cfset modo = "ALTA">
<cfif isdefined("url.Cconcepto") and len(trim(url.Cconcepto))>
	<cfset form.Cconcepto = url.Cconcepto>
</cfif>
<cfif isdefined("url.Ocodigoori") and len(trim(url.Ocodigoori))>
	<cfset form.Ocodigoori = url.Ocodigoori>
</cfif>
<cfif isdefined("url.Ocodigodest") and len(trim(url.Ocodigodest))>
	<cfset form.Ocodigodest = url.Ocodigodest>
</cfif>
<cfif isdefined("form.Cconcepto") and len(trim(form.Cconcepto))>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Consultas --->
<cfquery name="rsConceptos" datasource="#session.DSN#">
	select 
		Cconcepto,
		Cdescripcion
	from ConceptoContableE
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
</cfquery>
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select 
		Ocodigo,
		Odescripcion
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
</cfquery>
<cfif modo eq "CAMBIO">
	<cfquery name="rsCta" datasource="#session.DSN#">
		select 
			A.Cconcepto,
			A.Ocodigoori,
			A.Ocodigodest,
			A.CFcuentacxc,
			A.CFcuentacxp,
			B.Cdescripcion as dCconcepto,
			C.Odescripcion as dOcodigoori,
			D.Odescripcion as dOcodigodest			
		from CuentaBalanceOficina A
			inner join ConceptoContableE B on
				A.Ecodigo = B.Ecodigo and
				A.Cconcepto = B.Cconcepto		
			inner join Oficinas C on
				A.Ecodigo = C.Ecodigo and
				A.Ocodigoori = C.Ocodigo
			inner join Oficinas D on
				A.Ecodigo = D.Ecodigo and
				A.Ocodigodest = D.Ocodigo		
		where A.Ecodigo 	    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and A.Cconcepto 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Cconcepto#">
			and A.Ocodigoori 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigoori#">
			and A.Ocodigodest   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigodest#">
	</cfquery>
</cfif>

<!--- <cfdump var="#form#"> --->

<!--- Pintado del Formulario --->
<cfoutput>
<form action="CuentasBalanceOficina-sql.cfm" method="post" name="form1">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2" class="tituloAlterno"><div align="center"> 
				<cfif modo eq 'ALTA'>Nueva Cuenta de Balance<cfelse>Modificar Cuenta de Balance</cfif></div></td>
		</tr>	  	
		<tr> <!--- Concepto --->
			<td class="fileLabel" align="right">Concepto:</td>
			<td>
				<cfif modo eq "ALTA">
					<select name="Cconcepto" tabindex="1">
						<cfloop query="rsConceptos">
							<option value="#rsConceptos.Cconcepto#"
								<cfif isdefined("form.Cconcepto") 
									and len(trim(form.Cconcepto))
									and trim(form.Cconcepto eq #rsConceptos.Cconcepto#)>
									selected
								</cfif>
								label="#rsConceptos.Cdescripcion#">#rsConceptos.Cdescripcion#</option>
						</cfloop>
					</select>
				<cfelse>
					#rsCta.Cconcepto# - #rsCta.dCconcepto#
					<input type="hidden" name="Cconcepto" value="#form.Cconcepto#" tabindex="-1">
				</cfif>
		</tr>
		<tr> <!--- Oficina Origen --->
			<td class="fileLabel" align="right">Oficina Origen:</td>
			<td>
				<cfif modo eq "ALTA">
					<select name="Ocodigoori" tabindex="1">
						<cfloop query="rsOficinas">
							<option value="#rsOficinas.Ocodigo#"							
								<cfif isdefined("form.Ocodigoori") 
									and len(trim(form.Ocodigoori))
									and trim(form.Ocodigoori) eq #rsOficinas.Ocodigo#>
									selected
								</cfif>
								label="#rsOficinas.Odescripcion#">#rsOficinas.Odescripcion#</option>
						</cfloop>
					</select>			
				<cfelse>
					#rsCta.Ocodigoori# - #rsCta.dOcodigoori#
					<input type="hidden" name="Ocodigoori" value="#form.Ocodigoori#" tabindex="-1">
				</cfif>
			</td>			
		</tr>
		<tr> <!--- Oficina Destino --->
			<td class="fileLabel" align="right">Oficina Destino:</td>
			<td>
				<cfif modo eq "ALTA">
					<select name="Ocodigodest" tabindex="1">
						<cfloop query="rsOficinas">
							<option value="#rsOficinas.Ocodigo#" 
								<cfif isdefined("form.Ocodigodest") 
									and len(trim(form.Ocodigodest))
									and trim(form.Ocodigodest eq #rsOficinas.Ocodigo#)>
									selected
								</cfif>
								label="#rsOficinas.Odescripcion#">#rsOficinas.Odescripcion#</option>
						</cfloop>
					</select>			
				<cfelse>
					#rsCta.Ocodigodest# - #rsCta.dOcodigodest#
					<input type="hidden" name="Ocodigodest" value="#form.Ocodigodest#" tabindex="-1">
				</cfif>
			</td>			
		</tr>
		<tr> <!--- Cuenta por Cobrar --->
			<td class="fileLabel" align="right">Cuenta por Cobrar:</td>
			<td>
				<cfif modo NEQ 'ALTA'>
					<cfquery name="rsCuenta" datasource="#session.DSN#">
 						select A.CFcuenta, A.CFdescripcion, A.Ccuenta, A.CFcuenta, A.CFformato
						from CFinanciera A
						where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and A.CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCta.CFcuentacxc#">
					</cfquery>	
					<cf_cuentas descwidth="20" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxc" CFcuenta="CFcuentacxc" query="#rsCuenta#" tabindex="1">
				<cfelse>
					<cf_cuentas descwidth="20" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxc" CFcuenta="CFcuentacxc" tabindex="1"> 
				</cfif>
			</td>	
		</tr>
		<tr> <!--- Cuenta por Pagar --->
			<td class="fileLabel" align="right">Cuenta por Pagar:</td>
			<td>
				<cfif modo NEQ 'ALTA'>
					<cfquery name="rsCuenta" datasource="#session.DSN#">
						select A.CFcuenta, A.CFdescripcion, A.Ccuenta, A.CFcuenta, A.CFformato
						from CFinanciera A
						where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and A.CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCta.CFcuentacxp#">
					</cfquery>	
					<cf_cuentas descwidth="20" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxp" CFcuenta="CFcuentacxp" query="#rsCuenta#" tabindex="2">
				<cfelse>
					<cf_cuentas descwidth="20" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuentacxp" CFcuenta="CFcuentacxp" tabindex="2"> 
				</cfif>
			</td>	
		</tr>
		<tr><td><input type="hidden" name="modo" value="#modo#" tabindex="-1"></td></tr>
	</table>
	<cf_botones modo="#modo#" include="Importar" tabindex="3">
</form>
</cfoutput>

<!--- Validaciones del Form --->
<cf_qforms>
<cfoutput>
<script language="javascript" type="text/javascript">

	//1. Definir las descripciones de los objetos
	objForm.CFcuentacxc.description = "#JSStringFormat('Cuenta por Cobrar')#";
	objForm.CFcuentacxp.description = "#JSStringFormat('Cuenta por Pagar')#";
	
	//2. Definir la función de validacion
	function habilitarValidacion(){
		objForm.CFcuentacxc.required="true";
		objForm.CFcuentacxc.required="true";
		objForm.CFcuentacxp.required="true";
		objForm.CFcuentacxp.required="true";
	}
	
	//3. Definir la función de desabilitar la validacion
	function deshabilitarValidacion(){
		objForm.CFcuentacxc.required="false";
		objForm.CFcuentacxc.required="false";
		objForm.CFcuentacxp.required="false";
		objForm.CFcuentacxp.required="false";
	}
	
	function funcBaja() {
		document.form1.CFcuentacxc.value=".";
		document.form1.CFcuentacxp.value=".";
	}	

	function funcNuevo() {
		document.form1.CFcuentacxc.value=".";
		document.form1.CFcuentacxp.value=".";
	}	
</script>
</cfoutput>