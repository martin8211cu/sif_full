<script language="JavaScript1.2" type="text/javascript">
function prueba(){

	if ( (window.event.clientY < 0 ) || ( window.event.clientX < 0 ) ){
		if ( !window.opener.closed ){
			//window.opener.document.location.reload();
			window.opener.document.form1.submit();
			return;
		}
	}
}
</script>

<html>
<head>
<title>Copiar Días Feriados</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body <cfif isdefined("form.sql_ok")>onUnload="javscript:prueba();"</cfif> >

<cf_templatecss>

<cfquery name="rsAno" datasource="#session.DSN#">
	select max(RHFfecha) as ano
	from RHFeriados 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset anoActual = year(rsAno.ano)>

<form name="form1" method="post" action="SQLCopiarFeriados.cfm"> 
<table width="75%" cellpadding="2" cellspacing="2" align="center" class="areaFiltro">

	<tr bgcolor="#003366"><td align="center"><font size="2" color="#FFFFFF"><b><cf_translate key="LB_CopiarFeriados">Copiar Feriados</cf_translate></b></font></td></tr>	

	<cfif not isdefined("sql_ok")>		
		<cfset ano_siguiente = #anoActual# + 1 >
		<cfoutput>

		<tr>
			<td><p>
				<cf_translate key="LB_EsteProcesoVaAGenerarLosDíasFeriados">
				Este proceso va a generar los días feriados para el año #ano_siguiente#, basado en los feriados para el año #anoActual#.
				Si desea efectuar este proceso, presione en botón <b>Copiar</b>.
				</cf_translate>
				</p>
			</td>
		</tr>
		
		<tr><td><input type="hidden" name="ano" value="#anoActual#"></td></tr>
	
		<tr>
			<td align="center" nowrap>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Copiar"
					Default="Copiar"
					returnvariable="BTN_Copiar"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Cerrar"
					Default="Cerrar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Cerrar"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_DeseaCopiarLosFeriados"
					Default="Desea copiar los Feriados"
					returnvariable="MSG_DeseaCopiarLosFeriados"/>

				<input type="submit" name="btnCopiar" value="#BTN_Copiar#" onClick="return confirm('#MSG_DeseaCopiarLosFeriados#?');">
				<input type="button" name="btnCerrar" value="#BTN_Cerrar#" onClick="javascript:window.close();">
			</td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
	
		</cfoutput>
	<cfelse>
		<cfif form.sql_ok eq "false">
			<script language="JavaScript1.2" type="text/javascript">
				window.close();
			</script>
		<cfelse>
			<tr>
				<td align="center">
					<cf_translate key="LB_ErrorNoSePudoRealizarLaCopiaDeDiasFeriados">
					Error, no se pudo realizar la copia de D&iacute;as Feriados.
					</cf_translate>
				</td>
			</tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" nowrap>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Cerrar"
					Default="Cerrar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Cerrar"/>
				<input type="button" name="btnCerrar" value="#BTN_Cerrar#" onClick="javascript:window.close();">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>
</table>
</form>	

</body>
</html>
