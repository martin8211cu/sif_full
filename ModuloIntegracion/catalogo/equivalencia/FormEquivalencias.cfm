<cfif isdefined("Form.EQUid") and len(trim(form.EQUid)) NEQ 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif isDefined("Form.EQUid") and len(trim(#Form.EQUid#)) NEQ 0>
	<cfquery name="rsEquivalencias" datasource="sifinterfaces" >
    	select SIScodigo, CATcodigo, EQUid, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF,EQUidSIF, ts_rversion
		from SIFLD_Equivalencia
        where EQUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EQUid#">
	</cfquery>
</cfif>

<cfquery name="rsEmpOrigen" datasource="sifinterfaces" >
	select EQUempOrigen, EDescripcion
    from SIFLD_Empresa_Origen
    where
    	<cfif isdefined("form.SIScodigo") and trim(form.SIScodigo) GT 0>
        	SIScodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SIScodigo#">
        <cfelse>
        	SIScodigo is null
        </cfif>
    order by EDescripcion
</cfquery>

<cfquery name="rsEmpSIF" datasource="asp" >
	select Ereferencia as Ecodigo, Enombre
    from Empresa
    where Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    order by Enombre
</cfquery>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfoutput>
<form action="SQLEquivalencias.cfm" method="post" name="form1" onSubmit="javascript: return true;" >
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
	<input name="filtro_SISCodigo" type="hidden" value="<cfif isdefined('form.filtro_SISCodigo')>#form.filtro_SISCodigo#</cfif>">
	<input name="filtro_CATcodigo" type="hidden" value="<cfif isdefined('form.filtro_CATcodigo')>#form.filtro_CATcodigo#</cfif>">
	<input name="fSistema" type="hidden" value="<cfif isdefined('form.fSistema')>#form.fSistema#</cfif>">
    <input name="fCatalogo" type="hidden" value="<cfif isdefined('form.fCatalogo')>#form.fCatalogo#</cfif>">

	<table width="67%" height="75%" align="center" cellpadding="2" cellspacing="0">

     	<tr>
			<td align="right" nowrap>Sistema:&nbsp;</td>
			<td>
    	  	<cfif modo neq 'ALTA'>
				<cfloop query="SelSistema">
					<cfif modo neq 'ALTA' and trim(SelSistema.SIScodigo) eq trim(rsEquivalencias.siscodigo)>
						<input name="SIScodigo" type="hidden" value="#SelSistema.SIScodigo#" />
						#SelSistema.SISnombre#
					</cfif>
				</cfloop>
			<cfelse>
				<select name="SIScodigo" tabindex="1" onChange="javascript: funcrecarga();">
					<option value="">-Seleccione una opcion-</option>
					<cfloop query="SelSistema">
						<option value="#SelSistema.SIScodigo#" <cfif modo eq 'ALTA' and isdefined("form.SIScodigo") and trim(SelSistema.SIScodigo) eq trim(form.SIScodigo)>selected</cfif>>#SelSistema.SISnombre#</option>
					</cfloop>
				</select>
			</cfif>
      		</td>
		</tr>

		<tr>
			<td align="right" nowrap>Cat&aacute;logo:&nbsp;</td>
			<td>
		   	<cfif modo neq 'ALTA'>
				<cfloop query="SelCatalogo">
					<cfif modo neq 'ALTA' and trim(SelCatalogo.CATcodigo) eq trim(rsEquivalencias.CATcodigo)>
						<input name="CATcodigo" type="hidden" value="#SelCatalogo.CATcodigo#" />
						#SelCatalogo.CATnombre#
					</cfif>
				</cfloop>
			<cfelse>
			   <select name="CATcodigo" tabindex="2" onChange="javascript: funcrecarga();">
					<option value="">-Seleccione una opcion-</option>
					<cfloop query="SelCatalogo">
						<option value="#SelCatalogo.CATcodigo#" <cfif modo eq 'ALTA' and isdefined("form.CATcodigo") and trim(SelCatalogo.CATcodigo) eq trim(form.CATcodigo)>selected</cfif>>#SelCatalogo.CATnombre#</option>
					</cfloop>
				</select>
			</cfif>
     		</td>
		</tr>

		<tr>
			<td align="right" nowrap>Empresa origen:&nbsp;</td>
			<td>
			<cfif modo neq 'ALTA'>
				<cfloop query="rsEmpOrigen">
					<cfif modo neq 'ALTA' and trim(rsEmpOrigen.EQUempOrigen) EQ trim(rsEquivalencias.EQUempOrigen)>
						<input name="EQUempOrigen" type="hidden" value="#rsEmpOrigen.EQUempOrigen#" />
						#rsEmpOrigen.EDescripcion#
					</cfif>
				</cfloop>
			<cfelse>
                <select name="EQUempOrigen" tabindex="3">
                <option value="">-Seleccione una opcion-</option>
                    <cfloop query="rsEmpOrigen">
                        <option value="#rsEmpOrigen.EQUempOrigen#" <cfif modo eq 'ALTA' and isdefined("form.EQUempOrigen") and trim(rsEmpOrigen.EQUempOrigen) eq trim(form.EQUempOrigen)>selected</cfif>>#rsEmpOrigen.EDescripcion#</option>
                    </cfloop>
                </select>
			</cfif>
			</td>
            <td>&nbsp;</td>
		</tr>

		<tr>
			<td align="right" nowrap>Codigo Origen:&nbsp;</td>
			<td>
				<input name="EQUcodigoOrigen" tabindex="4" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsEquivalencias.EQUcodigoOrigen#</cfoutput></cfif>" size="35" maxlength="30"  alt="Codigo Origen" required="true">
            </td>
		</tr>

		<tr>
			<td align="right" nowrap>Empresa SIF:&nbsp;</td>
			<td>
		   		#rsEmpSIF.Enombre#
                <input type="hidden" name="EQUempSIF" tabindex="5" value="#rsEmpSIF.Ecodigo#"/>
            </td>
            <td>&nbsp;</td>
		</tr>

		<tr>
			<td align="right" nowrap>Codigo SIF:&nbsp;</td>
			<td><!--- <cf_dump var="#form#"> --->
				<cfif isdefined("form.CATcodigo") and trim(form.CATcodigo) GT 0>
					<cfquery name="rsCatalogo" datasource="#session.dsn#">
						<cfif form.CATcodigo EQ "BANCOS">
							select Bid as id, Bid as Codigo, Bdescripcion as Descripcion
                            from Bancos
						<cfelseif form.CATcodigo EQ "CADENA">
							select Ecodigo as id, EcodigoSDC as Codigo, Edescripcion as Descripcion
							from Empresas
						<cfelseif form.CATcodigo EQ "CENTRO_FUN">
							select CFid as id, CFcodigo as Codigo, CFdescripcion as Descripcion
							from CFuncional
						<cfelseif form.CATcodigo EQ "CONC_GASTO">
							select Cid as id, Ccodigo as Codigo, Cdescripcion as Descripcion
							from Conceptos
						<cfelseif form.CATcodigo EQ "CTA_BANEMP" OR form.CATcodigo EQ "CTA_BANSUC" OR form.CATcodigo EQ "CTA_PAGEMP"
						OR form.CATcodigo EQ "CTA_PAGSUC">
							select  CBid as id, CBid as Codigo, CBcodigo #_Cat# '-' #_Cat# CBdescripcion as Descripcion
							from CuentasBancos
						<cfelseif form.CATcodigo EQ "IETU">
							select TESRPTCid as id, TESRPTCcodigo as Codigo, TESRPTCdescripcion as Descripcion
							from TESRPTconcepto
						<cfelseif form.CATcodigo EQ "IMPUESTO">
							select Icodigo as id, Icodigo as Codigo, Idescripcion as Descripcion
							from Impuestos
						<cfelseif form.CATcodigo EQ "IEPS">
							select Icodigo as id, Icodigo as Codigo, Idescripcion as Descripcion
							from Impuestos
						<cfelseif form.CATcodigo EQ "MONEDA">
							select Mcodigo as id, Miso4217 as Codigo, Mnombre as Descripcion
							from Monedas
						<cfelseif form.CATcodigo EQ "PAIS">
							select Ppais as id, Ppais as Codigo, Pnombre as Descripcion
							from Pais
						<cfelseif form.CATcodigo EQ "RETENCION">
							select Rcodigo as id, Rcodigo as Codigo, Rdescripcion as Descripcion
							from Retenciones
						<cfelseif form.CATcodigo EQ "SUCURSAL">
							select Ocodigo as id, Oficodigo as Codigo, Odescripcion as Descripcion
							from Oficinas
						<cfelseif form.CATcodigo EQ "CTA_BANCO">
							select CBid as id, CBcodigo as Codigo, CBcodigo+'-'+CBdescripcion as Descripcion
							from CuentasBancos
						<cfelseif form.CATcodigo EQ "MODULO_ORI">
							select Oorigen as id, Oorigen as Codigo, Oorigen+'-'+Cdescripcion as Descripcion
							from ConceptoContable
						<cfelseif form.CATcodigo EQ "SOCIO_ANEX">
							select SNid as id, SNcodigo as Codigo, SNnombre as Descripcion
							from SNegocios
						</cfif>
						<cfif form.CATcodigo NEQ "PAIS">
							where
							<cfif form.CATcodigo NEQ "IETU">
								Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							<cfelse>
								CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
							</cfif>
							<cfif form.CATcodigo EQ "IMPUESTO">
								and ieps != 1 or ieps is null
							<cfelseif form.CATcodigo EQ "IEPS">
								and ieps = 1
							</cfif>
						</cfif>
					</cfquery>
					<select name="EQUidSIF" tabindex="6">
						<option value="">-Seleccione una opcion-</option>
						<cfloop query="rsCatalogo">
							<option value="#rsCatalogo.id#|#rsCatalogo.Codigo#|#rsCatalogo.descripcion#" <cfif modo neq 'ALTA' and trim(rsEquivalencias.EQUidSIF) eq trim(rsCatalogo.id)>selected</cfif>>#rsCatalogo.descripcion#</option>
						</cfloop>
					</select>
                </cfif>
            </td>
		</tr>


		<!--- *************************************************** --->

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr>
			<td colspan="2" align="center" nowrap>
				<cfif modo neq "ALTA">
					<cfset masbotones = "">
					<cfset masbotonesv = "">
				<cfelse>
					<cfset masbotones = "">
					<cfset masbotonesv = "">
				</cfif>
				<cf_botones modo="#modo#" tabindex="7">
	</td>
		</tr>
	</table>

  <cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsEquivalencias.ts_rversion#"/>
		</cfinvoke>
	</cfif>

  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="EQUid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsEquivalencias.EQUid#</cfoutput></cfif>">

 </form>
 </cfoutput>

<cf_qforms form="form1" objForm="objForm">
<script language="JavaScript" type="text/JavaScript">

	objForm.SIScodigo.required = true;
	objForm.SIScodigo.description="Código Sistema";

	objForm.CATcodigo.required = true;
	objForm.CATcodigo.description="Catálogo";

	objForm.EQUempOrigen.required = true;
	objForm.EQUempOrigen.description="Empresa Origen";

	objForm.EQUcodigoOrigen.required = true;
	objForm.EQUcodigoOrigen.description="Codigo Origen";

	objForm.EQUempSIF.required = true;
	objForm.EQUempSIF.description="Empresa SIF";

	objForm.EQUidSIF.required = true;
	objForm.EQUidSIF.description="Codigo SIF";

	<!---function funcAlta(){

		alert(objForm.EQUcodigoOrigen.required);
		return false;

	}--->

	function funcBaja(){

		if (!confirm('¿Desea Eliminar el Registro?') )
		{ return false;}
		else
		{ deshabilitarValidacion();
		  return true; }
	}

	function funcrecarga(){
		form1.action = "Equivalencias.cfm";
		form1.submit()
	}

	function deshabilitarValidacion(){
		objForm.SIScodigo.required = false;
		objForm.Catcodigo.required = false;
		objForm.EQUempOrigen.required = false;
		objForm.EQUcodigoOrigen.required = false;
		objForm.EQUempSIF.required = false;
		objForm.EQUidSIF.required = false;

	}

	<cfif modo NEQ "ALTA">
 		document.form.SIScodigo.focus();
	<cfelse>
		document.form.SIScodigo.focus();
 	</cfif>
</script>
