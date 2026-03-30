<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Detalle</title>
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cf_templatecss>
<cfsavecontent variable="dummy">
<cfinclude template="flash-update-campos.cfm"></cfsavecontent>
<cfoutput>


<cfparam name="url.FMT01COD" >

<!--- Encabezado --->
<cfquery name="encabezado" datasource="#session.DSN#">
	select FMT01TIP, c.FMT01SP1, c.FMT01SP2
	from FMT001 b
		left join FMT000 c
			on b.FMT01TIP = c.FMT00COD
	where b.FMT01COD=<cfqueryparam cfsqltype="cf_sql_char" value="#session.FMT01COD#">
 	  and (b.Ecodigo is null or b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
</cfquery>

<!--- Form--->
<cfquery name="rsForm" datasource="#session.DSN#">
	select FMT02LIN, FMT11NOM, FMT02FMT, rtrim(FMT02PRE) as FMT02PRE, rtrim(FMT02SUF) as FMT02SUF
	from FMT002
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#session.FMT01COD#">
	  and FMT11NOM is not null
</cfquery>

<form name="form1" method="post" target="_parent" action="FMT002-sql.cfm" >
	<input type="hidden" name="FMT01COD" value="#form.FMT01COD#">
	<table border="0" cellpadding="0" cellspacing="0">
	  <!--DWLayoutTable-->

		<tr>
		  <td width="96">&nbsp;</td>
		  <td width="16">&nbsp;</td>
		  <td width="309">&nbsp;</td>
	  </tr>
		<tr>
			<td>&nbsp;</td>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
	    </tr>
		<tr>
			<td colspan="3" valign="top">
			  <div align="center" class="subTitulo">
				  <font size="3">
					  <strong>Formatos de Campos
					  </strong>
				  </font>
		      </div></td>
		</tr>
		<tr>
			<td>
				<strong>Campo</strong>
			</td>
			<td>
				<strong>Formato</strong>
			</td>
		</tr>
		<cfloop query="rsForm">
		<tr>
			<td colspan="2">
				<input type="hidden" name="FMT02LIN" value="#rsForm.FMT02LIN#">
				#rsForm.FMT11NOM#  
			</td>
		</tr>
		<tr>
			<td></td>
			<td nowrap>
				<input type="text" name="FMT02PRE_#rsForm.FMT02LIN#" value="#rsForm.FMT02PRE#" size="2" style="text-align:right;" title="Prefijo: caracteres antes del dato formateado">
				<select name="FMT02FMT_#rsForm.FMT02LIN#"
						onchange="
							if (this.value == -2) 
								this.selectedIndex += 1;
						"
				>
					<option value="-1" <cfif rsForm.FMT02FMT eq '-1'>selected</cfif> >No Aplicar</option>
					<option value="-2" disabled>--VALOR NUMERICO:--</option>
					<option value="##" <cfif rsForm.FMT02FMT eq "##" or rsForm.FMT02FMT eq '######'>selected</cfif>>##</option>
					<option value="##0" <cfif rsForm.FMT02FMT eq '##0'>selected</cfif>>##0</option>
					<option value="##,####0" <cfif rsForm.FMT02FMT eq '##,####0'>selected</cfif>>##,####0</option>
					<option value="##0.00" <cfif rsForm.FMT02FMT eq '##0.00'>selected</cfif>>##0.00</option>
					<option value="######,######,######,######,####0.00" <cfif rsForm.FMT02FMT eq '######,######,######,######,####0.00'>selected</cfif>>##,####0.00</option>
					<option value="##0.0000" <cfif rsForm.FMT02FMT eq '##0.000' or rsForm.FMT02FMT eq '##0.0000'>selected</cfif>>##0.0000</option>
					<option value="######,######,######,######,####0.0000" <cfif rsForm.FMT02FMT eq '######,######,######,######,####0.0000'>selected</cfif>>##,####0.0000</option>
					<option value="MONTOENLETRAS" <cfif rsForm.FMT02FMT eq 'MONTOENLETRAS'>selected</cfif>>Monto en Letras</option>
					<option value="AMOUNTINWORDS" <cfif rsForm.FMT02FMT eq 'AMOUNTINWORDS'>selected</cfif>>Amount in Words</option>

					<option value="-2" disabled>--VALOR FECHA:--</option>
					<option value="dd/MM/yyyy" <cfif rsForm.FMT02FMT eq 'dd/MM/yyyy'>selected</cfif>>dd/MM/yyyy</option>
					<option value="dd/MMM/yyyy" <cfif rsForm.FMT02FMT eq 'dd/MMM/yyyy'>selected</cfif>>dd/MMM/yyyy</option>
					<option value="MMM/dd/yyyy" <cfif rsForm.FMT02FMT eq 'MMM/dd/yyyy'>selected</cfif>>MMM/dd/yyyy</option>
					<option value="MM/dd/yyyy" <cfif rsForm.FMT02FMT eq 'MM/dd/yyyy'>selected</cfif>>MM/dd/yyyy</option>
					<option value="FECHAENLETRAS" <cfif rsForm.FMT02FMT eq 'FECHAENLETRAS'>selected</cfif>>Fecha en Letras</option>
					<option value="DATEINWORDS" <cfif rsForm.FMT02FMT eq 'DATEINWORDS'>selected</cfif>>Date in Words</option>
					<option value="hh:mm:ss" <cfif rsForm.FMT02FMT eq 'hh:mm:ss'>selected</cfif>>hh:mm:ss</option>
					<option value="hh:mm" <cfif rsForm.FMT02FMT eq 'hh:mm'>selected</cfif>>hh:mm</option>
				</select>		  
				<input type="text" name="FMT02SUF_#rsForm.FMT02LIN#" value="#rsForm.FMT02SUF#" size="2" title="Sufijo: caracteres despues del dato formateado">
			</td>
		</tr>
		</cfloop>
		<cfif rsForm.recordcount GT 0>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<input type="submit" name="btnCambiaFmts" value="Cambiar">
			</td>
		</tr>
		</cfif>
</cfoutput>

</body>
</html>
