<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfparam name="form.tarjeta_id" type="numeric">
<cfparam name="form.MEDdescripcion" default="">
<cfparam name="form.MEDimporte" default="">
<cfparam name="form.MEDmoneda" default="">
<cfparam name="form.MEDproyecto" default="">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from MEDTarjetas
	where MEDtcid   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.tarjeta_id#">
	  and MEpersona = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.MEpersona#" null="#Len(session.MEpersona) EQ 0#">
</cfquery>

<cfquery datasource="asp" name="rsPais">
	select Ppais, Pnombre
	from Pais
	order by Pnombre
</cfquery>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Modificar Datos de Tarjeta
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfset ArrayAppend(navBarItems,'Donaciones')>
	<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/publico/donacion.cfm')>
	<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
	<cfset Regresar = "javascript:history.back()">
	<cfinclude template="pNavegacion.cfm">

<cfoutput>
	<form action="tarjeta_edit_apply.cfm" method="post" style="margin:0">
	<input type="hidden" name="id" value="#data.MEDtcid#">
	<input type="hidden" name="back_MEDdescripcion" value="#form.MEDdescripcion#">
	<input type="hidden" name="back_MEDimporte" value="#form.MEDimporte#">
	<input type="hidden" name="back_MEDmoneda" value="#form.MEDmoneda#">
	<input type="hidden" name="back_MEDproyecto" value="#form.MEDproyecto#">

				<cf_web_portlet titulo="" border="true" skin="info1" >
					<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td width="80%">
								<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
									<tr><td align="center"><b>Donaciones por Internet</b></td></tr>
									<tr>
										<td><p>Si desea contribuir con nuestro esfuerzo de anunciar la Buena Nueva, puede hacer una donación a nuestra Iglesia. Sólo tiene que llenar el siguiente formulario.</p></td>  
									</tr>
									<tr>
										<td><p>Esta información es totalmente confidencial y la misma está protegida para máxima seguridad. Ningún usuario del Internet puede leer esta información, la misma ha sido codificada exclusivamente para nuestra Iglesia.</p></td>
									</tr>
								</table>
							</td>
							<td width="20%" align="center" valign="middle"><img border="0" src="images/Verisign-Secure-White98x102.gif" ></td>
						</tr>
					</table>
				</cf_web_portlet>
