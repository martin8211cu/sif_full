<cf_navegacion name="RHEid" 	navegacion="params">
<cf_navegacion name="RHEfhasta" navegacion="params">
<cf_navegacion name="RHEfdesde" navegacion="params">

<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<html>
<head>
	<title>Importación Indiviual</title>
</head>
<body>
<cfoutput>
<cfif isdefined('form.btnImportar')>
	<script language="javascript1.2" type="text/javascript">
		window.opener.document.formPresupuestaria.action = "SA-PPresupuestarias-sql.cfm?RHPPids=#form.chk#";
		window.opener.document.formPresupuestaria.submit();
		window.close();
	</script>
</cfif>
<cfquery name="rsTEscenario" datasource="#session.DSN#">	
	select distinct RHTTid
	from RHETablasEscenario
	where Ecodigo = #session.Ecodigo#
	  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
</cfquery>
<cfquery name="rsEscenario" datasource="#session.DSN#">	
	select RHEfdesde, RHEfhasta 
	from RHEscenarios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
</cfquery>
<cfset Lvar_TablasEscenario = Valuelist(rsTEscenario.RHTTid)>
<cfif len(trim(Lvar_TablasEscenario)) eq 0>
	<cfthrow message="No se ha definido la Tabla Salarial">
</cfif>
<form name="form1" method="post" action="PopUp-ImportarIndividual.cfm">
	<input name="RHEid" 	id="RHEid" 		type="hidden" value="#form.RHEid#" />
	<input name="RHEfhasta" id="RHEfhasta" 	type="hidden" value="#rsEscenario.RHEfhasta#" />
	<input name="RHEfdesde" id="RHEfdesde" 	type="hidden" value="#rsEscenario.RHEfdesde#" />
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="pp.RHPPid, pp.RHPPcodigo, pp.RHPPdescripcion,
							  ltp.CFidautorizado 	as CFid,
							  ltrim(rtrim(cf.CFcodigo)) #_Cat# ' - ' #_Cat# ltrim(rtrim(cf.CFdescripcion)) as CFuncional,
							  ltrim(rtrim(mp.RHMPPcodigo))#_Cat#' - '#_Cat#ltrim(rtrim(mp.RHMPPdescripcion)) as PuestoPresupuestario"													
					tabla="RHPlazaPresupuestaria pp
						inner join RHLineaTiempoPlaza ltp
							on ltp.Ecodigo = pp.Ecodigo
							and pp.RHPPid = ltp.RHPPid
							and ltp.RHMPestadoplaza = 'A'
							and ltp.RHLTPfdesde <= '#rsEscenario.RHEfhasta#'
							and ltp.RHLTPfhasta >= '#rsEscenario.RHEfdesde#'
							and ltp.CFidautorizado is not null
						inner join CFuncional cf
							on cf.CFid = ltp.CFidautorizado and cf.Ecodigo = ltp.Ecodigo
						left outer join RHMaestroPuestoP mp
							on mp.RHMPPid = pp.RHMPPid and mp.Ecodigo = pp.Ecodigo"
					keys="RHPPid"
					filtro="pp.Ecodigo = #session.Ecodigo#
							and ltp.RHTTid in(#Lvar_TablasEscenario#)
                            and (select count(1) from RHSituacionActual sa where sa.RHPPid = pp.RHPPid and sa.Ecodigo = pp.Ecodigo and sa.RHEid = #form.RHEid#) = 0
                            order by pp.RHPPcodigo, pp.RHPPdescripcion"
					mostrar_filtro="true"
					filtrar_automatico="true"
					etiquetas="C&oacute;digo, Plaza, Puesto, Ctro Funcional"
					desplegar="RHPPcodigo, RHPPdescripcion, PuestoPresupuestario, CFuncional"
					filtrar_por="RHPPcodigo, RHPPdescripcion, ltp.CFidautorizado,
								ltrim(rtrim(mp.RHMPPcodigo))#_Cat#' - '#_Cat#ltrim(rtrim(mp.RHMPPdescripcion)),
								ltrim(rtrim(cf.CFcodigo)) #_Cat# ' - ' #_Cat# ltrim(rtrim(cf.CFdescripcion))"
					align="left,left,left,left,"					
					formatos="S,S,S,S,S"
					maxrows="10"
					showemptylistmsg="true"
					formname="form1"
					incluyeform="false"
					checkboxes="S"
					irA=""
					showLink="false"
					botones="Importar,Cerrar"
					navegacion="#params#"
				/>
			</td>
		</tr>
	</table>
</form>
<script language="javascript1.2" type="text/javascript">

	function funcImportar(){
		if(!fnAlgunoMarcadoform1()){
			alert("Debe de existir al menos un elemento marcado para continuar con la importación.");
			return false;
		}else if(confirm("Esta seguro de importar las situaciones marcadas?")){
			return true;
		}
		return false;
	}
	function funcCerrar(){
		window.close();
	}
</script>
</cfoutput>
</body>
