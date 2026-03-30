
<cfif isdefined ('url.CaridList') and len(trim(url.CaridList)) gt 0>
	<cfset parametros='&RCNid=#url.RCNid#&radrep=#url.radrep#&CaridList=#url.CaridList#'>
</cfif>
<cfif isdefined ('url.DedidList') and len(trim(url.DedidList)) gt 0>
	<cfset parametros='&RCNid=#url.RCNid#&radrep=#url.radrep#&DedidList=#url.DedidList#'>
</cfif>
<cfif isdefined ('url.mostrarEmpleados')>
	<cfset parametros= parametros & '&mostrarEmpleados=1'>
</cfif>
<cfif not isdefined ('url.CaridList') and not isdefined ('url.DedidList')>
	<cfthrow message="No se definio ningun parametro">
</cfif>
<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="RepDedCargas.cfm"
	param="#parametros#"
	FileName="AsientoContable.xls"
	title="AsientoContable">

<cfquery name="datosN" datasource="#session.DSN#">
	select CPcodigo,CPmes,CPperiodo
	from HRCalculoNomina a
	inner join CalendarioPagos b
		on b.CPid = a.RCNid
		and b.Ecodigo = a.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
</cfquery>

<cfif url.radrep eq 3>
<cf_dbtemp name="salidaCargas" returnvariable="salida">
	<cf_dbtempcol name="RCNid"		type="numeric"      mandatory="yes">
	<cf_dbtempcol name="RCdesde"   	type="datetime" 	mandatory="yes">
	<cf_dbtempcol name="RChasta"  	type="datetime" 	mandatory="no">
	<cf_dbtempcol name="CCvalorpat"	type="money" 		mandatory="no">
	<cf_dbtempcol name="DEid"		type="numeric"      mandatory="yes">
	<cf_dbtempcol name="DClinea"	type="numeric" 		mandatory="no"> <!--- LZ20100330 el campo en la tabla era ECid, el cual es incorrecto es por DCLinea (Detalle de Carga)--->
	<cf_dbtempcol name="Cformato"	type="varchar(40)"	mandatory="no">
	<cf_dbtempcol name="Nivel1"		type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="Nivel2"		type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="Nivel3"		type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="Nivel4"		type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="Nivel5"		type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="Nivel6"		type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="Nivel7"		type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="Nivel8"		type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="Identificacion"	type="varchar(40)"      mandatory="no">
	<cf_dbtempcol name="Nombre"			type="varchar(40)"      mandatory="no">
	<cf_dbtempcol name="Apellido1"		type="varchar(40)"      mandatory="no">
	<cf_dbtempcol name="Apellido2"		type="varchar(40)"      mandatory="no">
</cf_dbtemp>

<cfquery name="rsDatos" datasource="#session.dsn#">
	insert into #salida#(RCNid,RCdesde,RChasta,CCvalorpat
	,DEid
	<cfif isdefined("url.mostrarEmpleados")>
	,Identificacion
	,Nombre
	,Apellido1
	,Apellido2
	</cfif>
	,DClinea,Cformato, Nivel1,Nivel2,Nivel3,Nivel4,Nivel6,Nivel7,Nivel8)
	select a.RCNid ,a.RCdesde,a.RChasta,b.CCvalorpat
		,b.DEid
		<cfif isdefined("url.mostrarEmpleados")>
		,dx.DEidentificacion
		,dx.DEnombre
		,dx.DEapellido1
		,dx.DEapellido2
		</cfif>
		,c.ECid,
			cc.Cformato, substring (cc.Cformato,2,3) as Nivel1, substring(cc.Cformato,6,2) as Nivel2,
			substring(cc.Cformato,9,3) as Nivel3, substring(cc.Cformato,13,2) as Nivel4, 
			'0000' as Nivel6, '0000' as Nivel7, '0000' as Nivel8
	from HRCalculoNomina a
		inner join HCargasCalculo b
		on b.RCNid = a.RCNid
			inner join DCargas c
			on c.DClinea = b.DClinea
				inner join SNegocios d
				on d.SNcodigo = c.SNcodigo
			and d.Ecodigo = a.Ecodigo
				inner join CContables cc
				on cc.Ccuenta = d.SNcuentacxc
		<cfif isdefined("url.mostrarEmpleados")>
		inner join DatosEmpleado dx
		on dx.DEid = b.DEid
		</cfif>

