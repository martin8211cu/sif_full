<cfif qry_cvp.recordCount EQ 0>
	<script language="javascript">
		alert ("No tiene definidas ninguna Cuenta en el Centro Funcional");
		window.history.back()
	</script>
	<cfabort>
</cfif>

<cfif isdefined("url.FCPformato") and len(url.FCPformato) and not isdefined("form.FCPformato")><cfset form.FCPformato = url.FCPformato></cfif>
<cfif isdefined("url.FCPdescripcion") and len(url.FCPdescripcion) and not isdefined("form.FCPdescripcion")><cfset form.FCPdescripcion = url.FCPdescripcion></cfif>
<cfquery name="qry_cv" datasource="#Session.dsn#">
	select Ecodigo, CVid, CVtipo, CVdescripcion, CPPid, CVaprobada, ts_rversion
	from CVersion
	where Ecodigo = #session.ecodigo#
	and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
</cfquery>

<cfparam name="session.PRES_Formulacion.CVPcuenta" default="-1">
<cfparam name="session.PRES_Formulacion.Ocodigo" default="-1">
<cfif session.PRES_Formulacion.CVPcuenta NEQ form.CVPcuenta OR session.PRES_Formulacion.Ocodigo NEQ form.Ocodigo>
	<!--- Obtiene las Cuentas de Presupuesto existentes (correspondientes a las cuentas de Version) --->
	<!--- Actualiza los tipos de Cambio Proyectados por Mes y actualiza el monto a aplicar--->
	<!--- Actualiza los Totales de Formulacion por Cuenta+Año+Mes+Oficina (sin Moneda) --->
	<cfset LobjAjuste = createObject( "component","sif.Componentes.PRES_Formulacion")>
	<cfset LobjAjuste.AjustaFormulacion(form.cvid, form.CVPcuenta, form.Ocodigo)>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif not IsNumeric(form.cvid)>
	<cfthrow message="El valor de form cvid no es numérico">
</cfif>
<cfif not IsNumeric(form.cvpcuenta)>
	<cfthrow message="El valor de form cvpcuenta no es numérico">
</cfif>


<cfquery name="qry_lista" datasource="#session.dsn#">
	select 	a.Ecodigo, 'Oficina: ' #_Cat# o.Odescripcion as Oficina,
			#form.cvid# as CVid, 
			#form.cvpcuenta# as CVPcuenta, 
			o.Ocodigo, 
			b.CPCano, b.CPCmes, 
			a.CPCano as ano, a.CPCmes as mes, 
		<cf_dbfunction name="to_char" args="a.CPCano">#_Cat#' - '#_Cat#
			case a.CPCmes
				when 1 then 'Enero'
				when 2 then 'Febrero'
				when 3 then 'Marzo'
				when 4 then 'Abril'
				when 5 then 'Mayo'
				when 6 then 'Junio'
				when 7 then 'Julio'
				when 8 then 'Agosto'
				when 9 then 'Septiembre'
				when 10 then 'Octubre'
				when 11 then 'Noviembre'
				when 12 then 'Diciembre'
			end 
		 as anomes, 
		case 
			when a.CPCano*100+a.CPCmes<#LvarAuxAnoMes#
				then 'Mes Cerrado'
			when 
				(
					select count(1)
					  from CVPresupuesto c, CPCtaVinculada cv
					 where c.Ecodigo 	= b.Ecodigo
					   and c.CVid 		= b.CVid
					   and c.CVPcuenta 	= b.CVPcuenta
					   and cv.Ecodigo 	= c.Ecodigo
					   and cv.CPPid 	= #qry_cv.CPPid#
					   and cv.CPformato	= c.CPformato
				 ) <> 0 
				then '<font color=''##0000FF''>Cuenta Vinculada</font>' 
			when 
				(
					select count(1)
					  from CVFormulacionMonedas c
					 where c.Ecodigo = b.Ecodigo
					   and c.CPCano = b.CPCano
					   and c.CPCmes = b.CPCmes
					   and c.CVid = b.CVid
					   and c.CVPcuenta = b.CVPcuenta
					   and c.Ocodigo = b.Ocodigo
				 ) = 0 
				then '<font color=''##0000FF''>Formulación Vacía</font>' 
			when 
				(
					select count(1)
					  from CVFormulacionMonedas c
					 where c.Ecodigo = b.Ecodigo
					   and c.CPCano = b.CPCano
					   and c.CPCmes = b.CPCmes
					   and c.CVid = b.CVid
					   and c.CVPcuenta = b.CVPcuenta
					   and c.Ocodigo = b.Ocodigo
					   and coalesce(c.CVFMmontoAplicar,0) <> 0
				 ) = 0 
				then '<font color=''##0000FF''>No se ha solicitado <cfif qry_cv.CVtipo EQ 1>ningún Monto<cfelse>ninguna Modificación</cfif></font>' 
			when 
				(
					select count(1)
					  from CVFormulacionMonedas c
					 where c.Ecodigo = b.Ecodigo
					   and c.CPCano = b.CPCano
					   and c.CPCmes = b.CPCmes
					   and c.CVid = b.CVid
					   and c.CVPcuenta = b.CVPcuenta
					   and c.Ocodigo = b.Ocodigo
					   and coalesce(c.CVFMtipoCambio,0.00) = 0.00 and b.CVFTmontoAplicar <> 0
				  ) > 0 
				  then '<font color=''##FF0000''>Faltan Tipos de Cambio Proyectados</font>' 
		<cfif qry_cv.CVtipo EQ "2">
			else 'Modificación Solicitada'
		<cfelse>
			else 'Monto Solicitado'
		</cfif>
		end as mensaje, 
		case 
			when 
				(
					select count(1)
					  from CVFormulacionMonedas c
					 where c.Ecodigo = b.Ecodigo
					   and c.CPCano = b.CPCano
					   and c.CPCmes = b.CPCmes
					   and c.CVid = b.CVid
					   and c.CVPcuenta = b.CVPcuenta
					   and c.Ocodigo = b.Ocodigo
					   and coalesce(c.CVFMtipoCambio,0.00) = 0.00 
				  ) = 0 
			then 
			coalesce(b.CVFTmontoSolicitado,0)
		end as monto
		<cfif qry_cv.CVtipo EQ "2">
		, b.CVFTmontoSolicitado - b.CVFTmontoAplicar as montoActual
		, b.CVFTmontoAplicar as montoModificar
		</cfif>
	from Oficinas o
		inner join CPmeses a
			 on a.Ecodigo = o.Ecodigo
			and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_cv.cppid#">
		left outer join CVFormulacionTotales b
			on b.Ecodigo = a.Ecodigo
			and b.CPCano = a.CPCano
			and b.CPCmes = a.CPCmes
			and b.CVid = #form.cvid#
			and b.CVPcuenta = #form.cvpcuenta#
			and b.Ocodigo = o.Ocodigo
	where o.Ecodigo = #session.ecodigo#
		<cfif form.ocodigo NEQ -1>
		and o.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ocodigo#">
		</cfif> 
	order by o.Ocodigo, a.CPCano, a.CPCmes
