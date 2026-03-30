<cfif isdefined("Form.Cid") and len(trim(form.Cid)) NEQ 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.Cid") and len(trim(#Form.Cid#)) NEQ 0>
	<cfquery name="rsConceptos" datasource="#Session.DSN#" >
		Select Cid, coalesce(CCid,0) as CCid, Ecodigo, Ccodigo, Ctipo, Cdescripcion, Ucodigo, Cimportacion, cuentac, 
		Cformato,	'' as Cdescripcion2,	'' as Ccuenta, ts_rversion
        from Conceptos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#" >		  
		order by Cdescripcion asc
	</cfquery>
</cfif>

<cfquery name="rsUnidades" datasource="#Session.DSN#" >
	select Ucodigo, Udescripcion 
	from Unidades 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Utipo in (1,2)
</cfquery>

<cfif modo neq 'ALTA' and isdefined('rsConceptos') and rsConceptos.recordCount GT 0 and rsConceptos.CCid NEQ ''>
	<cfquery name="rsClasificacion" datasource="#session.DSN#">
		select CCid, CCcodigo, CCdescripcion, CCnivel as CCnivel
		from CConceptos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.CCid#">
	</cfquery>
</cfif>

<cfquery name="rsProfundidad" datasource="#session.DSN#">
	select coalesce(Pvalor,'1') as Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=540
</cfquery>



<body>
<cfoutput>
<form action="SQLConceptos.cfm" method="post" name="form">
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
	<input name="filtro_Ccodigo" type="hidden" value="<cfif isdefined('form.filtro_Ccodigo')>#form.filtro_Ccodigo#</cfif>">
	<input name="filtro_Cdescripcion" type="hidden" value="<cfif isdefined('form.filtro_Cdescripcion')>#form.filtro_Cdescripcion#</cfif>">
	<input name="fTipo" type="hidden" value="<cfif isdefined('form.fTipo')>#form.ftipo#</cfif>">
	
	<table width="67%" height="75%" align="center" cellpadding="2" cellspacing="0">
		<tr> 
			<td align="right" nowrap>C&oacute;digo:&nbsp;</td>
			<td>
				<input name="Ccodigo" tabindex="1" type="text"
				value="<cfif modo neq "ALTA" >#rsConceptos.Ccodigo#</cfif>" 
				size="10" maxlength="10"  alt="El Código del Concepto" <cfif modo NEQ 'ALTA'> class="cajasinborde" readonly</cfif>> 
			</td>
		</tr>
		<tr> 
			<td align="right" nowrap>Tipo:&nbsp;</td>
			<td align="left"> 
				<select name="Ctipo" tabindex="1">
					<cfif session.menues.SMcodigo eq 'CC' or session.menues.SMcodigo eq 'AD' or session.menues.SMcodigo eq 'FA'>
						<option value="I" <cfif (isDefined("rsConceptos.Ctipo") and trim(rsConceptos.Ctipo) EQ "I")>selected</cfif> >Ingreso</option>
					</cfif>
					<cfif session.menues.SMcodigo eq 'CP' or session.menues.SMcodigo eq 'AD' or session.menues.SMcodigo eq 'FA'>
						<option value="G" <cfif (isDefined("rsConceptos.Ctipo") and trim(rsConceptos.Ctipo) EQ "G")>selected</cfif> >Gasto</option>
					</cfif>
				</select>
			</td>
		</tr>

		<tr> 
			<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td>
				<input name="Cdescripcion" tabindex="1" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsConceptos.Cdescripcion#</cfoutput></cfif>" size="35" maxlength="50" onFocus="this.select();"  alt="La Descripción del Concepto">
			</td>
		</tr>

		<tr>
			<td valign="baseline" align="right">Clasificaci&oacute;n:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'>
					<cf_sifclasificacionconcepto query="#rsClasificacion#" form="form" tabindex="1">
				<cfelse>
					<cf_sifclasificacionconcepto form="form" tabindex="1">
				</cfif>
			</td>
		</tr>

		<tr> 
			<td align="right" nowrap>Unidad de Medida:&nbsp;</td>
			<td>
				<select name="Ucodigo" tabindex="1">
					<option value=""></option>
				<cfloop query="rsUnidades">
					<option value="#rsUnidades.Ucodigo#" <cfif modo neq 'ALTA' and trim(rsConceptos.Ucodigo) eq trim(rsUnidades.Ucodigo)  >selected</cfif> >#rsUnidades.Ucodigo# - #rsUnidades.Udescripcion#</option>
				</cfloop>
				</select>
			</td>
		</tr>

	<tr>
	  <td nowrap align="right">Complemento:&nbsp;</td>
		<td nowrap>
			<input type="text" name="cuentac" tabindex="1" size="12" maxlength="100" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsConceptos.cuentac#</cfoutput></cfif>" alt="Complemento">
		</td>
	</tr>
	<tr>
		<td nowrap align="right">Cuenta Gasto:&nbsp;</td>
		<td nowrap>
					<cfif modo EQ "ALTA">
						<cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="Ccuenta" 
							cdescripcion="Cdescripcion2" 
							cformato="Cformato" 
							conexion="#Session.DSN#"
							form="form"
							frame="frCuentac"
							comodin="?" tabindex="1">
					<cfelse>	
						<cfquery name="rsCformato" dbtype="query">
							select ccuenta, Cdescripcion2 as cdescripcion, Cformato from rsConceptos
						</cfquery>
						<cf_cuentasanexo 
							auxiliares="S" 
							movimientos="N"
							conlis="S"
							ccuenta="Ccuenta" 
							cdescripcion="Cdescripcion2" 
							cformato="Cformato" 
							conexion="#Session.DSN#"
							form="form"
							frame="frCuentac"
							query="#rsCformato#"
							comodin="?" tabindex="1">
					</cfif>
		</td>
	</tr>

		<tr> 
			<td align="right" nowrap>&nbsp;</td>
			<td valign="baseline">
				<input type="checkbox" tabindex="1" name="Cimportacion" id="Cimportacion" 
					<cfif (modo neq 'ALTA' and rsConceptos.Cimportacion eq 1)>checked</cfif>>
					<label for="Cimportacion" style="font-style:normal; font-variant:normal; font-weight:normal">Para Importaci&oacute;n&nbsp;</label></td>
		</tr>
		<!--- *************************************************** --->
		<cfif modo NEQ 'ALTA'>
			<tr>
			  <td colspan="2" align="center" class="tituloListas">Complementos Contables</td>
			</tr>
			<tr><td colspan="2" align="center">
			<cf_sifcomplementofinanciero action='display' tabindex="1"
					tabla="Conceptos"
					form = "form"
					llave="#form.Cid#" />		
			</td></tr>
		</cfif>	
		<!--- *************************************************** --->  

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr> 
			<td colspan="2" align="center" nowrap>
				<cfif modo neq "ALTA">
					<cfset masbotones = "CtasConcepto">
					<cfset masbotonesv = "Cuentas por Concepto">
				<cfelse>
					<cfset masbotones = "">
					<cfset masbotonesv = "">
				</cfif>
				<cf_botones modo="#modo#" include="#masbotones#" includevalues="#masbotonesv#" tabindex="1">
			
				<!--- <cfif modo NEQ "ALTA">
					<input name="btnContactos" tabindex="2" type="button" value="Cuentas por Concepto" onClick="javascript: document.form.Ccodigo.disabled = false; CtasConcepto('<cfoutput>trim(#rsConceptos.Ccodigo#)</cfoutput>')">
				</cfif> --->
			</td>
		</tr>
	</table>

	<cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsConceptos.ts_rversion#"/>
		</cfinvoke>
	</cfif>  

  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="Cid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsConceptos.Cid#</cfoutput></cfif>">
  <input type="hidden" name="profundidad" value="<cfoutput>#trim(rsProfundidad.Pvalor)#</cfoutput>">
	
 </form>
 </cfoutput>
 <cf_qforms form="form">
            <cf_qformsRequiredField name="Ccodigo" description="Código">
			<cf_qformsRequiredField name="Cdescripcion" description="Descripción">
			<cf_qformsRequiredField name="CCcodigo" description="Clasificación">
			<cf_qformsRequiredField name="Ctipo" description="Tipo">
