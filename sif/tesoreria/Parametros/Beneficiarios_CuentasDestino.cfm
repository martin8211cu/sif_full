<!--- 
	Creado por Gustavo Fonseca Hernández.
		Fecha: 26-7-2005.
		Motivo: Creación del Mantenimiento de Instrucciones de Pago de Beneficiarios.
	Modificado por Gustavo Fonseca H.
		Fecha: 20-12-2005.
		Motivo: Se corrige el tipo de dato del TESBid a numeric.
 --->
 <cfset navegacion="">
 <!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
	<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
		<cfset form.Pagina = url.Pagina>
	</cfif>
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
	<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
		<cfset form.Pagina = url.PageNum_Lista>
	</cfif>
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
	<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
		<cfset form.Pagina = form.PageNum>
	</cfif>
 	<cfif isdefined('form.Pagina')>
 		<cfset navegacion = '&Pagina=#form.Pagina#'>
	</cfif>
 
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
	<cfset form.Pagina2 = url.PageNum_Lista2>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
	<cfset form.Pagina2 = form.PageNum2>
</cfif>
<cfparam name="url.TESTPid" default="0">
<cfparam name="url.TESBid" default="0">
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina2" default="1">
<cfparam name="form.MaxRows2" default="10">

<!---<cfdump var="#url#">  --->
<!--- <cf_dump var="#form#"> --->

<cfif isdefined("url.TESBid") and url.TESBid gt 0 and not isdefined("form.TESBid")>
	<cfset form.TESBid = url.TESBid>
	
</cfif>

<cfif isdefined("url.TESTPid") and len(trim(url.TESTPid)) and not isdefined("form.TESTPid")>
	<cfset form.TESTPid = url.TESTPid>
</cfif>
<cfset navegacion = navegacion & '&TESBid=#form.TESBid#'>

<cfset CAMBIO = 0>

<cfquery name="rsBeneficiario" datasource="#session.DSN#">
	select a.TESBeneficiarioId, a.TESBeneficiario, a.TESBid
	from TESbeneficiario a
	where a.TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESBid#">
	order by a.CEcodigo
</cfquery>
<cfquery name="rsCHK" datasource="#session.DSN#">
	select count(1) as resultado
	from TEStransferenciaP
	where TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESBid#">
	and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
</cfquery>


<cfif isdefined("form.TESTPid")	and len(trim(form.TESTPid))>
	<cfquery datasource="#session.dsn#" name="data">
		select TESTPcuenta, 
				TESTPid,
				Miso4217, 
				TESTPcodigoTipo, 
				TESTPcodigo, 
				TESTPbanco, 
				TESTPdireccion, 
				TESTPciudad, 
				Ppais, 
				TESTPtelefono, 
				TESTPinstruccion, 
				TESTPestado, 
				UsucodigoAlta, 
				TESTPfechaAlta, 
				UsucodigoBaja, 
				TESTPfechaBaja, 
				BMUsucodigo, 
				ts_rversion, 
				TESBid
		from TEStransferenciaP

		 where TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
		   and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.tesoreria.TESid#">
	</cfquery>
</cfif>




<cfset checked   = "<img border='0' src='/cfmx/sif/imagenes/checked.gif'>" >
<cfset unchecked = "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif'>" > 

<cfquery name="rsLista" datasource="#session.DSN#">
	select 	TESTPid,
			TESid,
			TESTPcuenta as TESTPcuentab, 
			Miso4217 as Miso4217b, 
			TESTPcodigoTipo, 
			TESTPcodigo, 
			TESTPbanco as TESTPbancob,
			case when TESTPestado = 1 then <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#checked#"> else
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#unchecked#"> end as TESTPestadob,
			TESBid 
			<cfif isdefined('form.Pagina')>
			,'#Pagina#' as Pagina
			</cfif>
			<cfif isdefined('form.fTESBeneficiario')>
			,'#form.fTESBeneficiario#' as fTESBeneficiario
			</cfif>
			<cfif isdefined('form.fTESBeneficiarioID')>
			,'#form.fTESBeneficiarioID#' as fTESBeneficiarioID
			</cfif>

	from TEStransferenciaP a
	where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.tesoreria.TESid#">
		and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
		and TESTPestado < 2
	
