<cfif isdefined("Form.btnAplicar")>
<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso"><!--- Permite validar el acceso según parametrizacion 2526--->
	<cfset action = "ListaDeducciones.cfm">
<cfelseif isdefined("Form.btnImportar")>
	<cfset action = "RegDeducciones-import.cfm">
<cfelse>
	<cfset action = "RegDeducciones.cfm">
</cfif>

<cfif isdefined("Form.btnAplicar")>
<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso"><!--- Permite validar el acceso según parametrizacion 2526--->
	<cfif isdefined("Form.chk") and Len(Trim(Form.chk)) NEQ 0>
		<cfset lotes = ListToArray(Replace(Form.chk,' ', '', 'all'),',')>
		<cfloop index="i" from="1" to="#ArrayLen(lotes)#">
			<cfset lote = ListGetAt(lotes[i],1,'|')>
			<!--- Chequear si el lote es valido --->
			<cfquery name="rsChequear" datasource="#Session.DSN#">
				select count(1) as cant
				from DIDeducciones x
					inner join EIDeducciones y
						on  x.EIDlote = y.EIDlote
				where x.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
				group by y.SNcodigo, x.DIDidentificacion, x.DIDreferencia
				having count(1) > 1
			</cfquery>
			<!--- Chequear saldos válidos --->
			<cfquery name="rsChequearSaldos" datasource="#Session.DSN#">
				select 	x.DIDidentificacion as Identificacion, 
						{fn concat({fn concat({fn concat({ fn concat(e.DEapellido1, ' ') },e.DEapellido2)}, ' ')},e.DEnombre) } as Nombre,
						d.Dmonto as MontoAnterior,
						d.Dsaldo as SaldoAnterior,
						x.DIDmonto as Monto,
						(d.Dsaldo + x.DIDmonto - d.Dmonto) as NuevoSaldo
				from DIDeducciones x, EIDeducciones y, DatosEmpleado e, DeduccionesEmpleado d
				where x.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
					and x.DIDcontrolsaldo = 1
					and y.EIDlote = x.EIDlote
					and e.DEidentificacion = x.DIDidentificacion
					and e.Ecodigo = y.Ecodigo
					and d.DEid = e.DEid
					and d.Ecodigo = e.Ecodigo
					and d.SNcodigo = y.SNcodigo
					and d.Ecodigo = y.Ecodigo
					and d.Dreferencia = x.DIDreferencia
					and (d.Dsaldo + x.DIDmonto - d.Dmonto) < 0
			</cfquery>
			<cfif rsChequear.cant GT 0>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('Existen Deducciones Duplicadas en el Lote #lote#. Proceso cancelado a partir de este lote.')#" addtoken="no">
				<cfabort>
			<cfelseif rsChequearSaldos.recordCount GT 0>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('Saldos Invalidos')#" addtoken="no">
				<cfabort>
			<cfelse>
				<cfquery name="rsAplicar" datasource="#Session.DSN#">
					update DeduccionesEmpleado
					set Dmetodo = (select  b.DIDmetodo
							from EIDeducciones a, DIDeducciones b, DatosEmpleado c
							where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and b.EIDlote = a.EIDlote
							and b.DIDcontrolsaldo = 0
							and c.DEidentificacion = b.DIDidentificacion
							and c.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.DEid = c.DEid
							and DeduccionesEmpleado.Ecodigo = a.Ecodigo
						and DeduccionesEmpleado.SNcodigo = a.SNcodigo
							and DeduccionesEmpleado.Dreferencia = b.DIDreferencia
							and DeduccionesEmpleado.TDid=a.TDid),
						Dvalor = (select b.DIDvalor
							from EIDeducciones a, DIDeducciones b, DatosEmpleado c
							where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and b.EIDlote = a.EIDlote
							and b.DIDcontrolsaldo = 0
							and c.DEidentificacion = b.DIDidentificacion
							and c.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.DEid = c.DEid
							and DeduccionesEmpleado.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.SNcodigo = a.SNcodigo
							and DeduccionesEmpleado.Dreferencia = b.DIDreferencia
							and DeduccionesEmpleado.TDid=a.TDid	),
						Dfechafin =(select b.DIDfechafin
							from EIDeducciones a, DIDeducciones b, DatosEmpleado c
							where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and b.EIDlote = a.EIDlote
							and b.DIDcontrolsaldo = 0
							and c.DEidentificacion = b.DIDidentificacion
							and c.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.DEid = c.DEid
							and DeduccionesEmpleado.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.SNcodigo = a.SNcodigo
							and DeduccionesEmpleado.Dreferencia = b.DIDreferencia
							and DeduccionesEmpleado.TDid=a.TDid	),
						Dmonto = 0.00,
						Dcontrolsaldo = 0,
						Dactivo = 1,
						Dsaldo = 0.00
					where exists (	select 1 
					from EIDeducciones a, DIDeducciones b, DatosEmpleado c
					where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
					  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
					  and b.EIDlote = a.EIDlote
					  and b.DIDcontrolsaldo = 0
					  and c.DEidentificacion = b.DIDidentificacion
					  and c.Ecodigo = a.Ecodigo
					  and DeduccionesEmpleado.DEid = c.DEid
					  and DeduccionesEmpleado.Ecodigo = a.Ecodigo
					  and DeduccionesEmpleado.SNcodigo = a.SNcodigo
					  and DeduccionesEmpleado.Dreferencia = b.DIDreferencia
					  and DeduccionesEmpleado.TDid=a.TDid
					 )
				</cfquery>
				<cfquery name="rsAplicar2" datasource="#session.DSN#">
					update DeduccionesEmpleado
					set Dmetodo = (select b.DIDmetodo
							from EIDeducciones a, DIDeducciones b, DatosEmpleado c
							where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and b.EIDlote = a.EIDlote
							and b.DIDcontrolsaldo = 1
							and b.DIDmonto != 0.00
							and c.DEidentificacion = b.DIDidentificacion
							and c.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.DEid = c.DEid
							and DeduccionesEmpleado.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.SNcodigo = a.SNcodigo
							and DeduccionesEmpleado.Dreferencia = b.DIDreferencia
							and DeduccionesEmpleado.TDid=a.TDid	),
						Dvalor = (select b.DIDvalor
							from EIDeducciones a, DIDeducciones b, DatosEmpleado c
							where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and b.EIDlote = a.EIDlote
							and b.DIDcontrolsaldo = 1
							and b.DIDmonto != 0.00
							and c.DEidentificacion = b.DIDidentificacion
							and c.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.DEid = c.DEid
							and DeduccionesEmpleado.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.SNcodigo = a.SNcodigo
							and DeduccionesEmpleado.Dreferencia = b.DIDreferencia
							and DeduccionesEmpleado.TDid=a.TDid),
						Dfechafin = (select b.DIDfechafin
							from EIDeducciones a, DIDeducciones b, DatosEmpleado c
							where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and b.EIDlote = a.EIDlote
							and b.DIDcontrolsaldo = 1
							and b.DIDmonto != 0.00
							and c.DEidentificacion = b.DIDidentificacion
							and c.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.DEid = c.DEid
							and DeduccionesEmpleado.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.SNcodigo = a.SNcodigo
							and DeduccionesEmpleado.Dreferencia = b.DIDreferencia
							and DeduccionesEmpleado.TDid=a.TDid	),
						Dmonto = (select b.DIDmonto
							from EIDeducciones a, DIDeducciones b, DatosEmpleado c
							where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and b.EIDlote = a.EIDlote
							and b.DIDcontrolsaldo = 1
							and b.DIDmonto != 0.00
							and c.DEidentificacion = b.DIDidentificacion
							and c.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.DEid = c.DEid
							and DeduccionesEmpleado.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.SNcodigo = a.SNcodigo
							and DeduccionesEmpleado.Dreferencia = b.DIDreferencia
							and DeduccionesEmpleado.TDid=a.TDid	),
						Dcontrolsaldo = 1,
						Dactivo = 1,
						Dsaldo = (select (DeduccionesEmpleado.Dsaldo + b.DIDmonto - DeduccionesEmpleado.Dmonto)
						from EIDeducciones a, DIDeducciones b, DatosEmpleado c
							where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
							and b.EIDlote = a.EIDlote
							and b.DIDcontrolsaldo = 1
							and b.DIDmonto != 0.00
							and c.DEidentificacion = b.DIDidentificacion
							and c.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.DEid = c.DEid
							and DeduccionesEmpleado.Ecodigo = a.Ecodigo
							and DeduccionesEmpleado.SNcodigo = a.SNcodigo
							and DeduccionesEmpleado.Dreferencia = b.DIDreferencia
							and DeduccionesEmpleado.TDid=a.TDid	)
					where exists (	select 1 
						from EIDeducciones a, DIDeducciones b, DatosEmpleado c
						where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
						  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
						  and b.EIDlote = a.EIDlote
						  and b.DIDcontrolsaldo = 1
						  and b.DIDmonto != 0.00
						  and c.DEidentificacion = b.DIDidentificacion
						  and c.Ecodigo = a.Ecodigo
						  and DeduccionesEmpleado.DEid = c.DEid
						  and DeduccionesEmpleado.Ecodigo = a.Ecodigo
						  and DeduccionesEmpleado.SNcodigo = a.SNcodigo
						  and DeduccionesEmpleado.Dreferencia = b.DIDreferencia
						  and DeduccionesEmpleado.TDid=a.TDid
					)  
				</cfquery>	
				<cfquery name="rsAplicar3" datasource="#session.DSN#">
					insert into DeduccionesEmpleado (DEid, Ecodigo, SNcodigo, TDid, Ddescripcion, Dmetodo, Dvalor, Dfechaini, Dfechafin, Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, Usucodigo, Ulocalizacion, Dcontrolsaldo, Dactivo, Dreferencia)
					select c.DEid, a.Ecodigo, a.SNcodigo, a.TDid, d.TDdescripcion, b.DIDmetodo, b.DIDvalor, 
						   b.DIDfechaini, b.DIDfechafin, b.DIDmonto, 0, b.DIDmonto, 0, 0, 
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						   <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
						   b.DIDcontrolsaldo, 1, b.DIDreferencia
					from DIDeducciones b, EIDeducciones a, DatosEmpleado c, TDeduccion d
					where b.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
					  and a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
					  and a.EIDlote = b.EIDlote
					  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and c.DEidentificacion = b.DIDidentificacion
					  and c.Ecodigo = a.Ecodigo
					  and d.TDid = a.TDid
					  and not exists (select 1
									   from DeduccionesEmpleado x
									   where x.DEid = c.DEid
										 and x.Ecodigo = a.Ecodigo
										 and x.SNcodigo = a.SNcodigo
										 and x.Dreferencia = b.DIDreferencia
										 and x.TDid = a.TDid
									   )
				</cfquery>
				<cfquery name="rsAplicar4" datasource="#session.DSN#">
					update EIDeducciones
					set EIDestado = 1
					where EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#lote#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.EIDlote") and Len(Trim(Form.EIDlote)) NEQ 0>
		<input name="EIDlote" type="hidden" value="<cfoutput>#Form.EIDlote#</cfoutput>"> 
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
