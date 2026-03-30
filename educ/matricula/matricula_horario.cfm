<cfquery name="rsPeriodos"  datasource="#Session.DSN#">
	select convert(varchar,PLcodigo) as PLcodigo, 
			convert(varchar,PEcodigo) as PEcodigo
	  from PeriodoMatricula
	 where PMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PM#">
</cfquery>
<cfquery name="rsMatriculados" datasource="#Session.DSN#">
	select 	a.Ccodigo,
			m.Mcodificacion,
			h.HOdia,
			h.HOinicio,
			h.HOfinal,
			au.AUcodificacion
	  from 	MatriculaAlumnoCurso a,
			Curso c,
			Horario h, Aula au,
			Materia m
	 where exists (select * from PeriodoMatricula b
					where b.PMcodigo = a.PMcodigo
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					  and b.PLcodigo = #rsPeriodos.PLcodigo#
					<cfif rsPeriodos.PEcodigo EQ "">
					  and b.PEcodigo is null
					<cfelse>
					  and b.PEcodigo = #rsPeriodos.PEcodigo#
					</cfif>
					)
	   and a.Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.A#">
	   and a.Ccodigo = c.Ccodigo
	   and a.PMCmodificado = 0
	   and a.PMCtipo = 'M'
	   and c.Ccodigo *= h.Ccodigo
	   and h.AUcodigo *= au.AUcodigo
	   and c.Mcodigo = m.Mcodigo 
	order by isnull(h.HOdia,0), isnull(h.HOinicio,0)
</cfquery>
<cfquery name="rsConHorario" dbtype="query">
	select * from rsMatriculados
	 where HOdia is not null
</cfquery>
<cfquery name="rsSinHorario" dbtype="query">
	select * from rsMatriculados
	 where HOdia is null
</cfquery>
<cfset LvarPrimera = 8>
<cfset LvarUltima = 19>
<cfset GvarHorario = ArrayNew(3)>
<cfloop query="rsConHorario">
	<cfscript>
		LvarCodigo   = rsConHorario.Mcodificacion;
		LvarDiaSem = rsConHorario.HOdia;
		LvarInicio = rsConHorario.HOinicio;
		LvarFinal  = rsConHorario.HOfinal;
		LvarHorario = LvarCodigo & ": " & mid("DLKMJVS",LvarDiaSem,1) & " " & numberformat(LvarInicio,"00.00") & " - " & numberformat(LvarFinal,"00.00");
		if (rsConHorario.AUcodificacion NEQ "")
			LvarHorario = LvarHorario  &  " en " & rsConHorario.AUcodificacion;
		else
			LvarHorario = LvarHorario  &  " (el aula no ha sido asignada)";
		
		if (LvarInicio LT LvarPrimera)
		  LvarPrimera = LvarInicio;
		if (LvarFinal GT LvarUltima)
		  LvarUltima = LvarFinal;
		LvarInicio = LvarInicio * 2 + 1;
		LvarFinal  = LvarFinal * 2 + 1;
		
		if (ArrayIsEmpty(GvarHorario[LvarDiaSem][LvarInicio]))
		{
			GvarHorario[LvarDiaSem][LvarInicio][1] = LvarCodigo;
			GvarHorario[LvarDiaSem][LvarInicio][3] = LvarHorario;
			LvarChoque = false;
		}
		else
		{
			LvarChoque = true;
		}
		
		GvarHorario[LvarDiaSem][LvarInicio][2] = 1;
		for (k=LvarInicio+1; k LT LvarFinal; k=k+1)
		{
		  GvarHorario[LvarDiaSem][LvarInicio][2] = GvarHorario[LvarDiaSem][LvarInicio][2] + 1;
		  GvarHorario[LvarDiaSem][k][1] = "*";
		}

		if (LvarChoque)
		{
			for (kk=LvarInicio; GvarHorario[LvarDiaSem][kk][1] EQ "*"; kk=kk-1)
			{
			}
			GvarHorario[LvarDiaSem][kk][1] = GvarHorario[LvarDiaSem][kk][1] & "<BR>" & rsConHorario.Mcodificacion;
			GvarHorario[LvarDiaSem][kk][3] = GvarHorario[LvarDiaSem][kk][3] & chr(13) & LvarHorario;

			if ( (kk + GvarHorario[LvarDiaSem][kk][2]) LT (LvarInicio + GvarHorario[LvarDiaSem][LvarInicio][2]) )
			{
				GvarHorario[LvarDiaSem][kk][2] = LvarInicio + GvarHorario[LvarDiaSem][LvarInicio][2] - kk;
			}
		}
	</cfscript>
</cfloop>
<html>
<head>
<title>Horario</title>
<style>
<!--
.BloqueMatricula {
	color: #ADADCA;
	font-size: 12pt;
	font-family: Arial;
	font-weight: bold;
	border-bottom-style: solid;
	border-bottom-color: #ADADCA;
}
.EncabezadoPlan {
	color: #FFFFFF;
	background-color=#0066ff;
	font-size: 8pt;
	font-family: Arial;
	font-weight: bold;
	background-color: #006699;
	text-align: center;
}

