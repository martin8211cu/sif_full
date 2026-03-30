<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 07 de marzo del 2006
	Motivo: Agregar el filtro de Clasificación por dirección.
			Agregar el parámetro del Titulo del reporte segun el filtro de Clasificación por dirección.
			Se creo un nuevo reporte .cfr para cuando se selecciona por direccion.

	Creado por Mauricio Esquivel / Gustavo Fonseca H.
		Fecha: 28-10-2005
		Motivo: Creación del reporte de Antigüedad de Saldos por Clasificación x Mes.(solo en CxC).
	Modificado por Gustavo Fonseca H.
		Fecha: 5-12-2005.
		Motivo: Asegurar que el reporte salga solo para la empresa que está logueado. Se cambió para 
		que funcionara en Internet Explorer (se pasa el form por get) para que los valores del form vanyan por url.

 Para usar el query to file es necesario que no se pinte nada en la pantalla antes de invocarlo, por esa razón 
 se pone de primero 
--->

<!---Primer Vencimiento en dias--->	
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_AntSldMesCerrado = t.Translate('LB_AntSldMesCerrado','Antigüedad de Saldos por Mes Cerrado')>
<cfset BTN_Generar = t.Translate('BTN_Generar','Generar','/sif/generales.xml')>
<cfset BTN_Guardar = t.Translate('BTN_Guardar','Guardar','/sif/generales.xml')>
<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsParametros1" datasource="#session.DSN#">
		select Pvalor as p1
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 310
	</cfquery>
	<cfif isdefined("rsParametros1") and rsParametros1.recordcount gt 0>
		<cfset p1 = rsParametros1.p1>
	<cfelse>
    	<cfset MSG_DefPer1 = t.Translate('MSG_DefPer1','Debe definir el primer período en los parámetros')>
    	<cfset MSG_ErrPer1 = t.Translate('MSG_ErrPer1','No se ha definido el valor del primer período en los parámetros')>
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('#MSG_DefPer1#')#&errDet=#URLEncodedFormat('#MSG_ErrPer1#')#">
	</cfif>
	
<!---Segundo Vencimiento en dias--->		
	<cfquery name="rsParametros2" datasource="#session.DSN#">
		select Pvalor as p2
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 320
	</cfquery>
	<cfif isdefined("rsParametros2") and rsParametros2.recordcount gt 0>
		<cfset p2 = rsParametros2.p2>
	<cfelse>
    	<cfset MSG_DefPer2 = t.Translate('MSG_DefPer2','Debe definir el segundo período en los parámetros')>
    	<cfset MSG_ErrPer2 = t.Translate('MSG_ErrPer2','No se ha definido el valor del segundo periódo en los parámetros')>
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('#MSG_DefPer2#')#&errDet=#URLEncodedFormat('#MSG_ErrPer2#')#" >	
	</cfif>
	
<!---Tercer Vencimiento en dias--->		
	<cfquery name="rsParametros3" datasource="#session.DSN#">
		select Pvalor as p3
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 330
	</cfquery>
	<cfif isdefined("rsParametros3") and rsParametros3.recordcount gt 0>
		<cfset p3 = rsParametros3.p3>
	<cfelse>
    	<cfset MSG_DefPer3 = t.Translate('MSG_DefPer3','Debe definir el tercer período en los parámetros')>
    	<cfset MSG_ErrPer3 = t.Translate('MSG_ErrPer3','No se ha definido el valor del tercer periódo en los parámetros')>
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('#MSG_DefPer3#')#&errDet=#URLEncodedFormat('#MSG_ErrPer3#')#" >	
	</cfif>
<!---Cuarto Vencimiento en dias--->
	<cfquery name="rsParametros4" datasource="#session.DSN#">
		select Pvalor as p4
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 340
	</cfquery>
	<cfif isdefined("rsParametros4") and rsParametros4.recordcount gt 0>
		<cfset p4 = rsParametros4.p4>
	<cfelse>
    	<cfset MSG_DefPer4 = t.Translate('MSG_DefPer4','Debe definir el cuarto período en los parámetros')>
    	<cfset MSG_ErrPer4 = t.Translate('MSG_ErrPer4','No se ha definido el valor del cuarto periódo en los parámetros')>
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('#MSG_DefPer4#')#&errDet=#URLEncodedFormat('#MSG_ErrPer4#')#" >	
	</cfif>
<!---Periodo -Mes--->
<cfif isdefined("url.mes") and len(trim(url.mes)) and isdefined("url.periodo") and len(trim(url.periodo))>
		<cfif url.mes eq 12>
			<cfset Lvarperiodo = url.periodo + 1>
			<cfset Lvarmes = 1>
		<cfelse>
			<cfset Lvarperiodo = url.periodo>
			<cfset Lvarmes = url.mes + 1>
		</cfif>
	</cfif>
<!---Cuenta Empresarial--->	
<cfquery name="rsConsultaCorp" datasource="asp">
		select count(1) as cantidad
		from CuentaEmpresarial
		where Ecorporativa is not null
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
</cfquery>
	<cfif isdefined('session.Ecodigo') and 
		  isdefined('session.Ecodigocorp') and
		  session.Ecodigo NEQ session.Ecodigocorp and
		  rsConsultaCorp.cantidad GT 0>
		  <cfset filtro = " and cl.Ecodigo = #session.Ecodigo# ">
	<cfelse>
		  <cfset filtro = " and cl.Ecodigo is null ">								  
	</cfif>
