<cfif isdefined('form.codApersona') and form.codApersona NEQ ''>
	<cfquery name="rsAlumno" datasource="#session.DSN#">
		Select (Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as Anombre,Pid
		from Alumno
		where Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.codApersona#">
	</cfquery>
</cfif>

<form name="formEncAlumno" method="post" action="facturas.cfm" style="margin: 0">
	<cfoutput>
		<input type="hidden" name="codApersona" value="">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>	
		  <tr>
			<td width="31%" align="right"><strong><font size="2">Alumno</font></strong>:</td>
			<td width="2%">&nbsp;</td>
			<td colspan="2">
				<cfif isdefined('form.codApersona') and form.codApersona NEQ ''>
				<font color="##0000FF" size="3"><strong>#rsAlumno.Anombre#</strong></font>
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="right"><strong><font size="2">Identificaci&oacute;n</font></strong>:</td>
			<td>&nbsp;</td>
			<td width="22%"><cfif isdefined('form.codApersona') and form.codApersona NEQ ''>
			<font color="##0000FF" size="3"><strong>#rsAlumno.Pid#</strong></font>
			</cfif>
			</td>
		    <td width="45%" align="center"><input name="btnBuscar" type="button" id="btnBuscar" value="Buscar Alumno" onClick="javascript: doConlisAlumno();"></td>
		  </tr>
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>		  
		  <tr>
			<td colspan="4"><hr></td>
		  </tr>
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>		  
		</table>
	</cfoutput>	
</form>
<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
//---------------------------------------------------------------------------------------	
	//Llama el conlis
	function doConlisAlumno() {
		var params ="";
		params = "?form=formEncAlumno&cod=codApersona&conexion=<cfoutput>#session.DSN#</cfoutput>";
		popUpWindow("/cfmx/educ/administrativo/personas/conlisAlumnos.cfm"+params,250,200,650,400);
	}
//---------------------------------------------------------------------------------------	
</script>