<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html><head><title>Procesando reporte...</title></head>
<body>

<p><center>
<img src="imagenes/esperese.gif" alt="Un momento por favor.... trabajando en el reporte" width="320" height="90" border="0">
</center></p>
<p>
<cfloop from="1" to="110" index="miau">
	<!--- mucho espacio en blanco --->
</cfloop>
</p>
<cfflush>
<!--- <cfsavecontent variable="micontenido"> --->
<cfoutput>	
<!--- <cfapplication  applicationtimeout="300" sessiontimeout="300"> --->

<cfsetting requesttimeout="3600">

<!--- ------------------------------------------------ --->
<!--- Validación de los paramétros enviados en el form --->
<!--- DEFINICION  DE VARIABLE ID_REPORTE:              --->
<!--- 	1 - SALDOS PARA 1 CUENTA 					   --->
<!---	2 - SALDOS PARA RANGO						   --->
<!---	3 - SALDOS PARA LISTA DE CUENTAS               --->
<!--- ------------------------------------------------ --->
<cfif isdefined ("form.ID_REPORTE") or len(trim(form.ID_REPORTE))>
	<cfset tiporep = form.ID_REPORTE>
<cfelse> 
	<cf_errorCode	code = "50341" msg = "No está definido el tipo de reporte.">
</cfif>

<cfif isdefined ("form.SEGMENTO") or len(trim(form.SEGMENTO))>
	<cfset sucursal = form.SEGMENTO>
<cfelse> 
	<cfset sucursal = "T">
</cfif>

<cfif isdefined ("form.NIVELDETALLE") or len(trim(form.NIVELDETALLE))>
	<cfset niveldetalle = form.NIVELDETALLE>
<cfelse> 
	<cfset niveldetalle = 1>
</cfif>

<cfif isdefined ("form.NIVELTOTAL") or len(trim(form.NIVELTOTAL))>
	<cfset niveltotal = form.NIVELTOTAL>
<cfelse> 
	<cfset niveltotal = 1>
</cfif>

<cfif isdefined("form.ASIECONTIDLIST") and len(trim(form.ASIECONTIDLIST))>
	<cfset AsieContidList = form.ASIECONTIDLIST>
<cfelse>
	<cfset AsieContidList = "">	
</cfif> 


<cfif isdefined("form.ID_TotalCtaRes") and len(trim(form.ID_TotalCtaRes))>
	<cfset TotalCtaRes = 1>
<cfelse>
	<cfset TotalCtaRes = 0>	
</cfif> 

<cfset LarrAsientos = ListToarray(AsieContidList)>

<cfif ID_REPORTE NEQ 3>
	<cfif isdefined("form.CUENTASLIST") and len(trim(form.CUENTASLIST))>
		<cfset cuentalista = form.CUENTASLIST>
	<cfelse>
		<cfset cuentalista = "">	
	</cfif> 
<cfelse>
	<cfif isdefined("form.CUENTAIDLIST") and len(trim(form.CUENTAIDLIST))>
		<cfset cuentalista = form.CUENTAIDLIST>
	<cfelse>
		<cfset cuentalista = "">	
		<script language="JavaScript">
		alert('Error debe agregar las cuentas a la lista ')
		document.location = "../reportes/cmn_SaldosAsientoCuentas.cfm";
		</script>
	</cfif> 
</cfif>

<!---  <cfdump  var="#cuentalista#">
 --->

<cfset strAsientos = "">
<cfset LarrAsientos= ListToarray(AsieContidList)>
<cfloop index="i"  from="1" to="#ArrayLen(LarrAsientos)#">
	<cfset strAsientos = "#strAsientos#" & "#LarrAsientos[i]#">
	<cfif "#i#" neq "#ArrayLen(LarrAsientos)#">
		<cfset strAsientos = strAsientos & ",">
	</cfif>	
</cfloop>
<cfquery name="rsSucursales" datasource="#session.Conta.dsn#">
	select a.CGE5COD
	from CGE005 a, CGE000 b
	where a.CGE1COD = b.CGE1COD
	<cfif sucursal NEQ "T">
			and a.CGE5COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sucursal#">
		union
		select CGE5COD
		from anex_sucursald
		where cod_suc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sucursal#">
	</cfif>	  
</cfquery>