.Linea {
	font-size: 8pt;
	font-family: Arial;
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #C0C0C0;
}

.Linea1 {
	font-size: 8pt;
	font-family: Arial;
	white-space: nowrap;
}
.Amarillo
{
}
.Cuadro      {
	font-size: 8pt;
	font-family: Arial;
	FONT-WEIGHT: bold;
	COLOR: #009933;
	text-align: Center;
	border-left: 1px solid #C0C0C0;
	border-top: 1px solid #C0C0C0;
	background-color: #CCCCCC;
	line-height: 12px;
}
.Cuadro0      {
	font-size: 8pt;
	font-family: Arial;
	text-align: Center;
	border-left: 1px solid #C0C0C0;
	border-top: 1px solid #C0C0C0;
	line-height: 10px;
}
.Cuadro1      {
	font-size: 8pt;
	font-family: Arial;
	text-align: Center;
	border-left: 1px solid #C0C0C0;
	line-height: 10px;
}
-->
</style>
</head>
<body style= "margin:0;">
<TABLE id="tblHorario" border="0" cellspacing="0" cellpadding="0" width="100%" height="100%"
		style= "margin:0;
				border-right-width: 1px;
				border-right-style: solid;
				border-right-color: #C0C0C0;
				border-bottom-width: 1px;
				border-bottom-style: solid;
				border-bottom-color: #C0C0C0;">
  <TR> 
    <TD colspan="10" height="1%">
	<TABLE border="0" cellspacing="0" cellpadding="0" bgcolor="#CCCCCC" width="100%">
		<tr>
			<td width="2%">&nbsp;</td>
			<td width="2%" class="Cuadro" nowrap>Horario Normal</td>  
			<td width="2%">&nbsp;</td>
			<td width="2%" class="Cuadro" style="color:#FF0000" nowrap>Choque Horario</td>
			<td width="50%">&nbsp;&nbsp;&nbsp;<cfif rsSinHorario.recordCount GT 0><font style="font-size: 8pt;font-family: Arial;FONT-WEIGHT: bold;">Existen Cursos sin Horario asignado</font></cfif></td>
			
          <td width="2%" class=Cuadro nowrap style="color:#0000FF" onclick="parent.document.formMatricula.VerHorario.click()"><a href="#">Esconder</a></td>
		</tr>
	</TABLE>
	</TD>
</TR> 
  <TR>
    <TD class=EncabezadoPlan align=middle style="line-height: 12px;" width=50>HORA</TD>
    <TD class=EncabezadoPlan width=75>Domingo</TD>
    <TD class=EncabezadoPlan width=75>Lunes</TD>
    <TD class=EncabezadoPlan width=75>Martes</TD>
    <TD class=EncabezadoPlan width=75>Miercoles</TD>
    <TD class=EncabezadoPlan width=75>Jueves</TD>
    <TD class=EncabezadoPlan width=75>Viernes</TD>
    <TD class=EncabezadoPlan width=75>Sabado</TD>
  </TR>
<cfscript>
	for (h=LvarPrimera; h LT LvarUltima; h=h+1)
	{
		h2=h*2;
		for (h0=0; h0 LTE 1; h0=h0+1)
		{
			WriteOutput("<TR>");

			if (h0 EQ 0)
			{
				WriteOutput("	<TD class=EncabezadoPlan align=center valign=middle rowSpan=2>#NumberFormat(h,'_0.00')#</TD>");
			}
			h2 = h2 + 1;
			for (d=1; d LTE 7; d=d+1)
			{ 
				if (ArrayIsEmpty(GvarHorario[d][h2]))
				{
					WriteOutput("	<TD class=Cuadro#h0#>&nbsp;</TD>");
				}
				else if (Find("<BR>", GvarHorario[d][h2][1]) NEQ 0)
				{
					LvarTitle = "'Choque de Horario:#chr(13)##GvarHorario[d][h2][3]#'";
					WriteOutput("	<TD class=Cuadro title=#LvarTitle# style='COLOR: ##FF0000' rowSpan=#GvarHorario[d][h2][2]# style='cursor=pointer;' onclick='javascript:alert(this.title);'>#GvarHorario[d][h2][1]#</TD>");
				}
				else if (GvarHorario[d][h2][1] NEQ "*")
				{
					LvarTitle = "'Leccion:#chr(13)##GvarHorario[d][h2][3]#'";
					WriteOutput("	<TD class=Cuadro title=#LvarTitle# rowSpan=#GvarHorario[d][h2][2]# style='cursor=pointer;' onclick='javascript:alert(this.title);'>#GvarHorario[d][h2][1]#</TD>");
				}
			}
			WriteOutput("</TR>");
		}
	}
</cfscript>
</table>

</body>
</html>
