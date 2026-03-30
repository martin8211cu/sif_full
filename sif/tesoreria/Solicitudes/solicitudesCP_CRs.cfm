<cf_templatecss>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Créditos</title>
</head>

<body>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select TESDPid, TESDPdocumentoOri as numero, TESDPreferenciaOri as Referencia 
	  from TESdetallePago
	 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.creditos#">
</cfquery>
<p><strong>Registro de Créditos para el Pago</strong></p>
<form name="form1" action="solicitudesCP_sql.cfm" method="post" onSubmit="return sbAgregar();">
	<input type="hidden" name="TESSPid" value="#url.creditos#" />
	<table>
		<tr>
			<td>
				Documento:		
			</td>
			<td>
				<select name="TESDPID">
				<cfoutput query="rsSQL">
					<option value="#rsSQL.TESDPid#">#rsSQL.numero# - #rsSQL.referencia#</option>
				</cfoutput>
				</select>
			</td>
		</tr>
	     <tr>		
		<cfquery name="rsRetencion" datasource="#session.dsn#">
			select 
			    Rcodigo, Rdescripcion,Ccuentaretp, (select min(rtrim(CFformato)) from CFinanciera where Ccuenta=a.Ccuentaretp) as CFformato
		  from Retenciones a 
		         where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
			<td>
				Retención:
			</td>
			<td>
				<select name="Retencion" id="Retencion" onchange="funcPoneCuenta(this)">
				<option value="">Sin Retención</option>
				<cfoutput query="rsRetencion">				
					<option value="#rsRetencion.Rcodigo#,#rsRetencion.Ccuentaretp#,#rsRetencion.CFformato#">#rsRetencion.Rdescripcion#</option>
				</cfoutput>
				</select>
				<input type="hidden" id="Rcodigo" name="Rcodigo"/>
          <script language="javascript" type="text/javascript">
          function funcPoneCuenta(o)
          {
		  	var i=o.selectedIndex;
			if (o[i].value == "")
			{
			  document.form1.Rcodigo.value = "";
			}
			else
			{
				var LvarRet = o[i].value.split(",");
				document.form1.Rcodigo.value = LvarRet[0];
				o.form.descripcion.value = o[i].text;
				o.form.Ccuenta.value = LvarRet[1];
				o.form.Cmayor.value = LvarRet[2].substr(0,4);
				o.form.Cdescripcion.value = "";
				o.form.Cformato.value = "";
				if (LvarRet[1] == "")
				{
					alert ('No se definió cuenta para la Retención');
					return;
				}
				TraeMascaraCuenta(LvarRet[2].substr(0,4), 'frcuentas', ConlisArgumentsCcuenta());
				window.setTimeout("document.form1.Cformato.focus(); document.form1.Cformato.value = '" + LvarRet[2].substr(5) + "'; document.form1.Cformato.blur();",500);
			}
          }
            </script>
			</td>
		</tr>
		<tr>
			<td>
				Descripcion:
			</td>
			<td>
				<input type="text" size="60"  name="descripcion">		
			</td>
		</tr>	
		<tr>
			<td>
				Cuenta:		
			</td>
			<td>
				<cf_cuentas >
			</td>
		</tr>
	
		<tr>
			<td>
				Monto:		
			</td>
			<td>
				<cf_inputnumber 
							name="monto" 
							form="form1" 
							enteros="15" 
							decimales="2" 
				>
			</td>
		</tr>
	
		<tr>
			<td>
			</td>
			<td>
				<input type="submit" name="btnAgregarCR" value="Agregar Credito"> 	
    		</td>
		</tr>
	</table>
</form>
<script language="javascript">
	function sbAgregar()
	{
		if (document.form1.TESDPID.value == '')
		{
			alert ("No puede dejar el Documento en blanco");
			return false;
		}
		else if (document.form1.descripcion.value == '')
		{
			alert ("No puede dejar la Descripcion en blanco");
			return false;
		}
		else if (document.form1.CFcuenta.value == '')
		{
			alert ("No puede dejar la Cuenta Financiera en blanco");
			return false;
		}
		else if (document.form1.monto.value == '')
		{
			alert ("No puede dejar el Monto en blanco");
			return false;
		}
		return true;
	}
</script>
</body>
</html>