</cfquery>
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
 	<cfinvokeargument name="query" value="#qry_lista#">
	<cfinvokeargument name="cortes" value="Oficina"/>
	<cfif qry_cv.CVtipo EQ "2">
		<cfinvokeargument name="desplegar" value="anomes, monto, montoActual, montoModificar, mensaje"/>
		<cfinvokeargument name="etiquetas" value="Mes Presupuesto, Monto Solicitado #LvarMnombreEmpresa#, Formulaciones Aprobadas #LvarMnombreEmpresa#, Modificacion Solicitada #LvarMnombreEmpresa#, "/>
		<cfinvokeargument name="formatos" value="S, M, M,M,S"/>
		<cfinvokeargument name="align" value="left, right, right, right, left"/>
	<cfelse>
		<cfinvokeargument name="desplegar" value="anomes, monto, mensaje"/>
		<cfinvokeargument name="etiquetas" value="Mes Presupuesto, Monto<br>Solicitado<br>#LvarMnombreEmpresa#, "/>
		<cfinvokeargument name="formatos" value="S, M, S"/>
		<cfinvokeargument name="align" value="left, right, left"/>
	</cfif>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="/cfmx/sif/presupuesto/versiones/versionesComun.cfm"/>
	<cfinvokeargument name="funcion" value="funcProcesame"/>
	<cfinvokeargument name="fparams" value="CPCano, CPCmes, ano, mes, Ocodigo"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="pageindex" value="4"/>
	<cfinvokeargument name="formname" value="lista4"/>
	<cfinvokeargument name="maxrows" value="0"/>
	<cfinvokeargument name="botones" value="Solicitar_por_Monedas, Solicitar_por_Meses, Regresar"/>
</cfinvoke>
<BR>
<script language="javascript" type="text/javascript">
	<!--//
		function funcRegresar(){
			var cvid = <cfoutput>#form.CVid#</cfoutput>;
			var cmayor = <cfoutput>'#form.Cmayor#'</cfoutput>;
			var cvpcuenta = <cfoutput>'#form.CVPcuenta#'</cfoutput>;
			location.href="versionesComun.cfm?cvid="+cvid+"&cmayor="+cmayor+"&cpresup=1";
			return false;
		}
		function funcSolicitar_por_Meses(){
			<cfif form.Ocodigo EQ -1>
			alert('Escoja una oficina primero');
			<cfelse>
			var cvid = <cfoutput>#form.CVid#</cfoutput>;
			var cmayor = <cfoutput>'#form.Cmayor#'</cfoutput>;
			var cvpcuenta = <cfoutput>'#form.CVPcuenta#'</cfoutput>;
			var ocodigo = <cfoutput>'#form.ocodigo#'</cfoutput>;
			location.href="versionesComun.cfm?cvid="+cvid+"&cmayor="+cmayor+"&cvpcuenta="+cvpcuenta+"&ocodigo="+ocodigo+"&btnMonedas=yes";
			</cfif>
			return false;
		}
		function funcSolicitar_por_Monedas(CPCano, CPCmes, ano, mes, Ocodigo){
			<cfloop query="qry_lista">
			<cfif qry_lista.ano*100+qry_lista.mes GTE LvarAuxAnoMes>
				<cfoutput>
				funcProcesame(#qry_lista.ano#, #qry_lista.mes#, #qry_lista.ano#, #qry_lista.mes#, #form.Ocodigo#)
				</cfoutput>
				<cfbreak>
			</cfif>
			</cfloop>
			return false;
		}
		function funcProcesame(CPCano, CPCmes, ano, mes, Ocodigo)
		{
			<cfoutput>
			var LvarAnoMes = parseInt(ano)*100+ parseInt(mes);
			if (LvarAnoMes < #LvarAuxAnoMes#)
			{
				alert ('El mes ya está cerrado, no se puede modificar');
				return false;
			}
			location.href="versionesComun.cfm?cvid=#form.cvid#&cmayor=#form.cmayor#&cvpcuenta=#form.cvpcuenta#&ocodigo="+ Ocodigo +"&cpcano="+ano+"&cpcmes="+mes;
			</cfoutput>
			return false;
		}
	//-->
</script>