</cfquery>


<cfquery name="rsMonedas" datasource="#session.DSN#">
	select Miso4217, Mcodigo, Mnombre
	from Monedas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Mnombre
</cfquery>

<cfif isdefined("form.TESTPid")	and len(trim(form.TESTPid))>
	<cfset CAMBIO = data.RecordCount>
</cfif>
<style type="text/css">
<!--
.SinBorde {
 	border:none;
}
-->
</style>


<cfquery name="rsPais" datasource="#session.DSN#">
	select Ppais, Pnombre 
	from Pais
	order by Pnombre
</cfquery>

<form action="Beneficiarios_CuentasDestino_sql.cfm" method="post" name="form2" id="form2">
	<input name="TESBid" type="hidden" value="<cfoutput>#form.TESBid#</cfoutput>">
	<input name="TESTPid" type="hidden" value="<cfoutput>#data.TESTPid#</cfoutput>">
	<input name="Pagina2" type="hidden" value="<cfoutput>#form.Pagina2#</cfoutput>">
	<input name="MaxRows2" type="hidden" value="<cfoutput>#form.MaxRows2#</cfoutput>">
	<cfif isdefined('form.Pagina')>
		<input name="Pagina" type="hidden" value="<cfoutput>#form.Pagina#</cfoutput>">
	</cfif>
	<cfif isdefined('form.fTESBeneficiario')>
		<input name="fTESBeneficiario" type="hidden" value="<cfoutput>#form.fTESBeneficiario#</cfoutput>">
	</cfif>
	<cfif isdefined('form.fTESBeneficiarioID')>
		<input name="fTESBeneficiarioID" type="hidden" value="<cfoutput>#form.fTESBeneficiarioID#</cfoutput>">
	</cfif>
	
	<table summary="Tabla de entrada" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="4" width="125%">
				<fieldset> <legend><strong>Cuenta&nbsp;Destino</strong></legend>
					<table cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td align="right" nowrap><strong>Cuenta&nbsp;Bancaria:&nbsp;</strong></td>
							
							<td>
								<input name="TESTPcuentab" value="<cfif isdefined("data") and  data.recordcount eq 1><cfoutput>#data.TESTPcuenta#</cfoutput></cfif>" type="text" size="60" maxlength="100">
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Moneda:</strong></td>
							<td>
								<select name="Miso4217">
									<cfoutput query="rsMonedas">
										<option value="#rsMonedas.Miso4217#" <cfif rsMonedas.Miso4217 EQ data.Miso4217>selected</cfif>>#rsMonedas.Mnombre#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>C&oacute;digo&nbsp;Banco:</strong></td>
							<td>
								<select name="TESTPcodigoTipo">
									<option value="1" <cfif isdefined("data") and  data.TESTPcodigoTipo EQ 1>selected</cfif>>ABA</option>
									<option value="2" <cfif isdefined("data") and  data.TESTPcodigoTipo EQ 2>selected</cfif>>SWIFT</option>
									<option value="0" <cfif isdefined("data") and  data.TESTPcodigoTipo EQ 0>selected</cfif>>OTRO</option>
								</select>
								<input name="TESTPcodigo" value="<cfif isdefined("data") and len(trim(data.TESTPcodigo))><cfoutput>#data.TESTPcodigo#</cfoutput></cfif>" type="text" size="40" maxlength="100">
							</td>

					  </tr>
						<tr>
							<td align="right" nowrap><strong>Nombre&nbsp;del&nbsp;Banco:&nbsp;</strong></td>
							<td><input name="TESTPbanco" style="width:100% " value="<cfif isdefined("data") and len(trim(data.TESTPbanco))><cfoutput>#data.TESTPbanco#</cfoutput></cfif>" type="text" size="85" maxlength="100"></td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Direcci&oacute;n:&nbsp;</strong></td>
							<td><input name="TESTPdireccion" style="width:100% " value="<cfif isdefined("data") and len(trim(data.TESTPdireccion))><cfoutput>#data.TESTPdireccion#</cfoutput></cfif>" type="text" size="85" maxlength="100"></td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Ciudad:&nbsp;</strong></td>
							<td nowrap><input name="TESTPciudad" value="<cfif isdefined("data") and len(trim(data.TESTPciudad))><cfoutput>#data.TESTPciudad#</cfoutput></cfif>" type="text" size="20" maxlength="100"><!--- </td> --->
							<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Pa&iacute;s:&nbsp;</strong>
								<select name="Ppais">
									<cfoutput query="rsPais">
										<option value="#rsPais.Ppais#" <cfif rsPais.Ppais EQ data.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
									</cfoutput>
								</select>
							 </td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Tel&eacute;fono:&nbsp;</strong></td>
							<td><input name="TESTPtelefono" value="<cfif isdefined("data") and len(trim(data.TESTPtelefono))><cfoutput>#data.TESTPtelefono#</cfoutput></cfif>" type="text" size="13" maxlength="100"></td>
						</tr>

						<tr>
							<td align="right" nowrap><strong>Instrucciones:&nbsp;</strong></td>
							<td><textarea name="TESTPinstruccion" style="width:100%"><cfif isdefined("data") and len(trim(data.TESTPinstruccion))><cfoutput>#data.TESTPinstruccion#</cfoutput></cfif></textarea></td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Default:</strong>&nbsp;</td>
							<td><input name="chkTESTPestado" <cfif rsCHK.resultado EQ 0 or (rsCHK.resultado EQ 1 and CAMBIO) or (data.TESTPestado eq 1)>checked disabled</cfif> value="1" type="checkbox" >
								<cfif rsCHK.resultado EQ 0 or (rsCHK.resultado EQ 1 and CAMBIO) or (data.TESTPestado eq 1)>
									<input type="hidden" name="chkTESTPestado" value="1">
								</cfif>
							</td>
						</tr>
				</table>
				</fieldset>
				
			</td>
		</tr>
		<tr align="left">
			<td  style="width:100% ">

			<cfif isdefined("data") and data.RecordCount>
				<cf_botones modo='CAMBIO'>
			<cfelse>
				<cf_botones modo='ALTA'>
			</cfif>
			</td>
			<td>&nbsp;</td>

		</tr>
  </table>
	<cfoutput>
	<cfset ts = "">
	<cfif isdefined("form.TESTPid")	and len(trim(form.TESTPid))>
	  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
	  </cfinvoke>
	  <input type="hidden" name="ts_rversion" value="<cfif CAMBIO>#ts#</cfif>" size="32">
	</cfif>
	</cfoutput>	