WHERE a.Ecodigo = #session.Ecodigo#
and a.RCNid = #url.RCNid#
and c.DClinea in( #url.CaridList#) <!--- LZ20100330 la condicion era por ECid, el cual es incorrecto es por DCLinea (Detalle de Carga)--->
</cfquery>

<cfquery name="rsCD" datasource="#session.DSN#">
	update #salida#
	set Nivel5 = (select min(substring(CFcuentac,16,4))
					from LineaTiempo a
					inner join RHPlazas b
						on b.RHPid = a.RHPid
						and b.Ecodigo =a.Ecodigo
					inner join CFuncional c
						on c.CFid = b.CFid
						and c.Ecodigo = a.Ecodigo
					where a.Ecodigo = #session.Ecodigo#
					  and DEid = #salida#.DEid
					  and (#salida#.RCdesde between LTdesde and LThasta
						or #salida#.RChasta between LTdesde and LThasta))
</cfquery>


<cfquery name="rsDatos" datasource="#session.DSN#">
	select 
	<cfif isdefined("url.mostrarEmpleados")>
		DEid
		,Identificacion
		,Nombre
		,Apellido1
		,Apellido2,
	</cfif>
	RChasta, CCvalorpat, Nivel1, Nivel2, Nivel3, Nivel4,Nivel5, Nivel6,Nivel7, Nivel8
	from #salida#
	<cfif isdefined("url.mostrarEmpleados")>
	order by 
		Identificacion
		,Nombre
		,Apellido1
		,Apellido2
	</cfif>
</cfquery>

<cfquery name="rsDatos2" datasource="#session.dsn#">
	select 
	 s.SNcodigo,sum(c.CCvalorpat) as CCvalorpat,min(c.RCNid) as RCNid,min(h.RChasta) as RChasta
	,substring(min(cc.Cformato),2,3) as Nivel1
	,substring(min(cc.Cformato),6,2) as Nivel2
	,substring(min(cc.Cformato),9,3) as Nivel3
	,substring(min(cc.Cformato),13,2) as Nivel4
	,substring(min(cc.Cformato),16,4) as Nivel5
	,'0000' as Nivel6, '0000' as Nivel7, '0000' as Nivel8
	from
	HRCalculoNomina h			
		inner join HCargasCalculo c
			inner join DCargas d
				inner join SNegocios s
					inner join CContables cc
					on cc.Ccuenta=s.SNcuentacxp
				on s.SNcodigo =d.SNcodigo
				and s.Ecodigo=#session.Ecodigo#
			on d.DClinea=c.DClinea
			and d.DClinea in (#url.CaridList#)  <!--- LZ20100330 la condicion era por ECid, el cual es incorrecto es por DCLinea (Detalle de Carga)--->
		on c.RCNid=h.RCNid
		and c.RCNid=#url.RCNid#	
		
	where h.Ecodigo=#session.Ecodigo#
	and h.RCNid=#url.RCNid#	
	group by s.SNcodigo
</cfquery>

<table border="1" cellpadding="0" cellspacing="0">
	<tr bgcolor="#CCCCCC">
		<cfif isdefined("url.mostrarEmpleados")  and rsDatos.recordCount GT 0>
			<td><strong>IDENTIFICACION</strong></td>
			<td><strong>NOMBRE</strong></td>
			<td><strong>APELLIDOS</strong></td>
		</cfif>
		<td><strong>NUMERO_MOVIMIENTO</strong></td>
		<td><strong>USUARIO</strong></td>
		<td><strong>FECHA_MOVIMIENTO</strong></td>
		<td><strong>SECUENCIA_RENGLON</strong></td>
		<td><strong>DEBITO_CREDITO</strong></td>
		<td><strong>MONTO_MOVIMIENTO</strong></td>
		<td><strong>MONTO_MOVIMIENTO_LOCAL</strong></td>
		<td><strong>MOVIMIENTO_AJUSTE</strong></td>
		<td><strong>CODIGO_EMPRESA</strong></td>
		<td><strong>NIVEL_1</strong></td>
		<td><strong>NIVEL_2</strong></td>
		<td><strong>NIVEL_3</strong></td>
		<td><strong>NIVEL_4</strong></td>
		<td><strong>NIVEL_5</strong></td>
		<td><strong>NIVEL_6</strong></td>
		<td><strong>NIVEL_7</strong></td>
		<td><strong>NIVEL_8</strong></td>
		<td><strong>CODIGO_MONEDA</strong></td>
		<td><strong>CODIGO_AUXILIAR</strong></td>
		<td><strong>DESCRIPCION</strong></td>
		<td><strong>REFERENCIA</strong></td>
		<td><strong>NUMERO_AUTORIZACION</strong></td>
		<td><strong>USUARIO_AUTORIZADOR</strong></td>
		<td><strong>TASA_CAMBIO</strong></td>
		<td><strong>FECHA_TIPO_CAMBIO</strong></td>
		<td><strong>CODIGO_COMPANIA</strong></td>
		<td><strong>NUMERO_REFERENCIA</strong></td>
		<td><strong>CENTRO_DE_COSTO</strong></td>
		<td><strong>CODIGO_PRESUPUESTO</strong></td>
		<td><strong>CLASE_PRESUPUESTO</strong></td>
		<td><strong>NUMERO_ORDEN</strong></td>
		<td><strong>NUMERO_ITEM_ORDEN</strong></td>
		<td><strong>CODIGO_AUXILIAR_REF</strong></td>
		<td><strong>REFERENCIA_ORIGEN</strong></td>
	</tr>
	<cfset count=1>
	
	<cfoutput>
	
	<cfloop query="rsDatos">
		<cfif rsDatos.CCvalorpat gt 0>
		<tr>
			
			<cfif isdefined("url.mostrarEmpleados") >
				<td>#rsDatos.Identificacion#</td>
				<td>#rsDatos.nombre#</td>
				<td>#rsDatos.apellido1# #rsDatos.apellido2#</td>
			</cfif>

			<td>&nbsp;03#datosN.CPmes##datosN.CPperiodo#</td>
			<td>CSNOMINA</td>
			<td align="right">#LSdateFormat(rsDatos.RChasta,'dd/mm/yyyy')#</td>
			<td>#count#</td>
			<td>C</td>
			<td align="right"><cfset neg=#rsDatos.CCvalorpat#*-1>#NumberFormat(neg,",0.00")#</td>
			<td align="right"><cfset neg=#rsDatos.CCvalorpat#*-1>#NumberFormat(neg,",0.00")#</td>
			<td>N</td>
			<td>1</td>
			<td><cfif len(trim(rsDatos.Nivel1)) gt 0>&nbsp;#rsDatos.Nivel1#<cfelse>&nbsp;</cfif></td>
			<td><cfif len(trim(rsDatos.Nivel2)) gt 0>&nbsp;#rsDatos.Nivel2#<cfelse>&nbsp;</cfif></td>
			<td><cfif len(trim(rsDatos.Nivel3)) gt 0>&nbsp;#rsDatos.Nivel3#<cfelse>&nbsp;</cfif></td>
			<td><cfif len(trim(rsDatos.Nivel4)) gt 0>&nbsp;#rsDatos.Nivel4#<cfelse>&nbsp;</cfif></td>
			<td><cfif len(trim(rsDatos.Nivel5)) gt 0>&nbsp;#rsDatos.Nivel5#<cfelse>&nbsp;</cfif></td>
			<td><cfif len(trim(rsDatos.Nivel6)) gt 0>&nbsp;#rsDatos.Nivel6#<cfelse>&nbsp;</cfif></td>
			<td><cfif len(trim(rsDatos.Nivel7)) gt 0>&nbsp;#rsDatos.Nivel7#<cfelse>&nbsp;</cfif></td>
			<td><cfif len(trim(rsDatos.Nivel8)) gt 0>&nbsp;#rsDatos.Nivel8#<cfelse>&nbsp;</cfif></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>ASIENTO REVERSION PLANILLA #datosN.CPcodigo#</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<cfset count=count+1>
	</cfif>
	</cfloop>
	
	<cfloop query="rsDatos2">
	<tr>
		<cfif isdefined("url.mostrarEmpleados") and rsDatos.recordCount GT 0>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</cfif>
		<td>&nbsp;03#datosN.CPmes##datosN.CPperiodo#</td>
		<td>CSNOMINA</td>
		<td align="right">#LSdateFormat(rsDatos2.RChasta,'dd/mm/yyyy')#</td>
		<td>#count#</td>
		<td>D</td>
		<td align="right">#NumberFormat(rsDatos2.CCvalorpat,",0.00")#</td>
		<td align="right">#NumberFormat(rsDatos2.CCvalorpat,",0.00")#</td>
		<td>N</td>
		<td>1</td>
		<td><cfif len(trim(rsDatos2.Nivel1)) gt 0>&nbsp;#rsDatos2.Nivel1#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel2)) gt 0>&nbsp;#rsDatos2.Nivel2#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel3)) gt 0>&nbsp;#rsDatos2.Nivel3#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel4)) gt 0>&nbsp;#rsDatos2.Nivel4#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel5)) gt 0>&nbsp;#rsDatos2.Nivel5#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel6)) gt 0>&nbsp;#rsDatos2.Nivel6#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel7)) gt 0>&nbsp;#rsDatos2.Nivel7#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel8)) gt 0>&nbsp;#rsDatos2.Nivel8#<cfelse>&nbsp;</cfif></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>ASIENTO REVERSION PLANILLA #datosN.CPcodigo#</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	<cfset count=count+1>
	</tr>
	</cfloop>
</cfoutput>
</table>

</cfif>

<cfif radrep eq 2>
	<cfquery name="rsDatos" datasource="#session.dsn#">
		select h.RCNid 
		,u.Usulogin
		,h.RChasta
		,d.Dmonto
		,s.SNcodigo
		,c.DEid
		<cfif isdefined("url.mostrarEmpleados")>
		,dx.DEidentificacion as identificacion
		,dx.DEnombre as nombre
		,dx.DEapellido1 as Apellido1
		,dx.DEapellido2 as Apellido2
		</cfif>
		,'N'
		,1
		,cc.Cformato
		, substring (cc.Cformato,2,3) as Nivel1
		, substring(cc.Cformato,6,2) as Nivel2
		, substring(cc.Cformato,9,3) as Nivel3
		, substring(cc.Cformato,13,2) as Nivel4
		, substring(cf.CFcuentac,16,4) as Nivel5
		,'0000' as Nivel6
		,'0000' as Nivel7
		,'0000' as Nivel8
		, 1 as CodMoneda
		,l.RHPid
	from
	HRCalculoNomina h
		inner join Usuario u
		on u.Usucodigo=h.Usucodigo
	
		inner join HDeduccionesCalculo c
			inner join DeduccionesEmpleado d			
				inner join SNegocios s
					inner join CContables cc
					on cc.Ccuenta=s.SNcuentacxp
				on s.SNcodigo =d.SNcodigo
				and s.Ecodigo=#session.Ecodigo#
			on d.Did=c.Did
		and d.TDid in (#url.DedidList#)
	
			inner join LineaTiempo l
				inner join RHPlazas p
					inner join CFuncional cf					
					on cf.CFid= p.CFid
				on p.RHPid=l.RHPid
			on l.DEid=c.DEid
			
		on c.RCNid=h.RCNid
		and h.RChasta between l.LTdesde and l.LThasta
		
		<cfif isdefined("url.mostrarEmpleados")>
			inner join DatosEmpleado dx
			on dx.DEid=c.DEid
		</cfif>
		
	where h.Ecodigo=#session.Ecodigo#
	and h.RCNid=#url.RCNid#	
	</cfquery>
	
	<cfquery name="rsDatos2" datasource="#session.dsn#">
		select 
		s.SNcodigo
		,sum(d.Dmonto) as Dmonto
		,min(h.RCNid) as RCNid
		,min(d.Dfechaini) as RChasta
		,substring(min(cc.Cformato),2,3) as Nivel1
		,substring(min(cc.Cformato),6,2) as Nivel2
		,substring(min(cc.Cformato),9,3) as Nivel3
		,substring(min(cc.Cformato),13,2) as Nivel4
		,substring(min(cc.Cformato),16,4) as Nivel5
		,'0000' as Nivel6, '0000' as Nivel7
		, '0000' as Nivel8
		from
		HDeduccionesCalculo h			
				inner join DeduccionesEmpleado d
					inner join SNegocios s
						inner join CContables cc
						on cc.Ccuenta=s.SNcuentacxp
					on s.SNcodigo =d.SNcodigo
					and s.Ecodigo=#session.Ecodigo#
				on d.Did=h.Did
				and d.TDid in (#url.DedidList#)
			
		where  h.RCNid=#url.RCNid#	
		group by s.SNcodigo
		order by s.SNcodigo
	</cfquery>
	
	<table border="1" cellpadding="0" cellspacing="0">
	<tr bgcolor="#CCCCCC">
		<cfif isdefined("url.mostrarEmpleados")  and rsDatos.recordCount GT 0>
			<td><strong>IDENTIFICACION</strong></td>
			<td><strong>NOMBRE</strong></td>
			<td><strong>APELLIDOS</strong></td>
		</cfif>
		<td><strong>NUMERO_MOVIMIENTO</strong></td>
		<td><strong>USUARIO</strong></td>
		<td><strong>FECHA_MOVIMIENTO</strong></td>
		<td><strong>SECUENCIA_RENGLON</strong></td>
		<td><strong>DEBITO_CREDITO</strong></td>
		<td><strong>MONTO_MOVIMIENTO</strong></td>
		<td><strong>MONTO_MOVIMIENTO_LOCAL</strong></td>
		<td><strong>MOVIMIENTO_AJUSTE</strong></td>
		<td><strong>CODIGO_EMPRESA</strong></td>
		<td><strong>NIVEL_1</strong></td>
		<td><strong>NIVEL_2</strong></td>
		<td><strong>NIVEL_3</strong></td>
		<td><strong>NIVEL_4</strong></td>
		<td><strong>NIVEL_5</strong></td>
		<td><strong>NIVEL_6</strong></td>
		<td><strong>NIVEL_7</strong></td>
		<td><strong>NIVEL_8</strong></td>
		<td><strong>CODIGO_MONEDA</strong></td>
		<td><strong>CODIGO_AUXILIAR</strong></td>
		<td><strong>DESCRIPCION</strong></td>
		<td><strong>REFERENCIA</strong></td>
		<td><strong>NUMERO_AUTORIZACION</strong></td>
		<td><strong>USUARIO_AUTORIZADOR</strong></td>
		<td><strong>TASA_CAMBIO</strong></td>
		<td><strong>FECHA_TIPO_CAMBIO</strong></td>
		<td><strong>CODIGO_COMPANIA</strong></td>
		<td><strong>NUMERO_REFERENCIA</strong></td>
		<td><strong>CENTRO_DE_COSTO</strong></td>
		<td><strong>CODIGO_PRESUPUESTO</strong></td>
		<td><strong>CLASE_PRESUPUESTO</strong></td>
		<td><strong>NUMERO_ORDEN</strong></td>
		<td><strong>NUMERO_ITEM_ORDEN</strong></td>
		<td><strong>CODIGO_AUXILIAR_REF</strong></td>
		<td><strong>REFERENCIA_ORIGEN</strong></td>
	</tr>
	<cfset count=1>
	
	<cfoutput>
	<cfloop query="rsDatos">
	<cfif rsDatos.Dmonto gt 0>
	<tr>
		<cfif isdefined("url.mostrarEmpleados")>
			<td>#rsDatos.Identificacion#</td>
			<td>#rsDatos.nombre#</td>
			<td>#rsDatos.apellido1# #rsDatos.apellido2#</td>
		</cfif>
		<td>&nbsp;02#datosN.CPmes##datosN.CPperiodo#</td>
		<td>CSNOMINA</td>
		<td align="right">#LSdateFormat(rsDatos.RChasta,'dd/mm/yyyy')#</td>
		<td>#count#</td>
		<td>C</td>
		<td align="right"><cfset neg=#rsDatos.Dmonto#*-1>#NumberFormat(neg,",0.00")#</td>
		<td align="right"><cfset neg=#rsDatos.Dmonto#*-1>#NumberFormat(neg,",0.00")#</td>
		<td>N</td>
		<td>1</td>
		<td><cfif len(trim(rsDatos.Nivel1)) gt 0>&nbsp;#rsDatos.Nivel1#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos.Nivel2)) gt 0>&nbsp;#rsDatos.Nivel2#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos.Nivel3)) gt 0>&nbsp;#rsDatos.Nivel3#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos.Nivel4)) gt 0>&nbsp;#rsDatos.Nivel4#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos.Nivel5)) gt 0>&nbsp;#rsDatos.Nivel5#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos.Nivel6)) gt 0>&nbsp;#rsDatos.Nivel6#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos.Nivel7)) gt 0>&nbsp;#rsDatos.Nivel7#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos.Nivel8)) gt 0>&nbsp;#rsDatos.Nivel8#<cfelse>&nbsp;</cfif></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>ASIENTO REVERSION PLANILLA #datosN.CPcodigo#</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<cfset count=count+1>
	</cfif>
	</cfloop>
	
	<cfloop query="rsDatos2">
	<tr>
		<cfif isdefined("url.mostrarEmpleados") and rsDatos.recordCount GT 0>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</cfif>
		<td>&nbsp;02#datosN.CPmes##datosN.CPperiodo#</td>
		<td>CSNOMINA</td>
		<td align="right">#LSdateFormat(rsDatos2.RChasta,'dd/mm/yyyy')#</td>
		<td>#count#</td>
		<td>D</td>
		<td align="right">#NumberFormat(rsDatos2.Dmonto,",0.00")#</td>
		<td align="right">#NumberFormat(rsDatos2.Dmonto,",0.00")#</td>
		<td>N</td>
		<td>1</td>
		<td><cfif len(trim(rsDatos2.Nivel1)) gt 0>&nbsp;#rsDatos2.Nivel1#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel2)) gt 0>&nbsp;#rsDatos2.Nivel2#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel3)) gt 0>&nbsp;#rsDatos2.Nivel3#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel4)) gt 0>&nbsp;#rsDatos2.Nivel4#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel5)) gt 0>&nbsp;#rsDatos2.Nivel5#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel6)) gt 0>&nbsp;#rsDatos2.Nivel6#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel7)) gt 0>&nbsp;#rsDatos2.Nivel7#<cfelse>&nbsp;</cfif></td>
		<td><cfif len(trim(rsDatos2.Nivel8)) gt 0>&nbsp;#rsDatos2.Nivel8#<cfelse>&nbsp;</cfif></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>ASIENTO REVERSION PLANILLA #datosN.CPcodigo#</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	<cfset count=count+1>
	</tr>
	</cfloop>
</cfoutput>
</table>
	
</cfif>