<cfif isdefined("Url.ESid") and Len(Trim(Url.ESid))>
	<cfparam name="Form.ESid" default="#Url.ESid#">
</cfif>

<html>
<head>
<title>Copiar Escala Salarial</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
	<cfif isdefined("Form.btnCopiar") and isdefined("Form.ESid") and Len(Trim(Form.ESid))>
		<!--- Chequear si ya existe la Escala Actual --->
		<cfquery name="chkEscalas" datasource="#Session.DSN#">
			select count(1) as cantidad
			from RHEscalaSalHAY
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and EScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EScodigo#">
		</cfquery>
		<cfif chkEscalas.cantidad GT 0>
			<p align="center">
				<strong>Ya existe una escala con el mismo código</strong><br><br>
				<input type="button" value="Regresar" onClick="javascript: history.back();">
			</p>
		<cfelse>
			<cftransaction>
				<!--- Actualizar Escala Previa a la Actual --->
				<cfquery name="updUltimaEscala" datasource="#Session.DSN#">
					update RHEscalaSalHAY set
						ESfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', -1, LSParseDateTime(Form.ESfdesde))#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and ESfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100,01,01)#">
				</cfquery>
				
				<!--- Insercion del Encabezado de Escala Salarial --->
				<cfquery name="insEscala" datasource="#Session.DSN#">
					insert into RHEscalaSalHAY (Ecodigo, EScodigo, ESdescripcion, ESestado, ESfdesde, ESfhasta, ESreferencia, EStipo, ESporcinc, ESdescaumento, fechaalta, BMUsucodigo)
					select Ecodigo, 
						   <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EScodigo#">, 
						   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESdescripcion#">, 
						   0, 
						   <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ESfdesde)#">, 
						   <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100,01,01)#">, 
						   EScodigo, 
						   EStipo, 
						   <cfqueryparam cfsqltype="cf_sql_float" value="#Form.ESporcinc#">, 
						   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESdescaumento#">, 
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					from RHEscalaSalHAY
					where ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					<cf_dbidentity1 datasource="#Session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="insEscala">
				<cfset newESid = insEscala.identity>
	
				<!--- Insercion de los Niveles de la Escala Salarial --->
				<cfquery name="insNiveles" datasource="#Session.DSN#">
					insert into RHDEscalaSalHAY (ESid, DESnivel, DESptodesde, DESptohasta, DESsalmin, DESsalmax, DESsalprom, fechaalta, BMUsucodigo)
					select
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#newESid#">,
						DESnivel, DESptodesde, DESptohasta, DESsalmin * #(Form.ESporcinc / 100.0)+1#, DESsalmax * #(Form.ESporcinc / 100.0)+1#, DESsalprom * #(Form.ESporcinc / 100.0)+1#, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					from RHDEscalaSalHAY
					where ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
				</cfquery>
	
				<!--- Inserción de las Excepciones de cada Nivel Salarial --->
				<cfquery name="insExcepciones" datasource="#Session.DSN#">
					insert into RHNivelesPuestoHAY (DESlinea, Ecodigo, RHPcodigo, salmin, salmax, salprom, puntosactuales, fechaalta, BMUsucodigo)
					select
						c.DESlinea,
						b.Ecodigo,
						b.RHPcodigo,
						b.salmin * #(Form.ESporcinc / 100.0)+1#,
						b.salmax * #(Form.ESporcinc / 100.0)+1#,
						b.salprom * #(Form.ESporcinc / 100.0)+1#,
						b.puntosactuales, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					from RHDEscalaSalHAY a
						inner join RHNivelesPuestoHAY b
							on b.DESlinea = a.DESlinea
						inner join RHDEscalaSalHAY c
							on c.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#newESid#">
							and c.DESnivel = a.DESnivel
					where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
				</cfquery>
			</cftransaction>
			<script language="javascript" type="text/javascript">
				window.opener.reloadPage('<cfoutput>#newESid#</cfoutput>');
				window.close();
			</script>
		</cfif>
			
	<cfelse>
		<cfquery name="ultimaFechaTipo0" datasource="#Session.DSN#">
			select coalesce(max(ESfdesde), <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(1900, 01, 01)#">) as fecha
			from RHEscalaSalHAY 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<cf_templatecss>
		<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
		<cfoutput>
			<form name="form1" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0px;">
				<cfif isdefined("Form.ESid") and Len(Trim(Form.ESid))>
					<input type="hidden" name="ESid" id="ESid" value="#Form.ESid#">
				</cfif>
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td align="right" class="fileLabel">C&oacute;digo:</td>
					<td>
						<input name="EScodigo" type="text" id="EScodigo" size="12" maxlength="10" value="">
					</td>
					<td align="right" class="fileLabel">Descripci&oacute;n:</td>
					<td>
						<input name="ESdescripcion" type="text" id="ESdescripcion" size="40" maxlength="80" value="">
					</td>
				    <td align="right" class="fileLabel">Fecha Rige:</td>
				    <td>
						<cf_sifcalendario form="form1" name="ESfdesde">
					</td>
				  </tr>
				  <tr>
				    <td colspan="3" align="right" class="fileLabel">Descripci&oacute;n Aumento:</td>
				    <td>
						<input name="ESdescaumento" type="text" id="ESdescaumento" size="40" maxlength="80">
					</td>
			        <td align="right" class="fileLabel">Porcentaje Incremento:</td>
			        <td>
                      <input name="ESporcinc" type="text" id="ESporcinc" size="8" maxlength="6" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="0.00"> &nbsp; % 
					 </td>
				  </tr>
				  <tr>
					<td colspan="6" align="center">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="6" align="center">
						<input name="btnCopiar" type="submit" id="btnCopiar" value="Copiar">
					</td>
				  </tr>
				</table>
			</form>
		</cfoutput>

		<cf_qforms form="form1" objForm="objForm1">
		<script language="javascript" type="text/javascript">
			var valFechas = '<cfoutput>#LSDateFormat(ultimaFechaTipo0.fecha, 'dd/mm/yyyy')#</cfoutput>';
		
			function __isFecha() {
				if (this.required) {
					var a = valFechas.split("/");
					var ultimaFecha = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
					var b = this.obj.form.ESfdesde.value.split("/");
					var fechaRige = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
					if (fechaRige <= ultimaFecha) {
						this.error = "La Fecha Rige debe ser mayor a la última Fecha Rige de las escalas existentes que son del mismo tipo seleccionado";
					}
				}
			}
	
			_addValidator("isFecha", __isFecha);

			objForm1.EScodigo.required = true;
			objForm1.EScodigo.description = "Código";
			objForm1.ESdescripcion.required = true;
			objForm1.ESdescripcion.description = "Descripción";
			objForm1.ESfdesde.required = true;
			objForm1.ESfdesde.description = "Fecha Rige";
			objForm1.ESfdesde.validateFecha();
			objForm1.ESdescaumento.required = true;
			objForm1.ESdescaumento.description = "Descripción de Aumento";
			objForm1.ESporcinc.required = true;
			objForm1.ESporcinc.description = "Porcentaje de Incremento";
		</script>

	</cfif>
</body>
</html>