</form>
<fieldset><legend><strong>Lista Cuentas Destino</strong></legend>
<table cellspacing="0" cellpadding="0" border="0" width="100%">
	<tr>
		<td>&nbsp;</td>
		<td width="100%">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td width="100%">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#rsLista#"
				desplegar="TESTPbancob, Miso4217b, TESTPcuentab, TESTPestadob"
				etiquetas="Banco, Moneda, Cuenta, Default"
				formatos="S,S,S,S"
				ajustar="yes"
				showEmptyListMsg="yes"
				align="left,left,left,left"
				ira="Beneficiarios_form.cfm"
				incluyeForm = "true"
				formName = "form3"
				form_method="get"
				keys="TESTPid, TESBid, TESid"
				PageIndex="2"
				maxRows = "#form.MaxRows2#"
				navegacion="#navegacion#"
			/>
		</td>
	</tr>
</table>
</fieldset>


<cf_qforms form = "form2" objForm = "objForm2">
<script language="javascript" type="text/javascript">
<!-- //
	objForm2.TESTPcuentab.required = true;
	objForm2.TESTPcuentab.description="Cuenta Bancaria";
	objForm2.Miso4217.required = true;
	objForm2.Miso4217.description="Moneda";
	objForm2.TESTPcodigo.required = true;
	objForm2.TESTPcodigo.description="Código Banco";
	objForm2.TESTPbanco.required = true;
	objForm2.TESTPbanco.description="Nombre del Banco";
	objForm2.TESTPdireccion.required = true;
	objForm2.TESTPdireccion.description="Dirección";
	objForm2.TESTPciudad.required = true;
	objForm2.TESTPciudad.description="Ciudad";
	objForm2.TESTPtelefono.required = true;
	objForm2.TESTPtelefono.description="Teléfono";

//-->	
function funcEliminar(){
	deshabilitarValidacion();
}
</script><!---  --->


