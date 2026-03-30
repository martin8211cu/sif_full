
<!--- Mostrar Estado de la Línea de Detalle --->
<cfset estado = "">
<cfset estadodesplegar = "">
<cfset estadoetiquetas = "">
<cfset estadoformatos = "">
<cfset estadoalign = "">
<cfif (isDefined("showestado")) and (len(trim(showestado))) and (showestado)>
	<cfset estado = estado & ",
		case DRNestado
			when 1 then '<img src=/cfmx/rh/imagenes/iedit.gif>'
			when 2 then '<img src=/cfmx/rh/imagenes/idelete.gif>'
			else '<img src=/cfmx/rh/imagenes/question.gif>'
		end as estadoimg">
	<cfset estadodesplegar = ",estadoimg">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	returnvariable="LB_Estado"/>

	<cfset estadoetiquetas = ",#LB_Estado#">
	<cfset estadoformatos = ",S">
	<cfset estadoalign = ",center">
</cfif>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_TipoIdentificacion"
Default="Tipo Identificación"
returnvariable="LB_TipoIdentificacion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Identificacion"
Default="Identificación"
returnvariable="LB_Identificacion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CuentaCliente"
Default="Cuenta Cliente"
returnvariable="LB_CuentaCliente"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Nombre"
Default="Nombre"
returnvariable="LB_Nombre"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_TipoPago"
Default="Tipo pago"
returnvariable="LB_TipoPago"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Periodo"
Default="Periodo"
returnvariable="LB_Periodo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Importe"
Default="Importe"
returnvariable="LB_Importe"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_PagoEfe"
Default="Pago Efectivo"
returnvariable="LB_PagoEfe"/>

<cfquery name="Tnomina" datasource="#session.dsn#">
	select Tcodigo
	from ERNomina
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfset filtroMonto = "and DRNliquido > 0 ">
<cfif Tnomina.RecordCount gt 0 and Tnomina.Tcodigo eq '02'><!--- Nomina Temporada --->
	<cfset filtroMonto = "and DRNliquido >= 0 ">
</cfif>

<!--- Lista de Detalles de Nómina. Ver Argumentos Variables para entender que debe definirse. --->
<cfinvoke
	component="rh.Componentes.pListas"
	method="pListaRH"
	returnvariable="pListaRet">

	<!--- Argumentos Fijos --->
	<cfinvokeargument name="columnas" value="ERNid,DRNlinea,
							NTIdescripcion, DRIdentificacion,
							CBcc,
							{fn concat({fn concat({fn concat({fn concat(DRNapellido1 , ' ' )}, DRNapellido2 )}, ' ' )}, DRNnombre )} as Nombre,
							DRNtipopago, DRNperiodo, DRNliquido #estado#,
							(DRNliquido - (select
							sum(ic.ICmontores) ICmontores
						from ERNomina e
						inner join IncidenciasCalculo ic
							on e.RCNid = ic.RCNid
							and e.ERNid = a.ERNid
						inner join CIncidentes ci
						on ci.CIid = ic.CIid
						where ci.CIExcluyePagoLiquido = 1
						and ic.DEid = a.DEid)) as PagoEfectivo,
						(select case DETipoPago when 0 then '&nbsp;&nbsp;Transferencia'
								when 1 then '&nbsp;&nbsp;Cheque' else 'NA' end as TipoPago from DatosEmpleado de where de.DEid = a.DEid
						) TipoPago"/>
	<cfinvokeargument name="tabla" value="DRNomina a, NTipoIdentificacion b, Monedas c"/>
	<cfinvokeargument name="filtro" value="a.NTIcodigo = b.NTIcodigo and a.Mcodigo = c.Mcodigo #filtroMonto# and ERNid = #Form.ERNid# #filtro#  order by (select case DETipoPago when 0 then '  Transferencia'
								when 1 then '  Cheque' else 'NA' end as TipoPago from DatosEmpleado de where de.DEid = a.DEid
						),DRNapellido1,DRNapellido2,DRNnombre,DRIdentificacion,DRNperiodo"/>
	<cfinvokeargument name="desplegar" value="NTIdescripcion, DRIdentificacion,  CBcc, Nombre, DRNtipopago, DRNperiodo, DRNliquido ,#estadodesplegar#,PagoEfectivo,TipoPago"/>
	<cfinvokeargument name="etiquetas" value="#LB_TipoIdentificacion#,#LB_Identificacion#,#LB_CuentaCliente#,#LB_Nombre#,#LB_TipoPago#,#LB_Periodo#,#LB_Importe# #estadoetiquetas#, &nbsp;&nbsp;#LB_PagoEfe#, &nbsp;&nbsp;Tipo Pago"/>
	<cfinvokeargument name="formatos" value="S,S,S,S,S,D,M #estadoformatos#,M,S"/>
	<cfinvokeargument name="align" value="left,left,left,left,left,center,right #estadoalign#,right,left"/>
	<cfinvokeargument name="ajustar" value="S"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="keys" value="ERNid,DRNlinea"/>

	<!--- (*) Argumentos Variables 2 --->
	<cfif isDefined("irA") and len(trim(irA)) NEQ 0>
		<cfinvokeargument name="irA" value="#irA#"/>
	<cfelse>
		<cfinvokeargument name="showLink" value="false"/>
	</cfif>
	<cfif isDefined("showLink") and len(trim(showLink)) NEQ 0>
		<cfinvokeargument name="showLink" value="#showLink#"/>
	</cfif>
	<cfif isDefined("checkboxes") and len(trim(checkboxes)) NEQ 0>
		<cfinvokeargument name="checkboxes" value="#checkboxes#"/>
	</cfif>
	<cfif isDefined("botones") and len(trim(botones)) NEQ 0>
		<cfinvokeargument name="botones" value="#botones#"/>
	</cfif>
	<cfif isDefined("maxrows") and len(trim(maxrows)) NEQ 0>
		<cfinvokeargument name="maxrows" value="#maxrows#"/>
	</cfif>
</cfinvoke>