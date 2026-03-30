<cfoutput>

<cfquery name="rsHDocumentos" datasource="#session.DSN#">
	select	b.SNnombre, 
			a.SNcodigo, 
			a.CCTcodigo, 
			a.Ddocumento, 
			a.Dfecha, 
			a.Dsaldo, 
			a.Dtotal, 
			c.Mnombre, 
			substring(a.DEobservacion,1,10) as DEobservacion, 
			a.DEnumReclamo, 
			a.DEordenCompra, 
			a.HDid, 
			a.CDCcodigo, 
			cl.CDCidentificacion, 
			cl.CDCtipo

	from HDocumentos a

	inner join SNegocios b
	on b.Ecodigo = a.Ecodigo
	and b. SNcodigo = a.SNcodigo

	inner join Monedas c
	on c.Mcodigo = a.Mcodigo
	and c.Ecodigo = a.Ecodigo

	left outer join ClientesDetallistasCorp cl
	on cl.CDCcodigo = a.CDCcodigo

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
	  and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#">

		<cfif isdefined("form.SNcodigo") and len(form.SNcodigo) gt 0>
	  		and	a.SNcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		</cfif>
	
		<cfif isdefined("form.HDid") and len(trim(form.HDid))>
	  		and a.HDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.HDid#">
		</cfif>

		<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
	  		and c.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mcodigo#">
		</cfif>

</cfquery>

<cfif rsHDocumentos.recordcount GT 0>
	<cfset form.SNcodigo = rsHDocumentos.SNcodigo>
</cfif>

<!--- 
	<cfdump var="#form#">
	<cfdump var="#rsHDocumentos#"> 
--->
<script language="JavaScript" src="../../js/utilesMonto.js"></script>

<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
	<!--- <tr>
		<td colspan="2" class="subTitulo" style="text-transform:uppercase" align="center">Registro de Reclamos</td>
	</tr> --->
	<tr>
		<td colspan="4" align="center">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<fieldset><legend>Registro&nbsp;de&nbsp;Reclamos</legend>
			<form name="form1" action="RegReclamoModCC-sql.cfm" method="post">
			<table  width="95%" align="center" border="0" cellspacing="2" cellpadding="0">
				<tr>
					<td align="right" width="20%"><strong>Documento:&nbsp;</strong></td>
					<td align="left" width="20%"><cfif isdefined("form.Ddocumento") and len(trim(form.Ddocumento))>&nbsp;#rsHDocumentos.Ddocumento#</cfif></td>
					<td align="right" width="10%"><strong>Transacci&oacute;n:&nbsp;</strong></td>
					<td align="left" width="20%"><cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>&nbsp;#rsHDocumentos.CCTcodigo#</cfif></td>

				</tr>
				<tr>
					<td align="right" width="20%"><strong>Socio&nbsp;de&nbsp;Negocios:&nbsp;</strong></td>
					<td align="left" width="20%" colspan="3">
						<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>&nbsp;#rsHDocumentos.SNcodigo#&nbsp;&nbsp;-&nbsp;&nbsp;#rsHDocumentos.SNnombre#</cfif>
					</td>
				</tr>
				<tr>
					<td align="right" width="20%"><strong>Fecha&nbsp;del&nbsp;Documento:&nbsp;</strong></td>
					<td align="left" width="20%"><cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>&nbsp;#dateformat(rsHDocumentos.Dfecha,"dd/mm/yyyy")#</cfif></td>
					<td align="right" width="10%"><strong>Monto:&nbsp;</strong></td>
					<td align="left" width="20%"><input name="Dtotal" type="text" tabindex="-11" value="<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>&nbsp;#rsHDocumentos.Dtotal#</cfif>" onfocus=" this.select(); this.value=qf(this);" onblur="fm(this,2);" class="cajasinborde" readonly></td>
				</tr>
				<tr>
					<td align="right" width="20%"><strong>Moneda:&nbsp;</strong></td>
					<td align="left" width="20%"><cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>&nbsp;#rsHDocumentos.Mnombre#</cfif></td>
					<td align="right" width="10%"><strong>Observaciones:&nbsp;</strong></td>
					<td align="left" width="20%"><cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>&nbsp;#rsHDocumentos.DEobservacion#</cfif></td>
				</tr>
				<tr>
					<td align="right" width="20%"><strong>N&uacute;mero&nbsp;de&nbsp;Reclamo:&nbsp;</strong></td>
					
					<td align="left" width="20%">
						<input name="DEnumReclamo" type="text" size="20" maxlength="20" tabindex="1"
							value="<cfif isdefined("rsHDocumentos.DEnumReclamo") and len(trim(#rsHDocumentos.DEnumReclamo#)) GT 0>#rsHDocumentos.DEnumReclamo#<cfelse>&nbsp;</cfif>" >
					</td>
					<td align="right" width="10%"><strong>N&uacute;mero&nbsp;de&nbsp;Orden:&nbsp;</strong></td>
					<td align="left" width="20%"><input name="DEordenCompra" type="text" tabindex="1" value="<cfif isdefined("rsHDocumentos.DEordenCompra") and len(trim(#rsHDocumentos.DEordenCompra#)) GT 0>#rsHDocumentos.DEordenCompra#<cfelse>&nbsp;</cfif>" size="20" maxlength="20"></td>
				</tr>

				<tr>
					<td align="right" width="20%">
						<strong>Cliente Final:&nbsp;</strong>
					</td>
					<td colspan="3">
						<cf_sifclientedetcorp modo='CAMBIO' idquery='#rsHDocumentos.CDCcodigo#' tabindex="1">
					</td>
				</tr>
				<tr><td colspan="4" align="center">&nbsp;</td></tr>
				<tr>
					<td colspan="4" align="center">
					<!--- <input name="Aplicar" type="submit" value="Aplicar" onClick="javascript: funcAplicar();">
					<input name="Regresar" type="submit" value="Regresar" onClick="javascript: funcRegresar();"> --->
					<cf_botones values="Aplicar,Regresar" names="Aplicar,Regresar" regresarMenu ="true" tabindex="1">
					</td>
				</tr>
				
			</table>
			<input name="HDid" type="hidden" value="<cfif isdefined("rsHDocumentos.HDid") and len(trim(rsHDocumentos.HDid))>#rsHDocumentos.HDid#</cfif>">
			<input name="SNcodigo" type="hidden" value="<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>#form.SNcodigo#</cfif>">
			<input name="CCTcodigo" type="hidden" value="<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>#form.CCTcodigo#</cfif>">
			<input name="Ddocumento" type="hidden" value="<cfif isdefined("form.Ddocumento") and len(trim(form.Ddocumento))>#form.Ddocumento#</cfif>">

			<cfif isdefined("Form.CCTcodigoE1") and Len(Trim(Form.CCTcodigoE1))>
				<input type="hidden" name="CCTcodigoE1" value="#Form.CCTcodigoE1#" />
			</cfif>
			<cfif isdefined("Form.CCTcodigoE2") and Len(Trim(Form.CCTcodigoE2))>
				<input type="hidden" name="CCTcodigoE2" value="#Form.CCTcodigoE2#" />
			</cfif>
			<cfif isdefined("Form.Corte") and Len(Trim(Form.Corte))>
				<input type="hidden" name="Corte" value="#form.Corte#" />
			</cfif>
			<cfif isdefined("Form.Corte2") and Len(Trim(Form.Corte2))>
				<input type="hidden" name="Corte2" value="#form.Corte2#" />
			</cfif>
			<cfif isdefined("Form.Documento") and Len(Trim(Form.Documento))>
				<input type="hidden" name="Documento" value="#form.Documento#" />
			</cfif>

			<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo))>
				<input type="hidden" name="Mcodigo" value="#form.Mcodigo#" />
			</cfif>
			<cfif isdefined('form.Pagina')>
				<input name="Pagina" type="hidden" value="#form.Pagina#">
			</cfif>
			</form>
			</fieldset>
			<tr>
				<td colspan="4" align="center">&nbsp;</td>
			</tr>
		</td>
	</tr>		