<!---GUARDAR--->
<!---<cfif isdefined("url.Guardar")>--->
<cfif isdefined("url.botonSel") and url.botonSel eq #BTN_Guardar#>
	<cfif url.TipoReporte eq 0>
		<cfquery name="rsReporte" datasource="#session.DSN#">
			<!--- /* resumido por Detalle de Clasificacion */ --->
			select 
				m.Miso4217 as Miso4217,
				m.Mnombre as Mnombre, 
				cd.SNCDvalor as SNCDvalor, 
				cd.SNCDdescripcion as SNCDdescripcion,
				cl.SNCEdescripcion,min(cl.SNCEcodigo) as SNCEcodigo,
				sum(SIsaldoinicial) as Saldo,
				sum(SIsinvencer) as SinVencer, 
				sum(SIcorriente) as Corriente,
				sum(SIp1) as V1a#p1#,
				sum(SIp2) as V#p1+1#a#p2#,
				sum(SIp3) as V#p2+1#a#p3#,
				sum(SIp4) as V#p3+1#a#p4#,
				sum(SIp5) as V#p4+1#a150,
				sum(SIp5p) as V151mas,
				sum(SIp1 + SIp2 + SIp3 + SIp4 + SIp5 + SIp5p) as Morosidad
			from SNClasificacionD cd
			
				inner join  SNClasificacionE cl
					on cl.SNCEid = cd.SNCEid
				<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
					inner join SNClasificacionSN cs
					on cs.SNCDid = cd.SNCDid
					
				<cfelse>
					inner join SNClasificacionSND cs
					   on cs.SNCDid = cd.SNCDid
	
					inner join SNDirecciones snd
					  on cs.SNid = snd.SNid
					 and cs.id_direccion = snd.id_direccion
				</cfif>
				inner join SNegocios sn
					on sn.SNid = cs.SNid
					
				<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
					<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
					   inner join DatosEmpleado g
							on g.DEid = sn.DEidCobrador<!--- --->
				    </cfif>
				<cfelse>
					<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
						inner join DatosEmpleado g
							on g.DEid = snd.DEidCobrador <!------>
					</cfif>
				</cfif>

				inner join SNSaldosIniciales si
					   on si.SNid = cs.SNid
					and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarperiodo#">	<!---         ---- {periodo parametros al siguiente mes} --->
					and si.Smes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarmes#">              <!--- ----- {mes parametros al siguiente mes} --->
					<cfif isdefined('url.TClasif') and url.TClasif EQ 1>					
					and si.id_direccion = snd.id_direccion
					</cfif>
			
				inner join Monedas m
					on m.Mcodigo = si.Mcodigo
					and m.Ecodigo = si.Ecodigo
			
				inner join Empresas e
					on e.Ecodigo = sn.Ecodigo
				
			where cd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
				#filtro#
				and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<!--- Cobrador --->
				<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
					and g.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
				</cfif>
				<!--- Valores de Clasificación --->
				<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
					<cfif url.SNCDvalor1 gt url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
						and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
										 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#">
					<cfelse>
						and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
										 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
					</cfif>
				<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
					and rtrim(ltrim(cd.SNCDvalor)) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
				<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
					and rtrim(ltrim(dc.SNCDvalor)) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#"> 
				</cfif>
			group by 
				m.Miso4217,
				m.Mnombre, 
				cd.SNCDvalor, 
				cd.SNCDdescripcion,
				cl.SNCEdescripcion

			order by 1,3,5
			</cfquery>

	<cfelseif url.TipoReporte eq 1>			
		<cfquery name="rsReporte" datasource="#session.DSN#">
			<!--- /* resumido por Detalle de Clasificacion / Cliente */ --->
				select 
					m.Miso4217, 
					m.Mnombre,
					cd.SNCDvalor, 
					cd.SNCDdescripcion,
					cl.SNCEdescripcion,min(cl.SNCEcodigo) as SNCEcodigo,
					sn.SNnumero,
					sn.SNnombre,
					sum(SIsaldoinicial) as Saldo,
					sum(SIsinvencer) as SinVencer, 
					sum(SIcorriente) as Corriente,
					sum(SIp1) as V1a#p1#,
					sum(SIp2) as V#p1+1#a#p2#,
					sum(SIp3) as V#p2+1#a#p3#,
					sum(SIp4) as V#p3+1#a#p4#,
					sum(SIp5) as V#p4+1#a150,
					sum(SIp5p) as V151aMas,
					sum(SIp1 + SIp2 + SIp3 + SIp4 + SIp5 + SIp5p) as Morosidad
				from SNClasificacionD cd
				
					inner join  SNClasificacionE cl
						on cl.SNCEid  = cd.SNCEid
	
					<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
						inner join SNClasificacionSN cs
						on cs.SNCDid = cd.SNCDid
					<cfelse>
						inner join SNClasificacionSND cs
							on cs.SNCDid = cd.SNCDid
		
						inner join SNDirecciones snd
						  on cs.SNid = snd.SNid
						 and cs.id_direccion = snd.id_direccion
					</cfif>
				
					inner join SNegocios sn
						on sn.SNid = cs.SNid
						
					<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
						<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
						   inner join DatosEmpleado g
								on g.DEid = sn.DEidCobrador<!--- --->
						</cfif>
					<cfelse>
						<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
							inner join DatosEmpleado g
								on g.DEid = snd.DEidCobrador <!--- --->
						</cfif>
					</cfif>

					inner join SNSaldosIniciales si
						   on si.SNid = cs.SNid
							and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarperiodo#">	<!---         ---- {periodo parametros al siguiente mes} --->
							and si.Smes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarmes#">              <!--- ----- {mes parametros al siguiente mes} --->
							<cfif isdefined('url.TClasif') and url.TClasif EQ 1>					
							and si.id_direccion = snd.id_direccion
							</cfif>

					inner join Monedas m
						on m.Mcodigo = si.Mcodigo
						and m.Ecodigo = si.Ecodigo
				
					inner join Empresas e
						on e.Ecodigo = sn.Ecodigo
				
				where cd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
					#filtro#
					and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<!--- Cobrador --->
					<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
						and g.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
					</cfif>
					<!--- Valores de Clasificación --->
					<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
						<cfif url.SNCDvalor1 gt url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
							and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
											 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#">
						<cfelse>
							and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
											 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
						</cfif>
					<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
						and rtrim(ltrim(cd.SNCDvalor)) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
					<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
						and rtrim(ltrim(dc.SNCDvalor)) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#"> 
					</cfif>
				group by 
					m.Miso4217, 
					m.Mnombre , 
					cd.SNCDvalor, 
					cd.SNCDdescripcion, 
					cl.SNCEdescripcion, 
					sn.SNnumero, 
					sn.SNnombre
				order by 1,3,6
			</cfquery>

	<cfelseif url.TipoReporte eq 2>
		<cfquery name="rsReporte" datasource="#session.DSN#">
			<!--- /* Detallado por Clasificacion / Cliente / Direccion */ --->
			select 
				m.Miso4217 as Miso4217,
				m.Mnombre as Mnombre, 
				cd.SNCDvalor as SNCDvalor, 
				cd.SNCDdescripcion as SNCDdescripcion,
				cl.SNCEdescripcion,
				min(cl.SNCEcodigo) as SNCEcodigo,
				coalesce(ds.SNDcodigo,sn.SNnumero) as SNnumero,
				coalesce(ds.SNnombre,sn.SNnombre) as SNnombre,
				sum(SIsaldoinicial) as Saldo,
				sum(SIsinvencer) as SinVencer, 
				sum(SIcorriente) as Corriente,
				sum(SIp1) as V1a#p1#,
				sum(SIp2) as V#p1+1#a#p2#,
				sum(SIp3) as V#p2+1#a#p3#,
				sum(SIp4) as V#p3+1#a#p4#,
				sum(SIp5) as V#p4+1#a150,
				sum(SIp5p) as V151aMas,
				sum(SIp1 + SIp2 + SIp3 + SIp4 + SIp5 + SIp5p) as Morosidad
			from SNClasificacionE cl
			inner join SNClasificacionD cd
				on cl.SNCEid = cd.SNCEid
				<!--- Valores de Clasificación --->
				<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
					<cfif url.SNCDvalor1 gt url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
						and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
										 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#">
					<cfelse>
						and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
										 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
					</cfif>
				<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
					and rtrim(ltrim(cd.SNCDvalor)) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
				<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
					and rtrim(ltrim(dc.SNCDvalor)) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#"> 
				</cfif>

			inner join SNClasificacionSND cs
				on cs.SNCDid = cd.SNCDid
			
			inner join SNDirecciones ds
				on ds.SNid = cs.SNid
				and ds.id_direccion = cs.id_direccion
				<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
					and ds.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
				</cfif>

			inner join SNegocios sn
				on sn.SNid = ds.SNid
				and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				
			inner join SNSaldosIniciales si
				on sn.SNid = si.SNid
				and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarperiodo#">
				and si.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarmes#">
				and si.id_direccion = ds.id_direccion
			
			inner join Monedas m
				on m.Mcodigo = si.Mcodigo
				and m.Ecodigo = si.Ecodigo
			
			where cl.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
				#filtro#
			group by 
				m.Miso4217,
				m.Mnombre, 
				cd.SNCDvalor, 
				cd.SNCDdescripcion,
				cl.SNCEdescripcion,
				coalesce(ds.SNDcodigo,sn.SNnumero),
				coalesce(ds.SNnombre,sn.SNnombre)
			order by 1,3,6
		</cfquery>
	</cfif>
    
	<cf_QueryToFile query="#rsReporte#" filename="AntiguedadSaldosXMes.xls" titulo="#LB_AntSldMesCerrado#">
	<cfabort>
