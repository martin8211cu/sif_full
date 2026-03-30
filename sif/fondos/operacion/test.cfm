<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>PRUEBAS</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfif isdefined("subm")>

	<cfquery datasource="#session.Fondos.dsn#"  name="sql2" > 
		SELECT  CJM08NOM,CJM08TIP  
		FROM CJM008  
		WHERE CJM07COD ='CA05'		  
	</cfquery> 
	 
	<cfset CJX22INF = "">
	<cfoutput query="sql2">
	
					<cfswitch expression = #sql2.CJM08TIP#>
						<cfcase value="50;62;56;60" delimiters=";"> <!--- NUMERICO --->
							<cfset CJX22INF = CJX22INF & sql2.CJM08NOM &"="& Trim('2') & "¶">
						</cfcase>
						<cfcase value="47;39" delimiters=";">  <!--- ALFANUMERICO --->							
							<cfif sql2.CJM08NOM eq "NUMEN">
							<cfset valor="601310329">
							</cfif>
							<cfif sql2.CJM08NOM eq "NOMEN">
							<cfset valor="LUIS A. APU LEITON">
							</cfif>
							<cfif sql2.CJM08NOM eq "NUMRE">
							<cfset valor="70736">
							</cfif>																					
							<cfset CJX22INF = CJX22INF & sql2.CJM08NOM &"="& Trim('#valor#') & "¶">
						</cfcase>
						<cfcase value="61" delimiters=";">  <!--- Fecha --->							
							<cfset CJX22INF = CJX22INF & sql2.CJM08NOM &"="& #Trim((dateformat(Evaluate(Evaluate('sql2.CJM08NOM')),"yyyymmdd")))#&"¶">
						</cfcase>     
					</cfswitch>				
	</cfoutput>
	<cfset CJX22INF = mid(CJX22INF, 1, len(trim(CJX22INF)) -1)>
	<cfoutput>#CJX22INF#</cfoutput>

<cfelse>

	<form method="post" name="form1" action="test.cfm">
	
	<Table>
	<tr>
		<td><cf_CJCcalendario  tabindex    ="3" name="FECRE" form="form1" ></td>
	</tr>
	</Table>
	
	<input type="submit" name="subm" value="SUMITIR">
	</form>

</cfif>

</body>
</html>

