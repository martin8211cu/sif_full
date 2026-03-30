<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Insertado de datos en empresa de demostraciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body style="margin:0">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr> 
			<td>
				<table width="100%" height="50%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						  <td id="td1" width="1%" height="21" bgcolor="#0099FF"></td>
						  <td id="td2" width="100%" height="21"></td>
						  <td width="1%" height="21" nowrap>&nbsp;&nbsp;<input type="text" name="txt1" id="txt1" value="1%" size="3" class="cajasinbordeb"></td>
					</tr>
				</table>			
				<!---<table width="50%" style="border:1px solid black;" align="center"> 
					<tr><td>
						<!---Tabla de una columna que va a ir aumentando el with dinámicamente por medio de un llamado de una funcion de javascript--->
						<table width="0%" id="pct2" bgcolor="#0066CC"><tr><td>&nbsp;</td></tr></table>
					</td></tr>
				</table>--->
			</td>
		</tr>
	</table>		
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr><td>
			<table width="50%" align="center"> 
				<tr><td nowrap align="center">
					<!---Etiqueta de avance del proceso--->
					<span id="paso" style=" font-size:11px">Cargando datos... </span><span id="percent">0</span>
				</td></tr>
			</table>
		</td></tr>									
	</table>
	
		<script language="javascript" type="text/javascript">
			function aumentarStatus(strValor){
				var td1 = document.getElementById("td1");
				var txt1 = document.getElementById("txt1");
				td1.width = strValor;
				txt1.value = strValor;
				if (strValor == '100%'){ 												//Cuando se ha llegado al tope
				window.parent.location.href ='ResultadoCalculo-lista.cfm?<cfoutput>RCNid=#url.RCNid#&Tcodigo=#url.Tcodigo#</cfoutput>';	//Envia al menú
							}
			}
			
			function resetStatus() {
				var td1 = document.getElementById("td1");
				var txt1 = document.getElementById("txt1");
				td1.width = '1%';
				txt1.value = '1%';
			}
		</script>
		
		
<!---	<script language='javascript' type='text/JavaScript'>
		var total = 100;//Valor máximo al que se puede llegar		
		function funcDevuelveObjeto(elid){
			return document.all?document.all[elid]:document.getElementById(elid);//devuelve el objeto
		}
		
		function funcAvance(n) {
			var percent = 0;
			percent = Math.floor(n * 100 / total);						//Obtiene el porcentaja
			funcDevuelveObjeto('pct2').width = " " + percent + "%"; 	//Aumenta el with del td (columna) 
			funcDevuelveObjeto('percent').innerHTML = percent + " % ";	//Pinta el porcentaje de avance dinamicamente
			
			if (n == 100){ 												//Cuando se ha llegado al tope
				funcDevuelveObjeto('paso').innerHTML = 'La carga de datos ha finalizado con &eacute;xito...';	//Pinta etiqueta de finalización
				funcDevuelveObjeto('percent').innerHTML = '';												
				setTimeout("window.parent.location.href ='ResultadoCalculo-lista.cfm?<cfoutput>RCNid=#url.RCNid#&Tcodigo=#url.Tcodigo#</cfoutput>'",1000);	//Envia al menú
			}
		}
	</script>--->
	<cfflush interval="1">
	
	<cfsetting requesttimeout="8600">

<cftry>	
<cfset vn_Ecodigo = 1097>
<!---<script type="text/javascript" language="javascript1.2">
	funcAvance(10);
</script>
<script type="text/javascript" language="javascript1.2">
	funcAvance(30);
</script>--->
<cfquery name="ABC_Relacion" datasource="#Session.DSN#">
	insert into RCalculoNomina (RCNid, RCDescripcion, Ecodigo, Tcodigo, RCdesde, RChasta, RCestado, Usucodigo, Ulocalizacion)
	values (
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RCDescripcion#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
		<cfqueryparam cfsqltype="cf_sql_char" value="#url.Tcodigo#">, 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RCdesde)#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RChasta)#">,
		0,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
	)
</cfquery>
<!---<script type="text/javascript" language="javascript1.2">
	funcAvance(50);
</script>
<script type="text/javascript" language="javascript1.2">
	funcAvance(70);
</script>--->
<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
	datasource="#session.dsn#"
	Ecodigo = "#Session.Ecodigo#"
	RCNid = "#url.RCNid#"
	Tcodigo = "#url.Tcodigo#"
	Usucodigo = "#Session.Usucodigo#"
	Ulocalizacion = "#Session.Ulocalizacion#"
/>
<cfquery name="rsRC" datasource="#session.dsn#">
	select * from SalarioEmpleado where RCNid=#url.RCNid#
</cfquery>
<cfloop query="rsRC">
	<cfoutput>
	<script language="javascript" type="text/javascript">
		aumentarStatus("#iif(Round(CurrentRow*100/RecordCount) gt 0,Round(CurrentRow*100/RecordCount),1)#%");
	</script>
	</cfoutput>
</cfloop>
<!---<script type="text/javascript">
	funcAvance(90);
</script>
<script type="text/javascript">
	funcAvance(100);
</script>
--->

<cfcatch type="any">
<cfdump var="#cfcatch#">
</cfcatch></cftry>