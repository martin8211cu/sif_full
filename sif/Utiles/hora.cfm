<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Hora</title>
</head>
<cf_templatecss>
<body>
	<cfparam name="url.Hora" default="hora">
	<table width="100" border="1" align="center">
		<tr>
			<td colspan="3" align="center" style="background-color:#CCCCCC" nowrap>
				<input type="text" name="HHMM" id="HHMM" size="8" style="border:none; background-color:#CCCCCC; font-weight:bolder" onkeydown="return false;" >
				<input type="button" value="OK" style="border:solid 1px; background-color:#CCCCCC" onclick="sbOK();">
		</td>
		</tr>
		<tr>
			<td align="center" style="background-color:#CCCCCC" width="70">HORA</th>
			<td align="center" style="background-color:#CCCCCC" colspan="2">MINUTOS</th>		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_01" onclick="sbEscoger('HH_01');">01</td>
			<td align="center" style="cursor:pointer" id="MX_0" onclick="sbEscoger('MX_0');">&nbsp;0</td>
			<td style="cursor:pointer" id="MM_0" onclick="sbEscoger('MM_0');">0</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_02" onclick="sbEscoger('HH_02');">02</td>
			<td align="center" style="cursor:pointer" id="MX_1" onclick="sbEscoger('MX_1');">10</td>
			<td style="cursor:pointer" id="MM_1" onclick="sbEscoger('MM_1');">1</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_03" onclick="sbEscoger('HH_03');">03</td>
			<td align="center" style="cursor:pointer" id="MX_2" onclick="sbEscoger('MX_2');">20</td>
			<td style="cursor:pointer" id="MM_2" onclick="sbEscoger('MM_2');">2</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_04" onclick="sbEscoger('HH_04');">04</td>
			<td align="center" style="cursor:pointer" id="MX_3" onclick="sbEscoger('MX_3');">30</td>
			<td style="cursor:pointer" id="MM_3" onclick="sbEscoger('MM_3');">3</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_05" onclick="sbEscoger('HH_05');">05</td>
			<td align="center" style="cursor:pointer" id="MX_4" onclick="sbEscoger('MX_4');">40</td>
			<td style="cursor:pointer" id="MM_4" onclick="sbEscoger('MM_4');">4</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_06" onclick="sbEscoger('HH_06');">06</td>
			<td align="center" style="cursor:pointer" id="MX_5" onclick="sbEscoger('MX_5');">50</td>
			<td style="cursor:pointer" id="MM_5" onclick="sbEscoger('MM_5');">5</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_07" onclick="sbEscoger('HH_07');">07</td>
			<td>&nbsp;</td>
			<td style="cursor:pointer" id="MM_6" onclick="sbEscoger('MM_6');">6</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_08" onclick="sbEscoger('HH_08');">08</td>
			<td>&nbsp;</td>
			<td style="cursor:pointer" id="MM_7" onclick="sbEscoger('MM_7');">7</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_09" onclick="sbEscoger('HH_09');">09</td>
			<td>&nbsp;</td>
			<td style="cursor:pointer" id="MM_8" onclick="sbEscoger('MM_8');">8</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_10" onclick="sbEscoger('HH_10');">10</td>
			<td>&nbsp;</td>
			<td style="cursor:pointer" id="MM_9" onclick="sbEscoger('MM_9');">9</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_11" onclick="sbEscoger('HH_11');">11</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="center" style="cursor:pointer" id="HH_12" onclick="sbEscoger('HH_12');">12</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<input name="AMPM" id="AMPM" size="5" style="border:none;cursor:pointer; font-weight:bold" value="AM/PM"
						 onclick="sbEscoger('AMPM');"
						 onkeydown="return false;"
				>			</td>
		</tr>
	</table>
<script language="javascript">
		var GvarHH = "";
		var GvarMX = "";
		var GvarMM = "";
		var GvarAMPM = "AM";
		
		function sbEscoger(td)
		{
			var LvarTD = document.getElementById(td);
			var LvarTIP = td.substr(0,2);
			var LvarVAL = td.substr(3,2);

			if (LvarTIP == 'HH')
			{
				if (GvarHH != "")
					document.getElementById("HH_" + GvarHH).style.backgroundColor = "";
				LvarTD.style.backgroundColor = "#FF0000";
				GvarHH = LvarVAL;
			}
			else if (LvarTIP == 'MX')
			{
				if (GvarMX != "")
					document.getElementById("MX_" + GvarMX).style.backgroundColor = "";
				LvarTD.style.backgroundColor = "#FF0000";
				GvarMX = LvarVAL;
			}
			else if (LvarTIP == 'MM')
			{
				if (GvarMM != "")
					document.getElementById("MM_" + GvarMM).style.backgroundColor = "";
				LvarTD.style.backgroundColor = "#FF0000";
				GvarMM = LvarVAL;
			}
			else if (td == 'AMPM')
			{
				
				if (GvarAMPM == 'AM') 
					GvarAMPM='PM'; 
				else 
					GvarAMPM='AM';
			}
			var LvarHH = GvarHH;
			var LvarMX = GvarMX;
			var LvarMM = GvarMM;
			if (GvarHH == "") sbEscoger("HH_12");
			if (GvarMX == "") sbEscoger("MX_0");
			if (GvarMM == "") sbEscoger("MM_0");
			document.getElementById("HHMM").value =  GvarHH + ":" + GvarMX + GvarMM + " " + GvarAMPM;
		}
		
		function sbOK()
		{
			var LvarMinutos = 0;
			var LvarHoras = 0;
			if (GvarAMPM == 'AM')
			{
				if (GvarHH == "12")
					LvarHoras = 0;
				else
					LvarHoras = new Number(GvarHH);
			}
			else
			{ 
				if (GvarHH == "12")
					LvarHoras = 12;
				else
					LvarHoras = new Number(GvarHH) + 12;
			}
			LvarMinutos = LvarHoras*60 + new Number((GvarMX + GvarMM));

			if (opener.set<cfoutput>#url.Hora#</cfoutput>_HHMM)
				opener.set<cfoutput>#url.Hora#</cfoutput>_HHMM(LvarMinutos);
			window.close();
		}
		
		if (opener.fnValidate_<cfoutput>#url.Hora#</cfoutput>_HHMM)
		{
			LvarMinutos = opener.fnValidate_<cfoutput>#url.Hora#</cfoutput>_HHMM();
			if (LvarMinutos != "")
			{
				LvarMinutos = new Number(LvarMinutos)
				var LvarHH = parseInt(LvarMinutos / 60);
				var LvarMM = LvarMinutos - LvarHH*60;
				
				GvarAMPM = (LvarHH <= 11)?'AM':'PM';
				if (LvarHH == 0)
					LvarHH = 12;
				else if (GvarAMPM == 'PM' && LvarHH != 12)
					LvarHH -= 12;

				if (LvarHH < 10)
					GvarHH = "0" + LvarHH;
				else 
					GvarHH = "" + LvarHH;
					
				GvarMX = parseInt(LvarMM / 10);
				GvarMM = LvarMM - GvarMX*10;
		
				sbEscoger("HH_"+GvarHH);
				sbEscoger("MX_"+GvarMX);
				sbEscoger("MM_"+GvarMM);
			}
		}
	</script>
</body>
</html>