</cf_qforms>

<script language="JavaScript" type="text/JavaScript">
	function CtasConcepto(data1, data2, filtro) {
		if (data1!="" && data2!="") {
			location.href = 'CtasConcepto.cfm?Ccodigo='+ data1+'&Cid='+data2+filtro;
		}
		return false;
	}
	function funcCtasConcepto(){
		var filtro;
		document.form.Ccodigo.disabled = false; 
		filtro = '&Pagina='+document.form.Pagina.value+'&filtro_Ccodigo='+document.form.filtro_Ccodigo.value+'&filtro_Cdescripcion='+document.form.filtro_Cdescripcion.value+'&hfiltro_Ccodigo='+document.form.filtro_Ccodigo.value+'&hfiltro_Cdescripcion='+document.form.filtro_Cdescripcion.value+'&fTipo='+document.form.fTipo.value;
		CtasConcepto(document.form.Ccodigo.value,document.form.Cid.value,filtro);
		return false;
	}
	function funcCCcodigo(){
		if( document.form.profundidad.value != (parseInt(document.form.CCnivel.value))+1 ){
			alert('El nivel de Clasificación seleccionada no corresponde al nivel máximo definido en Parámetros.\n Debe seleccionar otra Clasificación.');
			document.form.CCid.value = '';
			document.form.CCcodigo.value = '';
			document.form.CCdescripcion.value = '';
			document.form.CCnivel.value = '';
		}
	}	

 	<cfif modo NEQ "ALTA">
 		document.form.Cdescripcion.focus();
	<cfelse>
		document.form.Ccodigo.focus();
 	</cfif> 
</script>