<p></p>
<table width="100%"  border="0" cellspacing="0" cellpadding="3" style="border-top-width:1px; border-top-style:solid; border-top-color:##999999; border-left-width:1px; border-left-style:solid; border-left-color:##999999; border-right-width:1px; border-right-style:solid; border-right-color:##999999; border-bottom-width:1px; border-bottom-style:solid; border-bottom-color:##999999;">

		<tr><td colspan="2" class="tituloListas" align="center">Datos de la Tarjeta</td></tr>

		<tr>
			<td align="right"><b>Tipo de Tarjeta:&nbsp;</b></td>
			<td>
				<select name="MEDtctipo">
					<option value="VISA" <cfif data.MEDtctipo is 'VISA'>selected</cfif> >Tarjeta de Crédito VISA</option>
					<option value="AMEX" <cfif data.MEDtctipo is 'AMEX'>selected</cfif> >Tarjeta de Crédito American Express</option>
					<option value="MC"   <cfif trim(data.MEDtctipo) is 'MC'>  selected</cfif> >Tarjeta de Crédito MasterCard</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<td align="right"><b>No. Tarjeta:&nbsp;</b></td>
			<td>
				<input name="MEDtcnumero" onFocus="this.select()" type="text" size="25" maxlength="20" value="<cfif trim(data.MEDtcnumero GT 4)>#repeatstring('X', len(trim(data.MEDtcnumero))-4)##right(trim(data.MEDtcnumero), 4)#<cfelse>#trim(data.MEDtcnumero)#</cfif>">
			</td>
		</tr>
		
		<tr>
			<td nowrap align="right"><b>Nombre como aparece en la Tarjeta:&nbsp;</b></td>
			<td valign="top">
				<input name="MEDtcnombre" onFocus="this.select()" type="text" size="35" maxlength="60" value="#data.MEDtcnombre#">
			</td>
		</tr>

		<tr>
			<td nowrap align="right"><b>Vencimiento:&nbsp;</b></td>
			<td>
			<cfset l_mes = Mid(data.MEDtcvence,1,2)>
			<cfset l_ano = Mid(data.MEDtcvence,4,2)>
				<select name="mm">
					<option value="01" <cfif l_mes eq 01>selected</cfif> >01 - Enero</option> 
					<option value="02" <cfif l_mes eq 02>selected</cfif> >02 - Febrero</option> 
					<option value="03" <cfif l_mes eq 03>selected</cfif> >03 - Marzo</option> 
					<option value="04" <cfif l_mes eq 04>selected</cfif> >04 - Abril</option> 
					<option value="05" <cfif l_mes eq 05>selected</cfif> >05 - Mayo</option> 
					<option value="06" <cfif l_mes eq 06>selected</cfif> >06 - Junio</option> 
					<option value="07" <cfif l_mes eq 07>selected</cfif> >07 - Julio</option> 
					<option value="08" <cfif l_mes eq 08>selected</cfif> >08 - Agosto</option> 
					<option value="09" <cfif l_mes eq 09>selected</cfif> >09 - Setiembre</option> 
					<option value="10" <cfif l_mes eq 10>selected</cfif> >10 - Octubre</option> 
					<option value="11" <cfif l_mes eq 11>selected</cfif> >11 - Noviembre</option> 
					<option value="12" <cfif l_mes eq 12>selected</cfif> >12 - Diciembre</option> 
				</select>
				<select name="yy" >
					<cfset ano = DatePart('yyyy', Now())>
					<cfloop from="#ano#" to="#ano+20#" step="1" index="i">
						<option value="#i#"  <cfif l_ano eq right(i,2)>selected</cfif>>#i#</option>
					</cfloop>
				</select>
			</td>
		</tr>

		<tr>
			<td nowrap align="right"><b>Dígito Verificador:&nbsp;</b></td>
			<td><input name="MEDtcdigito" onFocus="this.select()" type="text" size="8" maxlength="5" value="#data.MEDtcdigito#"></td>
		</tr>

		<tr>
			<td nowrap align="right"><b>Dirección 1:&nbsp;</b></td>
			<td ><input name="MEDtcdireccion1" onFocus="this.select()" size="70" maxlength="255" value="#Trim(data.MEDtcdireccion1)#" ></td>
		</tr>

		<tr>
			<td nowrap align="right"><b>Dirección 2:&nbsp;</b></td>
			<td ><input name="MEDtcdireccion2" onFocus="this.select()" size="70" maxlength="255"  value="#Trim(data.MEDtcdireccion2)#"  ></td>
		</tr>

		<tr>
			<td align="right"><b>Ciudad:&nbsp;</b></td>
			<td valign="top"><input name="MEDtcciudad" onFocus="this.select()" type="text" size="30" maxlength="30" value="#Trim(data.MEDtcciudad)#" ></td>
		</tr>

		<tr>
			<td align="right"><b>Estado:&nbsp;</b></td>
			<td valign="top"><input name="MEDtcestado" onFocus="this.select()" type="text" size="30" maxlength="30" value="#Trim(data.MEDtcestado)#" ></td>
		</tr>

		<tr>
			<td align="right"><b>Código Postal:&nbsp;</b></td>
			<td valign="top"><input name="MEDtczip" onFocus="this.select()" type="text" size="30" maxlength="60" value="#Trim(data.MEDtczip)#"></td>
		</tr>

		<tr>
			<td align="right"><b>País:&nbsp;</b></td>
			<td valign="top">
				<select name="MEDtcpais">
					<cfloop query="rsPais">
						<option value="#rsPais.Ppais#" <cfif data.MEDtcpais eq  rsPais.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr align="center">
		  <td colspan="2">
		  
		  <input type="submit" value="Modificar">
		  <input type="button" value="Cancelar" onClick="javascript:history.back()">
		  </td>
	  </tr>
	</table>
</form>
</cfoutput>
</body>
</html>
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
</cf_template>