</cfif>

<cfset LB_TituloH = t.Translate('LB_TituloH','SIF - Cuentas por Cobrar')>
<cfset LB_Titulo = t.Translate('LB_Titulo','Antigüedad&nbsp;de&nbsp;Saldos&nbsp;por&nbsp;Clasificaci&oacute;n y Mes')>

<cf_templateheader title="#LB_TituloH#">

<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
<script language="JavaScript" src="../../js/fechas.js"></script>

<cfquery name="rsPer" datasource="#Session.DSN#">
	select distinct Speriodo as Speriodo
	from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Speriodo desc
</cfquery>
<cfif rsPer.recordcount EQ 0>
	<cfset MSG_NoMEsCerrado = t.Translate('MSG_NoMEsCerrado','La empresa no posee ningún Mes Cerrado en la contabilidad General!')>
	<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('#MSG_NoMEsCerrado#')#" >
</cfif>
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<cfoutput>
<form name="form1" action="Antiguedad_Saldos_ClasiFxMes.cfm" method="get">
<cfset LB_ClasifSocios = t.Translate('LB_ClasifSocios','Clasificaci&oacute;n de Socios')>
<cfset LB_ClasifDirSocios = t.Translate('LB_ClasifDirSocios','Clasificaci&oacute;n de Direcci&oacute;n de Socio')>
<cfset LB_DetClasif = t.Translate('LB_DetClasif','Detalle de Clasificaci&oacute;n')>
<cfset LB_DetadoClasif = t.Translate('LB_DetadoClasif','Detallado por Clasificaci&oacute;n')>
<cfset LB_CLIENTE = t.Translate('LB_CLIENTE','Cliente','/sif/generales.xml')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&oacute;n','/sif/generales.xml')>
<cfset LB_Valor = t.Translate('LB_Valor','Valor','/sif/generales.xml')>
<cfset LB_Clasificacion = t.Translate('LB_Clasificacion','Clasificaci&oacute;n')>
<cfset LB_ClasificacionSA = t.Translate('LB_ClasificacionSA','Clasificación')>
<cfset LB_Desde = t.Translate('LB_Desde','desde','/sif/generales.xml')>
<cfset LB_Hasta = t.Translate('LB_Hasta','hasta','/sif/generales.xml')>
<cfset LB_Cobrador = t.Translate('LB_Cobrador','Cobrador')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
<cfset LB_Periodo = t.Translate('LB_Periodo','Periodo')>
<cfset LB_DatosdelReporte = t.Translate('LB_DatosdelReporte','Datos del Reporte')>
<cfset LB_Mes = t.Translate('CMB_Mes','Mes','/sif/generales.xml')>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
        
		<fieldset><legend>#LB_DatosdelReporte#</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<input name="TClasif" id="TClasif1" type="radio" value="0" checked tabindex="1" onclick="Verificar();">
						<label for="TClasif1" style="font-style:normal; font-variant:normal;">#LB_ClasifSocios#</label>
						<input name="TClasif" id="TClasif2" type="radio" value="1" tabindex="1" onclick="Verificar();">
						<label for="TClasif2"  style="font-style:normal; font-variant:normal;">#LB_ClasifDirSocios#</label>
					</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3" nowrap>
					<input name="TipoReporte" id="tipo1" type="radio" value="0" checked tabindex="1"> &nbsp;<strong><label for="tipo1" style="font-style:normal; font-variant:normal; ">#LB_DetClasif#</label></strong> &nbsp;&nbsp;
					<input name="TipoReporte" id="tipo2" type="radio" value="1" tabindex="1">&nbsp;<strong><label for="tipo2" style="font-style:normal; font-variant:normal;">#LB_DetClasif# / #LB_CLIENTE#</label></strong> &nbsp;&nbsp;
					<input name="TipoReporte" id="tipo3" type="radio" value="2" tabindex="1">&nbsp;<strong><label for="tipo3" style="font-style:normal; font-variant:normal;">#LB_DetadoClasif# / #LB_CLIENTE# / #LB_Direccion#</label></strong></td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Clasificacion#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%"><strong>#LB_Valor#&nbsp;#LB_Clasificacion#&nbsp;#LB_Desde#:&nbsp;</strong></td>
					<td width="10%"><strong>#LB_Valor#&nbsp;#LB_Clasificacion#&nbsp;#LB_Hasta#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" desc="SNCDdescripcion1" tabindex="1"></td>					
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				
				<tr>
                    <cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
					<td>&nbsp;</td>
					<td width="10%" nowrap><strong>#LB_Cobrador#:</strong></td>
					<input type="hidden" name="DEidCobrador" value="" >
					<input type="hidden" name="Cobrador" value="#LB_Todos#" >
				</tr>
				<tr id="sinSNDirecciones">
					<td>&nbsp;</td>	
					 <td width="10%" nowrap><!--- --->
					<cfset LB_ListaCobrador = t.Translate('LB_ListaCobrador','Lista de Cobradores')>
					 <cf_conlis
							<!--- -----El título se muestra en el Conlis y en el onMouseOver de la Imágen que levanta el Conlis. --->
							title="#LB_ListaCobrador#"
							<!--- -----Campos que van a ser pintados por el tag en la pantalla donde se coloque. --->
							campos = "DEidCobrador_SNegocios1, DEidentificacion1, Cobrador1"
							<!--- -----Indica cuales de los campos que van a ser pintados en la panalla van a ser visibles (TextBox) y cuales No (Hidden). --->
							desplegables = "N,S,S" 
							<!--- -----Indica cuales campos van a ser modificables y cuales no (readonly), cuando hay campos modificables, se presenta la funcionalidad busqueda al salir del campo en que se digitó, mejor conocido como TAG, y cuando no hay campos modificables, únicames se muestra una lista de selección, mejor conocido como conlis, cuando hay funcionalidad TAG, también hay conlis. Los campos modificables deben ser desplegables, sino son desplegables, se omite funcionalidad de modificable. --->
							modificables = "N,S,N"
							<!--- -----Tamaño de los objetos desplegables, el tamaño asignado a los objetos no desplegables se omite. --->
							size = "0,20,30"
							<!--- -----Valores iniciales de los campos pintados por el tag. --->
							<!--- valuesarray="#Lvar_valuesArray#"  --->
							<!--- -----Tabla para el query, como se observa puede llevar una sintaxis compleja que involucre joins, subqueries, parámetros que cambian dinámicamente en el form donde reside el tag(ver uso de sintaxis $campo,tipo$), variables de coldfusion que serán asignadas en el servidor cuando se este generando el html, que será retornado al cliente. --->
							tabla=" SNegocios a
									inner join DatosEmpleado d
										on d.DEid = a.DEidCobrador"
										<!--- and tc1.Hfecha <=  $EMfecha,date$ --->
							<!--- -----Columnas a retornar por el query, como se obserba, al igual que la tabla puede llevar una sintaxis compleja. --->
							columnas="distinct
										a.DEidCobrador,
										a.DEidCobrador as DEidCobrador_SNegocios,
										d.DEid as DEid_DatosEmpleado,
										d.NTIcodigo,
										d.DEidentificacion as DEidentificacion1,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador1"
							<!--- -----filtro del query, , como se obserba, al igual que la tabla puede llevar una sintaxis compleja. --->
							filtro="a.Ecodigo  =#session.Ecodigo#"
							filtrar_por ="DEidentificacion, d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ' ' #_Cat# d.DEnombre"
							<!--- -----campos del query a desplegar la lista del Conlis. --->
							desplegar="DEidentificacion1, Cobrador1"
							tabindex="1"
							<!--- -----etiquetas de la lista del Conlis. --->
							etiquetas="#LB_Identificacion#, #LB_Cobrador#"
							<!--- -----formatos de los campos a desplegar en la lista del Conlis. --->
							formatos="S,S"
							<!--- -----alineamiento de los campos de la lista del Conlis. --->
							align="left,left"
							<!--- -----cortes de la lista del Conlis --->
							<!--- cortes="Mnombre" --->
							<!--- -----campos a asignar cuando se seleccione un item del Conlis, como se observa se pueden asignar mas campos de los pintados por el tag, esto implica que estos campos deben existir en la pantalla donde se pinta el tag. --->
							asignar="DEidCobrador, Cobrador, DEidentificacion1, Cobrador1"
							<!--- -----formatos de los valores a asignar a los campos cuando se seleccione un item del Conlis. --->
							asignarformatos="S, S,S,S">
					 </td> 
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr id="conSNDirecciones" style="display:none">
					<td>&nbsp;</td>	
					 <td width="10%" nowrap><!--- --->
					<cfset LB_ListaCobradorporDir = t.Translate('LB_ListaCobradorporDir','Lista de Cobradores por Direcci&oacute;n')>
                     
					 <cf_conlis 
							<!--- -----El título se muestra en el Conlis y en el onMouseOver de la Imágen que levanta el Conlis. --->
							title="#LB_ListaCobradorporDir#"
							<!--- -----Campos que van a ser pintados por el tag en la pantalla donde se coloque. --->
							campos = "DEidCobrador_SNdirecciones2, DEidentificacion2, Cobrador2" 
							<!--- -----Indica cuales de los campos que van a ser pintados en la panalla van a ser visibles (TextBox) y cuales No (Hidden). --->
							desplegables = "N,S,S" 
							<!--- -----Indica cuales campos van a ser modificables y cuales no (readonly), cuando hay campos modificables, se presenta la funcionalidad busqueda al salir del campo en que se digitó, mejor conocido como TAG, y cuando no hay campos modificables, únicames se muestra una lista de selección, mejor conocido como conlis, cuando hay funcionalidad TAG, también hay conlis. Los campos modificables deben ser desplegables, sino son desplegables, se omite funcionalidad de modificable. --->
							modificables = "N,S,N"
							<!--- -----Tamaño de los objetos desplegables, el tamaño asignado a los objetos no desplegables se omite. --->
							size = "0,20,30"
							<!--- -----Valores iniciales de los campos pintados por el tag. --->
							<!--- valuesarray="#Lvar_valuesArray#"  --->
							<!--- -----Tabla para el query, como se observa puede llevar una sintaxis compleja que involucre joins, subqueries, parámetros que cambian dinámicamente en el form donde reside el tag(ver uso de sintaxis $campo,tipo$), variables de coldfusion que serán asignadas en el servidor cuando se este generando el html, que será retornado al cliente. --->
							tabla=" SNDirecciones a
									inner join DatosEmpleado d
										on d.DEid = a.DEidCobrador"
							<!--- -----Columnas a retornar por el query, como se obserba, al igual que la tabla puede llevar una sintaxis compleja. --->
							columnas="	distinct
										a.DEidCobrador,
										a.DEidCobrador as DEidCobrador_SNdirecciones,
										d.DEid as DEid_DatosEmpleado ,
										d.NTIcodigo,
										d.DEidentificacion as DEidentificacion2,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador2"
							<!--- -----filtro del query, , como se obserba, al igual que la tabla puede llevar una sintaxis compleja. --->
							filtro="a.Ecodigo  =#session.Ecodigo#"
							filtrar_por ="DEidentificacion, d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ' ' #_Cat# d.DEnombre"
							<!--- -----campos del query a desplegar la lista del Conlis. --->
							desplegar="DEidentificacion2, Cobrador2"
							tabindex="1"
							<!--- -----etiquetas de la lista del Conlis. --->
							etiquetas="#LB_Identificacion#, #LB_Cobrador#"
							<!--- -----formatos de los campos a desplegar en la lista del Conlis. --->
							formatos="S,S"
							<!--- -----alineamiento de los campos de la lista del Conlis. --->
							align="left,left"
							<!--- -----cortes de la lista del Conlis --->
							<!--- cortes="Mnombre" --->
							<!--- -----campos a asignar cuando se seleccione un item del Conlis, como se observa se pueden asignar mas campos de los pintados por el tag, esto implica que estos campos deben existir en la pantalla donde se pinta el tag. --->
							asignar="DEidCobrador, Cobrador, DEidentificacion2, Cobrador2"
							<!--- -----formatos de los valores a asignar a los campos cuando se seleccione un item del Conlis. --->
							asignarformatos="S,S,S,S">
					 </td> 
					<td colspan="3">&nbsp;</td>
				</tr>
				
				<tr>
                    <cfset CMB_Mes = t.Translate('CMB_Mes','Mes','/sif/generales.xml')>
                    <cfset CMB_Ano = t.Translate('CMB_Ano','A&ntilde;o')>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#CMB_Mes#:</strong></td>
					<td nowrap align="left" width="10%"><strong>#CMB_Ano#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left">
						<select name="mes" tabindex="1">
							<cfloop query="rsMeses">
								<option value="#VSvalor#">#VSdesc#</option>
							</cfloop>	
						</select>
					</td>
					<td nowrap align="left">
						<select name="periodo" tabindex="1">
							<cfloop query="rsPer">
								<option value="#Speriodo#">#Speriodo#</option>
							</cfloop>
						</select>
					</td>
					<td colspan="2">&nbsp;</td>					
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>				
				<tr>
					<td>&nbsp;</td>
                    <cfset LB_Formato = t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
					<td align="left" width="10%"><strong>#LB_Formato#&nbsp;</strong>
					
					<select name="Formato" id="Formato" tabindex="1">
						<option value="1">FLASHPAPER</option>
						<option value="2">PDF</option>
						<option value="3">EXCEL</option>
					</select>
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr><td colspan="4"><cf_botones values="Generar,Download" names="#BTN_Generar#,#BTN_Guardar#"  tabindex="1"></td></tr>
			</table>
			</fieldset>			
		</td>	
	</tr>