<cfset strSucursales = "">
<cfloop query="rsSucursales" >
	<cfset strSucursales = "#strSucursales#" & "'" & #rsSucursales.CGE5COD# & "'" >
	<cfif rsSucursales.currentrow lt rsSucursales.recordcount>
		<cfset strSucursales = strSucursales & ",">
	</cfif>	
</cfloop>
<cfset mesini = form.MESINICIAL>
<cfset mesfin = form.MESFINAL>  
<cfset anoini = form.ANOINICIAL>
<cfset anofin = anoini>

<cfset bandera = 0>  
<cfset imes = mesini> 
<cfset iano = anoini> 

<cfquery name="rsPrimeraCuenta" datasource="#session.Conta.dsn#">
	select min(CGM1IM) as Cuenta 
	from CGM001 
	where CGM1CD is null
</cfquery>

<cfquery name="rsLongCuenta" datasource="#session.Conta.dsn#">
	select datalength(convert(varchar, CGM1IM)) as Long 
	from CGM001 
	where CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPrimeraCuenta.Cuenta#">
	  and CGM1CD is null
</cfquery>

<cfset long = #rsLongCuenta.Long#>

<!---
create table tbl_reportecf (
	rptid numeric identity not null,   -- numero del reporte
	fechaini datetime,                 -- fecha y hora de arranque del proceso
	fechafin datetime,                 -- fecha y hora de finalizacion del pintado
	archivo char(12) default 'tbl_cuentas',  -- archivo utilizado
	fechacontrol datetime null,        -- fecha y hora de finalizacion de insercion de registros detalle
	fechacontrol1 datetime null,       -- fecha y hora de finalizacion de insercion de registros padres
	fechacontrol2 datetime null        -- fecha y hora de finalizacion de insercion de registros mayor
)

create index tbl_reportecf00 on tbl_reportecf (rptid)

create table tbl_reportecfp (
	rptid numeric not null,            -- numero del reporte
    parametros varchar(255) null       -- parametros del reporte
)
create index tbl_reportecfp01 on tbl_reportecfp (rptid)	
	
create table tbl_cuentas (
	rptid numeric not null,             -- numero del reporte
	CuentaMayor int,                    -- Cuenta a "pintar" 
	FormatoCuenta char(30),             -- Formato de la Cuenta a "printar"
	CuentaDetalle int,                  -- Cuenta de Detalle para sumarizar
	Detalle int,                        -- Detalle -1- o Mayor -0-
	niveltotal int null                 -- nivel del total para el reporte
)

create index tbl_cuentas00 on tbl_cuentas (rptid, CuentaMayor)

se generan archivos iguales desde tb_cuentas1 hasta tbl_cuentas5

--->

<cfquery name="rs_creatablatemp" datasource="#session.Conta.dsn#">
	insert into tbl_reportecf (fechaini, fechafin, archivo, fechacontrol, fechacontrol1, fechacontrol2)
	select getdate(), getdate(), 'tbl_cuentas', null, null, null
	select @@identity as llave
</cfquery>


<cfset llave =  #rs_creatablatemp.llave#>

<cfquery name="rs_creatablatemp" datasource="#session.Conta.dsn#">
	insert into tbl_reportecfp (rptid, parametros)
	select #llave#, <cfqueryparam  cfsqltype="cf_sql_longvarchar" value="#trim(session.usuario)#-#cuentalista#">
</cfquery>

<cfset archivotbl = "tbl_cuentas">
<cfset numeroarchivo = llave mod 6>
<cfif numeroarchivo GT 0 and numeroarchivo LT 6>
	<cfset archivotbl = archivotbl & trim(numeroarchivo)>
	<cfquery name="rs_acttablatemp1" datasource="#session.Conta.dsn#">
		update tbl_reportecf 
			set archivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#archivotbl#">
		where rptid = #llave#
	</cfquery>
</cfif>
	
