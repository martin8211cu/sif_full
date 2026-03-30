<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<cfinclude template="../Application.cfm">
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 50
		and Mcodigo = 'GN'
</cfquery>
<cfset rsPeriodos = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodos,3)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-2,1)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-1,2)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor,3)>
<cfquery name="rsMes" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 60
		and Mcodigo = 'GN'
</cfquery>
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>
<cfoutput>
<form name="form1" method="post" action="">
  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
    <tr>
      <th colspan="2" nowrap scope="row"><div align="right"></div></th>
    </tr>
    <tr>
      <th width="50%" nowrap scope="row"><div align="right">Periodo: </div></th>
      <td nowrap><div align="left">
        <select name="Periodo" onChange="javascript:CambiarMes();">
				<cfloop query="rsPeriodos">
					<option value="#Pvalor#" <cfif rsPeriodo.Pvalor eq rsPeriodos.Pvalor>selected</cfif>>#Pvalor#</option>
				</cfloop>
        </select>
      </div></td>
    </tr>
    <tr>
      <th width="50%" nowrap scope="row"><div align="right">Mes:</div></th>
      <td nowrap><div align="left">
        <select name="Mes">
        </select>
      </div></td>
    </tr>
    <tr>
      <th colspan="2" nowrap scope="row"><div align="right"></div></th>
    </tr>
  </table>
</form>
</cfoutput>
</body>
</html>
<script language="javascript" type="text/javascript">
<!--//

	function CambiarMes(){
		var oCombo = document.form1.Mes;
		var vPeriodo = document.form1.Periodo.value;
		var cont = 0;
		oCombo.length=0;
		<cfoutput query="rsMeses">
			if ( (#Trim(rsPeriodo.Pvalor)# > vPeriodo) || ((#Trim(rsPeriodo.Pvalor)# == vPeriodo) && (#Trim(rsMes.Pvalor)# >= #rsMeses.Pvalor#)) )
			{
				oCombo.length=cont+1;
				oCombo.options[cont].value='#Trim(rsMeses.Pvalor)#';
				oCombo.options[cont].text='#Trim(rsMeses.Pdescripcion)#';
				<cfif rsMeses.Pvalor eq rsMes.Pvalor>
					if (#Trim(rsPeriodo.Pvalor)# == vPeriodo)
						oCombo.options[cont].selected = true;
				</cfif>
				cont++;
			};
		</cfoutput>
	}
	
	CambiarMes();

//-->
</script>