</table>	
</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	
	function funcVisualizar(){
		document.getElementById("sinSNDirecciones").style.display='none'; 
		document.getElementById("conSNDirecciones").style.display=''
		document.form1.DEidCobrador_SNegocios1.value='';
		document.form1.DEidentificacion1.value='';
		document.form1.Cobrador1.value='';
		document.form1.DEidCobrador_SNdirecciones2.value='';
		document.form1.DEidentificacion2.value='';
		document.form1.Cobrador2.value='';
		document.form1.DEidCobrador.value='';
		
	}
	function funcDesVisualizar(){
		document.getElementById("conSNDirecciones").style.display='none'; 
		document.getElementById("sinSNDirecciones").style.display=''
		document.form1.DEidCobrador_SNegocios1.value='';
		document.form1.DEidentificacion1.value='';
		document.form1.Cobrador1.value='';
		document.form1.DEidCobrador_SNdirecciones2.value='';
		document.form1.DEidentificacion2.value='';
		document.form1.Cobrador2.value='';
		document.form1.DEidCobrador.value='';
	}
	
	function Verificar(){
		if (document.getElementById("TClasif2").checked == true){
			funcVisualizar();
			}
		else{
			funcDesVisualizar();		
		}
	}
	Verificar();
</script>
<!---<cfif isdefined("url.Generar")>--->
<cfif isdefined("url.botonSel") and url.botonSel eq #BTN_Generar#>
<!---<cf_dump var = "#url#">--->
	<cfif url.TipoReporte eq 0>
		<cfquery name="rsReporte" datasource="#session.DSN#">
			<!--- /* resumido por Detalle de Clasificacion */ --->
			select 
				m.Miso4217 as Miso4217,
				m.Mnombre as Mnombre, 
				cd.SNCDvalor as SNCDvalor, 
				cd.SNCDdescripcion as SNCDdescripcion,
				cl.SNCEdescripcion, 
				cl.SNCEcodigo as SNCEcodigo,
				sum(SIsaldoinicial) as Saldo,
				sum(SIsinvencer) as SinVencer, 
				sum(SIcorriente) as Corriente,
				sum(SIp1) as P1,
				sum(SIp2) as P2,
				sum(SIp3) as P3,
				sum(SIp4) as P4,
				sum(SIp5) as P5,
				sum(SIp5p) as P5p,
				sum(SIp1 + SIp2 + SIp3 + SIp4 + SIp5 + SIp5p) as Morosidad
			from SNClasificacionD cd
			
				inner join  SNClasificacionE cl
					on cl.SNCEid = cd.SNCEid
				<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
					inner join SNClasificacionSN cs
					on cs.SNCDid = cd.SNCDid
				<cfelse>
					inner join SNClasificacionSND cs
					   on cs.SNCDid = cd.SNCDid
	
					inner join SNDirecciones snd
					  on cs.SNid = snd.SNid
					 and cs.id_direccion = snd.id_direccion
					 <cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
					 and snd.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
					 </cfif>
				</cfif>
			
				inner join SNegocios sn
					on sn.SNid = cs.SNid
					<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
						 <cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
						 and sn.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
						 </cfif>
					</cfif>
			
				inner join SNSaldosIniciales si
					   on si.SNid = cs.SNid
					and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarperiodo#">	<!---         ---- {periodo parametros al siguiente mes} --->
					and si.Smes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarmes#">              <!--- ----- {mes parametros al siguiente mes} --->
					<cfif isdefined('url.TClasif') and url.TClasif EQ 1>					
					and si.id_direccion = snd.id_direccion
					</cfif>
				inner join Monedas m
					on m.Mcodigo = si.Mcodigo
					and m.Ecodigo = si.Ecodigo
			
				inner join Empresas e
					on e.Ecodigo = sn.Ecodigo
			
			where cd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
				#filtro#
				and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

				<!--- Valores de Clasificación --->
				<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
					<cfif url.SNCDvalor1 gt url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
						and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
										 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#">
					<cfelse>
						and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
										 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
					</cfif>
				<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
					and rtrim(ltrim(cd.SNCDvalor)) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
				<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
					and rtrim(ltrim(dc.SNCDvalor)) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#"> 
				</cfif>
			group by 
				m.Miso4217, 
				m.Mnombre, 
				cl.SNCEcodigo,
				cl.SNCEdescripcion,
				cd.SNCDvalor, 
				cd.SNCDdescripcion

				order by 1,3,5
			</cfquery>

	<cfelseif url.TipoReporte eq 1>			
		<cfquery name="rsReporte" datasource="#session.DSN#">
			<!--- /* resumido por Detalle de Clasificacion / Cliente */ --->
				select 
					m.Miso4217, 
					m.Mnombre,
					cd.SNCDvalor, 
					cd.SNCDdescripcion,
					cl.SNCEdescripcion,min(cl.SNCEcodigo) as SNCEcodigo,
					sn.SNnumero,
					sn.SNnombre,
					sum(SIsaldoinicial) as Saldo,
					sum(SIsinvencer) as SinVencer, 
					sum(SIcorriente) as Corriente,
					sum(SIp1) as P1,
					sum(SIp2) as P2,
					sum(SIp3) as P3,
					sum(SIp4) as P4,
					sum(SIp5) as P5,
					sum(SIp5p) as P5p,
					sum(SIp1 + SIp2 + SIp3 + SIp4 + SIp5 + SIp5p) as Morosidad
				from SNClasificacionD cd
				
					inner join  SNClasificacionE cl
						on cl.SNCEid  = cd.SNCEid
	
					<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
						inner join SNClasificacionSN cs
						on cs.SNCDid = cd.SNCDid
					<cfelse>
						inner join SNClasificacionSND cs
							on cs.SNCDid = cd.SNCDid
		
						inner join SNDirecciones snd
						  on cs.SNid = snd.SNid
						 and cs.id_direccion = snd.id_direccion
					</cfif>
				
					inner join SNegocios sn
						on sn.SNid = cs.SNid
						
					<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
						<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
						   inner join DatosEmpleado g
								on g.DEid = sn.DEidCobrador<!--- --->
						</cfif>
					<cfelse>
						<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
							inner join DatosEmpleado g
								on g.DEid = snd.DEidCobrador <!--- --->
						</cfif>
					</cfif>

					inner join SNSaldosIniciales si
						   on si.SNid = cs.SNid
							and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarperiodo#">	<!---         ---- {periodo parametros al siguiente mes} --->
							and si.Smes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarmes#">              <!--- ----- {mes parametros al siguiente mes} --->
							<cfif isdefined('url.TClasif') and url.TClasif EQ 1>					
							and si.id_direccion = snd.id_direccion
							</cfif>

					inner join Monedas m
						on m.Mcodigo = si.Mcodigo
						and m.Ecodigo = si.Ecodigo
				
					inner join Empresas e
						on e.Ecodigo = sn.Ecodigo
				
				where cd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
					#filtro#
					and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<!--- Cobrador --->
					<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
						and g.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
					</cfif>
					<!--- and cd.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor2#"> --->
					<!--- Valores de Clasificación --->
					<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
						<cfif url.SNCDvalor1 gt url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
							and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
											 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#">
						<cfelse>
							and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
											 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
						</cfif>
					<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
						and rtrim(ltrim(cd.SNCDvalor)) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
					<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
						and rtrim(ltrim(dc.SNCDvalor)) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#"> 
					</cfif>
				group by 
					m.Miso4217, 
					m.Mnombre,
					cd.SNCDvalor, 
					cd.SNCDdescripcion,
					cl.SNCEdescripcion,
					sn.SNnumero,
					sn.SNnombre
				order by 1,3,6
		</cfquery>

	<cfelseif url.TipoReporte eq 2>
		<cfquery name="rsReporte" datasource="#session.DSN#" >
			<!--- /* Detallado por Clasificacion / Cliente / Direccion */ --->
			select 
				m.Miso4217 as Miso4217,
				m.Mnombre as Mnombre, 
				cd.SNCDvalor as SNCDvalor, 
				cd.SNCDdescripcion as SNCDdescripcion,
				cl.SNCEdescripcion,min(cl.SNCEcodigo) as SNCEcodigo,
				coalesce(ds.SNDcodigo,sn.SNnumero) as SNnumero,
				coalesce(ds.SNnombre,sn.SNnombre) as SNnombre,
				sum(SIsaldoinicial) as Saldo,
				sum(SIsinvencer) as SinVencer, 
				sum(SIcorriente) as Corriente,
				sum(SIp1) as P1,
				sum(SIp2) as P2,
				sum(SIp3) as P3,
				sum(SIp4) as P4,
				sum(SIp5) as P5,
				sum(SIp5p) as P5p,
				sum(SIp1 + SIp2 + SIp3 + SIp4 + SIp5 + SIp5p) as Morosidad
			from SNClasificacionE cl
			inner join SNClasificacionD cd
				on cl.SNCEid = cd.SNCEid
				<!--- Valores de Clasificación --->
				<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
					<cfif url.SNCDvalor1 gt url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
						and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
										 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#">
					<cfelse>
						and rtrim(ltrim(cd.SNCDvalor)) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
										 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
					</cfif>
				<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
					and rtrim(ltrim(cd.SNCDvalor)) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor1)#"> 
				<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
					and rtrim(ltrim(dc.SNCDvalor)) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#"> 
				</cfif>

			inner join SNClasificacionSND cs
				on cs.SNCDid = cd.SNCDid
			
			inner join SNDirecciones ds
				on ds.SNid = cs.SNid
				and ds.id_direccion = cs.id_direccion
				<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
					and ds.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
				</cfif>
			
			inner join SNegocios sn
				on sn.SNid = ds.SNid
				and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				
			inner join SNSaldosIniciales si
				on sn.SNid = si.SNid
				and si.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarperiodo#">
				and si.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarmes#">
				and si.id_direccion = ds.id_direccion
			
			inner join Monedas m
				on m.Mcodigo = si.Mcodigo
				and m.Ecodigo = si.Ecodigo
			
			where cl.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
				#filtro#
			group by 
				m.Miso4217,
				m.Mnombre, 
				cd.SNCDvalor, 
				cd.SNCDdescripcion,
				cl.SNCEdescripcion,
				coalesce(ds.SNDcodigo,sn.SNnumero),
				coalesce(ds.SNnombre,sn.SNnombre)
			order by 1,3,6

		</cfquery>
	</cfif>
	
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
       	<cfset MSG_GeneraMas5000 = t.Translate('MSG_GeneraMas5000','Se han generado mas de 5000 registros para este reporte.')>
		<cf_errorCode	code = "50196" msg = "#MSG_GeneraMas5000#">
		<cfabort>
	</cfif>
	
	<!--- Busca el nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="rsSNCEdescripcion" datasource="#session.DSN#">
		select SNCEdescripcion
			from  SNClasificacionE
				where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
	</cfquery>

	<cfquery name="rsSNCDdescripcion1" datasource="#session.DSN#">
		select SNCDdescripcion
			from  SNClasificacionD
				where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid1#">
	</cfquery>

	<cfquery name="rsSNCDdescripcion2" datasource="#session.DSN#">
		select SNCDdescripcion
			from  SNClasificacionD
				where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid2#">
	</cfquery>

	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
		<cfset formatos = "excel"><!---a parte  boton download (query to file)--->
	</cfif>

	<!--- Invocación del reporte --->
	<cfset nombreReporteJR = "">
	<cfif url.TipoReporte EQ 0>
			<cfset LvarReporte = "AntiguedadSaldosxClas_X_Mes.cfr">
			<cfset nombreReporteJR = "AntiguedadSaldosxClas_X_Mes">
	</cfif>	

	<cfif url.TipoReporte GT 0>
		<cfset LvarReporte = "AntiguedadSaldosxClas_X_Mes_Cliente.cfr">
		<cfset nombreReporteJR = "AntiguedadSaldosxClas_X_Mes_Cliente">
	</cfif>

	<cfset LvarFechaCorte =	DateAdd("d", -1, createdate(#Lvarperiodo#,#Lvarmes#,01))>
    <cfset LB_CuentasporCobrar = t.Translate('LB_CuentasporCobrar','Cuentas por Cobrar')>
    <cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
    <cfset LB_Hora = t.Translate('LB_Hora','Hora')>
    <cfset LB_FechadeCorte = t.Translate('LB_FechadeCorte','Fecha de Corte')>
    <cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
    <cfset LB_CodValClas = t.Translate('LB_CodValClas','Código Valor de Clasificación')>
    <cfset LB_ValClas = t.Translate('LB_ValClas','Valor de Clasificación')>
    <cfset LB_Corriente = t.Translate('LB_Corriente','Corriente')>
	<cfset LB_SinVencer = t.Translate('LB_SinVencer','Sin Vencer')>
	<cfset LB_151omas = t.Translate('LB_151omas','151 o mas')>
	<cfset LB_Morosidad = t.Translate('LB_Morosidad','Morosidad')>
	<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
	<cfset LB_Criterio = t.Translate('LB_Criterio','Criterios de Selección:')>
	<cfset LB_ValorClasDesde = t.Translate('LB_ValorClasDesde','Valor Clasificación desde')>
	<cfset LB_ValorClasHasta = t.Translate('LB_ValorClasHasta','Valor Clasificación desde')>
	<cfset LB_OficinaInicial = t.Translate('LB_OficinaInicial','Oficina Inicial')>
	<cfset LB_OficinaFinal = t.Translate('LB_OficinaFinal','Oficina Final')>
    <cfset LB_Codigo = t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
	<cfset LB_SocioNegocio = t.Translate('LB_Socio_de_Negocios','Socio de Negocios','/sif/generales.xml')>
	<cfset LB_SocioNegDir = t.Translate('LB_SocioNegDir','Socio de Negocios/Dirección')>
                    
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.#nombreReporteJR#"/>
	<cfelse>
	<cfreport format="#formatos#" template="#LvarReporte#" query="rsReporte">
    	<cfreportparam name="LB_CuentasporCobrar" value="#LB_CuentasporCobrar#">
    	<cfreportparam name="LB_Cobrador" value="#LB_Cobrador#">
    	<cfreportparam name="LB_Fecha" value="#LB_Fecha#">
    	<cfreportparam name="LB_Hora" value="#LB_Hora#">
    	<cfreportparam name="LB_FechadeCorte" value="#LB_FechadeCorte#">
    	<cfreportparam name="LB_Moneda" value="#LB_Moneda#">
        <cfreportparam name="LB_ClasificacionSA" value="#LB_ClasificacionSA#">
    	<cfreportparam name="LB_CodValClas" value="#LB_CodValClas#">
    	<cfreportparam name="LB_ValClas" value="#LB_ValClas#">
    	<cfreportparam name="LB_Corriente" value="#LB_Corriente#">
    	<cfreportparam name="LB_SinVencer" value="#LB_SinVencer#">
    	<cfreportparam name="LB_151omas" value="#LB_151omas#">
    	<cfreportparam name="LB_Morosidad" value="#LB_Morosidad#">
    	<cfreportparam name="LB_Saldo" value="#LB_Saldo#">
    	<cfreportparam name="LB_Criterio" value="#LB_Criterio#">
    	<cfreportparam name="LB_ValorClasDesde" value="#LB_ValorClasDesde#">
    	<cfreportparam name="LB_ValorClasHasta" value="#LB_ValorClasHasta#">
    	<cfreportparam name="LB_Mes" value="#LB_Mes#">
    	<cfreportparam name="LB_OficinaInicial" value="#LB_OficinaInicial#">
    	<cfreportparam name="LB_OficinaFinal" 	value="#LB_OficinaFinal#">
    	<cfreportparam name="LB_Valor" value="#LB_Valor#">
    	<cfreportparam name="LB_Codigo" value="#LB_Codigo#">
    	<cfreportparam name="LB_SocioNegocio" value="#LB_SocioNegocio#">
    	<cfreportparam name="LB_SocioNegDir" value="#LB_SocioNegDir#">
    	<cfreportparam name="LB_Hasta" value="#LB_Hasta#">
        
		<cfif isdefined("rsSNCEdescripcion") and rsSNCEdescripcion.recordcount eq 1>
			<cfreportparam name="SNCEdescripcion" value="#rsSNCEdescripcion.SNCEdescripcion#">
		</cfif> 
		<cfif isdefined("rsSNCDdescripcion1") and rsSNCDdescripcion1.recordcount eq 1>
			<cfreportparam name="SNCDdescripcion1" value="#rsSNCDdescripcion1.SNCDdescripcion#">
		</cfif>
		<cfif isdefined("rsSNCDdescripcion2") and rsSNCDdescripcion2.recordcount eq 1>
			<cfreportparam name="SNCDdescripcion2" value="#rsSNCDdescripcion2.SNCDdescripcion#">
		</cfif>
		<cfif isdefined("url.Cobrador") and len(trim(url.Cobrador)) eq 0>
			<cfset url.cobrador = 'Todos'>
		</cfif>
		<cfreportparam name="Cobrador" value="#url.Cobrador#">

		<cfif isdefined("url.mes") and len(trim(Lvarmes))>
			<cfreportparam name="mes" value="#url.mes#">
		</cfif>

		<cfif isdefined("url.periodo") and len(trim(Lvarperiodo))>
			<cfreportparam name="periodo" value="#url.periodo#">
		</cfif>
		<cfif isdefined("url.mes") and len(trim(Lvarmes))>
			<cfreportparam name="Lvarmes" value="#Lvarmes#">
		</cfif>

		<cfif isdefined("url.periodo") and len(trim(Lvarperiodo))>
			<cfreportparam name="Lvarperiodo" value="#Lvarperiodo#">
		</cfif>
		
		<cfif isdefined("LvarFechaCorte") and len(trim(LvarFechaCorte))>
			<cfreportparam name="LvarFechaCorte" value="#LvarFechaCorte#">
		</cfif>
		
		<cfif isdefined("url.TipoReporte") and len(trim(url.TipoReporte))>
			<cfreportparam name="TipoReporte" value="#url.TipoReporte#">
			<cfset request.TipoReporte = url.TipoReporte>
		</cfif>

		<cfif isdefined("rsSNCEdescripcion_orden") and rsSNCEdescripcion_orden.recordcount eq 1>
			<cfreportparam name="SNCEdescripcion_orden" value="#rsSNCEdescripcion_orden.SNCEdescripcion#">
		</cfif>
	
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
		</cfif>

		<cfif isdefined("P1")>
			<cfreportparam name="P1" value="#P1#">
		</cfif>		

		<cfif isdefined("P2")>
			<cfreportparam name="P2" value="#P2#">
		</cfif>		

		<cfif isdefined("P3")>
			<cfreportparam name="P3" value="#P3#">
		</cfif>

		<cfif isdefined("P4")>
			<cfreportparam name="P4" value="#P4#">
		</cfif>
<cfset LB_TitRep1 = t.Translate('LB_TitRep1','Antigüedad de Saldos por Clasificación (Mes Cerrado): por Socio')>
<cfset LB_TitRep2 = t.Translate('LB_TitRep2','Antigüedad de Saldos por Clasificación (Mes Cerrado): por Dirección')>
<cfset LB_TitRep3 = t.Translate('LB_TitRep3','Antigüedad de Saldos,  Detallado por Clasificación / Cliente (Mes Cerrado): por Socio')>
<cfset LB_TitRep4 = t.Translate('LB_TitRep4','Antigüedad de Saldos,  Detallado por Clasificación / Cliente (Mes Cerrado): por Dirección')>
<cfset LB_TitRep5 = t.Translate('LB_TitRep5','Antigüedad de Saldos,  Detallado por Clasificación / Cliente / Dirección (Mes Cerrado): por Socio')>
<cfset LB_TitRep6 = t.Translate('LB_TitRep6','Antigüedad de Saldos,  Detallado por Clasificación / Cliente / Dirección (Mes Cerrado): por Dirección')>

		<cfif url.TipoReporte EQ 0>
			<cfif isdefined("url.TClasif") and url.TClasif EQ 0>
				<cfreportparam name="Titulo" value="#LB_TitRep1#">
			<cfelse>
				<cfreportparam name="Titulo" value="#LB_TitRep2#">
			</cfif>
		<cfelseif url.TipoReporte EQ 1>
			<cfif isdefined("url.TClasif") and url.TClasif EQ 0>
				<cfreportparam name="Titulo" value="#LB_TitRep3#">
			<cfelse>
				<cfreportparam name="Titulo" value="#LB_TitRep4#">
			</cfif>
		<cfelse>
			<cfif isdefined("url.TClasif") and url.TClasif EQ 0>
				<cfreportparam name="Titulo" value="#LB_TitRep5#">
			<cfelse>
				<cfreportparam name="Titulo" value="#LB_TitRep6#">
			</cfif>
		</cfif>
		
	</cfreport>	
	</cfif>
	
</cfif>
<cf_qforms>
    <cf_qformsRequiredField name="SNCEid" description="#LB_ClasificacionSA#">
    <cf_qformsRequiredField name="SNCDid1" description="#LB_Valor# #LB_ClasificacionSA# #LB_Desde#">
    <cf_qformsRequiredField name="SNCDid2" description="#LB_Valor# #LB_ClasificacionSA# #LB_Hasta#">
    <cf_qformsRequiredField name="periodo" description="LB_Periodo">
</cf_qforms>