<cfset LarrCuentas = ListToarray(cuentalista)>
<cftry> 
	<cfif ID_REPORTE EQ 2>
		<cfset cuenta = "#LarrCuentas[1]#">
		<cfset cMayor1 = mid(cuenta,1,long)>
		<cfset cDetalle1 = mid(cuenta,long + 1,len(cuenta))>

		<cfset cuenta = "#LarrCuentas[2]#">
		<cfset cMayor2 = mid(cuenta,1,long)>
		<cfset cDetalle2 = mid(cuenta,long + 1,len(cuenta))>

		<cfset rango1 = cMayor1 & cDetalle1>
		<cfset rango2 = cMayor2 & cDetalle2>
		<cfquery name="rsCuentas" datasource="#session.Conta.dsn#">
			set transaction isolation level 0	

			insert into #archivotbl# 
			(rptid, CuentaMayor, FormatoCuenta, CuentaDetalle, Detalle, niveltotal)
			select 	#llave#,
					c.ctanivel as CuentaMayor, 
					d.CGM1IM + ' ' + d.CGM1CD as FormatoCuenta,
					c.CGM1ID as CuentaDetalle, 
					1 as Detalle,
					#niveltotal# as niveltotal
		    from CGM001 ct (index CGM00103)
				inner join CGM001cubo c
					inner join CGM001 d
					  on d.CGM1ID = c.ctanivel
				  on  c.CGM1ID = ct.CGM1ID
			      and c.nivelcubo = #niveldetalle#
			where ct.CGM1IM >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#cMayor1#">
			  and ct.CGM1IM <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#cMayor2#">
			  and ltrim(rtrim(ct.CGM1IM))+ ct.CGM1CD between <cfqueryparam cfsqltype="cf_sql_varchar" value="#rango1#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#rango2#">

			set transaction isolation level 1

		</cfquery>
	<cfelse>	
		<cfloop index="i"  from="1" to="#ArrayLen(LarrCuentas)#">
			<cfset arreglo = listtoarray(LarrCuentas[i],"¶")>	
			<cfset cuenta = "#arreglo[1]#">
			<cfset cMayor = mid(cuenta,1,long)>
			<cfset cDetalle = trim(mid(cuenta,long + 1,len(cuenta)))>
			<!---
				OJO. Si se puede obtener el primer nivel de la cuenta
				con VALORES, se puede mejorar el query de inserción
				a la tabla tbl_cuentas, en especial cuando se selecciona
				un nivel al final.  Por ejemplo:  0009 ___ ___ ___ 003
				y se puede obtener que el primer nivel con valores es 4 y el valor es 003,
				se genera un query mas eficiente.
				Siempre y cuando el nivel sea mayor a 0
			--->
			<cfset primernivel = 0>
			<cfset valorprimernivel = " ">			
			<cfif  len(trim(cDetalle)) gt 0 >
				<cfif len(trim(arreglo[2])) gt 0 >
					<cfset  primernivel = arreglo[2] >
				</cfif>
				<cfif  len(trim(arreglo[3])) gt 0 >
					<cfset  valorprimernivel = arreglo[3] >
				</cfif>
			</cfif>
			<cfif primernivel GT 0>
				<cfquery name="rsCuentas1" datasource="#session.Conta.dsn#">
					set transaction isolation level 0	

					insert into #archivotbl#  (rptid, CuentaMayor, FormatoCuenta, CuentaDetalle, Detalle, niveltotal)
					select 	#llave#,
						c.ctanivel as CuentaMayor, 
						d.CGM1IM + ' ' + d.CGM1CD as FormatoCuenta,
						c.CGM1ID as CuentaDetalle, 
						1 as Detalle,
						#niveltotal# as niveltotal
					from CGM001cubo c1 (index CGM001cubo02)
						INNER JOIN CGM001 ct (index CGM00100)
							on  ct.CGM1ID = c1.CGM1ID 
							and ct.CGM1CD like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(cDetalle)#%">
						INNER JOIN CGM001cubo c (index CGM001cubo01)
							on  c.CGM1ID = ct.CGM1ID 
							and c.nivelcubo = #niveldetalle#
						INNER JOIN CGM001 d (index CGM00100)
							on d.CGM1ID = c.ctanivel 
	 				where c1.CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cMayor#">
					  and c1.nivelcubo = <cfqueryparam cfsqltype="cf_sql_integer" value="#primernivel#">
					  and c1.CG12ID like <cfqueryparam cfsqltype="cf_sql_varchar" value="#valorprimernivel#%">
					<cfif i GT 1>
					  and not exists(
					  		select 1 
							from #archivotbl#  ci 
							where ci.rptid = #llave# 
							  and ci.CuentaMayor = c.ctanivel
							  and ci.CuentaDetalle = c.CGM1ID
							)
					</cfif>
					set transaction isolation level 1
				</cfquery>
			<cfelse>
				<cfquery name="rsCuentas" datasource="#session.Conta.dsn#">
					set transaction isolation level 0	

					insert into #archivotbl#  (rptid, CuentaMayor, FormatoCuenta, CuentaDetalle, Detalle, niveltotal)
					select 	
						#llave#,
						c.ctanivel as CuentaMayor, 
						d.CGM1IM + ' ' + d.CGM1CD as FormatoCuenta,
						c.CGM1ID as CuentaDetalle, 
						1 as Detalle,
						#niveltotal# as niveltotal
					from CGM001cubo c (index CGM001cubo02)
						INNER JOIN CGM001 ct (index CGM00100)
							 ON ct.CGM1ID = c.CGM1ID
							<cfif trim(cDetalle) NEQ "">
							  AND ct.CGM1CD like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(cDetalle)#%">
							</cfif>
						INNER JOIN CGM001 d (index CGM00100)
							 ON d.CGM1ID = c.ctanivel 
	 				where c.CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cMayor#">
					  and c.nivelcubo = #niveldetalle#
					  <cfif i GT 1>
					  and not exists
					  			(select 1 from #archivotbl# ci 
								  where ci.rptid = #llave# 
								    and ci.CuentaMayor = c.ctanivel
								    and ci.CuentaDetalle = c.CGM1ID
								)
					  </cfif>
					set transaction isolation level 1
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>

	<cfquery name="rs_acttablatemp1" datasource="#session.Conta.dsn#">
		update tbl_reportecf 
			set fechacontrol = getdate()
		where rptid = #llave#
	</cfquery>


	<cfif niveltotal LT niveldetalle>
		<cfquery name="rsIncluyeCtasCorte" datasource="#session.Conta.dsn#">
			set transaction isolation level 0	

			insert into #archivotbl#  (rptid, CuentaMayor, FormatoCuenta, CuentaDetalle, Detalle, niveltotal)
			select 	distinct #llave#,
				cm.CGM1ID as CuentaMayor, 
				cm.CGM1IM || ' ' || cm.CGM1CD as FormatoCuenta,
				<cfif TotalCtaRes EQ 1>
					c.ctanivel as CuentaDetalle,
				<cfelse>
					ctas.CuentaDetalle as CuentaDetalle, 
				</cfif>
				0 as Detalle,
				#niveltotal# as niveltotal
			 from #archivotbl# ctas (index #archivotbl#00)
				inner join CGM001cubo c (index CGM001cubo01)
					inner join CGM001 cm (index CGM00100)
						on cm.CGM1ID = c.ctanivel
					on  c.CGM1ID = ctas.CuentaDetalle 
					and c.nivelcubo = ctas.niveltotal
			 where ctas.rptid = #llave#

			set transaction isolation level 1
		</cfquery>
	</cfif>

	<cfquery name="rs_acttablatemp1" datasource="#session.Conta.dsn#">
		update tbl_reportecf 
			set fechacontrol1 = getdate()
		where rptid = #llave#
	</cfquery>
	
	<cfquery name="rsIncluyeCtasMayor" datasource="#session.Conta.dsn#">
		set transaction isolation level 0	

		insert into #archivotbl#  (rptid, CuentaMayor, FormatoCuenta, CuentaDetalle, Detalle)
		select 	distinct #llave#,
			cm.CGM1ID as CuentaMayor, 
			cm.CGM1IM as FormatoCuenta,
			<cfif TotalCtaRes EQ 1>
				cm.CGM1ID as CuentaDetalle,
			<cfelse>
				ctas.CuentaDetalle as CuentaDetalle, 
			</cfif>
			0 as Detalle
		 from #archivotbl# ctas (index #archivotbl#00)
			inner join CGM001 ct (index CGM00100)
				on ct.CGM1ID = ctas.CuentaDetalle
			inner join CGM001 cm (index CGM00103)
			    on cm.CGM1IM = ct.CGM1IM
			   and cm.CGM1CD is null
		 where ctas.rptid = #llave#
	   <cfif niveltotal LT niveldetalle>
		  and ctas.Detalle = 0
	   </cfif>

		set transaction isolation level 1
	</cfquery>

	<cfquery name="rs_acttablatemp2" datasource="#session.Conta.dsn#">
		update tbl_reportecf 
		set fechacontrol2 = getdate() 
		where rptid = #llave#
	</cfquery>

	<cfquery name="rsCuentasContables" datasource="#session.Conta.dsn#" >
		set transaction isolation level 0
			select  
					a.FormatoCuenta, 
				 	a.CuentaMayor, 
					a.Detalle, 
					convert(char(20), c.CTADES) as Descripcion, 
					c.CGM1FI as MascaraCuenta,
					coalesce(sum((
						select sum(CTSSAN)
						<cfif len(strAsientos) GT 0>
							from CGM007 s (index CGM00700)
						<cfelse>
							from CGM004 s (index CGM00400)
						</cfif>
						where s.CGM1ID = a.CuentaDetalle
						  and s.CTSPER = #anoini#
						  and s.CTSMES = #mesini#
						<cfif len(strAsientos) GT 0>
						  and s.CG5CON in (#strAsientos#)
						</cfif>
						<cfif sucursal NEQ "T">
							and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
						</cfif>
					)), 0.00) as SaldoIncial,
					coalesce(sum((
						select sum(CTSDEB)
						<cfif len(strAsientos) GT 0>
							from CGM007 s (index CGM00700)
						<cfelse>
							from CGM004 s (index CGM00400)
						</cfif>
						where s.CGM1ID = a.CuentaDetalle
						  and s.CTSPER = #anoini#
						  and s.CTSMES >= #mesini#
						  and s.CTSMES <= #mesfin#
						<cfif len(strAsientos) GT 0>
						  and s.CG5CON in (#strAsientos#)
						</cfif>
						<cfif sucursal NEQ "T">
							and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
						</cfif>
					)), 0.00) as Debitos,
					coalesce(sum((
						select sum(CTSCRE)
						<cfif len(strAsientos) GT 0>
							from CGM007 s (index CGM00700)
						<cfelse>
							from CGM004 s (index CGM00400)
						</cfif>
						where s.CGM1ID = a.CuentaDetalle
						  and s.CTSPER = #anoini#
						  and s.CTSMES >= #mesini#
						  and s.CTSMES <= #mesfin#
						<cfif len(strAsientos) GT 0>
						  and s.CG5CON in (#strAsientos#)
						</cfif>
						<cfif sucursal NEQ "T">
							and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
						</cfif>
					)), 0.00) as Creditos
		from #archivotbl#  a, CGM001 c
		where a.rptid = #llave#
		  and c.CGM1ID = a.CuentaMayor
		group by a.FormatoCuenta, a.CuentaMayor, a.Detalle, convert(char(20), c.CTADES) , c.CGM1FI
		order by a.FormatoCuenta

		set transaction isolation level 1

	</cfquery>

	<cfquery name="rs_acttablatemp2" datasource="#session.Conta.dsn#">
		update tbl_reportecf 
		set fechacontrol3 = getdate() 
		where rptid = #llave#
	</cfquery>

<cfinclude template="Reporte.cfm">

<cfcatch type="any">
	<cfdump  var="#cfcatch#">
	<cfquery name="rs_acttablatemp1" datasource="#session.Conta.dsn#">
		update tbl_reportecf 
			set archivo = 'error'
		where rptid = #llave#
	</cfquery>
	<cfquery name="borradatos" datasource="#session.Conta.dsn#">
		delete #archivotbl# 
		where rptid = #llave#
	</cfquery>	
	<cfexit>
</cfcatch>

</cftry>

<cfquery name="actualizafecha" datasource="#session.Conta.dsn#">
	update tbl_reportecf
	set fechafin = getdate()
	where rptid = #llave#
</cfquery>

<cfquery name="borradatos" datasource="#session.Conta.dsn#">
	delete #archivotbl# 
	where rptid = #llave#
</cfquery>

</cfoutput>
<cfset session.tempfile_cfm = tempfile_cfm>
<script type="text/javascript">location.href='ReporteBalance2.cfm';</script>

<a href="ReporteBalance2.cfm">Reporte generado, haga clic para verlo</a>

</body>
</html>


