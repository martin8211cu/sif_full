<cfquery name="qry_cv" datasource="#Session.dsn#">
	select Ecodigo, CVid, CVtipo, CVdescripcion, CPPid, CVaprobada, ts_rversion
	from CVersion
	where Ecodigo = #session.ecodigo#
	and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
</cfquery>

<cfset form.Cmayor = mid(form.Cmayor,1,4)>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="qry_lista" datasource="#session.dsn#">
	select a.Mcodigo, a.Ocodigo, 'Oficina: ' #_Cat# o.Odescripcion as Oficina, a.CVid, 
		'#form.Cmayor#' as Cmayor,
		a.CVPcuenta, CPCano, CPCmes, 
		Miso4217 as moneda, 
		a.CVFMmontoBase 											as MontoBase, 
		a.CVFMajusteUsuario 										as AjusteU, 
		a.CVFMmontoBase + a.CVFMajusteUsuario						as VersionU, 
		a.CVFMajusteFinal 											as AjusteF, 
		a.CVFMmontoBase + a.CVFMajusteUsuario + a.CVFMajusteFinal 	as VersionF,
		a.CVFMmontoBase + a.CVFMajusteUsuario + a.CVFMajusteFinal - a.CVFMmontoAplicar as Actual,
		coalesce(a.CVFMmontoAplicar,0) as Modificar,
		coalesce(a.CVFMtipoCambio, 0) as TipoCambio,
		case 
			when coalesce(a.CVFMtipoCambio, 0) <> 0 
			then (a.CVFMmontoBase + a.CVFMajusteUsuario + a.CVFMajusteFinal)*a.CVFMtipoCambio 
		end as colonesSolicitado, 
		<cfif qry_cv.CVtipo EQ "2">
		case 
			when coalesce(a.CVFMtipoCambio, 0) <> 0 
			then ((a.CVFMmontoBase + a.CVFMajusteUsuario + a.CVFMajusteFinal) - a.CVFMmontoAplicar)*a.CVFMtipoCambio 
		end as colonesActual,
		case 
			when coalesce(a.CVFMtipoCambio, 0) <> 0 
			then a.CVFMmontoAplicar*a.CVFMtipoCambio 
		 end as colonesModificar,
		</cfif>
		' ' as nada
	from CVFormulacionMonedas a
		inner join Monedas b
		on b.Ecodigo = a.Ecodigo
		and b.Mcodigo = a.Mcodigo
		inner join Oficinas o
			 on o.Ecodigo = a.Ecodigo
			and o.Ocodigo = a.Ocodigo
	where a.Ecodigo = #session.ecodigo#
	and a.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
	and a.CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcano#">
	and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcmes#">
	and a.CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvpcuenta#">
	<cfif form.ocodigo NEQ "" AND form.ocodigo NEQ -1>
	and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ocodigo#">
	</cfif>
	order by a.Ocodigo, a.Mcodigo
</cfquery>

<table width="50%"align="center" border="0" cellspacing="0" cellpadding="0" summary="Control de Versiones de Presupuesto">
<tr><td class="subTitulo" align="center">Lista de Montos Solicitados por Moneda</td></tr>
<tr><td>
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
 	<cfinvokeargument name="query" value="#qry_lista#">
	<cfif qry_cv.CVtipo EQ "1">
		<cfif form.Ocodigo NEQ -1>
			<cfinvokeargument name="totales" value="colonesSolicitado"/>
		</cfif>
		<cfinvokeargument name="desplegar" value="moneda, MontoBase, AjusteU, VersionU, AjusteF, VersionF, TipoCambio, colonesSolicitado"/>
		<cfinvokeargument name="etiquetas" value="Moneda, Version<br>Base,Ajuste<br>Usuario,Version<BR>Usuario,Ajuste<br>Final,Monto Final<BR>Solicitado, Tipo Cambio<BR>Proyectado, Monto Final<br>Solicitado<br>#LvarMnombreEmpresa#"/>
		<cfinvokeargument name="formatos" value="S, M, M, M, M, M, R TipoCambio EQ 0, M"/>
		<cfinvokeargument name="align" value="left, right,right, right,right, right,right, right"/>
	<cfelse>
		<cfif form.Ocodigo NEQ -1>
			<cfinvokeargument name="totales" value="colonesSolicitado,colonesActual,colonesModificar"/>
		</cfif>
		<cfinvokeargument name="desplegar" value="moneda, MontoBase, AjusteU, VersionU, AjusteF, VersionF, actual, modificar, TipoCambio, colonesSolicitado, colonesActual, colonesModificar"/>
		<cfinvokeargument name="etiquetas" value="Moneda, Version<br>Base,Ajuste<br>Usuario,Version<BR>Usuario,Ajuste<br>Final,Version<BR>Final, Formulaciones<BR>Aprobadas,Modificación<BR>Solicitada, Tipo Cambio<BR>Proyectado, Monto<br>Solicitado<br>#LvarMnombreEmpresa#, Formulaciones<BR>Aprobadas<br>#LvarMnombreEmpresa#, Modificación<br>Solicitada<br>#LvarMnombreEmpresa#"/>
		<cfinvokeargument name="formatos" value="S, M, M, M, M, M, M, M, R TipoCambio EQ 0, M, M, M"/>
		<cfinvokeargument name="align" value="left, right,right,right,right,right,right,right,right, right, right, right"/>
	</cfif>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="/cfmx/sif/presupuesto/versiones/versionesComun.cfm"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="pageindex" value="5"/>
	<cfinvokeargument name="formname" value="lista5"/>
	<cfinvokeargument name="maxrows" value="0"/>
	<cfinvokeargument name="showLink" value="yes"/>
</cfinvoke>
</td>
</tr>
</table>
<BR>



<script language="javascript" type="text/javascript">
	function funcEliminar(mcodigo){
		document.form1.Mcodigo.value=mcodigo;
		document.form1.BajaMonedaEsp.value=true;
		document.form1.submit();
		document.lista5.nosubmit=true;
	}
</script>