</table>

<script language="javascript1.1" type="text/javascript">
	function funcAplicar(){
		if (confirm('¿Desea aplicar el Reclamo?')){
			return true;
		}else{
			return false;
		}
	}
	 
	function funcRegresar() {
		var params = "";
		<cfoutput>
			<cfif isdefined("Form.CCTcodigoE1") and Len(Trim(Form.CCTcodigoE1))>
				params = params + "&CCTcodigoE1=#Form.CCTcodigoE1#";
			</cfif>
			<cfif isdefined("Form.CCTcodigoE2") and Len(Trim(Form.CCTcodigoE2))>
				params = params + "&CCTcodigoE2=#Form.CCTcodigoE2#";
			</cfif>
			<cfif isdefined("Form.Corte") and Len(Trim(Form.Corte))>
				params = params + "&Corte=#Form.Corte#";
			</cfif>
			<cfif isdefined("Form.Corte2") and Len(Trim(Form.Corte2))>
				params = params + "&Corte2=#Form.Corte2#";
			</cfif>
			<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo))>
				params = params + "&SNcodigo=#Form.SNcodigo#";
			</cfif>

			<cfif isdefined("Form.CCTcodigo") and Len(Trim(Form.CCTcodigo))>
				params = params + "&CCTcodigo=#Form.CCTcodigo#";
			</cfif>

			<cfif isdefined("Form.Documento") and Len(Trim(Form.Documento))>
				params = params + "&Documento=#Form.Documento#";
			</cfif>

			<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo))>
				params = params + "&Mcodigo=#Form.Mcodigo#";
			</cfif>
			<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
				params = params + "&Pagina=#Form.Pagina#";
			</cfif>


		</cfoutput>
		location.href = "RegReclamoCC.cfm?Consultar=1"+params;
		return false;
	}
	
</script>

</cfoutput>
