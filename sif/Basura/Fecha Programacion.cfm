<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>

<cfdump var="#form#"><br>
<cfoutput>
	<span style="color:##FF0000;">#Now()#</span><br>
	<cfif isdefined("form.but_dele")>
		#DateAdd("n",Form.MinutosProgramacion,DateAdd("h",Form.HoraProgramacion+Form.AMPM,Form.FechaProgramacion))#<br>
	</cfif>
	#(DateCompare(DateAdd("n",Form.MinutosProgramacion,DateAdd("h",Form.HoraProgramacion+Form.AMPM,Form.FechaProgramacion)), Now()) eq -1)#<br>
</cfoutput>
<form action="" method="post" name="form1">
<cfoutput>
<input type="hidden" name="FechaProgramacion" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
<!--- Modo Alta --->
<select name="HoraProgramacion">
	<cfloop from="1" to="12" index="Hora">
		<option value="#Hora#" <cfif Hour(Now()) mod 12 eq Hora>selected</cfif>>#Hora#</option>
	</cfloop>
</select>
<select name="MinutosProgramacion">
	<cfloop from="0" to="45" step="15" index="Minuto">
		<option value="#Minuto#" <cfif Minute(Now()) gte Minuto and Minute(Now()) lt (Minuto + 15)>selected</cfif>>#Minuto#</option>
	</cfloop>
</select>
<select name="AMPM">
	<option value="0"<cfif Hour(Now()) lt 12>selected</cfif>>AM</option>
	<option value="12"<cfif Hour(Now()) gte 12>selected</cfif>>PM</option>
</select>
</cfoutput>
<input type="submit" name="but_Dele" value="Dele">
</form>
</body>
</html>