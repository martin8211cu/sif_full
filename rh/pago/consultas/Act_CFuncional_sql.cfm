
<cfinvoke Key="LB_RecursosHumanos" 		Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>

<cfobject component="rh.Componentes.RH_ActCFuncional" name="CF">

<cfif isdefined('form.BorrarPropuesto')>
	 
	<cfset vErrores = CF.BorraPropuesto(form.RCNid,form.CFid,form.CFidAnt)>
	
	<cfparam name="action" default="CFuncional-Act.cfm">
	<cfoutput>
	<form action="#action#" method="post" name="sql" id="sql">
		<input name="CFpk"  	type="hidden" value="#form.CFid#">
		<input name="CFid"  	type="hidden" value="#form.CFidAnt#">
		
		<input name="RCNid" 	type="hidden" value="#form.RCNid#">
		<input name="CFdescrip" type="hidden" value="#form.CFdescrip#">
		<input name="CFcod"  	type="hidden" value="#form.CFcod#">
		<input name="Error"	type="hidden" value="0">
		<input name="tab"  	type="hidden" value="1">
		
	</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">
		document.forms[0].submit();
	</script>
	</body>
	</HTML>
	
<cfelseif  isdefined('form.Generar')>
	
	<cfquery datasource="#session.dsn#" name="DelRCTExac">
			delete from RCuentasTipoExactus
			where RCNid = #form.RCNid#
			and Ecodigo = #session.Ecodigo#
			and CFidAnt is null
	</cfquery>
	
	<!---CarolRS. Validacion: Centros Funcionales inactivos en RCuentasTipo sin CF propuesto en RCuentasTipoExactus--->
	<cfquery datasource="#session.dsn#" name="rsValida1">
		select distinct a.CFid
		from CFuncional b
			inner join RCuentasTipo a
				on b.CFid = a.CFid
				and a.RCNid = #form.RCNid#
				
		where b.Ecodigo = #session.Ecodigo#
			and b.CFestado = 0
			and  ( 
					select distinct x.CFidAnt
					from RCuentasTipoExactus x
					where x.RCNid = #form.RCNid#
					and a.CFid=x.CFidAnt)=0
	</cfquery>
	<cfif rsValida1.RecordCount GT 0>
		<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
			<br><br><br><br>
			<center> <strong>Existen Centros Funcionales inactivos, sin centros funcionales propuestos, favor verificar.</strong> </center>
			<br><center> <input type="button" name="Regresar" value="Regresar" onClick="javascript: history.go(-1)"> </center>
		<cfabort>
	</cfif>
	
	<!---CarolRS. Validacion: Centros Funcionales activos en RCuentasTipo con CF propuestos en RCuentasTipoExactus--->
	<cfquery datasource="#session.dsn#" name="rsValida2">
		select Count(1) as cantidad
		from RCuentasTipoExactus x
		
		inner join CFuncional y	
		on x.CFidAnt = y.CFid
		and y.CFestado = 1
		
		where x.RCNid = #form.RCNid#
		and x.CFidAnt is not null
		and x.Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfif rsValida2.cantidad GT 0>
			<cf_templateheader title="#LB_RecursosHumanos#">
			<cf_templatecss>
			<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
			<br><br><br><br>
			<center> <strong>Existen Centros Funcionales activos, con centros funcionales propuestos, favor verificar.</strong> </center>
			<br><center> <input type="button" name="Regresar" value="Regresar" onClick="javascript: history.go(-1)"> </center>
			<!---En este caso una solucion podria ser devolverse y borrar las propuestas.--->
			<cfabort>
	</cfif>
	
	<!---CarolRS. Validacion: Centros Funcionales inactivos en RCuentasTipo con CF propuestos en RCuentasTipoExactus inactivos--->
	<cfquery datasource="#session.dsn#" name="rsValida3">
		select Count(1) as cantidad
		from RCuentasTipoExactus x
		
		inner join CFuncional y	
		on y.CFid = x.CFid
		and y.CFestado = 0
		
		where x.RCNid = #form.RCNid#
		and x.CFidAnt is not null
		and x.Ecodigo = #session.Ecodigo#
		
	</cfquery>
	
	<cfif rsValida3.cantidad GT 0>
		<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<br><br><br><br>
		<center> <strong>Existen Centros Funcionales propuestos que se encuentran inactivos, favor verificar.</strong> </center>
		<br><center> <input type="button" name="Regresar" value="Regresar" onClick="javascript: history.go(-1)"> </center>
		<!---CarolRS. En este caso una solucion podria ser devolverse y borrar las propuestas de centros inactivos y cambiarlas por propuestas de centros funcionales activos.--->
		<cfabort>
	</cfif>
	
	<!---CarolRS. Agrega los registros faltantes en RCuentasTipoExactus que estan en RCuentasTipo--->
	<cfquery datasource="#session.dsn#" name="rsFaltantes">
		insert into RCuentasTipoExactus(T.RCTid, T.RCNid, T.Ecodigo, T.tiporeg, T.DEid, T.referencia, T.cuenta, T.valor, T.Cformato, T.Ccuenta, T.CFcuenta, T.tipo, T.CFid, T.Ocodigo, T.Dcodigo, T.montores, T.vpresupuesto, T.BMfechaalta, T.BMUsucodigo, T.RHPPid, T.Periodo, T.Mes, T.valor2, T.CFidAnt, T.valorAnt)
		select distinct T.RCTid, T.RCNid, T.Ecodigo, T.tiporeg, T.DEid, T.referencia, T.cuenta, T.valor, T.Cformato, T.Ccuenta,
		 T.CFcuenta, T.tipo, T.CFid, T.Ocodigo, T.Dcodigo, T.montores, T.vpresupuesto, #now()#, T.BMUsucodigo, 
		 T.RHPPid, T.Periodo, T.Mes, T.valor2,  T.CFidAnt, T.valorAnt 
		
		from RCuentasTipo T
		where T.RCNid = #form.RCNid#					
		and T.Ecodigo = #session.Ecodigo#
		and (Select count(1)
			 from RCuentasTipoExactus x
			 Where T.CFid = x.CFidAnt
			 and T.RCNid = #form.RCNid#
			 and T.Ecodigo =  #session.Ecodigo#
			 ) = 0
			 
	</cfquery>
	
	<!---Genera el asiento--->
	<cfinclude template="/rh/pago/consultas/Genera_asiento.cfm">
