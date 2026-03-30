<cfquery name="qry_cv" datasource="#Session.dsn#">
	select Ecodigo, CVid, CVtipo, CVdescripcion, CPPid, CVaprobada, ts_rversion
	from CVersion
	where Ecodigo = #session.ecodigo#
	and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
</cfquery>

<cfif isdefined("url.FCPformato") and len(url.FCPformato) and not isdefined("form.FCPformato")>
	<cfset form.FCPformato = url.FCPformato>
</cfif>
<cfif isdefined("url.FCPdescripcion") and len(url.FCPdescripcion) and not isdefined("form.FCPdescripcion")>
	<cfset form.FCPdescripcion = url.FCPdescripcion>
</cfif>
<cfquery name="qry_lista" datasource="#session.dsn#">
	select Ecodigo, CVid, Cmayor, CVPcuenta, CPformato, CPdescripcion,
		case 
			when 
				(
					select count(1)
					  from CVFormulacionMonedas c
					 where c.Ecodigo = b.Ecodigo
					   and c.CVid = b.CVid
					   and c.CVPcuenta = b.CVPcuenta
					   and coalesce(c.CVFMtipoCambio,0.00) = 0.00 
				  ) = 0 
				  then 
				  	coalesce(
						(
							select sum(CVFTmontoSolicitado)
							  from CVFormulacionTotales c
							 where c.Ecodigo = b.Ecodigo
							   and c.CVid = b.CVid
							   and c.CVPcuenta = b.CVPcuenta
						)
					  		, 0)
		end as monto,
		<cfif qry_cv.CVtipo EQ "2">
			(
				select sum(CVFTmontoSolicitado - CVFTmontoAplicar)
				  from CVFormulacionTotales c
				 where c.Ecodigo = b.Ecodigo
				   and c.CVid = b.CVid
				   and c.CVPcuenta = b.CVPcuenta
			)
		montoActual,
			(
				select sum(CVFTmontoAplicar)
				  from CVFormulacionTotales c
				 where c.Ecodigo = b.Ecodigo
				   and c.CVid = b.CVid
				   and c.CVPcuenta = b.CVPcuenta
			)
		montoAplicar,
		</cfif>
		case 
			when 
				(
					select count(1)
					  from CPCtaVinculada cv
					 where cv.Ecodigo 	= b.Ecodigo
					   and cv.CPPid 	= #qry_cv.CPPid#
					   and cv.CPformato	= b.CPformato
				 ) <> 0 
				then '<font color=''##0000FF''>Cuenta Vinculada</font>' 
			when 
				(
					select count(1)
					  from CVFormulacionMonedas c
					 where c.Ecodigo = b.Ecodigo
					   and c.CVid = b.CVid
					   and c.CVPcuenta = b.CVPcuenta
					   and coalesce(c.CVFMmontoAplicar,0.00) <> 0.00
				 ) = 0 
				then '<font color=''##0000FF''>No se ha solicitado <cfif qry_cv.CVtipo EQ 1>ningún Monto<cfelse>ninguna Modificación</cfif></font>' 
			when 
				(
					select count(1)
					  from CVFormulacionMonedas c
					 where c.Ecodigo = b.Ecodigo
					   and c.CVid = b.CVid
					   and c.CVPcuenta = b.CVPcuenta
					   and coalesce(c.CVFMtipoCambio,0.00) = 0.00 
				  ) > 0 
				  then '<font color=''##FF0000''>Faltan Tipos de Cambio Proyectados</font>' 
			else 'Monto Solicitado'
		end as mensaje
	from CVPresupuesto b
	where Ecodigo=#session.ecodigo#
		and CVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
		<cfif isdefined('form.Cmayor') and form.Cmayor neq -1>
			and Cmayor=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
		</cfif>
		<cfif isdefined("form.FCPformato") and len(form.FCPformato)>
			and upper(CPformato) like '%#Ucase(form.FCPformato)#%'
		</cfif>
		<cfif isdefined("form.FCPdescripcion") and len(form.FCPdescripcion)>
			and upper(CPdescripcion) like '%#Ucase(form.FCPdescripcion)#%'
		</cfif>
		<cf_CPSegUsu_where Formulacion="true" aliasCuentas="b">
	order by CPformato
</cfquery>

<cfset navegacion = "&CVid=#form.CVid#&Cmayor=#form.Cmayor#&Cpresup=1">
<cfif isdefined("form.FCPformato") and len(form.FCPformato)>
	<cfset navegacion = navegacion & "&FCPformato=#URLEncodedFormat(form.FCPformato)#">
</cfif>
<cfif isdefined("form.FCPdescripcion") and len(form.FCPdescripcion)>
	<cfset navegacion = navegacion & "&FCPdescripcion=#URLEncodedFormat(form.FCPdescripcion)#">
</cfif>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
 	<cfinvokeargument name="query" value="#qry_lista#">
	<cfif qry_cv.CVtipo EQ "1">
		<cfinvokeargument name="desplegar" value="CPformato, CPdescripcion, monto, mensaje"/>
		<cfinvokeargument name="etiquetas" value="Cuenta, Descripción, Monto<BR>Solicitado<BR>#LvarMnombreEmpresa#, "/>
		<cfinvokeargument name="formatos" value="S, S, M,S"/>
		<cfinvokeargument name="align" value="left, left, right, left"/>
	<cfelse>
		<cfinvokeargument name="desplegar" value="CPformato, CPdescripcion, monto, montoActual, montoAplicar, mensaje"/>
		<cfinvokeargument name="etiquetas" value="Cuenta, Descripción, Monto<BR>Solicitado<BR>#LvarMnombreEmpresa#, Formulaciones<BR>Aprobadas<BR>#LvarMnombreEmpresa#, Modificacion<BR>Solicitada<BR>#LvarMnombreEmpresa#, "/>
		<cfinvokeargument name="formatos" value="S, S, M,M,M,S"/>
		<cfinvokeargument name="align" value="left, left, right, right, right, left"/>
	</cfif>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="/cfmx/sif/presupuesto/versiones/versionesComun.cfm"/>
	<cfinvokeargument name="keys" value="CVid, Cmayor, CVPcuenta"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="pageindex" value="3"/>
	<cfinvokeargument name="formname" value="lista3"/>
	<cfinvokeargument name="maxrows" value="20"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
<cfif session.versiones.formular EQ "V">
	<cfinvokeargument name="botones" value="Nueva_Cuenta,Regresar"/>
<cfelse>
	<cfinvokeargument name="botones" value="Regresar"/>
</cfif>
</cfinvoke>
<script language="javascript" type="text/javascript">
	<!--//
		function funcRegresar(){
			var cvid = <cfoutput>#form.CVid#</cfoutput>;
			var cmayor = <cfoutput>'#form.Cmayor#'</cfoutput>;
			location.href="versionesComun.cfm?cvid="+cvid+"&cmayor="+cmayor+"&cpresup=0";
			return false;
		}
		function funcNueva_Cuenta(){
			var cvid = <cfoutput>#form.CVid#</cfoutput>;
			var cmayor = <cfoutput>'#form.Cmayor#'</cfoutput>;
			location.href="versionesComun.cfm?cvid="+cvid+"&cmayor="+cmayor+"&cpresup=-100";
			return false;
		}		
	//-->
</script>