<cfelse>		
		<cfset vErrores = CF.Actualiza(form.RCNid,form.CFid,form.CFpk)>
		
		<!---CarolRS, se modifica la tabla para incluir la nueva tabla de RCuentasTipoExactus en el filtro--->
		<cfquery datasource="#session.dsn#" name="rsHayMas">
			select count(1) as cantidad
			from CFuncional b
				inner join RCuentasTipo a
					on b.CFid = a.CFid
					and a.RCNid = #form.RCNid#
					
			where b.Ecodigo = #session.Ecodigo#
				and b.CFestado = 0
				and b.CFid not in ( 
								select distinct x.CFidAnt
								from RCuentasTipoExactus x
								where x.RCNid = #form.RCNid#)
		</cfquery>
		<!---<cfif rsHayMas.cantidad eq 0>
			<cfset action = "RepAsientosGenera.cfm">
		</cfif>--->


		<cfparam name="action" default="CFuncional-Act.cfm">
		<cfoutput>
		<form action="#action#" method="post" name="sql">
			<input name="CFpk"  	type="hidden" value="#form.CFpk#">
			<input name="CFid"  	type="hidden" value="#form.CFid#">
			
			<input name="RCNid" 	type="hidden" value="#form.RCNid#">
			<input name="CFdescrip" type="hidden" value="#form.CFdescrip#">
			<input name="CFcod"  	type="hidden" value="#form.CFcod#">
			<cfif isdefined("vErrores") and vErrores.RecordCount GT 0>
				<input name="Error"	type="hidden" value="1">
				<input name="tab"  	type="hidden" value="3">
			<cfelse>
				<input name="Error"	type="hidden" value="0">
				<input name="tab"  	type="hidden" value="1">
			</cfif>		
		</form>
		</cfoutput>
		
		<HTML>
		<head>
		</head>
		<body>
		<script language="JavaScript1.2" type="text/javascript">
			document.forms[0].submit();
		</script>
		</body>
		</HTML>

		
</cfif>

